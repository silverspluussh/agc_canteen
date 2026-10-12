import 'dart:async';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/app_log.dart';
import '../database/activity_log_service.dart';

/// Default cadence for the fast upload (push) loop.
const Duration kDefaultPushInterval = Duration(minutes: 4);

/// Default cadence for the light download (pull) loop.
const Duration kDefaultPullInterval = Duration(minutes: 60);

/// Upper bound on the retry backoff after consecutive failures.
const Duration kMaxSyncBackoff = Duration(minutes: 15);

/// Why a cycle was requested. Lets a loop vary what it runs (e.g. a full
/// reconcile on startup vs. a light refresh on a timer tick).
enum SyncTrigger { start, timer, connectivity, resume, manual, test, coalesced }

/// True when any of [results] represents a usable connection.
bool syncAnyOnline(List<ConnectivityResult> results) =>
    results.any((r) => r != ConnectivityResult.none);

/// Immutable view of a single loop's health, exposed to the UI.
@immutable
class SyncSnapshot {
  final bool isSyncing;
  final DateTime? lastSyncedAt;
  final String? lastError;
  final int consecutiveFailures;

  /// True when the last completed cycle found nothing remote to pull.
  /// Always false for the push loop.
  final bool pullSkipped;

  const SyncSnapshot({
    this.isSyncing = false,
    this.lastSyncedAt,
    this.lastError,
    this.consecutiveFailures = 0,
    this.pullSkipped = false,
  });
}

/// Outcome of one cycle, consumed by the base loop to drive health + backoff.
class SyncOutcome {
  /// Non-null when the cycle failed.
  final String? error;

  /// True when the cycle deliberately skipped its download (remote unchanged).
  final bool skipped;

  const SyncOutcome({this.error, this.skipped = false});

  static const SyncOutcome ok = SyncOutcome();
}

/// Shared scaffolding for the independent push and pull loops.
///
/// Owns the timer, the connectivity/lifecycle triggers, single-run coalescing,
/// exponential backoff and the health [snapshot]. Subclasses supply [runOnce] —
/// the actual push or pull work — and keep their own concerns (version gating,
/// pull groups, daily reconcile).
///
/// This is deliberately *not* an isolate: the work is network + async DB I/O,
/// and the services serialise themselves. The loop's job is purely to decide
/// *when* a cycle runs.
abstract class SyncLoop with WidgetsBindingObserver {
  SyncLoop({
    required Connectivity connectivity,
    required Future<bool> Function() isOnline,
    ActivityLogService? activityLog,
    required this.enabledKey,
    required this.intervalKey,
    required Duration defaultInterval,
    Logger? logger,
    DateTime Function()? now,
    Duration? interval,
    bool observeLifecycle = true,
  })  : _connectivity = connectivity,
        _isOnline = isOnline,
        _activityLog = activityLog,
        _logger = logger ?? createAppLogger(),
        _now = now ?? DateTime.now,
        _interval = interval ?? defaultInterval,
        _observeLifecycle = observeLifecycle;

  final Connectivity _connectivity;
  final Future<bool> Function() _isOnline;
  final ActivityLogService? _activityLog;
  final Logger _logger;
  final DateTime Function() _now;
  final bool _observeLifecycle;

  /// SharedPreferences keys that let an operator disable the loop or change its
  /// cadence without a rebuild.
  final String enabledKey;
  final String intervalKey;

  Duration _interval;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _timer;

  bool _running = false;
  bool _observing = false;
  bool _isSyncing = false;
  bool _queued = false;
  bool _queuedForce = false;
  bool _queuedForceFull = false;
  bool _lastSkipped = false;
  bool _disposed = false;

  /// The cycle currently in flight, if any. Concurrent triggers share it.
  Future<void>? _active;

  /// Serialises start/stop so a fast logout→login cannot interleave with a stop
  /// still awaiting its subscription cancellation.
  Future<void> _control = Future.value();

  DateTime? _lastSyncedAt;
  String? _lastError;
  int _consecutiveFailures = 0;

  /// No trigger other than an explicit force may run before this instant.
  DateTime _nextEligibleAt = DateTime.fromMillisecondsSinceEpoch(0);

  final ValueNotifier<SyncSnapshot> snapshot =
      ValueNotifier(const SyncSnapshot());

  /// Human-readable loop name used in logs and activity entries.
  String get loopName;

  bool get isRunning => _running;

  /// The injected clock, exposed to subclasses that need date arithmetic.
  @protected
  DateTime now() => _now();

  /// Performs one cycle. Subclasses override this.
  Future<SyncOutcome> runOnce({
    required SyncTrigger trigger,
    required bool forceFull,
  });

  /// Begins the periodic loop. Idempotent. Runs one immediate cycle so a
  /// freshly logged-in terminal catches up without waiting a full interval.
  Future<void> start() => _serialize(_start);

  /// Stops all triggers and cancels in-flight bookkeeping. Idempotent.
  Future<void> stop() => _serialize(_stop);

  /// Runs a cycle now, ignoring backoff. Used by the manual Sync screen.
  Future<void> runNow({bool full = false}) =>
      _maybeRun(trigger: SyncTrigger.manual, force: true, forceFull: full);

  /// Runs a single cycle if running. Exposed for tests.
  @visibleForTesting
  Future<void> runCycle() =>
      _maybeRun(trigger: SyncTrigger.test, force: true, forceFull: true);

  /// A non-forced tick (what the timer would do). Exposed for tests so backoff
  /// can be exercised without real wall-clock waits.
  @visibleForTesting
  Future<void> tick() => _maybeRun(trigger: SyncTrigger.timer);

  Future<void> _serialize(Future<void> Function() op) {
    final next = _control.then<void>((_) => op());
    _control = next.catchError((_) {});
    return next;
  }

  Future<void> _start() async {
    if (_running) return;

    var enabled = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      enabled = prefs.getBool(enabledKey) ?? true;
      final seconds = prefs.getInt(intervalKey);
      if (seconds != null && seconds > 0) {
        _interval = Duration(seconds: seconds);
      }
    } catch (e) {
      _logger.w('SyncLoop[$loopName]: could not read config ($e), using defaults');
    }

    if (!enabled) {
      _logger.i('SyncLoop[$loopName]: disabled by configuration');
      return;
    }

    _running = true;
    _nextEligibleAt = DateTime.fromMillisecondsSinceEpoch(0);

    if (_observeLifecycle) {
      WidgetsBinding.instance.addObserver(this);
      _observing = true;
    }

    _connectivitySub = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
    _timer = Timer.periodic(
      _interval,
      (_) => _maybeRun(trigger: SyncTrigger.timer),
    );

    _logger.i('SyncLoop[$loopName]: started (interval ${_interval.inSeconds}s)');
    unawaited(_maybeRun(trigger: SyncTrigger.start, force: true));
  }

  Future<void> _stop() async {
    if (!_running) return;
    _running = false;

    _timer?.cancel();
    _timer = null;

    await _connectivitySub?.cancel();
    _connectivitySub = null;

    if (_observing) {
      WidgetsBinding.instance.removeObserver(this);
      _observing = false;
    }

    _logger.i('SyncLoop[$loopName]: stopped');
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    if (!_running) return;
    if (syncAnyOnline(results)) {
      // Reconnect should retry immediately even if we were backing off.
      _maybeRun(trigger: SyncTrigger.connectivity, force: true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeRun(trigger: SyncTrigger.resume);
    }
  }

  Future<void> _maybeRun({
    required SyncTrigger trigger,
    bool force = false,
    bool forceFull = false,
  }) {
    if (!_running) return Future.value();

    if (_active != null) {
      // Coalesce: fold this trigger into a single follow-up after the run in
      // flight, so flapping reconnect/resume signals cannot stack cycles.
      _queued = true;
      _queuedForce = _queuedForce || force;
      _queuedForceFull = _queuedForceFull || forceFull;
      return _active!;
    }

    if (!force && _now().isBefore(_nextEligibleAt)) {
      return Future.value();
    }

    final run = _runCycle(trigger, forceFull: forceFull);
    _active = run.whenComplete(() {
      _active = null;
      if (_queued) {
        final followUpForce = _queuedForce;
        final followUpForceFull = _queuedForceFull;
        _queued = false;
        _queuedForce = false;
        _queuedForceFull = false;
        _maybeRun(
          trigger: SyncTrigger.coalesced,
          force: followUpForce,
          forceFull: followUpForceFull,
        );
      }
    });
    return _active!;
  }

  Future<void> _runCycle(SyncTrigger trigger, {required bool forceFull}) async {
    if (!await _isOnline()) {
      _logger.i('SyncLoop[$loopName]: offline, deferring ${trigger.name} cycle');
      return;
    }

    _isSyncing = true;
    _emit();

    String? error;
    var skipped = false;
    try {
      final outcome = await runOnce(trigger: trigger, forceFull: forceFull);
      error = outcome.error;
      skipped = outcome.skipped;
    } catch (e, stack) {
      error = e.toString();
      _logger.w(
        'SyncLoop[$loopName]: ${trigger.name} cycle failed ($e)',
        stackTrace: stack,
      );
    }

    _lastSkipped = skipped && error == null;
    if (error == null) {
      _consecutiveFailures = 0;
      _lastSyncedAt = _now();
      _lastError = null;
      _nextEligibleAt = _lastSyncedAt!.add(_interval);
      _activityLog?.log(
        type: 'sync',
        message: '$loopName sync completed (${trigger.name})',
      );
    } else {
      _consecutiveFailures++;
      _lastError = error;
      final backoff = _backoffFor(_consecutiveFailures);
      _nextEligibleAt = _now().add(backoff);
      _activityLog?.log(
        type: 'sync',
        message: '$loopName sync failed (${trigger.name}): $error',
        metadata: {'failures': _consecutiveFailures},
      );
      _logger.w(
        'SyncLoop[$loopName]: backing off ${backoff.inSeconds}s after '
        '$_consecutiveFailures failure(s): $error',
      );
    }

    _isSyncing = false;
    _emit();
    _logger.i('SyncLoop[$loopName]: ${trigger.name} cycle completed');
  }

  Duration _backoffFor(int failures) {
    final exponent = math.min(failures - 1, 10);
    final scaled = _interval * math.pow(2, exponent);
    return scaled > kMaxSyncBackoff ? kMaxSyncBackoff : scaled;
  }

  void _emit() {
    if (_disposed) return;
    snapshot.value = SyncSnapshot(
      isSyncing: _isSyncing,
      lastSyncedAt: _lastSyncedAt,
      lastError: _lastError,
      consecutiveFailures: _consecutiveFailures,
      pullSkipped: _lastSkipped,
    );
  }

  Future<void> dispose() async {
    _disposed = true;
    await stop();
    snapshot.dispose();
  }
}

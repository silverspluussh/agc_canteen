import 'dart:async';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/app_log.dart';
import '../database/activity_log_service.dart';
import 'sync_from_local_to_remote.dart';
import 'sync_from_remote_to_local.dart';
import 'sync_pull_gate.dart';

/// Default cadence for the periodic pull/push cycle.
const Duration kDefaultSyncInterval = Duration(minutes: 3);

/// Upper bound on the retry backoff after consecutive failures.
const Duration kMaxSyncBackoff = Duration(minutes: 15);

/// Immutable view of the scheduler's health, exposed to the UI.
@immutable
class SyncSnapshot {
  final bool isSyncing;
  final DateTime? lastSyncedAt;
  final String? lastError;
  final int consecutiveFailures;

  const SyncSnapshot({
    this.isSyncing = false,
    this.lastSyncedAt,
    this.lastError,
    this.consecutiveFailures = 0,
    this.pullSkipped = false,
  });

  /// True when the last completed cycle found nothing remote to pull.
  final bool pullSkipped;
}

/// Drives the existing sync services on a timer and on meaningful events.
///
/// This is deliberately *not* an isolate: the work is network + async DB I/O,
/// and both services already serialise themselves. The scheduler's job is
/// purely to decide *when* a cycle runs, to coalesce overlapping triggers, and
/// to back off when the server is unhealthy.
class SyncScheduler with WidgetsBindingObserver {
  static const _enabledKey = 'sync_scheduler_enabled';
  static const _intervalKey = 'sync_scheduler_interval_seconds';

  final RemoteToLocalSyncService _remoteToLocal;
  final LocalToRemoteSyncService _localToRemote;
  final Connectivity _connectivity;
  final Logger _logger;
  final Future<bool> Function() _isOnline;
  final DateTime Function() _now;
  final ActivityLogService? _activityLog;
  final RemotePullGate? _pullGate;
  final bool _observeLifecycle;

  Duration _interval;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _timer;

  bool _running = false;
  bool _observing = false;
  bool _isSyncing = false;
  bool _queued = false;
  bool _queuedForce = false;
  bool _queuedForcePull = false;
  bool _lastPullSkipped = false;
  bool _disposed = false;

  /// The cycle currently in flight, if any. Concurrent triggers share it.
  Future<void>? _active;

  /// Serialises start/stop so a fast logout→login cannot interleave with a
  /// stop still awaiting its subscription cancellation (which would leak the
  /// new timer/subscription).
  Future<void> _control = Future.value();

  DateTime? _lastSyncedAt;
  String? _lastError;
  int _consecutiveFailures = 0;

  /// No trigger other than an explicit force may run before this instant.
  DateTime _nextEligibleAt = DateTime.fromMillisecondsSinceEpoch(0);

  final ValueNotifier<SyncSnapshot> snapshot =
      ValueNotifier(const SyncSnapshot());

  SyncScheduler({
    required RemoteToLocalSyncService remoteToLocal,
    required LocalToRemoteSyncService localToRemote,
    required Connectivity connectivity,
    Logger? logger,
    Future<bool> Function()? isOnline,
    DateTime Function()? now,
    ActivityLogService? activityLog,
    RemotePullGate? pullGate,
    Duration interval = kDefaultSyncInterval,
    bool observeLifecycle = true,
  })  : _remoteToLocal = remoteToLocal,
        _localToRemote = localToRemote,
        _connectivity = connectivity,
        _logger = logger ?? createAppLogger(),
        _isOnline = isOnline ?? (() async {
          final results = await connectivity.checkConnectivity();
          return _anyOnline(results);
        }),
        _now = now ?? DateTime.now,
        _activityLog = activityLog,
        _pullGate = pullGate,
        _interval = interval,
        _observeLifecycle = observeLifecycle;

  bool get isRunning => _running;

  static bool _anyOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  /// Begins periodic syncing. Idempotent.
  ///
  /// Runs one immediate cycle so a freshly logged-in terminal catches up without
  /// waiting a full interval. Honours a persisted "enabled"/interval override.
  Future<void> start() => _serialize(_start);

  /// Stops all triggers and cancels in-flight bookkeeping. Idempotent.
  Future<void> stop() => _serialize(_stop);

  /// Runs [op] after any control operation already queued. Errors are swallowed
  /// on the queue itself so one failure cannot wedge the next operation.
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
      enabled = prefs.getBool(_enabledKey) ?? true;
      final seconds = prefs.getInt(_intervalKey);
      if (seconds != null && seconds > 0) {
        _interval = Duration(seconds: seconds);
      }
    } catch (e) {
      _logger.w('SyncScheduler: could not read config ($e), using defaults');
    }

    if (!enabled) {
      _logger.i('SyncScheduler: disabled by configuration');
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
    _timer = Timer.periodic(_interval, (_) => _maybeRun(trigger: 'timer'));

    _logger.i(
      'SyncScheduler: started (interval ${_interval.inSeconds}s)',
    );
    unawaited(_maybeRun(trigger: 'start', force: true));
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

    _logger.i('SyncScheduler: stopped');
  }

  /// Forces a cycle now, ignoring backoff and the pull gate. Used by the manual
  /// Sync screen, where the operator explicitly wants a full download.
  Future<void> syncNow() =>
      _maybeRun(trigger: 'manual', force: true, forcePull: true);

  /// Runs a single cycle if [running]. Exposed for tests to drive deterministically.
  @visibleForTesting
  Future<void> runCycle() =>
      _maybeRun(trigger: 'test', force: true, forcePull: true);

  /// A non-forced tick (what the timer would do). Exposed for tests so backoff
  /// can be exercised without real wall-clock waits. Honours the pull gate.
  @visibleForTesting
  Future<void> tick() => _maybeRun(trigger: 'tick');

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    if (!_running) return;
    if (_anyOnline(results)) {
      // Reconnect should retry immediately even if we were backing off.
      _maybeRun(trigger: 'connectivity', force: true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeRun(trigger: 'resume');
    }
  }

  Future<void> _maybeRun({
    required String trigger,
    bool force = false,
    bool forcePull = false,
  }) {
    if (!_running) return Future.value();

    if (_active != null) {
      // Coalesce: fold this trigger into a single follow-up after the run
      // in flight, so flapping reconnect/resume signals cannot stack cycles.
      // Preserve the force flags so a reconnect/manual trigger still forces
      // the catch-up.
      _queued = true;
      _queuedForce = _queuedForce || force;
      _queuedForcePull = _queuedForcePull || forcePull;
      return _active!;
    }

    if (!force && _now().isBefore(_nextEligibleAt)) {
      return Future.value();
    }

    final run = _runCycle(trigger, forceFullPull: forcePull);
    _active = run.whenComplete(() {
      _active = null;
      if (_queued) {
        final followUpForce = _queuedForce;
        final followUpForcePull = _queuedForcePull;
        _queued = false;
        _queuedForce = false;
        _queuedForcePull = false;
        _maybeRun(
          trigger: 'coalesced',
          force: followUpForce,
          forcePull: followUpForcePull,
        );
      }
    });
    return _active!;
  }

  Future<void> _runCycle(String trigger, {bool forceFullPull = false}) async {
    if (!await _isOnline()) {
      _logger.i('SyncScheduler: offline, deferring $trigger cycle');
      return;
    }

    _isSyncing = true;
    _emit();

    String? error;
    var pullSkipped = false;
    try {
      final gate = _pullGate;
      final shouldPull =
          forceFullPull || gate == null || await gate.shouldPull();

      if (shouldPull) {
        await _remoteToLocal.syncAll(background: false);
        await _pullGate?.onPullSucceeded();
      } else {
        pullSkipped = true;
        _logger.i('SyncScheduler: remote unchanged, skipping pull');
      }

      // Pending orders/bio always push, regardless of the remote version.
      final result = await _localToRemote.syncAll();
      if (result.errors.isNotEmpty) {
        error = result.errors.first;
      }
    } catch (e, stack) {
      error = e.toString();
      _logger.w('SyncScheduler: $trigger cycle failed ($e)', stackTrace: stack);
    }

    _lastPullSkipped = pullSkipped && error == null;
    if (error == null) {
      _consecutiveFailures = 0;
      _lastSyncedAt = _now();
      _lastError = null;
      _nextEligibleAt = _lastSyncedAt!.add(_interval);
      _activityLog?.log(
        type: 'sync',
        message: 'Periodic sync completed ($trigger)',
      );
    } else {
      _consecutiveFailures++;
      _lastError = error;
      final backoff = _backoffFor(_consecutiveFailures);
      _nextEligibleAt = _now().add(backoff);
      _activityLog?.log(
        type: 'sync',
        message: 'Periodic sync failed ($trigger): $error',
        metadata: {'failures': _consecutiveFailures},
      );
      _logger.w(
        'SyncScheduler: backing off ${backoff.inSeconds}s after '
        '$_consecutiveFailures failure(s): $error',
      );
    }

    _isSyncing = false;
    _emit();
    _logger.i('SyncScheduler: $trigger cycle completed');
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
      pullSkipped: _lastPullSkipped,
    );
  }

  Future<void> dispose() async {
    _disposed = true;
    await stop();
    snapshot.dispose();
  }
}

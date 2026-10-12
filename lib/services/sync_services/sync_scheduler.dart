import 'package:shared_preferences/shared_preferences.dart';

import 'sync_from_remote_to_local.dart';
import 'sync_loop.dart';
import 'sync_pull_gate.dart';

export 'sync_loop.dart' show SyncSnapshot, SyncTrigger;

/// Drives the remote→local pull on its own timer, independently of the upload
/// loop.
///
/// A normal tick refreshes only the **light** set (staff, meal types, work
/// functions, bio-data) and is version-gated, so it is skipped entirely when the
/// server reports nothing changed. The **heavy** set (departments, shifts,
/// visitors, contractor staff, dependents, NFC cards) is pulled manually from
/// the Sync screen or as one full reconcile on the first cycle of the day.
class SyncScheduler extends SyncLoop {
  final RemoteToLocalSyncService _remoteToLocal;
  final RemotePullGate? _pullGate;

  /// Records the day of the last completed full reconcile so the first cycle of
  /// a new day performs one automatically.
  static const _dailyFullPullKey = 'sync_last_daily_full_pull_date';

  SyncScheduler({
    required RemoteToLocalSyncService remoteToLocal,
    required super.connectivity,
    required super.isOnline,
    super.logger,
    super.now,
    super.activityLog,
    RemotePullGate? pullGate,
    super.interval,
    super.observeLifecycle,
  })  : _remoteToLocal = remoteToLocal,
        _pullGate = pullGate,
        super(
          enabledKey: 'sync_scheduler_enabled',
          intervalKey: 'sync_scheduler_interval_seconds',
          defaultInterval: kDefaultPullInterval,
        );

  @override
  String get loopName => 'pull';

  @override
  Future<SyncOutcome> runOnce({
    required SyncTrigger trigger,
    required bool forceFull,
  }) async {
    final full = forceFull || await _needsDailyFullPull();

    if (full) {
      final ran = await _remoteToLocal.syncAll(background: false);
      if (!ran) {
        // The link dropped before/while pulling: do not mark the day done, so
        // the reconcile is retried on the next online cycle.
        return const SyncOutcome(error: 'No internet connection');
      }
      await _markDailyFullPull();
      return SyncOutcome.ok;
    }

    final gate = _pullGate;
    // A manual pull is an explicit operator request, so it ignores the version
    // gate and fetches regardless.
    final manual = trigger == SyncTrigger.manual;
    final shouldPull = manual || gate == null || await gate.shouldPull();
    if (!shouldPull) {
      return const SyncOutcome(skipped: true);
    }

    final ran = await _remoteToLocal.syncLight(background: false);
    if (!ran) {
      return const SyncOutcome(error: 'No internet connection');
    }
    await gate?.onPullSucceeded();
    return SyncOutcome.ok;
  }

  Future<bool> _needsDailyFullPull() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_dailyFullPullKey);
      if (raw == null) return true;
      final last = DateTime.tryParse(raw);
      if (last == null) return true;
      final now = _dateOnly(this.now());
      return _dateOnly(last).isBefore(now);
    } catch (_) {
      return true;
    }
  }

  Future<void> _markDailyFullPull() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_dailyFullPullKey, now().toIso8601String());
    } catch (_) {
      // Best-effort: a failure only costs a redundant full pull next cycle.
    }
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}

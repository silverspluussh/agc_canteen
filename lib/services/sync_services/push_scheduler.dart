import 'sync_from_local_to_remote.dart';
import 'sync_loop.dart';

/// Uploads local work (vouchers, function vouchers, bio-data) on a fast,
/// independent timer.
///
/// The push loop never downloads and is therefore never blocked behind a slow
/// pull: pending vouchers leave the terminal within minutes even while a heavy
/// download is in flight. Failures back off independently of the pull loop.
class PushScheduler extends SyncLoop {
  final LocalToRemoteSyncService _localToRemote;

  PushScheduler({
    required LocalToRemoteSyncService localToRemote,
    required super.connectivity,
    required super.isOnline,
    super.logger,
    super.now,
    super.activityLog,
    super.interval,
    super.observeLifecycle,
  })  : _localToRemote = localToRemote,
        super(
          enabledKey: 'sync_push_enabled',
          intervalKey: 'sync_push_interval_seconds',
          defaultInterval: kDefaultPushInterval,
        );

  @override
  String get loopName => 'push';

  @override
  Future<SyncOutcome> runOnce({
    required SyncTrigger trigger,
    required bool forceFull,
  }) async {
    final result = await _localToRemote.syncAll();
    return SyncOutcome(
      error: result.errors.isEmpty ? null : result.errors.first,
    );
  }
}

import '../../core/utils/app_log.dart';
import 'sync_version_service.dart';

/// Decides whether a cycle should perform the (expensive) remote pull.
///
/// Abstracted so the scheduler stays decoupled from the version endpoint and
/// remains trivially testable.
abstract class RemotePullGate {
  /// True when the terminal should run its full remote pull this cycle.
  Future<bool> shouldPull();

  /// Called only after a successful pull, so the gate can remember the version
  /// it just synced to.
  Future<void> onPullSucceeded();

  /// Convenience factory for the default version-based gate.
  static RemotePullGate? maybe({
    required SyncVersionService? versions,
    DateTime Function()? now,
    Duration fullReconcileInterval = kDefaultFullReconcileInterval,
  }) {
    if (versions == null) return null;
    return VersionPullGate(
      versions: versions,
      now: now,
      fullReconcileInterval: fullReconcileInterval,
    );
  }
}

/// Default cadence for an unconditional full pull, regardless of the token.
///
/// Acts as a reconciliation floor: even if the server's version computation
/// ever missed a change, the terminal still fully re-syncs on this interval.
const Duration kDefaultFullReconcileInterval = Duration(minutes: 30);

class VersionPullGate implements RemotePullGate {
  final SyncVersionService _versions;
  final DateTime Function() _now;
  final Duration fullReconcileInterval;

  /// The version fetched by the most recent [shouldPull], persisted on success.
  String? _fetched;

  VersionPullGate({
    required SyncVersionService versions,
    DateTime Function()? now,
    this.fullReconcileInterval = kDefaultFullReconcileInterval,
  })  : _versions = versions,
        _now = now ?? DateTime.now;

  @override
  Future<bool> shouldPull() async {
    // Reconciliation floor — never skip for longer than this.
    final last = await _versions.lastFullPullAt;
    if (last == null || _now().difference(last) >= fullReconcileInterval) {
      await _tryFetch();
      return true;
    }

    final server = await _tryFetch();
    // Cannot tell whether anything changed → pull to be safe.
    if (server == null) return true;

    final stored = await _versions.storedVersion;
    if (server != stored) {
      appLog('SyncVersionGate: change detected, pulling remote');
      return true;
    }

    appLog('SyncVersionGate: remote unchanged, skipping pull');
    return false;
  }

  @override
  Future<void> onPullSucceeded() async {
    final fetched = _fetched;
    if (fetched != null) {
      await _versions.saveVersion(fetched);
    }
    await _versions.markFullPull(_now());
    _fetched = null;
  }

  Future<String?> _tryFetch() async {
    try {
      _fetched = await _versions.fetchVersion();
    } catch (e) {
      appLog('SyncVersionGate: version fetch failed ($e) — falling back to full pull');
      _fetched = null;
    }
    return _fetched;
  }
}

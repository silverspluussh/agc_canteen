typedef SyncTask = Future<bool> Function();

/// Download grouping for a [SyncJob].
///
/// [light] jobs hold the data the POS needs to take orders and authenticate
/// people, so they refresh automatically. [heavy] jobs change rarely and are
/// pulled manually or on the daily reconcile.
enum SyncGroup { light, heavy }

class SyncJob {
  final String name;
  final SyncGroup group;
  final SyncTask execute;

  const SyncJob({
    required this.name,
    required this.execute,
    this.group = SyncGroup.light,
  });
}


enum SyncStatus { idle, syncing, success, error }

class SyncResult {
  final Map<String, int> pushed;
  final Map<String, int> pulled;
  final List<String> errors;

  const SyncResult({
    required this.pushed,
    required this.pulled,
    required this.errors,
  });

  bool get isSuccess => errors.isEmpty;
}
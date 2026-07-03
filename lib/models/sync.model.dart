typedef SyncTask = Future<bool> Function();

class SyncJob {
  final String name;
  final SyncTask execute;

  const SyncJob({required this.name, required this.execute});
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
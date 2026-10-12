import '../database/app_database.dart';

/// In-memory cache of active fingerprint templates, grouped by the owner's
/// department.
///
/// Building the cache reads the whole bio-data table and resolves each row's
/// department through its parent entity (see
/// [AppDatabase.activeBioDataDepartments]). That is far too much work to repeat
/// on every tap, so it is built lazily once per snapshot and reused until
/// something changes.
///
/// Call [invalidate] whenever bio-data or the entities that resolve a
/// template's department change: after a sync pull, and after a local
/// enrollment.
class FingerprintTemplateCache {
  final AppDatabase _db;

  Future<_FingerprintSnapshot>? _snapshot;

  FingerprintTemplateCache({required AppDatabase db}) : _db = db;

  /// Active templates whose owner belongs to [departmentId].
  Future<List<BioDataEntry>> forDepartment(int departmentId) async {
    final snapshot = await _load();
    return snapshot.byDepartment[departmentId] ?? const [];
  }

  /// Every active template, including rows whose owner has no department.
  ///
  /// Used only as a fallback when no department is known — the normal path is
  /// [forDepartment].
  Future<List<BioDataEntry>> all() async => (await _load()).all;

  /// Drops the snapshot so the next read rebuilds from the database.
  void invalidate() => _snapshot = null;

  Future<_FingerprintSnapshot> _load() => _snapshot ??= _build();

  Future<_FingerprintSnapshot> _build() async {
    final entries = await _db.getActiveBioData();
    if (entries.isEmpty) {
      return const _FingerprintSnapshot(all: [], byDepartment: {});
    }

    final departments = await _db.activeBioDataDepartments();
    final byDepartment = <int, List<BioDataEntry>>{};
    for (final entry in entries) {
      final departmentId = departments[entry.id];
      if (departmentId == null) continue;
      byDepartment.putIfAbsent(departmentId, () => []).add(entry);
    }

    return _FingerprintSnapshot(all: entries, byDepartment: byDepartment);
  }
}

class _FingerprintSnapshot {
  const _FingerprintSnapshot({required this.all, required this.byDepartment});

  final List<BioDataEntry> all;
  final Map<int, List<BioDataEntry>> byDepartment;
}

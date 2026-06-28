import 'package:drift/drift.dart';
import 'app_database.dart';

class ActivityLogService {
  final AppDatabase _db;
  ActivityLogService(this._db);

  Future<void> log({
    required String type,
    required String message,
    String? actorType,
    int? actorId,
    String? actorName,
    String? sourceTable,
    String? recordId,
    Map<String, dynamic>? metadata,
  }) async {
    final now = DateTime.now().toIso8601String();
    await _db.insertActivityLog(
      ActivityLogsCompanion(
        id: Value(DateTime.now().millisecondsSinceEpoch),
        type: Value(type),
        message: Value(message),
        actorType: Value.absentIfNull(actorType),
        actorId: Value.absentIfNull(actorId),
        actorName: Value.absentIfNull(actorName),
        sourceTable: Value.absentIfNull(sourceTable),
        recordId: Value.absentIfNull(recordId),
        metadata: Value.absentIfNull(
          metadata != null ? _encodeMap(metadata) : null,
        ),
        createdAt: Value(now),
      ),
    );
  }

  Future<List<ActivityLog>> getAll({int? limit, int? offset}) =>
      _db.getAllActivityLogs(limit: limit, offset: offset);

  Future<List<ActivityLog>> getByType(String type) =>
      _db.getActivityLogsByType(type);

  Future<List<ActivityLog>> getByActor(String actorType, int actorId) =>
      _db.getActivityLogsByActor(actorType, actorId);

  Future<int> count() => _db.getActivityLogCount();

  Future<void> clear() => _db.clearActivityLogs();

  String _encodeMap(Map<String, dynamic> map) {
    return map.entries.map((e) => '${e.key}=${e.value}').join(';');
  }
}

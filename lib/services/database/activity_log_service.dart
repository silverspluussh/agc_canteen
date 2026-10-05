import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'app_database.dart';
import 'dart:convert';

class ActivityLogService {
  final AppDatabase _db;
  ActivityLogService(this._db);

  /// Fire-and-forget by design: every caller logs from inside an auth or order
  /// flow and none of them await it.
  ///
  /// That makes it this method's job to never throw. A failed audit write must
  /// not abort an order, and once the write crosses an async gap it can outlive
  /// the caller entirely (a torn-down database, a disposed session) and surface
  /// as an unhandled error far from its cause.
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

    try {
      await _db.insertActivityLog(
        ActivityLogsCompanion(
          id: Value(await _db.nextLocalId('activity_logs')),
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
    } catch (error) {
      debugPrint('ActivityLogService: dropped "$type" entry — $error');
    }
  }

  Future<List<ActivityLog>> getAll({int? limit, int? offset}) =>
      _db.getAllActivityLogs(limit: limit, offset: offset);

  Future<List<ActivityLog>> getByType(String type) =>
      _db.getActivityLogsByType(type);

  Future<List<ActivityLog>> getByActor(String actorType, int actorId) =>
      _db.getActivityLogsByActor(actorType, actorId);

  Future<int> count() => _db.getActivityLogCount();

  Future<void> clear() => _db.clearActivityLogs();

  /// JSON, not `key=value;`: a value containing a semicolon, an equals sign or a
  /// newline used to corrupt the blob into something that could not be parsed
  /// back apart.
  String _encodeMap(Map<String, dynamic> map) => jsonEncode(map);
}

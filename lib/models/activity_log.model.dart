class ActivityLogEntity {
  final String id;
  final String type;
  final String message;
  final String? actorType;
  final String? actorId;
  final String? actorName;
  final String? sourceTable;
  final String? recordId;
  final String? metadata;
  final DateTime createdAt;

  const ActivityLogEntity({
    required this.id,
    required this.type,
    required this.message,
    this.actorType,
    this.actorId,
    this.actorName,
    this.sourceTable,
    this.recordId,
    this.metadata,
    required this.createdAt,
  });

  factory ActivityLogEntity.fromMap(Map<String, dynamic> map) {
    return ActivityLogEntity(
      id: map['id'] as String,
      type: map['type'] as String,
      message: map['message'] as String,
      actorType: map['actor_type'] as String?,
      actorId: map['actor_id'] as String?,
      actorName: map['actor_name'] as String?,
      sourceTable: map['source_table'] as String?,
      recordId: map['record_id'] as String?,
      metadata: map['metadata'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'message': message,
      'actor_type': actorType,
      'actor_id': actorId,
      'actor_name': actorName,
      'source_table': sourceTable,
      'record_id': recordId,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

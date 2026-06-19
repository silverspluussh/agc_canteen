class Fingerprint {
  final String id;
  final String staffId;
  final String dataBase64;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Fingerprint({
    required this.id,
    required this.staffId,
    required this.dataBase64,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Fingerprint.fromMap(Map<String, dynamic> map) {
    return Fingerprint(
      id: map['id'] as String,
      staffId: map['staff_id'] as String,
      dataBase64: map['data_base64'] as String,
      isActive: map['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'staff_id': staffId,
      'data_base64': dataBase64,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Fingerprint copyWith({
    String? id,
    String? staffId,
    String? dataBase64,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Fingerprint(
      id: id ?? this.id,
      staffId: staffId ?? this.staffId,
      dataBase64: dataBase64 ?? this.dataBase64,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

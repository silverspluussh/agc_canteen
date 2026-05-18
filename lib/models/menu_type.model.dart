class MenuType {
  final String id;
  final String name;
  final String? remarks;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MenuType({
    required this.id,
    required this.name,
    this.remarks,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuType.fromMap(Map<String, dynamic> map) {
    return MenuType(
      id: map['id'] as String,
      name: map['name'] as String,
      remarks: map['remarks'] as String?,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'remarks': remarks,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  MenuType copyWith({
    String? id,
    String? name,
    String? remarks,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuType(
      id: id ?? this.id,
      name: name ?? this.name,
      remarks: remarks ?? this.remarks,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

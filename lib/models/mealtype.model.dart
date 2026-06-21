class MealTypeModel {
  final int id;
  final String name;
  final String status;
  final String beginTime;
  final String endTime;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MealTypeModel({
    required this.id,
    required this.name,
    required this.status,
    required this.beginTime,
    required this.endTime,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MealTypeModel.fromMap(Map<String, dynamic> map) {
    return MealTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      beginTime: map['begin_time'] as String,
      endTime: map['end_time'] as String,
      remarks: map['remarks'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'begin_time': beginTime,
      'end_time': endTime,
      'remarks': remarks,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  MealTypeModel copyWith({
    int? id,
    String? name,
    String? status,
    String? beginTime,
    String? endTime,
    String? remarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MealTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

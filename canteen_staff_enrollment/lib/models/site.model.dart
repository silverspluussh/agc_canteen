class Site {
  final String id;
  final String name;
  final String? location;
  final int noOfEmployees;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Site({
    required this.id,
    required this.name,
    this.location,
    this.noOfEmployees = 0,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Site.fromMap(Map<String, dynamic> map) {
    return Site(
      id: map['id'] as String,
      name: map['name'] as String,
      location: map['location'] as String?,
      noOfEmployees: (map['no_of_employees'] as num?)?.toInt() ?? 0,
      isActive: map['is_active'] as bool,
      startDate: map['start_date'] != null
          ? DateTime.parse(map['start_date'] as String)
          : null,
      endDate: map['end_date'] != null
          ? DateTime.parse(map['end_date'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'no_of_employees': noOfEmployees,
      'is_active': isActive,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Site copyWith({
    String? id,
    String? name,
    String? location,
    int? noOfEmployees,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Site(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      noOfEmployees: noOfEmployees ?? this.noOfEmployees,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

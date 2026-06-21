class Site {
  final int id;
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
      id: map['id'] as int,
      name: (map['name'] ?? '') as String,
      location: map['location'] as String?,
      noOfEmployees:
          int.tryParse(
            (map['no_of_employees'] ?? map['noOfEmployees'] ?? '').toString(),
          ) ??
          0,
      isActive: map['is_active'] as bool? ?? map['isActive'] as bool? ?? true,
      startDate: (map['start_date'] ?? map['startDate']) != null
          ? DateTime.parse((map['start_date'] ?? map['startDate']) as String)
          : null,
      endDate: (map['end_date'] ?? map['endDate']) != null
          ? DateTime.parse((map['end_date'] ?? map['endDate']) as String)
          : null,
      createdAt: DateTime.parse(
        (map['created_at'] ?? map['createdAt']) as String,
      ),
      updatedAt: DateTime.parse(
        (map['updated_at'] ?? map['updatedAt']) as String,
      ),
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
    int? id,
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


class DepartmentCompany {
  final String id;
  final String name;
  final String location;

  const DepartmentCompany({
    required this.id,
    required this.name,
    required this.location,
  });

  factory DepartmentCompany.fromMap(Map<String, dynamic> map) {
    return DepartmentCompany(
      id: map['id'] as String,
      name: map['name'] as String,
      location: map['location'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }

  DepartmentCompany copyWith({
    String? id,
    String? name,
    String? location,
  }) {
    return DepartmentCompany(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
    );
  }
}

class Department {
  final String id;
  final String name;
  final DepartmentCompany company;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Department({
    required this.id,
    required this.name,
    required this.company,
    required this.createdAt,
    this.updatedAt,
  });

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'] as String,
      name: map['name'] as String,
      company: DepartmentCompany.fromMap(
          map['company'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'company': company.toMap(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Department copyWith({
    String? id,
    String? name,
    DepartmentCompany? company,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

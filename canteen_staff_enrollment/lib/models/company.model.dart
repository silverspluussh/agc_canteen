
class DepartmentCompany {
  final int id;
  final String name;
  final String location;

  const DepartmentCompany({
    required this.id,
    required this.name,
    required this.location,
  });

  factory DepartmentCompany.fromMap(Map<String, dynamic> map) {
    return DepartmentCompany(
      id: map['id'] as int,
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
    int? id,
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
  final int id;
  final String name;
  final DepartmentCompany company;


  const Department({
    required this.id,
    required this.name,
    required this.company,
 
  });

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'] as int,
      name: map['name'] as String,
      company: DepartmentCompany.fromMap(
          map['company'] as Map<String, dynamic>),
     
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'company': company.toMap(),

    };
  }

  Department copyWith({
    int? id,
    String? name,
    DepartmentCompany? company,
  
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,

    );
  }
}

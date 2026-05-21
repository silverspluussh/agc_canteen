import 'company.model.dart';
import 'dependant.model.dart';
import 'kitchen.model.dart';

class Staff {
  final String id;
  final String empId;
  final String firstName;
  final String lastName;
  final int tier;
  final String level;
  final String? staffType;
  final int? totalDependant;
  final int? noOfDependantAssigned;
  final Department? department;
  final List<Kitchen>? kitchens;
  final List<Dependant>? dependants;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Staff({
    required this.id,
    required this.empId,
    required this.firstName,
    required this.lastName,
    required this.tier,
    required this.level,
     this.staffType,
     this.totalDependant,
     this.noOfDependantAssigned,
     this.department,
     this.kitchens,
     this.dependants,
    required this.createdAt,
    this.updatedAt,
  });

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['id'] as String,
      empId: map['emp_id'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      tier: map['tier'] as int,
      level: map['level'] as String,
      staffType: map['staff_type'] as String?,
      totalDependant: map['total_dependant'] as int?,
      noOfDependantAssigned: map['no_of_dependant_assigned'] as int?,
      department: Department.fromMap(map['department'] as Map<String, dynamic>),
      kitchens: (map['kitchens'] as List<dynamic>)
          .map((item) => Kitchen.fromMap(item as Map<String, dynamic>))
          .toList(),
      dependants: (map['dependants'] as List<dynamic>)
          .map((item) => Dependant.fromMap(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emp_id': empId,
      'first_name': firstName,
      'last_name': lastName,
      'tier': tier,
      'level': level,
      'staff_type': staffType,
      'total_dependant': totalDependant,
      'no_of_dependant_assigned': noOfDependantAssigned,
      'department': department?.toMap(),
      'kitchens': kitchens?.map((item) => item.toMap()).toList(),
      'dependants': dependants?.map((item) => item.toMap()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Staff copyWith({
    String? id,
    String? empId,
    String? firstName,
    String? lastName,
    int? tier,
    String? level,
    String? staffType,
    int? totalDependant,
    int? noOfDependantAssigned,
    Department? department,
    List<Kitchen>? kitchens,
    List<Dependant>? dependants,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Staff(
      id: id ?? this.id,
      empId: empId ?? this.empId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      tier: tier ?? this.tier,
      level: level ?? this.level,
      staffType: staffType ?? this.staffType,
      totalDependant: totalDependant ?? this.totalDependant,
      noOfDependantAssigned: noOfDependantAssigned ?? this.noOfDependantAssigned,
      department: department ?? this.department,
      kitchens: kitchens ?? this.kitchens,
      dependants: dependants ?? this.dependants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

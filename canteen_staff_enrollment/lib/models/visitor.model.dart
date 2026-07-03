
import 'package:canteen_staff_enrollment/models/biodata.model.dart';
import 'package:canteen_staff_enrollment/models/staff.model.dart';

class Visitor {
  final int id;
  final String name;
  final String? gender;
  final DateTime? startDate;
  final DateTime? endTime;
  final int? companyId;
  final String? company;
  final int? departmentId;
  final String? department;
  final String employeeType = 'visitor';
  final List<BioData>? bioData;

  const Visitor({
    required this.id,
    required this.name,
    this.gender,
    this.startDate,
    this.endTime,
    this.companyId,
    this.company,
    this.departmentId,
    this.department,
    this.bioData,
  });

  factory Visitor.fromMap(Map<String, dynamic> map) {
    return Visitor(
      id: map['id'] as int,
      name: map['name'] as String,
      gender: map['gender'] as String?,
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'] as String)
          : null,
      endTime: map['endTime'] != null
          ? DateTime.parse(map['endTime'] as String)
          : null,
      companyId: map['companyId'] as int?,
      company: map['company'] as String?,
      departmentId: map['departmentId'] as int?,
      department: map['department'] as String?,
      bioData: map['bioData'] != null
          ? (map['bioData'] as List<dynamic>)
              .map((item) => BioData.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
          
      
    );
  }

  Visitor copyWith({
    int? id,
    String? name,
    String? gender,
    DateTime? startDate,
    DateTime? endTime,
    int? companyId,
    String? company,
    int? departmentId,
    String? department,
    List<BioData>? bioData,
  }) {
    return Visitor(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      startDate: startDate ?? this.startDate,
      endTime: endTime ?? this.endTime,
      companyId: companyId ?? this.companyId,
      company: company ?? this.company,
      departmentId: departmentId ?? this.departmentId,
      department: department ?? this.department,
      bioData: bioData ?? this.bioData,
    );
  }
}
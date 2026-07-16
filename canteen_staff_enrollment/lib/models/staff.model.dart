import 'dart:developer';

import 'biodata.model.dart';
import 'company.model.dart';
import 'dependent.model.dart';
import 'kitchen.model.dart';

class Staff {
  final int id;
  final String empId;
  final String fullname;
  final int? companyId;
  final String? jobTitle;
  final String? empStatus;
  final String employeeType;
  final List<BioData>? bioData;
  final Department? department;
  final List<Kitchen>? kitchens;

  const Staff({
    required this.id,
    required this.empId,
    required this.fullname,
    this.companyId,
    this.jobTitle,
    this.empStatus,
    required this.employeeType,

    this.bioData,
   
    this.department,
    this.kitchens,
  });

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['id'] as int,
      empId: map['empId'] as String,
      fullname: map['fullName'] as String,
      companyId: map['companyId'] as int?,
      jobTitle: map['jobTitle'] as String?,
      empStatus: map['status'] as String?,
      employeeType: map['employeeType'] as String,
    
     
      bioData: map['bioData'] != null
          ? (map['bioData'] as List<dynamic>)
              .map((item) => BioData.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      department: map['department'] != null
          ? Department.fromMap(map['department'] as Map<String, dynamic>)
          : null,

      
    );
  }



  Staff copyWith({
    int? id,
    String? empId,
    String? fullname,
    int? companyId,
    String? jobTitle,
    String? empStatus,
    String? employeeType,
    DateTime? startDate,
    DateTime? endDate,
    bool? allowGroupOrder,
    int? maxOrderCount,
    int? shiftId,
    int? totalDependent,
    List<dynamic>? card,
    int? noOfDependentAssigned,
    Department? department,
    List<BioData>? bioData,
    List<Kitchen>? kitchens,
    List<Dependent>? dependents,
  }) {
    return Staff(
      id: id ?? this.id,
      empId: empId ?? this.empId,
      fullname: fullname ?? this.fullname,
      companyId: companyId ?? this.companyId,
      jobTitle: jobTitle ?? this.jobTitle,
      empStatus: empStatus ?? this.empStatus,
      employeeType: employeeType ?? this.employeeType, 
      department: department ?? this.department,
      bioData: bioData ?? this.bioData,
      kitchens: kitchens ?? this.kitchens,
    );
  }
}


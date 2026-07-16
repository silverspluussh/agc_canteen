import 'package:agc_canteen/models/nfc_card.model.dart';

import 'company.model.dart';
import 'dependent.model.dart';
import 'kitchen.model.dart';

class Staff {
  final int id;
  final String empId;
  final String firstName;
  final String lastName;
  final int? companyId;
  final String? jobTitle;
  final String? empStatus;
  final String employeeType;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? allowGroupOrder;
  final int? maxOrderCount;
  final int? shiftId;
  final List<BioData>? bioData;
  final int? totalDependent;
  final List<NfcCard>? cards;
  final int? noOfDependentAssigned;
  final Department? department;
  final List<Kitchen>? kitchens;
  final List<Dependent>? dependents;

  const Staff({
    required this.id,
    required this.empId,
    required this.firstName,
    required this.lastName,
    this.companyId,
    this.jobTitle,
    this.empStatus,
    required this.employeeType,
    this.startDate,
    this.endDate,
    this.allowGroupOrder,
    this.maxOrderCount,
    this.shiftId,
    this.bioData,
    this.totalDependent,
    this.cards,
    this.noOfDependentAssigned,
    this.department,
    this.kitchens,
    this.dependents,
  });

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['id'] as int,
      empId: map['emp_id'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      companyId: map['company_id'] as int?,
      jobTitle: map['job_title'] as String?,
      empStatus: map['emp_status'] as String?,
      employeeType: map['employee_type'] as String,
      startDate: map['start_date'] != null
          ? DateTime.parse(map['start_date'] as String)
          : null,
      endDate: map['end_date'] != null
          ? DateTime.parse(map['end_date'] as String)
          : null,
      allowGroupOrder: map['allow_group_order'] as bool?,
      maxOrderCount: map['max_order_count'] as int?,
      shiftId: map['shift_id'] as int?,
      totalDependent: map['total_dependent'] as int?,
      cards: map['cards'] != null
          ? (map['cards'] as List<dynamic>)
              .map((item) => NfcCard.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      noOfDependentAssigned: map['no_of_dependent_assigned'] as int?,
      bioData: map['bioData'] != null
          ? (map['bioData'] as List<dynamic>)
              .map((item) => BioData.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      department: map['department'] != null
          ? Department.fromMap(map['department'] as Map<String, dynamic>)
          : null,
      kitchens: map['kitchens'] != null
          ? (map['kitchens'] as List<dynamic>)
              .map((item) => Kitchen.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      dependents: map['dependents'] != null
          ? (map['dependents'] as List<dynamic>)
              .map((item) => Dependent.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toLocalDatabase() {
    return {

      'id': id,
      'emp_id': empId,
      'first_name': firstName,
      'last_name': lastName,
      'company_id': companyId,
      'job_title': jobTitle,
      'emp_status': empStatus,
      'employee_type': employeeType,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'allow_group_order': allowGroupOrder,
      'max_order_count': maxOrderCount,
      'shift_id': shiftId,
      'total_dependent': totalDependent,
      'cardIds': cards?.map((item) => item.id).toList(),
      'no_of_dependent_assigned': noOfDependentAssigned,
      'departmentId': department?.id,
      'bioDataIds': bioData?.map((item) => item.id).toList(),
      'kitchensIds': kitchens?.map((item) => item.id).toList(),
      'dependentsIds': dependents?.map((item) => item.id).toList()
    };
  }


  Staff copyWith({
    int? id,
    String? empId,
    String? firstName,
    String? lastName,
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
    List<NfcCard>? cards,
    int? noOfDependentAssigned,
    Department? department,
    List<BioData>? bioData,
    List<Kitchen>? kitchens,
    List<Dependent>? dependents,
  }) {
    return Staff(
      id: id ?? this.id,
      empId: empId ?? this.empId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      companyId: companyId ?? this.companyId,
      jobTitle: jobTitle ?? this.jobTitle,
      empStatus: empStatus ?? this.empStatus,
      employeeType: employeeType ?? this.employeeType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      allowGroupOrder: allowGroupOrder ?? this.allowGroupOrder,
      maxOrderCount: maxOrderCount ?? this.maxOrderCount,
      shiftId: shiftId ?? this.shiftId,
      totalDependent: totalDependent ?? this.totalDependent,
      cards: cards ?? this.cards,
      noOfDependentAssigned:
          noOfDependentAssigned ?? this.noOfDependentAssigned,
      department: department ?? this.department,
      bioData: bioData ?? this.bioData,
      kitchens: kitchens ?? this.kitchens,
      dependents: dependents ?? this.dependents,
    );
  }
}

class BioData {
  int id;
  Finger finger;
  String data;
  int staffId;
  bool isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  BioData({
    required this.id,
    required this.finger,
    required this.data,
    required this.staffId,
    required this.isActive,
     this.createdAt,
     this.updatedAt
  });

  factory BioData.fromMap(Map<String, dynamic> map) {
    return BioData(
      id: map['id'] as int,
      finger: Finger.values.firstWhere((f) => f.name == map['finger']),
      data: map['data'] as String,
      staffId: map['staffId'] as int,
      isActive: map['isActive'] as bool,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'finger': finger.name,
      'data': data,
      'staffId': staffId,
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toMapLocal() {
    return {
      'id': id,
      'finger': finger.name,
      'data': data,
      'staffId': staffId,
      'isActive': isActive,
      'sync_status': 0,
    };
  }
}


enum Finger {
  thumb,
  indexFinger,
  middle,
  ring,
  little,
}

extension FingerExtension on Finger {
  String get name {
    switch (this) {
      case Finger.thumb:
        return 'thumb';
      case Finger.indexFinger:
        return 'index';
      case Finger.middle:
        return 'middle';
      case Finger.ring:
        return 'ring';
      case Finger.little:
        return 'pinky';
    }
  }
}
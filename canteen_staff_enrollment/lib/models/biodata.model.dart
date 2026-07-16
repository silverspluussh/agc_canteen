import 'package:canteen_staff_enrollment/models/employee_type.enum.dart';

class BioData {
  int id;
  String uuid;
  Finger finger;
  String data;
  bool isActive;
  int? staffId;
  EmployeeType employeeType;
  int? dependentId;
  int? visitorId;
  int? contractorStaffId;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  BioData({
    required this.id,
    required this.uuid,
    required this.finger,
    required this.data,
    required this.isActive,
    required this.employeeType,
    this.staffId,
    this.dependentId,
    this.visitorId,
    this.contractorStaffId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory BioData.fromMap(Map<String, dynamic> map) {
    return BioData(
      id: map['id'] as int,
      uuid: map['uuid'] as String? ?? '',
      finger: Finger.values.firstWhere((f) => f.name == map['finger']),
      data: map['data'] as String,
      isActive: map['isActive'] as bool,
      employeeType: EmployeeType.values.firstWhere(
        (e) => e.name == map['employeeType'],
        orElse: () => EmployeeType.permanent,
      ),
      staffId: map['staffId'] as int?,
      dependentId: map['dependentId'] as int?,
      visitorId: map['visitorId'] as int?,
      contractorStaffId: map['contractorStaffId'] as int?,
      createdBy: map['createdBy'] as int?,
      updatedBy: map['updatedBy'] as int?,
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
      'uuid': uuid,
      'finger': finger.name,
      'data': data,
      'isActive': isActive,
      'employeeType': employeeType.name,
      if (staffId != null) 'staffId': staffId,
      if (dependentId != null) 'dependentId': dependentId,
      if (visitorId != null) 'visitorId': visitorId,
      if (contractorStaffId != null) 'contractorStaffId': contractorStaffId,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedBy != null) 'updatedBy': updatedBy,
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
import 'company.model.dart';
import 'dependant.model.dart';
import 'kitchen.model.dart';

class Staff {
  final int id;
  final String empId;
  final String firstName;
  final String lastName;
  final int tier;
  final String level;
  final List<BioData>? bioData;
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
    this.bioData,
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
      id: map['id'] as int,
      empId: (map['empId'] ?? map['emp_id'] ?? '') as String,
      firstName: (map['firstName'] ?? map['first_name'] ?? '') as String,
      lastName: (map['lastName'] ?? map['last_name'] ?? '') as String,
      tier: int.tryParse((map['tier'] ?? '1').toString()) ?? 1,
      level: (map['level'] ?? '') as String,
      staffType: (map['staffType'] ?? map['staff_type']) as String?,
      bioData: map['bioData'] != null
          ? (map['bioData'] as List<dynamic>)
              .map((item) => BioData.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      totalDependant: int.tryParse((map['totalDependant'] ?? map['total_dependant'] ?? '').toString()),
      noOfDependantAssigned: int.tryParse((map['noOfDependantAssigned'] ?? map['no_of_dependant_assigned'] ?? '').toString()),
      department: map['department'] != null ? Department.fromMap(map['department'] as Map<String, dynamic>) : null,
      kitchens: map['kitchens'] != null
          ? (map['kitchens'] as List<dynamic>)
              .map((item) => Kitchen.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      dependants: (map['dependents'] ?? map['dependants']) != null
          ? ((map['dependents'] ?? map['dependants']) as List<dynamic>)
              .map((item) => Dependant.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: DateTime.parse((map['createdAt'] ?? map['created_at']) as String),
      updatedAt: (map['updatedAt'] ?? map['updated_at']) != null
          ? DateTime.parse((map['updatedAt'] ?? map['updated_at']) as String)
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
      'bioData': bioData?.map((item) => item.toMap()).toList(),
      'kitchens': kitchens?.map((item) => item.toMap()).toList(),
      'dependants': dependants?.map((item) => item.toMap()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Staff copyWith({
    int? id,
    String? empId,
    String? firstName,
    String? lastName,
    int? tier,
    String? level,
    String? staffType,
    int? totalDependant,
    int? noOfDependantAssigned,
    Department? department,
    List<BioData>? bioData,
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
      bioData: bioData ?? this.bioData,
      totalDependant: totalDependant ?? this.totalDependant,
      noOfDependantAssigned:
          noOfDependantAssigned ?? this.noOfDependantAssigned,
      department: department ?? this.department,
      kitchens: kitchens ?? this.kitchens,
      dependants: dependants ?? this.dependants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      finger: Finger.values.firstWhere(
        (f) {
          final fingerVal = (map['finger'] as String? ?? '').toLowerCase();
          return f.name.toLowerCase() == fingerVal ||
              (f == Finger.indexFinger && fingerVal == 'index') ||
              (f == Finger.little && fingerVal == 'pinky');
        },
        orElse: () => Finger.thumb,
      ),
      data: map['data'] as String,
      staffId: (map['staffId'] as num?)?.toInt() ?? 0,
      isActive: map['isActive'] as bool? ?? map['is_active'] as bool? ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : (map['created_at'] != null ? DateTime.tryParse(map['created_at'] as String) : null),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : (map['updated_at'] != null ? DateTime.tryParse(map['updated_at'] as String) : null),
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
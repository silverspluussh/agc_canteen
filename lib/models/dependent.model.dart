import 'package:agc_canteen/models/dependent_visit.model.dart';
import 'package:agc_canteen/models/kitchen.model.dart';
import 'package:agc_canteen/models/staff.model.dart';

class Dependent {
  final int id;
  final String fullname;
  final String status;
  final String? gender;
  final int? staffId;
  final int? contractorStaffId;
  final String? parentStatus;
  final List<DependentVisit>? visits;
  final List<BioData>? bioData;
  final List<Kitchen>? kitchens;

  /// 'staff' or 'contractor'. Derived from which parent column is set.
  String get parentType => contractorStaffId != null ? 'contractor' : 'staff';

  int? get parentId => contractorStaffId ?? staffId;

  const Dependent({
    required this.id,
    required this.fullname,
    this.bioData,
    this.kitchens,
    required this.status,
    this.staffId,
    this.contractorStaffId,
    this.parentStatus,
    this.visits,
    this.gender
  });

  factory Dependent.fromMap(Map<String, dynamic> map) {
    int? staffId;
    int? contractorStaffId;
    final parentType = map['parentType'] as String?;
    if (parentType == 'contractor') {
      contractorStaffId = (map['contractorStaffId'] as num?)?.toInt() ??
          (map['parentId'] as num?)?.toInt();
    } else {
      final rawStaffId = map['staffId'] ?? map['staff']?['id'] ?? map['parentId'];
      staffId = (rawStaffId as num?)?.toInt();
      contractorStaffId = (map['contractorStaffId'] as num?)?.toInt();
    }
    return Dependent(
      id: map['id'] as int,
      fullname: map['fullName'] as String,
      status: map['status'] as String,
      gender: map['gender'] as String?,
      staffId: staffId,
      contractorStaffId: contractorStaffId,
      parentStatus: map['parentStatus'] as String?,
      visits: map['visits'] != null
          ? (map['visits'] as List<dynamic>)
                .map((item) => DependentVisit.fromMap(item as Map<String, dynamic>))
                .toList()
          : null,
      bioData: map['bioData'] != null
          ? (map['bioData'] as List<dynamic>)
                .map((item) => BioData.fromMap(item as Map<String, dynamic>))
                .toList()
          : null,
      kitchens: map['kitchens'] != null
          ? (map['kitchens'] as List<dynamic>)
                .map((item) => Kitchen.fromMap(item as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Dependent copyWith({
    int? id,
    String? fullname,
    String? email,
    String? phone,
    String? status,
    String? gender,
    String? relationship,
    int? staffId,
    int? contractorStaffId,
    String? parentStatus,
    List<DependentVisit>? visits,
    List<BioData>? bioData,
    List<Kitchen>? kitchens
  }) {
    return Dependent(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      status: status ?? this.status,
      gender: gender ?? this.gender,
      bioData: bioData ?? this.bioData,
      kitchens: kitchens ?? this.kitchens,
      staffId: staffId ?? this.staffId,
      contractorStaffId: contractorStaffId ?? this.contractorStaffId,
      parentStatus: parentStatus ?? this.parentStatus,
      visits: visits ?? this.visits,
    );
  }
}

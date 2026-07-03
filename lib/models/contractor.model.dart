import 'package:agc_canteen/models/kitchen.model.dart';
import 'package:agc_canteen/models/staff.model.dart';

class Contractor {
  final int id;
  final String name;
  final String status;
  final int noOfStaffs;
  final int companyId;
  final int departmentId;
  final String company;
  final String department;
  final List<Kitchen>? kitchens;

  const Contractor({
    required this.id,
    required this.name,
    required this.noOfStaffs,
    required this.companyId,
    required this.department,
    required this.company,
    required this.departmentId,
    required this.status,
    this.kitchens,
  });

  factory Contractor.fromMap(Map<String, dynamic> map) {
    return Contractor(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      noOfStaffs: map['no_of_staffs'] as int,
      companyId: map['company_id'] as int,
      departmentId: map['department_id'] as int,
      company: map['company'] as String,
      department: map['department'] as String,
      kitchens: map['kitchens'] != null
          ? (map['kitchens'] as List<dynamic>)
                .map((item) => Kitchen.fromMap(item as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
}

class ContractorStaff {
  final int id;
  final String name;
  final String? gender;
  final int contractorId;
  final String? contractorName;
  final int companyId;
  final String? company;
  final int departmentId;
  final String? department;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCharged;
  final List<BioData>? bioData;
  final List<Kitchen>? kitchens;

  const ContractorStaff({
    required this.id,
    required this.name,
    this.gender,
    required this.contractorId,
    this.contractorName,
    required this.companyId,
    this.company,
    required this.departmentId,
    this.department,
    required this.startDate,
    required this.endDate,
    required this.isCharged,
    this.kitchens,
    this.bioData,
  });

  factory ContractorStaff.fromMap(Map<String, dynamic> map) {
    return ContractorStaff(
      id: map['id'] as int,
      name: map['name'] as String,
      gender: map['gender'] as String?,
      contractorId: map['contractor_id'] as int,
      contractorName: map['contractor_name'] as String?,
      companyId: map['company_id'] as int,
      company: map['company'] as String?,
      departmentId: map['department_id'] as int,
      department: map['department'] as String?,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      isCharged: map['is_charged'] as bool,
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

  ContractorStaff copyWith({
    int? id,
    String? name,
    String? gender,
    int? contractorId,
    String? contractorName,
    int? companyId,
    String? company,
    int? departmentId,
    String? department,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCharged,
    List<BioData>? bioData,
    List<Kitchen>? kitchens,
  }) {
    return ContractorStaff(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      contractorId: contractorId ?? this.contractorId,
      contractorName: contractorName ?? this.contractorName,
      companyId: companyId ?? this.companyId,
      company: company ?? this.company,
      departmentId: departmentId ?? this.departmentId,
      department: department ?? this.department,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCharged: isCharged ?? this.isCharged,
      bioData: bioData ?? this.bioData,
      kitchens: kitchens ?? this.kitchens,
    );
  }
}

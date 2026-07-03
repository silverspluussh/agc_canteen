
import 'package:canteen_staff_enrollment/models/biodata.model.dart';

class Dependant {
  final int id;
  final String fullname;
  final String status;
  final String? gender;
  final String employeeType = 'dependant';
  final List<BioData>? bioData;

  const Dependant({
    required this.id,
    required this.fullname,
    this.bioData,
    required this.status,
    this.gender
  });

  factory Dependant.fromMap(Map<String, dynamic> map) {
    return Dependant(
      id: map['id'] as int,
      fullname: map['fullName'] as String,
      status: map['status'] as String,
      gender: map['gender'] as String?,
      bioData: map['bioData'] != null
          ? (map['bioData'] as List<dynamic>)
                .map((item) => BioData.fromMap(item as Map<String, dynamic>))
                .toList()
          : null,
    
    );
  }

  Dependant copyWith({
    int? id,
    String? fullname,
    String? email,
    String? phone,
    String? status,
    String? gender,
    String? relationship,
   int? staffId,
       List<BioData>? bioData,
  }) {
    return Dependant(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      status: status ?? this.status,
      gender: gender ?? this.gender,
      bioData: bioData ?? this.bioData,
    );
  }
}

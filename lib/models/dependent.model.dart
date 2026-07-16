import 'package:agc_canteen/models/kitchen.model.dart';
import 'package:agc_canteen/models/staff.model.dart';

class Dependent {
  final int id;
  final String fullname;
  final String status;
  final String? gender;
  final int staffId;
  final List<BioData>? bioData;
  final List<Kitchen>? kitchens;

  const Dependent({
    required this.id,
    required this.fullname,
    this.bioData,
    this.kitchens,
    required this.status,
   required this.staffId,
    this.gender
  });

  factory Dependent.fromMap(Map<String, dynamic> map) {
    return Dependent(
      id: map['id'] as int,
      fullname: map['fullName'] as String,
      status: map['status'] as String,
      gender: map['gender'] as String?,
      staffId: map['staffId'] as int,
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
       List<BioData>? bioData,
   List<Kitchen>? kitchens
  }) {
    return Dependent(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      status: status ?? this.status,
      gender: gender ?? this.gender,
      bioData: bioData ?? this.bioData,
      kitchens: kitchens?? this.kitchens
      , staffId: staffId ?? this.staffId
    );
  }
}

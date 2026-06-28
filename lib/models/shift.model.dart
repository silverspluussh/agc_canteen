import 'package:agc_canteen/models/mealtype.model.dart';

class Shift {
  final int id;
  final String name;
  final List<MealTypeModel> mealTypeAllowed;
  final int hours;
  final int companyId;

  const Shift({
    required this.id,
    required this.companyId,
    required this.hours,
    required this.name,
    required this.mealTypeAllowed,
  });
  factory Shift.fromMap(Map<String, dynamic> map) {
    return Shift(
      id: map['id'],
      companyId: map['companyId'],
      hours: map['hours'],
      name: map['name'],
      mealTypeAllowed: (map['mealTypeAllowed'] as List<dynamic>)
          .map((item) => MealTypeModel.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Shift copyWith({
    int? id,
    String? name,
    List<MealTypeModel>? mealTypeAllowed,
    int? hours,
    int? companyId,
  }) {
    return Shift(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      hours: hours ?? this.hours,
      name: name ?? this.name,
      mealTypeAllowed: mealTypeAllowed ?? this.mealTypeAllowed,
    );
  }
}

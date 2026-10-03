import 'package:agc_canteen/models/mealtype.model.dart';

class Shift {
  final int id;
  final String name;
  final List<MealTypeModel> mealTypeAllowed;
  final int hours;
  final int companyId;
  final int dailyMealQuota;
  final int workingDaysPerMonth;

  const Shift({
    required this.id,
    required this.companyId,
    required this.hours,
    required this.name,
    required this.mealTypeAllowed,
    this.dailyMealQuota = 0,
    this.workingDaysPerMonth = 0,
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
      dailyMealQuota: (map['dailyMealQuota'] as num?)?.toInt() ?? 0,
      workingDaysPerMonth: (map['workingDaysPerMonth'] as num?)?.toInt() ?? 0,
    );
  }

  Shift copyWith({
    int? id,
    String? name,
    List<MealTypeModel>? mealTypeAllowed,
    int? hours,
    int? companyId,
    int? dailyMealQuota,
    int? workingDaysPerMonth,
  }) {
    return Shift(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      hours: hours ?? this.hours,
      name: name ?? this.name,
      mealTypeAllowed: mealTypeAllowed ?? this.mealTypeAllowed,
      dailyMealQuota: dailyMealQuota ?? this.dailyMealQuota,
      workingDaysPerMonth: workingDaysPerMonth ?? this.workingDaysPerMonth,
    );
  }

  /// Monthly meal pool for staff on this shift (fixed per shift).
  int get monthlyPool => dailyMealQuota * workingDaysPerMonth;
}

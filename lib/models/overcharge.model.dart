import 'staff.model.dart';
import 'meal.model.dart';

class Overcharge {
  final String id;
  final String mealType;
  final String orderCode;
  final double price;
  final Staff staff;
  final Meal meal;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Overcharge({
    required this.id,
    required this.mealType,
    required this.orderCode,
    required this.price,
    required this.staff,
    required this.meal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Overcharge.fromMap(Map<String, dynamic> map) {
    return Overcharge(
      id: map['id'] as String,
      mealType: map['meal_type'] as String,
      orderCode: map['order_code'] as String,
      price: (map['price'] as num).toDouble(),
      staff: Staff.fromMap(map['staff'] as Map<String, dynamic>),
      meal: Meal.fromMap(map['meal'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'meal_type': mealType,
      'order_code': orderCode,
      'price': price,
      'staff': staff.toMap(),
      'meal': meal.toMap(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Overcharge copyWith({
    String? id,
    String? mealType,
    String? orderCode,
    double? price,
    Staff? staff,
    Meal? meal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Overcharge(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      orderCode: orderCode ?? this.orderCode,
      price: price ?? this.price,
      staff: staff ?? this.staff,
      meal: meal ?? this.meal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

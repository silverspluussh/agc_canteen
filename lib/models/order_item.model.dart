import 'meal.model.dart';

class OrderItem {
  final String id;
  final double price;
  final int qty;
  final Meal meal;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderItem({
    required this.id,
    required this.price,
    required this.qty,
    required this.meal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as String,
      price: (map['price'] as num).toDouble(),
      qty: (map['qty'] as num).toInt(),
      meal: Meal.fromMap(map['meal'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
      'qty': qty,
      'meal': meal.toMap(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  OrderItem copyWith({
    String? id,
    double? price,
    int? qty,
    Meal? meal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderItem(
      id: id ?? this.id,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      meal: meal ?? this.meal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

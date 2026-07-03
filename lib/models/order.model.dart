import 'staff.model.dart';

class Order {
  final int id;
  final String uuid;
  final String orderCode;
  final String status;
  final String orderType;
  final String mealType;
  final double total;
  final int groupCount;
  final String? description;
  final Staff orderedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.uuid,
    required this.orderCode,
    required this.status,
    required this.orderType,
    required this.mealType,
    required this.total,
    required this.groupCount,
    this.description,
    required this.orderedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      uuid: map['uuid'] as String,
      orderCode: map['order_code'] as String,
      status: map['status'] as String,
      orderType: map['order_type'] as String,
      mealType: map['meal_type'] as String,
      total: double.tryParse((map['total'] ?? '').toString()) ?? 0,
      groupCount: int.tryParse((map['group_count'] ?? '').toString()) ?? 0,
      description: map['description'] as String?,
      orderedBy: Staff.fromMap(map['ordered_by'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

 

  Order copyWith({
    int? id,
    String? uuid,
    String? orderCode,
    String? status,
    String? orderType,
    String? mealType,
    double? total,
    int? groupCount,
    String? description,
    Staff? orderedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      orderCode: orderCode ?? this.orderCode,
      status: status ?? this.status,
      orderType: orderType ?? this.orderType,
      mealType: mealType ?? this.mealType,
      total: total ?? this.total,
      groupCount: groupCount ?? this.groupCount,
      description: description ?? this.description,
      orderedBy: orderedBy ?? this.orderedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

import 'menu_type.model.dart';
import 'kitchen.model.dart';

class Meal {
  final String id;
  final String name;
  final String status;
  final String mealType;
  final String? remarks;
  final double price;
  final String? photoUrl;
  final MenuType menuType;
  final List<Kitchen> kitchens;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Meal({
    required this.id,
    required this.name,
    required this.status,
    required this.mealType,
    this.remarks,
    required this.price,
    this.photoUrl,
    required this.menuType,
    required this.kitchens,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] as String,
      name: map['name'] as String,
      status: map['status'] as String,
      mealType: map['meal_type'] as String,
      remarks: map['remarks'] as String?,
      price: (map['price'] as num).toDouble(),
      photoUrl: map['photo_url'] as String?,
      menuType: MenuType.fromMap(map['menu_type'] as Map<String, dynamic>),
      kitchens: (map['kitchens'] as List<dynamic>)
          .map((item) => Kitchen.fromMap(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'meal_type': mealType,
      'remarks': remarks,
      'price': price,
      'photo_url': photoUrl,
      'menu_type': menuType.toMap(),
      'kitchens': kitchens.map((item) => item.toMap()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Meal copyWith({
    String? id,
    String? name,
    String? status,
    String? mealType,
    String? remarks,
    double? price,
    String? photoUrl,
    MenuType? menuType,
    List<Kitchen>? kitchens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      mealType: mealType ?? this.mealType,
      remarks: remarks ?? this.remarks,
      price: price ?? this.price,
      photoUrl: photoUrl ?? this.photoUrl,
      menuType: menuType ?? this.menuType,
      kitchens: kitchens ?? this.kitchens,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

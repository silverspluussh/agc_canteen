class MealTypeModel {
  final int id;
  final String name;
  final String status;
  final String beginTime;
  final String endTime;
  final double price;



  const MealTypeModel({
    required this.id,
    required this.name,
    required this.status,
    required this.beginTime,
    required this.endTime,
    required this.price,
  
  });

  factory MealTypeModel.fromMap(Map<String, dynamic> map) {
    return MealTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      beginTime: map['begin_time'] as String,
      endTime: map['end_time'] as String,
      price: (map['price'] as num).toDouble(),
 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'begin_time': beginTime,
      'end_time': endTime,
      'price': price,
    
    };
  }

  MealTypeModel copyWith({
    int? id,
    String? name,
    String? status,
    String? beginTime,
    String? endTime,
    double? price,
    String? remarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MealTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
      price: price ?? this.price,
    
    );
  }
}

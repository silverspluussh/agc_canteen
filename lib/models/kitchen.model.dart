import 'site.model.dart';

class Kitchen {
  final int id;
  final String name;
  final int minTierRequired;
  final String status;
  final Site company;


  const Kitchen({
    required this.id,
    required this.name,
    required this.minTierRequired,
    required this.status,
    required this.company,
   
  });

  factory Kitchen.fromMap(Map<String, dynamic> map) {
    return Kitchen(
      id: map['id'] as int,
      name: map['name'] as String,
      minTierRequired: (map['min_tier_required'] as num).toInt(),
      status: map['status'] as String,
      company: Site.fromMap(map['company'] as Map<String, dynamic>),

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'min_tier_required': minTierRequired,
      'status': status,
      'company': company.toMap(),
      
    };
  }

  Kitchen copyWith({
    int? id,
    String? name,
    int? minTierRequired,
    String? status,
    Site? company,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Kitchen(
      id: id ?? this.id,
      name: name ?? this.name,
      minTierRequired: minTierRequired ?? this.minTierRequired,
      status: status ?? this.status,
      company: company ?? this.company,
   
    );
  }
}

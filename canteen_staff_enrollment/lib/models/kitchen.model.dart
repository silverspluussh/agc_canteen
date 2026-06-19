import 'site.model.dart';

class Kitchen {
  final String id;
  final String name;
  final int minTierRequired;
  final String status;
  final Site company;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Kitchen({
    required this.id,
    required this.name,
    required this.minTierRequired,
    required this.status,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Kitchen.fromMap(Map<String, dynamic> map) {
    return Kitchen(
      id: map['id'] as String,
      name: map['name'] as String,
      minTierRequired: (map['min_tier_required'] as num).toInt(),
      status: map['status'] as String,
      company: Site.fromMap(map['company'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'min_tier_required': minTierRequired,
      'status': status,
      'company': company.toMap(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Kitchen copyWith({
    String? id,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

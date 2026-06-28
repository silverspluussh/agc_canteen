import 'kitchen.model.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String role;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime? actStartDate;
  final DateTime? actEndDate;
  final List<Kitchen> kitchens;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    required this.role,
    required this.isActive,
    this.lastLoginAt,
    this.actStartDate,
    this.actEndDate,
    required this.kitchens,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      role: map['role'] as String,
      isActive: map['is_active'] as bool,
      lastLoginAt: map['last_login_at'] != null
          ? DateTime.parse(map['last_login_at'] as String)
          : null,
      actStartDate: map['act_start_date'] != null
          ? DateTime.parse(map['act_start_date'] as String)
          : null,
      actEndDate: map['act_end_date'] != null
          ? DateTime.parse(map['act_end_date'] as String)
          : null,
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
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'act_start_date': actStartDate?.toIso8601String(),
      'act_end_date': actEndDate?.toIso8601String(),
      'kitchens': kitchens.map((item) => item.toMap()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? role,
    bool? isActive,
    DateTime? lastLoginAt,
    DateTime? actStartDate,
    DateTime? actEndDate,
    List<Kitchen>? kitchens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      actStartDate: actStartDate ?? this.actStartDate,
      actEndDate: actEndDate ?? this.actEndDate,
      kitchens: kitchens ?? this.kitchens,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


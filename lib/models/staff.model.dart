class Staff {
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;

  const Staff({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
  });

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['id'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
    };
  }

  Staff copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
  }) {
    return Staff(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}

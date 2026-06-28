class Dependant {
  final int id;
  final String firstName;
  final String lastName;
  final String status;
  final String? gender;

  const Dependant({
    required this.id,
    required this.firstName,
    required this.lastName,

    required this.status,
    this.gender,
  });

  factory Dependant.fromMap(Map<String, dynamic> map) {
    return Dependant(
      id: map['id'] as int,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      status: map['status'] as String,
      gender: map['gender'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'status': status,
      'gender': gender,
    };
  }

  Dependant copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? status,
    String? gender,
    DateTime? dob,
    String? relationship,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Dependant(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      status: status ?? this.status,
      gender: gender ?? this.gender,
    );
  }
}

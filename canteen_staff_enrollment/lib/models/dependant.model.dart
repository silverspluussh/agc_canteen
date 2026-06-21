class Dependant {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String status;
  final String? gender;
  final DateTime? dob;
  final String relationship;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Dependant({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    required this.status,
    this.gender,
    this.dob,
    required this.relationship,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory Dependant.fromMap(Map<String, dynamic> map) {
    return Dependant(
      id: map['id'] as int,
      firstName: (map['firstName'] ?? map['first_name'] ?? '') as String,
      lastName: (map['lastName'] ?? map['last_name'] ?? '') as String,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      status: (map['status'] ?? map['empStatus'] ?? '') as String,
      gender: map['gender'] as String?,
      dob: (map['dob'] ?? map['dateOfBirth']) != null
          ? DateTime.tryParse((map['dob'] ?? map['dateOfBirth']) as String)
          : null,
      relationship: (map['relationship'] ?? '') as String,
      photoUrl: (map['photoUrl'] ?? map['photo_url']) as String?,
      createdAt: DateTime.parse((map['createdAt'] ?? map['created_at']) as String),
      updatedAt: (map['updatedAt'] ?? map['updated_at']) != null
          ? DateTime.tryParse((map['updatedAt'] ?? map['updated_at']) as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'status': status,
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'relationship': relationship,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      relationship: relationship ?? this.relationship,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

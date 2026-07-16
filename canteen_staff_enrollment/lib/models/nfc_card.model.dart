class NfcCard {
  final int id;
  final String? code;
  final String? tagId;
  final String? reversedCode;
  final String status;
  final bool isAssigned;
  final int? assignedToId;
  final String? assignedToType;
  final int? companyId;
  final DateTime? issuedDate;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final NfcCardAssignedTo? assignedTo;

  const NfcCard({
    required this.id,
    this.code,
    this.tagId,
    this.reversedCode,
    required this.status,
    required this.isAssigned,
    this.assignedToId,
    this.assignedToType,
    this.companyId,
    this.issuedDate,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.assignedTo,
  });

  factory NfcCard.fromMap(Map<String, dynamic> map) {
    return NfcCard(
      id: map['id'] as int,
      code: map['code'] as String?,
      tagId: map['tagId'] as String?,
      reversedCode: map['reversedCode'] as String?,
      status: map['status'] as String? ?? 'active',
      isAssigned: map['isAssigned'] as bool? ?? false,
      assignedToId: map['assignedToId'] as int?,
      assignedToType: map['assignedToType'] as String?,
      companyId: map['companyId'] as int?,
      issuedDate: map['issuedDate'] != null
          ? DateTime.parse(map['issuedDate'] as String)
          : null,
      createdBy: map['createdBy'] as int?,
      updatedBy: map['updatedBy'] as int?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      assignedTo: map['assignedTo'] != null
          ? NfcCardAssignedTo.fromMap(
              map['assignedTo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'tagId': tagId,
      'reversedCode': reversedCode,
      'status': status,
      'isAssigned': isAssigned,
      'assignedToId': assignedToId,
      'assignedToType': assignedToType,
      'companyId': companyId,
      'issuedDate': issuedDate?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      if (assignedTo != null) 'assignedTo': assignedTo!.toMap(),
    };
  }

  NfcCard copyWith({
    int? id,
    String? code,
    String? tagId,
    String? reversedCode,
    String? status,
    bool? isAssigned,
    int? assignedToId,
    String? assignedToType,
    int? companyId,
    DateTime? issuedDate,
    int? createdBy,
    int? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    NfcCardAssignedTo? assignedTo,
  }) {
    return NfcCard(
      id: id ?? this.id,
      code: code ?? this.code,
      tagId: tagId ?? this.tagId,
      reversedCode: reversedCode ?? this.reversedCode,
      status: status ?? this.status,
      isAssigned: isAssigned ?? this.isAssigned,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedToType: assignedToType ?? this.assignedToType,
      companyId: companyId ?? this.companyId,
      issuedDate: issuedDate ?? this.issuedDate,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}

class NfcCardAssignedTo {
  final int id;
  final String name;
  final String? code;
  final String type;
  final NfcCardAssignedCompany? company;

  const NfcCardAssignedTo({
    required this.id,
    required this.name,
    this.code,
    required this.type,
    this.company,
  });

  factory NfcCardAssignedTo.fromMap(Map<String, dynamic> map) {
    return NfcCardAssignedTo(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String?,
      type: map['type'] as String,
      company: map['company'] != null
          ? NfcCardAssignedCompany.fromMap(
              map['company'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      if (company != null) 'company': company!.toMap(),
    };
  }
}

class NfcCardAssignedCompany {
  final int id;
  final String name;

  const NfcCardAssignedCompany({
    required this.id,
    required this.name,
  });

  factory NfcCardAssignedCompany.fromMap(Map<String, dynamic> map) {
    return NfcCardAssignedCompany(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

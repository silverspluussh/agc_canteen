class NfcCard {
  final int id;
  final String? tagId;
  final double? code;
  final double? reversedCode;
  final String status;
  final bool? isAssigned;
  final int? assignedToId;
  final int? departmentId;
  final String? departmentName;
  final String? personnelName;
  final String? assignedToType;
  final DateTime? issuedDate;
  final DateTime? createdAt;

  const NfcCard({
    required this.id,
     this.code,
    this.reversedCode,
    required this.status,
    this.tagId,
    this.isAssigned,
    this.assignedToId,
    this.assignedToType,
    this.departmentId,
    this.departmentName,
    this.personnelName,
    this.issuedDate,
    this.createdAt,
  });

  factory NfcCard.fromMap(Map<String, dynamic> map) {
    return NfcCard(
      id: map['id'] as int,
        tagId:  map['tagId'] as String?,
      code: map['code'] as double?,
      reversedCode: map['reversedCode'] as double?,
      status: map['status'] as String,
      isAssigned: map['isAssigned'] as bool?,
      assignedToId: map['assignedToId'] as int?,
      assignedToType: map['assignedToType'] as String?,
      departmentId: map['departmentId'] as int?,
      departmentName: map['departmentName'] as String?,
      personnelName: map['personnelName'] as String?,
      issuedDate: map['issuedDate'] != null
          ? DateTime.parse(map['issuedDate'] as String)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
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
      'issuedDate': issuedDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'departmentId': departmentId,
      'departmentName': departmentName,
      'personnelName': personnelName,
    };
  }

  NfcCard copyWith({
    int? id,
    String? tagId,
    double? code,
    double? reversedCode,
    String? status,
    bool? isAssigned,
    int? assignedToId,
    String? assignedToType,
    DateTime? issuedDate,
    DateTime? createdAt,
  }) {
    return NfcCard(
      id: id ?? this.id,
      tagId: tagId ?? this.tagId,
      code: code ?? this.code,
      reversedCode: reversedCode ?? this.reversedCode,
      status: status ?? this.status,
      isAssigned: isAssigned ?? this.isAssigned,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedToType: assignedToType ?? this.assignedToType,
      issuedDate: issuedDate ?? this.issuedDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

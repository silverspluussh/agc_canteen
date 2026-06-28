class NfcCard {
  final int id;
  final String serialNumber;
  final String status;
  final bool isEncoded;
  final bool isAssigned;
  final int totalScanCount;
  final DateTime? issuedDate;
  final DateTime? expiryDate;
  final DateTime? lastUsedAt;
  final DateTime uploadedAt;

  const NfcCard({
    required this.id,
    required this.serialNumber,
    required this.status,
    required this.isEncoded,
    required this.isAssigned,
    required this.totalScanCount,
    this.issuedDate,
    this.expiryDate,
    this.lastUsedAt,
    required this.uploadedAt,
  });

  factory NfcCard.fromMap(Map<String, dynamic> map) {
    return NfcCard(
      id: map['id'] as int,
      serialNumber: map['serial_number'] as String,
      status: map['status'] as String,
      isEncoded: map['is_encoded'] as bool,
      isAssigned: map['is_assigned'] as bool,
      totalScanCount: map['total_scan_count'] as int,
      issuedDate: map['issued_date'] != null
          ? DateTime.parse(map['issued_date'] as String)
          : null,
      expiryDate: map['expiry_date'] != null
          ? DateTime.parse(map['expiry_date'] as String)
          : null,
      lastUsedAt: map['last_used_at'] != null
          ? DateTime.parse(map['last_used_at'] as String)
          : null,
      uploadedAt: DateTime.parse(map['uploaded_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'status': status,
      'is_encoded': isEncoded,
      'is_assigned': isAssigned,
      'total_scan_count': totalScanCount,
      'issued_date': issuedDate?.toIso8601String(),
      'expiry_date': expiryDate?.toIso8601String(),
      'last_used_at': lastUsedAt?.toIso8601String(),
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }

  NfcCard copyWith({
    int? id,
    String? serialNumber,
    String? status,
    bool? isEncoded,
    bool? isAssigned,
    int? totalScanCount,
    DateTime? issuedDate,
    DateTime? expiryDate,
    DateTime? lastUsedAt,
    DateTime? uploadedAt,
  }) {
    return NfcCard(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      status: status ?? this.status,
      isEncoded: isEncoded ?? this.isEncoded,
      isAssigned: isAssigned ?? this.isAssigned,
      totalScanCount: totalScanCount ?? this.totalScanCount,
      issuedDate: issuedDate ?? this.issuedDate,
      expiryDate: expiryDate ?? this.expiryDate,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

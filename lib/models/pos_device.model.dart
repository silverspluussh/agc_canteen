class PosDevice {
  final String id;
  final String name;
  final String serialNumber;
  final String? model;
  final String status;
  final String? macAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PosDevice({
    required this.id,
    required this.name,
    required this.serialNumber,
    this.model,
    required this.status,
    this.macAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PosDevice.fromMap(Map<String, dynamic> map) {
    return PosDevice(
      id: map['id'] as String,
      name: map['name'] as String,
      serialNumber: map['serial_number'] as String,
      model: map['model'] as String?,
      status: map['status'] as String,
      macAddress: map['mac_address'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'serial_number': serialNumber,
      'model': model,
      'status': status,
      'mac_address': macAddress,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PosDevice copyWith({
    String? id,
    String? name,
    String? serialNumber,
    String? model,
    String? status,
    String? macAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PosDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      serialNumber: serialNumber ?? this.serialNumber,
      model: model ?? this.model,
      status: status ?? this.status,
      macAddress: macAddress ?? this.macAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

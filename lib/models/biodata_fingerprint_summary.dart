/// Lightweight bio-data row for list UIs (no fingerprint template payload).
class BioDataFingerprintSummary {
  final int id;
  final int? staffId;
  final int? dependentId;
  final int? contractorStaffId;
  final int? visitorId;
  final String finger;
  final String createdAt;

  const BioDataFingerprintSummary({
    required this.id,
    this.staffId,
    this.dependentId,
    this.contractorStaffId,
    this.visitorId,
    required this.finger,
    required this.createdAt,
  });
}

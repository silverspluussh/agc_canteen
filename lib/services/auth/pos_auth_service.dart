import '../database/app_database.dart';
import 'fingerprint_auth_service.dart';

class StaffAuthResult {
  final String staffId;
  final String firstName;
  final String lastName;

  const StaffAuthResult({
    required this.staffId,
    required this.firstName,
    required this.lastName,
  });
}

class PosAuthService {
  final AppDatabase _db;
  final FingerprintAuthService _fingerprintAuth;

  PosAuthService({
    required AppDatabase db,
    required FingerprintAuthService fingerprintAuth,
  })  : _db = db,
        _fingerprintAuth = fingerprintAuth;

  Future<void> init() async {
    await _fingerprintAuth.init();
  }

  Future<bool> get isFingerprintAvailable => _fingerprintAuth.isAvailable;


  Future<StaffAuthResult?> authenticateWithFingerprint() async {
    final staffId = await _fingerprintAuth.authenticate();
    if (staffId == null) return null;

    final staff = await _db.getStaff(staffId);
    if (staff == null) return null;

    return StaffAuthResult(
      staffId: staff.id,
      firstName: staff.firstName,
      lastName: staff.lastName,
    );
  }

  /// Authenticate with PIN (fallback when fingerprint isn't available).
  Future<StaffAuthResult?> authenticateWithPin(
      String staffId, String pin) async {
    // TODO: implement PIN verification against staff table or remote
    final staff = await _db.getStaff(staffId);
    if (staff == null) return null;

    // TODO: verify pin

    return StaffAuthResult(
      staffId: staff.id,
      firstName: staff.firstName,
      lastName: staff.lastName,
    );
  }

  /// Enroll a new fingerprint for a staff member.
  Future<String?> enrollFingerprint(String staffId) async {
    return _fingerprintAuth.enroll(staffId);
  }

  /// Get all enrolled fingerprint IDs for a staff member.
  Future<List<String>> getFingerprintsForStaff(String staffId) async {
    return _fingerprintAuth.getFingerprintsForStaff(staffId);
  }

  /// Remove a fingerprint from a staff member.
  Future<void> deleteFingerprint(String fingerprintId) async {
    await _fingerprintAuth.deleteFingerprint(fingerprintId);
  }
}

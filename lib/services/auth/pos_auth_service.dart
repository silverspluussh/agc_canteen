import 'dart:developer' as dev;
import 'package:agc_canteen/models/staff.model.dart';

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

  Future<bool> init() async {
    dev.log('[PosAuthService] Initializing fingerprint auth service...',
        name: 'POS_AUTH');
    final ok = await _fingerprintAuth.init();
    dev.log('[PosAuthService] Fingerprint auth init result: $ok', name: 'POS_AUTH');
    return ok;
  }

  Future<bool> get isFingerprintAvailable => _fingerprintAuth.isAvailable;


  Future<StaffAuthResult?> authenticateWithFingerprint() async {
    dev.log('[PosAuthService] authenticateWithFingerprint() — calling fingerprintAuth.authenticate()',
        name: 'POS_AUTH');
    final staffId = await _fingerprintAuth.authenticate();
    dev.log('[PosAuthService] fingerprintAuth.authenticate() returned: staffId=$staffId',
        name: 'POS_AUTH');
    if (staffId == null) return null;

    dev.log('[PosAuthService] Looking up staff in DB: staffId=$staffId',
        name: 'POS_AUTH');
    final staff = await _db.getStaff(staffId);
    if (staff == null) {
      dev.log('[PosAuthService] Staff NOT found in DB for staffId=$staffId',
          name: 'POS_AUTH');
      return null;
    }

    dev.log('[PosAuthService] Staff found: ${staff.firstName} ${staff.lastName} (id=${staff.id})',
        name: 'POS_AUTH');
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
  Future<int?> enrollFingerprint(String staffId,  Finger finger) async {
    return _fingerprintAuth.enroll(staffId, finger);
  }

  /// Get all enrolled fingerprint IDs for a staff member.
  Future<List<int>> getFingerprintsForStaff(String staffId) async {
    return _fingerprintAuth.getFingerprintsForStaff(staffId);
  }

  /// Remove a fingerprint from a staff member.
  Future<void> deleteFingerprint(int fingerprintId) async {
    await _fingerprintAuth.deleteFingerprint(fingerprintId);
  }
}

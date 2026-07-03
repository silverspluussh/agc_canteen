import 'dart:developer' as dev;
import 'package:canteen_staff_enrollment/models/biodata.model.dart';
import 'package:canteen_staff_enrollment/models/staff.model.dart';
import 'fingerprint_auth_service.dart';

class StaffAuthResult {
  final int staffId;
  final String firstName;
  final String lastName;

  const StaffAuthResult({
    required this.staffId,
    required this.firstName,
    required this.lastName,
  });
}

class PosAuthService {
  final FingerprintAuthService _fingerprintAuth;

  PosAuthService({
    required FingerprintAuthService fingerprintAuth,
  })  : 
        _fingerprintAuth = fingerprintAuth;

  Future<bool> init() async {
    dev.log('[PosAuthService] Initializing fingerprint auth service...',
        name: 'POS_AUTH');
    final ok = await _fingerprintAuth.init();
    dev.log('[PosAuthService] Fingerprint auth init result: $ok', name: 'POS_AUTH');
    return ok;
  }

  Future<bool> get isFingerprintAvailable => _fingerprintAuth.isAvailable;

  Future<int?> enrollFingerprint(int staffId,  Finger finger) async {
    return _fingerprintAuth.enroll(staffId, finger);
  }
  
}

import 'dart:developer' as dev;
import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/models/staff.model.dart';
import '../database/app_database.dart';
import 'fingerprint_auth_service.dart';
import 'nfc_auth_service.dart';

enum AuthFailureReason { notEnrolled, notInKitchen }

class AuthResult {
  final int? entityId;
  final EmployeeType? entityType;
  final String? displayName;
  final AuthFailureReason? failureReason;
  final int? staffId;
  final String? firstName;
  final String? lastName;

  bool get isAuthenticated => entityId != null;

  const AuthResult.authenticated({
    required int entityId,
    required EmployeeType entityType,
    required String displayName,
    int? staffId,
    String? firstName,
    String? lastName,
  }) : entityId = entityId,
       entityType = entityType,
       displayName = displayName,
       failureReason = null,
       staffId = staffId,
       firstName = firstName,
       lastName = lastName;

  const AuthResult.failed({required this.failureReason})
    : entityId = null,
      entityType = null,
      displayName = null,
      staffId = null,
      firstName = null,
      lastName = null;
}

class PosAuthService {
  final AppDatabase _db;
  final FingerprintAuthService _fingerprintAuth;
  final NfcAuthService _nfcAuth;

  PosAuthService({
    required AppDatabase db,
    required FingerprintAuthService fingerprintAuth,
    required NfcAuthService nfcAuth,
  }) : _db = db,
       _fingerprintAuth = fingerprintAuth,
       _nfcAuth = nfcAuth;

  Future<bool> init() async {
    dev.log(
      '[PosAuthService] Initializing fingerprint auth service...',
      name: 'POS_AUTH',
    );
    final ok = await _fingerprintAuth.init();
    dev.log(
      '[PosAuthService] Fingerprint auth init result: $ok',
      name: 'POS_AUTH',
    );
    return ok;
  }

  Future<bool> get isFingerprintAvailable => _fingerprintAuth.isAvailable;

  Future<AuthResult> authenticateWithFingerprint({int? departmentId}) async {
    dev.log(
      '[PosAuthService] authenticateWithFingerprint(departmentId=$departmentId) — calling fingerprintAuth.authenticate()',
      name: 'POS_AUTH',
    );
    final match = await _fingerprintAuth.authenticate(departmentId: departmentId);
    dev.log(
      '[PosAuthService] fingerprintAuth.authenticate() returned: match=$match',
      name: 'POS_AUTH',
    );
    if (match == null) {
      return const AuthResult.failed(
        failureReason: AuthFailureReason.notEnrolled,
      );
    }

    // Resolve entity type and ID directly from the matched bio_data_entry,
    // which now carries personnelName, departmentId, and departmentName
    // — no separate entity table query needed.
    final displayName = match.personnelName;
    final entityId = match.staffId ?? match.dependentId ?? match.contractorStaffId ?? match.visitorId;

    if (entityId == null || displayName == null || displayName.isEmpty) {
      return const AuthResult.failed(
        failureReason: AuthFailureReason.notInKitchen,
      );
    }

    final EmployeeType entityType;
    if (match.staffId != null) {
      entityType = EmployeeType.permanent;
    } else if (match.dependentId != null) {
      entityType = EmployeeType.dependent;
    } else if (match.contractorStaffId != null) {
      entityType = EmployeeType.contractor;
    } else {
      entityType = EmployeeType.visitor;
    }

    return AuthResult.authenticated(
      entityId: entityId,
      entityType: entityType,
      displayName: displayName,
      staffId: entityId,
    );
  }

  /// Authenticate with PIN (fallback when fingerprint isn't available).
  Future<AuthResult> authenticateWithPin(String staffId, String pin) async {
    final staff = await _db.getStaff(int.tryParse(staffId) ?? 0);
    if (staff == null) {
      return const AuthResult.failed(
        failureReason: AuthFailureReason.notInKitchen,
      );
    }

    // TODO: verify pin

    return AuthResult.authenticated(
      entityId: staff.id,
      entityType: EmployeeType.permanent,
      displayName: '${staff.firstName} ${staff.lastName}',
      staffId: staff.id,
      firstName: staff.firstName,
      lastName: staff.lastName,
    );
  }

  Future<AuthResult> authenticateWithNfc({int? departmentId}) async {
    dev.log('[PosAuthService] authenticateWithNfc(departmentId=$departmentId) — reading NFC card', name: 'POS_AUTH');
    final card = await _nfcAuth.readCard(departmentId: departmentId);

    if (card == null) {
      return const AuthResult.failed(failureReason: AuthFailureReason.notEnrolled);
    }

    final assignedToId = card.assignedToId;
    final assignedToType = card.assignedToType;

    if (assignedToId == null || assignedToType == null) {
      return const AuthResult.failed(failureReason: AuthFailureReason.notEnrolled);
    }

    // Use personnelName from the card directly — no entity table query needed.
    final displayName = card.personnelName;
    if (displayName == null || displayName.isEmpty) {
      return const AuthResult.failed(failureReason: AuthFailureReason.notInKitchen);
    }

    final employeeType = EmployeeType.values.firstWhere(
      (e) => e.name == assignedToType,
      orElse: () => EmployeeType.permanent,
    );

    return AuthResult.authenticated(
      entityId: assignedToId,
      entityType: employeeType,
      displayName: displayName,
      staffId: assignedToId,
    );
  }

  /// Enroll a new fingerprint for an entity.
  Future<int?> enrollFingerprint(
    int entityId,
    Finger finger, {
    EmployeeType entityType = EmployeeType.permanent,
  }) async {
    return _fingerprintAuth.enroll(entityId, finger, entityType: entityType);
  }

  /// Get all enrolled fingerprint IDs for an entity.
  Future<List<int>> getFingerprintsForEntity(
    int entityId, {
    EmployeeType entityType = EmployeeType.permanent,
  }) async {
    return _fingerprintAuth.getFingerprintsForEntity(
      entityId,
      entityType: entityType,
    );
  }

  /// Remove a fingerprint from a staff member.
  Future<void> deleteFingerprint(int fingerprintId) async {
    await _fingerprintAuth.deleteFingerprint(fingerprintId);
  }
}

/// Backward-compatible alias.
typedef StaffAuthResult = AuthResult;

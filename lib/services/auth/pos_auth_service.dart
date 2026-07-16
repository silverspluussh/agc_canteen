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

  Future<AuthResult> authenticateWithFingerprint() async {
    dev.log(
      '[PosAuthService] authenticateWithFingerprint() — calling fingerprintAuth.authenticate()',
      name: 'POS_AUTH',
    );
    final match = await _fingerprintAuth.authenticate();
    dev.log(
      '[PosAuthService] fingerprintAuth.authenticate() returned: match=$match',
      name: 'POS_AUTH',
    );
    if (match == null) {
      return const AuthResult.failed(
        failureReason: AuthFailureReason.notEnrolled,
      );
    }

    if (match.staffId != null) {
      final staff = await _db.getStaff(match.staffId!);
      if (staff != null) {
        dev.log(
          '[PosAuthService] Staff found: ${staff.firstName} ${staff.lastName} (id=${staff.id})',
          name: 'POS_AUTH',
        );
        return AuthResult.authenticated(
          entityId: staff.id,
          entityType: EmployeeType.permanent,
          displayName: '${staff.firstName} ${staff.lastName}',
          staffId: staff.id,
          firstName: staff.firstName,
          lastName: staff.lastName,
        );
      }
    }

    if (match.dependentId != null) {
      final dep = await _db.getDependent(match.dependentId!);
      if (dep != null) {
        dev.log(
          '[PosAuthService] Dependent found: ${dep.fullname} (id=${dep.id})',
          name: 'POS_AUTH',
        );
        return AuthResult.authenticated(
          entityId: dep.id,
          entityType: EmployeeType.dependent,
          displayName: dep.fullname,
        );
      }
    }

    if (match.contractorStaffId != null) {
      final cs = await _db.getContractorStaff(match.contractorStaffId!);
      if (cs != null) {
        dev.log(
          '[PosAuthService] ContractorStaff found: ${cs.name} (id=${cs.id})',
          name: 'POS_AUTH',
        );
        return AuthResult.authenticated(
          entityId: cs.id,
          entityType: EmployeeType.contractor,
          displayName: cs.name,
        );
      }
    }

    if (match.visitorId != null) {
      final visitor = await _db.getVisitor(match.visitorId!);
      if (visitor != null) {
        dev.log(
          '[PosAuthService] Visitor found: ${visitor.name} (id=${visitor.id})',
          name: 'POS_AUTH',
        );
        return AuthResult.authenticated(
          entityId: visitor.id,
          entityType: EmployeeType.visitor,
          displayName: visitor.name,
        );
      }
    }

    dev.log(
      '[PosAuthService] Entity NOT found in DB for matched bioData (id=${match.id})',
      name: 'POS_AUTH',
    );
    return const AuthResult.failed(
      failureReason: AuthFailureReason.notInKitchen,
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

  Future<AuthResult> authenticateWithNfc() async {
    dev.log('[PosAuthService] authenticateWithNfc() — reading NFC card', name: 'POS_AUTH');
    final card = await _nfcAuth.readCard();

    if (card == null) {
      return const AuthResult.failed(failureReason: AuthFailureReason.notEnrolled);
    }

    final assignedToId = card.assignedToId;
    final assignedToType = card.assignedToType;

    if (assignedToId == null || assignedToType == null) {
      return const AuthResult.failed(failureReason: AuthFailureReason.notEnrolled);
    }

    final employeeType = EmployeeType.values.firstWhere(
      (e) => e.name == assignedToType,
      orElse: () => EmployeeType.permanent,
    );

    if (employeeType.isStaffType) {
      final staff = await _db.getStaff(assignedToId);
      if (staff != null) {
        return AuthResult.authenticated(
          entityId: staff.id,
          entityType: employeeType,
          displayName: '${staff.firstName} ${staff.lastName}',
          staffId: staff.id,
          firstName: staff.firstName,
          lastName: staff.lastName,
        );
      }
    }

    if (employeeType == EmployeeType.dependent) {
      final dep = await _db.getDependent(assignedToId);
      if (dep != null) {
        return AuthResult.authenticated(
          entityId: dep.id,
          entityType: EmployeeType.dependent,
          displayName: dep.fullname,
        );
      }
    }

    if (employeeType == EmployeeType.contractor) {
      final cs = await _db.getContractorStaff(assignedToId);
      if (cs != null) {
        return AuthResult.authenticated(
          entityId: cs.id,
          entityType: EmployeeType.contractor,
          displayName: cs.name,
        );
      }
    }

    if (employeeType == EmployeeType.visitor) {
      final visitor = await _db.getVisitor(assignedToId);
      if (visitor != null) {
        return AuthResult.authenticated(
          entityId: visitor.id,
          entityType: EmployeeType.visitor,
          displayName: visitor.name,
        );
      }
    }

    return const AuthResult.failed(failureReason: AuthFailureReason.notInKitchen);
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

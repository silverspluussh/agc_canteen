import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/core/utils/app_log.dart';
import 'package:agc_canteen/models/staff.model.dart';
import '../../core/di/injection_container.dart';
import '../database/app_database.dart';
import '../pos/pos_device_service.dart';
import 'fingerprint_auth_service.dart';
import 'nfc_auth_service.dart';

enum AuthFailureReason { notEnrolled, entityNotFound }

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
  final FingerprintAuthService _fingerprintAuth;
  final NfcAuthService _nfcAuth;

  PosAuthService({
    required FingerprintAuthService fingerprintAuth,
    required NfcAuthService nfcAuth,
  }) : _fingerprintAuth = fingerprintAuth,
       _nfcAuth = nfcAuth;

  /// Cancels any in-progress auth (fingerprint capture or NFC read).
  Future<void> cancelAuth() async {
    await _fingerprintAuth.cancel();
    _nfcAuth.cancel();
  }

  Future<bool> init() async {
    appLog(
      '[PosAuthService] Initializing POS device + fingerprint auth...',
      name: 'POS_AUTH',
    );
    final deviceOk = await getIt<PosDeviceService>().init();
    appLog(
      '[PosAuthService] POS device init result: $deviceOk',
      name: 'POS_AUTH',
    );
    final ok = await _fingerprintAuth.init();
    appLog(
      '[PosAuthService] Fingerprint auth init result: $ok',
      name: 'POS_AUTH',
    );
    return ok;
  }

  Future<bool> get isFingerprintAvailable => _fingerprintAuth.isAvailable;

  Future<AuthResult> authenticateWithFingerprint({int? departmentId}) async {
    appLog(
      '[PosAuthService] authenticateWithFingerprint(departmentId=$departmentId) — calling fingerprintAuth.authenticate()',
      name: 'POS_AUTH',
    );
    final match = await _fingerprintAuth.authenticate(departmentId: departmentId);
    appLog(
      '[PosAuthService] fingerprintAuth.authenticate() returned: match=$match',
      name: 'POS_AUTH',
    );
    if (match == null) {
      return const AuthResult.failed(
        failureReason: AuthFailureReason.notEnrolled,
      );
    }

    return _resolveEntityFromBio(match);
  }

  Future<AuthResult> authenticateWithNfc({int? departmentId}) async {
    appLog('[PosAuthService] authenticateWithNfc(departmentId=$departmentId) — reading NFC card', name: 'POS_AUTH');
    final card = await _nfcAuth.readCard(departmentId: departmentId);

    if (card == null) {
      return const AuthResult.failed(failureReason: AuthFailureReason.notEnrolled);
    }

    final assignedToId = card.assignedToId;
    final assignedToType = card.assignedToType;

    if (assignedToId == null || assignedToType == null) {
      return const AuthResult.failed(failureReason: AuthFailureReason.notEnrolled);
    }

    final hintedType = EmployeeType.tryParse(assignedToType);
    return _resolveEntityByIdAndType(
      entityId: assignedToId,
      hintedType: hintedType,
      fallbackName: card.personnelName,
    );
  }

  /// Resolves staff / dependent / contractor / visitor from a bio match FK.
  Future<AuthResult> _resolveEntityFromBio(BioDataEntry match) async {
    if (match.staffId != null) {
      return _resolveStaff(match.staffId!, fallbackName: match.personnelName);
    }
    if (match.dependentId != null) {
      return _resolveDependent(match.dependentId!, fallbackName: match.personnelName);
    }
    if (match.contractorStaffId != null) {
      return _resolveContractorStaff(
        match.contractorStaffId!,
        fallbackName: match.personnelName,
      );
    }
    if (match.visitorId != null) {
      return _resolveVisitor(match.visitorId!, fallbackName: match.personnelName);
    }

    appLog(
      '[PosAuthService] Bio match has no entity FK (id=${match.id})',
      name: 'POS_AUTH',
    );
    return const AuthResult.failed(failureReason: AuthFailureReason.entityNotFound);
  }

  Future<AuthResult> _resolveEntityByIdAndType({
    required int entityId,
    required EmployeeType? hintedType,
    String? fallbackName,
  }) async {
    if (hintedType == null) {
      // Try staff first, then other entity tables.
      final staffResult = await _resolveStaff(entityId, fallbackName: fallbackName);
      if (staffResult.isAuthenticated) return staffResult;
      final dependentResult =
          await _resolveDependent(entityId, fallbackName: fallbackName);
      if (dependentResult.isAuthenticated) return dependentResult;
      final contractorResult =
          await _resolveContractorStaff(entityId, fallbackName: fallbackName);
      if (contractorResult.isAuthenticated) return contractorResult;
      return _resolveVisitor(entityId, fallbackName: fallbackName);
    }

    if (hintedType.isStaffType) {
      return _resolveStaff(entityId, fallbackName: fallbackName);
    }
    return switch (hintedType) {
      EmployeeType.dependent =>
        _resolveDependent(entityId, fallbackName: fallbackName),
      EmployeeType.contractor =>
        _resolveContractorStaff(entityId, fallbackName: fallbackName),
      EmployeeType.visitor =>
        _resolveVisitor(entityId, fallbackName: fallbackName),
      _ => _resolveStaff(entityId, fallbackName: fallbackName),
    };
  }

  Future<AuthResult> _resolveStaff(int staffId, {String? fallbackName}) async {
    final db = getIt<AppDatabase>();
    final staff = await db.getStaff(staffId);
    if (staff == null) {
      appLog(
        '[PosAuthService] Staff not found for id=$staffId',
        name: 'POS_AUTH',
      );
      return const AuthResult.failed(failureReason: AuthFailureReason.entityNotFound);
    }

    final entityType =
        EmployeeType.tryParse(staff.employeeType) ?? EmployeeType.permanent;
    final displayName = '${staff.firstName} ${staff.lastName}'.trim();
    final name = displayName.isNotEmpty
        ? displayName
        : (fallbackName?.trim().isNotEmpty == true ? fallbackName!.trim() : null);

    if (name == null || name.isEmpty) {
      return const AuthResult.failed(failureReason: AuthFailureReason.entityNotFound);
    }

    appLog(
      '[PosAuthService] Resolved staff id=$staffId type=${entityType.name} name=$name',
      name: 'POS_AUTH',
    );
    return AuthResult.authenticated(
      entityId: staffId,
      entityType: entityType,
      displayName: name,
      staffId: staffId,
      firstName: staff.firstName,
      lastName: staff.lastName,
    );
  }

  Future<AuthResult> _resolveDependent(
    int dependentId, {
    String? fallbackName,
  }) async {
    final db = getIt<AppDatabase>();
    final dependent = await db.getDependent(dependentId);
    if (dependent == null) {
      appLog(
        '[PosAuthService] Dependent not found for id=$dependentId',
        name: 'POS_AUTH',
      );
      return const AuthResult.failed(failureReason: AuthFailureReason.entityNotFound);
    }

    final name = dependent.fullname.trim().isNotEmpty
        ? dependent.fullname.trim()
        : (fallbackName?.trim().isNotEmpty == true ? fallbackName!.trim() : null);
    if (name == null || name.isEmpty) {
      return const AuthResult.failed(failureReason: AuthFailureReason.entityNotFound);
    }

    return AuthResult.authenticated(
      entityId: dependentId,
      entityType: EmployeeType.dependent,
      displayName: name,
      staffId: dependentId,
    );
  }

  Future<AuthResult> _resolveContractorStaff(
    int contractorStaffId, {
    String? fallbackName,
  }) async {
    final db = getIt<AppDatabase>();
    final contractor = await db.getContractorStaff(contractorStaffId);
    if (contractor == null) {
      appLog(
        '[PosAuthService] Contractor staff not found for id=$contractorStaffId',
        name: 'POS_AUTH',
      );
      return const AuthResult.failed(failureReason: AuthFailureReason.entityNotFound);
    }

    final name = contractor.name.trim().isNotEmpty
        ? contractor.name.trim()
        : (fallbackName?.trim().isNotEmpty == true ? fallbackName!.trim() : null);
    if (name == null || name.isEmpty) {
      return const AuthResult.failed(failureReason: AuthFailureReason.entityNotFound);
    }

    return AuthResult.authenticated(
      entityId: contractorStaffId,
      entityType: EmployeeType.contractor,
      displayName: name,
      staffId: contractorStaffId,
    );
  }

  Future<AuthResult> _resolveVisitor(
    int visitorId, {
    String? fallbackName,
  }) async {
    final db = getIt<AppDatabase>();
    final visitor = await db.getVisitor(visitorId);
    if (visitor == null) {
      appLog(
        '[PosAuthService] Visitor not found for id=$visitorId',
        name: 'POS_AUTH',
      );
      return const AuthResult.failed(failureReason: AuthFailureReason.entityNotFound);
    }

    final name = visitor.name.trim().isNotEmpty
        ? visitor.name.trim()
        : (fallbackName?.trim().isNotEmpty == true ? fallbackName!.trim() : null);
    if (name == null || name.isEmpty) {
      return const AuthResult.failed(failureReason: AuthFailureReason.entityNotFound);
    }

    return AuthResult.authenticated(
      entityId: visitorId,
      entityType: EmployeeType.visitor,
      displayName: name,
      staffId: visitorId,
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

import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/models/staff.model.dart';
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import '../database/app_database.dart';
import '../pos/pos_fingerprint_service.dart';
import '../database/activity_log_service.dart';
import '../sync_services/sync_from_local_to_remote.dart';
import '../../core/di/injection_container.dart';

class FingerprintAuthService {
  final AppDatabase _db;
  final PosFingerprintService _fingerprint;
  final Logger _logger;

  static const int matchThreshold = 80;

  FingerprintAuthService({
    required AppDatabase db,
    required PosFingerprintService fingerprint,
    Logger? logger,
  })  : _db = db,
        _fingerprint = fingerprint,
        _logger = logger ?? Logger();

  Future<bool> init() async {
    dev.log('[FingerprintAuth] Initializing fingerprint device...',
        name: 'POS_AUTH');
    const maxRetries = 4;
    await Future.delayed(const Duration(seconds: 2));
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final ok = await _fingerprint.init();
        if (ok) {
          dev.log('[FingerprintAuth] Fingerprint device initialized successfully (attempt $attempt)',
              name: 'POS_AUTH');
          return true;
        }
        dev.log('[FingerprintAuth] Fingerprint device init returned false (attempt $attempt/$maxRetries)',
            name: 'POS_AUTH');
      } on PlatformException catch (e) {
        dev.log('[FingerprintAuth] Fingerprint device init error (attempt $attempt/$maxRetries): ${e.code} — ${e.message}',
            name: 'POS_AUTH');
        if (e.code == 'FINGER_INIT_ERROR' || (e.message?.contains('already in progress') ?? false)) {
          dev.log('[FingerprintAuth] SDK init in progress, waiting...', name: 'POS_AUTH');
          await Future.delayed(const Duration(seconds: 5));
          continue;
        }
      }
      if (attempt < maxRetries) {
        await Future.delayed(Duration(seconds: attempt));
      }
    }
    throw Exception('Fingerprint device initialization failed after $maxRetries attempts');
  }

  Future<bool> get isAvailable => _fingerprint.isAvailable();

  /// Cancels an in-progress fingerprint capture.
  Future<void> cancel() => _fingerprint.cancel();

  
  Future<bool> hasFingerType(int entityId, Finger finger, {EmployeeType entityType = EmployeeType.permanent}) async {
    final fingerprints = await _getActiveBioData(entityId, entityType: entityType);
    return fingerprints.any((f) => f.finger == finger.name);
  }

  Future<List<BioDataEntry>> _getActiveBioData(int entityId, {required EmployeeType entityType}) async {
    if (entityType.isStaffType) {
      return _db.getActiveBioDataByStaff(entityId);
    }
    switch (entityType) {
      case EmployeeType.dependent:
        return _db.getActiveBioDataByDependent(entityId);
      case EmployeeType.contractor:
        return _db.getActiveBioDataByContractorStaff(entityId);
      case EmployeeType.visitor:
        return _db.getActiveBioDataByVisitor(entityId);
      default:
        return [];
    }
  }

  Future<int?> enroll(int entityId, Finger finger, {EmployeeType entityType = EmployeeType.permanent}) async {
    final result = await _fingerprint.capture();
    if (result == null || !result.success || result.templateBase64 == null) {
      _logger.w('Fingerprint enrollment capture failed');
      return null;
    }

    final fingerprintId = DateTime.now().millisecondsSinceEpoch;
    final now = DateTime.now().toIso8601String();
    final base64data = result.templateBase64??"";

    // Look up department info for staff-type entities
    int? departmentId;
    String? departmentName;
    String? personnelName;
    if (entityType.isStaffType) {
      final staff = await _db.getStaff(entityId);
      if (staff != null) {
        departmentId = staff.departmentId;
        final dep = departmentId != null ? await _db.getDepartment(departmentId) : null;
        departmentName = dep?.name;
        personnelName = '${staff.firstName} ${staff.lastName}';
      }
    }

    final companion = BioDataEntriesCompanion(
      id: Value(fingerprintId),
      finger: Value(finger.name),
      dataBase64: Value(base64data),
      isActive: const Value(true),
      departmentId: Value.absentIfNull(departmentId),
      departmentName: Value.absentIfNull(departmentName),
      personnelName: Value.absentIfNull(personnelName),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value(0),
      syncUpdatedAt: const Value.absent(),
    );

    switch (entityType) {
      case EmployeeType.permanent:
      case EmployeeType.graduateTrainee:
      case EmployeeType.nationalService:
      case EmployeeType.intern:
        await _db.insertBioData(companion.copyWith(staffId: Value(entityId)));
      case EmployeeType.dependent:
        await _db.insertBioData(companion.copyWith(dependentId: Value(entityId)));
      case EmployeeType.contractor:
        await _db.insertBioData(companion.copyWith(contractorStaffId: Value(entityId)));
      case EmployeeType.visitor:
        await _db.insertBioData(companion.copyWith(visitorId: Value(entityId)));
    }

    unawaited(getIt<LocalToRemoteSyncService>().syncBioData());

    _logger.i('Fingerprint enrolled: id=$fingerprintId entityId=$entityId type=${entityType.name}');
    getIt<ActivityLogService>().log(
      type: 'fingerprint_enrolled',
      message: 'Fingerprint enrolled for ${entityType.name}: $entityId',
      actorType: entityType.name,
      actorId: entityId,
      sourceTable: 'bio_data_entries',
      recordId: fingerprintId.toString(),
    );
    return fingerprintId;
  }

  Future<BioDataEntry?> authenticate({int? departmentId}) async {
    dev.log('[FingerprintAuth] Starting fingerprint capture via hardware...',
        name: 'POS_AUTH');
    final result = await _fingerprint.capture();
    if (result == null || !result.success || result.templateBase64 == null) {
      dev.log('[FingerprintAuth] Capture FAILED: '
          'result=${result != null ? "success=${result.success}, template=${result.templateBase64 != null}" : "null"}',
          name: 'POS_AUTH');
      _logger.w('Fingerprint authentication capture failed');
      return null;
    }

    dev.log('[FingerprintAuth] Capture SUCCESS — templateBase64 length=${result.templateBase64!.length}',
        name: 'POS_AUTH');

    final query = _db.selectOnly(_db.bioDataEntries)
      ..addColumns([
        _db.bioDataEntries.id,
        _db.bioDataEntries.dataBase64,
        _db.bioDataEntries.staffId,
        _db.bioDataEntries.dependentId,
        _db.bioDataEntries.contractorStaffId,
        _db.bioDataEntries.visitorId,
      ])
      ..where(_db.bioDataEntries.isActive.equals(true));
    if (departmentId != null) {
      query.where(_db.bioDataEntries.departmentId.equals(departmentId));
    }
    final rows = await query.get();

    dev.log('[FingerprintAuth] Got ${rows.length} active fingerprint(s) from DB',
        name: 'POS_AUTH');

    if (rows.isEmpty) {
      dev.log('[FingerprintAuth] No fingerprints stored in local DB — no match possible',
          name: 'POS_AUTH');
      _logger.w('No fingerprints stored locally');
      return null;
    }

    int? bestId;
    int bestScore = -1;

    for (final row in rows) {
      final id = row.read(_db.bioDataEntries.id)!;
      final dataBase64 = row.read(_db.bioDataEntries.dataBase64)!;
      final staffId = row.read(_db.bioDataEntries.staffId);
      dev.log('[FingerprintAuth] Verifying against templateId=$id, staffId=$staffId',
          name: 'POS_AUTH');
      final score = await _fingerprint.verify(dataBase64);
      dev.log('[FingerprintAuth] Verify result: score=$score for staffId=$staffId',
          name: 'POS_AUTH');
      if (score != null && score > bestScore) {
        bestScore = score;
        bestId = id;
        if (bestScore >= 95) break;
      }
    }

    if (bestId != null && bestScore >= matchThreshold) {
      final bestMatch = await _db.getBioData(bestId);
      if (bestMatch != null) {
        dev.log('[FingerprintAuth] MATCH FOUND: staffId=${bestMatch.staffId}, score=$bestScore (threshold=$matchThreshold)',
            name: 'POS_AUTH');
        _logger.i(
            'Fingerprint matched: staffId=${bestMatch.staffId} score=$bestScore');
        return bestMatch;
      }
    }

    dev.log('[FingerprintAuth] NO MATCH: bestScore=$bestScore (threshold=$matchThreshold)',
        name: 'POS_AUTH');
    _logger.w('No fingerprint match. Best score: $bestScore');
    return null;
  }

  /// Get all stored template IDs for a staff member.
  Future<List<int>> getFingerprintsForEntity(int entityId, {EmployeeType entityType = EmployeeType.permanent}) async {
    final fingerprints = await _getActiveBioData(entityId, entityType: entityType);
    return fingerprints.map((t) => t.id).toList();
  }

  /// Delete a stored fingerprint .
  Future<void> deleteFingerprint(int fingerprintId) async {
    await _db.deleteBioData(fingerprintId);
    getIt<ActivityLogService>().log(
      type: 'fingerprint_deleted',
      message: 'Fingerprint deleted: $fingerprintId',
      sourceTable: 'bio_data_entries',
      recordId: fingerprintId.toString(),
    );
  }

  Future<void> deactivateFingerprint(int fingerprintId) async {
    final now = DateTime.now().toIso8601String();
    await _db.updateBioData(
      fingerprintId,
      BioDataEntriesCompanion(
        isActive: const Value(false),
        updatedAt: Value(now),
        syncStatus: const Value(0),
        syncUpdatedAt: Value(now),
      ),
    );
    getIt<ActivityLogService>().log(
      type: 'fingerprint_deactivated',
      message: 'Fingerprint deactivated: $fingerprintId',
      sourceTable: 'bio_data_entries',
      recordId: fingerprintId.toString(),
    );
  }

  /// Count unsynced fingerprints.
  Future<int> getUnsyncedCount() async {
    final unsynced = await _db.getUnsyncedBioData();
    return unsynced.length;
  }

  /// Count total active fingerprints stored locally.
  Future<int> getStoredFingerprintCount() async {
    final fingerprints = await _db.getActiveBioData();
    return fingerprints.length;
  }
}

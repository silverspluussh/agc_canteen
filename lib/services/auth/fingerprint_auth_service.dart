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

  
  Future<bool> hasFingerType(int entityId, Finger finger, {EmployeeType entityType = EmployeeType.permanent}) async {
    final fingerprints = await _getActiveBioData(entityId, entityType: entityType);
    return fingerprints.any((f) => f.finger == finger.name);
  }

  Future<List<BioDataEntry>> _getActiveBioData(int entityId, {required EmployeeType entityType}) async {
    final all = await _db.getActiveBioData();
    switch (entityType) {
      case EmployeeType.permanent:
      case EmployeeType.graduateTrainee:
      case EmployeeType.nationalService:
      case EmployeeType.intern:
        return all.where((e) => e.staffId == entityId).toList();
      case EmployeeType.dependent:
        return all.where((e) => e.dependantId == entityId).toList();
      case EmployeeType.contractor:
        return all.where((e) => e.contractorStaffId == entityId).toList();
      case EmployeeType.visitor:
        return all.where((e) => e.visitorId == entityId).toList();
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
    // final encryptedData = await _encryptionService.encrypt(result.templateBase64!);

    final companion = BioDataEntriesCompanion(
      id: Value(fingerprintId),
      finger: Value(finger.name),
      dataBase64: Value(base64data),
      isActive: const Value(true),
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
        await _db.insertBioData(companion.copyWith(dependantId: Value(entityId)));
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

  Future<BioDataEntry?> authenticate() async {
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

    final fingerprints = await _db.getActiveBioData();

    dev.log('[FingerprintAuth] Got ${fingerprints.length} active fingerprint(s) from DB',
        name: 'POS_AUTH');

    if (fingerprints.isEmpty) {
        dev.log('[FingerprintAuth] No fingerprints stored in local DB — no match possible',
            name: 'POS_AUTH');
      _logger.w('No fingerprints stored locally');
      return null;
    }

    BioDataEntry? bestMatch;
    int bestScore = -1;

    for (final tpl in fingerprints) {
      dev.log('[FingerprintAuth] Verifying against templateId=${tpl.id}, staffId=${tpl.staffId}',
          name: 'POS_AUTH');
      String templateData;
      try {
        // templateData = await _encryptionService.decrypt(tpl.dataBase64);
              templateData = tpl.dataBase64;

      } catch (_) {
        templateData = tpl.dataBase64;
      }
      final score = await _fingerprint.verify(templateData);
      dev.log('[FingerprintAuth] Verify result: score=$score for staffId=${tpl.staffId}',
          name: 'POS_AUTH');
      if (score != null && score > bestScore) {
        bestScore = score;
        bestMatch = tpl;
      }
    }

    if (bestMatch != null && bestScore >= matchThreshold) {
      dev.log('[FingerprintAuth] MATCH FOUND: staffId=${bestMatch.staffId}, score=$bestScore (threshold=$matchThreshold)',
          name: 'POS_AUTH');
      _logger.i(
          'Fingerprint matched: staffId=${bestMatch.staffId} score=$bestScore');
      return bestMatch;
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

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/core/utils/app_log.dart';
import 'package:agc_canteen/models/staff.model.dart';
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../pos/pos_fingerprint_service.dart';
import '../database/activity_log_service.dart';
import '../sync_services/sync_from_local_to_remote.dart';
import 'fingerprint_template_cache.dart';
import '../../core/di/injection_container.dart';

class FingerprintAuthService {
  final AppDatabase _db;
  final PosFingerprintService _fingerprint;
  final Logger _logger;
  final FingerprintTemplateCache _templateCache;

  /// Default minimum native comparison score (0–100) for a match.
  static const int defaultMatchThreshold = 80;

  /// SharedPreferences key for the operator-tunable threshold.
  static const String matchThresholdPrefsKey = 'finger_match_threshold';

  bool _initialized = false;

  FingerprintAuthService({
    required AppDatabase db,
    required PosFingerprintService fingerprint,
    FingerprintTemplateCache? templateCache,
    Logger? logger,
  })  : _db = db,
        _fingerprint = fingerprint,
        _templateCache = templateCache ?? FingerprintTemplateCache(db: db),
        _logger = logger ?? createAppLogger();

  /// The configured match threshold, falling back to the default when unset or
  /// out of range.
  Future<int> _resolveMatchThreshold() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getInt(matchThresholdPrefsKey);
      if (value != null && value >= 0 && value <= 100) return value;
    } catch (e) {
      _logger.w('FingerprintAuth: could not read match threshold ($e)');
    }
    return defaultMatchThreshold;
  }

  Future<bool> init() async {
    if (_initialized) return true;
    // Extra grace for kernel SPI probe before the first launch() — see
    // SingleAuthPosPage 2s delay + 9s observed spidev ready window.
    await Future.delayed(const Duration(seconds: 2));
    // Fast-path if another page already initialized.
    try {
      if (await _fingerprint.isAvailable()) {
        _initialized = true;
        return true;
      }
    } catch (_) {}
    appLog('[FingerprintAuth] Initializing fingerprint device...',
        name: 'POS_AUTH');
    const maxRetries = 4;
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final ok = await _fingerprint.init();
        if (ok) {
          appLog('[FingerprintAuth] Fingerprint device initialized successfully (attempt $attempt)',
              name: 'POS_AUTH');
          _initialized = true;
          return true;
        }
        appLog('[FingerprintAuth] Fingerprint device init returned false (attempt $attempt/$maxRetries)',
            name: 'POS_AUTH');
      } on PlatformException catch (e) {
        appLog('[FingerprintAuth] Fingerprint device init error (attempt $attempt/$maxRetries): ${e.code} — ${e.message}',
            name: 'POS_AUTH');
        if (e.code == 'FINGER_INIT_ERROR' || (e.message?.contains('already in progress') ?? false)) {
          appLog('[FingerprintAuth] SDK init in progress, waiting...', name: 'POS_AUTH');
          await Future.delayed(const Duration(seconds: 5));
          continue;
        }
      }
      if (attempt < maxRetries) {
        // Exponential backoff: 2s, 4s, 8s — covers the ~9s spidev probe + jitter.
        await Future.delayed(Duration(seconds: 1 << attempt));
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

    final fingerprintId = await _db.nextLocalId('bio_data_entries');
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
      // Stable idempotency key: this exact capture must map to exactly one
      // server row no matter how many times the push is retried.
      uuid: Value(const Uuid().v4()),
      syncStatus: const Value(0),
      syncUpdatedAt: const Value.absent(),
    );

    switch (entityType) {
      case EmployeeType.permanent:
      case EmployeeType.graduateTrainee:
      case EmployeeType.nationalService:
      case EmployeeType.intern:
      case EmployeeType.shortTermContractor:
        await _db.insertBioData(companion.copyWith(staffId: Value(entityId)));
      case EmployeeType.dependent:
        await _db.insertBioData(companion.copyWith(dependentId: Value(entityId)));
      case EmployeeType.contractor:
        await _db.insertBioData(companion.copyWith(contractorStaffId: Value(entityId)));
      case EmployeeType.visitor:
        await _db.insertBioData(companion.copyWith(visitorId: Value(entityId)));
    }

    // The new template must be visible to the next scan.
    _templateCache.invalidate();

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
    await _fingerprint.cancel();
    appLog('[FingerprintAuth] Starting fingerprint capture via hardware...',
        name: 'POS_AUTH');
    final result = await _fingerprint.capture();
    if (result == null || !result.success || result.templateBase64 == null) {
      appLog('[FingerprintAuth] Capture FAILED: '
          'result=${result != null ? "success=${result.success}, template=${result.templateBase64 != null}" : "null"}',
          name: 'POS_AUTH');
      _logger.w('Fingerprint authentication capture failed');
      return null;
    }

    appLog('[FingerprintAuth] Capture SUCCESS — templateBase64 length=${result.templateBase64!.length}',
        name: 'POS_AUTH');

    // Scope is resolved through the owner's parent record (staff/contractor/
    // visitor/dependent), not the stored bio-data department — the latter is
    // only populated for staff-type enrolments, so contractor/visitor/dependent
    // templates would be invisible to a department-scoped scan otherwise. The
    // snapshot is cached in memory so a tap never re-reads the table.
    final rows = departmentId == null
        ? await _templateCache.all()
        : await _templateCache.forDepartment(departmentId);

    appLog('[FingerprintAuth] Got ${rows.length} active fingerprint(s) from DB',
        name: 'POS_AUTH');

    if (rows.isEmpty) {
      appLog('[FingerprintAuth] No fingerprints stored in local DB — no match possible',
          name: 'POS_AUTH');
      _logger.w('No fingerprints stored locally');
      return null;
    }

    // One native call compares the captured template against the whole scoped
    // set; only the best index + score cross the channel.
    final threshold = await _resolveMatchThreshold();
    final stopwatch = Stopwatch()..start();
    final match = await _fingerprint.verifyBatch(
      [for (final entry in rows) entry.dataBase64],
    );
    stopwatch.stop();
    appLog(
      '[FingerprintAuth] Batch verified ${rows.length} template(s) in '
      '${stopwatch.elapsedMilliseconds}ms',
      name: 'POS_AUTH',
    );
    final bestScore = match?.score ?? -1;

    if (match != null &&
        match.index >= 0 &&
        match.index < rows.length &&
        bestScore >= threshold) {
      final bestId = rows[match.index].id;
      final bestMatch = await _db.getBioData(bestId);
      if (bestMatch != null) {
        appLog('[FingerprintAuth] MATCH FOUND: staffId=${bestMatch.staffId}, score=$bestScore (threshold=$threshold)',
            name: 'POS_AUTH');
        _logger.i(
            'Fingerprint matched: staffId=${bestMatch.staffId} score=$bestScore');
        return bestMatch;
      }
    }

    appLog('[FingerprintAuth] NO MATCH: bestScore=$bestScore (threshold=$threshold)',
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
  Future<int> getUnsyncedCount() => _db.countUnsyncedBioData();

  /// Count total active fingerprints stored locally.
  Future<int> getStoredFingerprintCount() => _db.countActiveBioData();
}

import 'dart:developer' as dev;
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';
import '../database/app_database.dart';
import '../pos/pos_fingerprint_service.dart';
import '../activity_log_service.dart';
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
    final ok = await _fingerprint.init();
    if (!ok) {
      dev.log('[FingerprintAuth] Fingerprint device init returned false',
          name: 'POS_AUTH');
      throw Exception('Fingerprint device initialization failed');
    }
    dev.log('[FingerprintAuth] Fingerprint device initialized successfully',
        name: 'POS_AUTH');
    return true;
  }

  Future<bool> get isAvailable => _fingerprint.isAvailable();

  
  Future<String?> enroll(String staffId) async {
    final result = await _fingerprint.capture();
    if (result == null || !result.success || result.templateBase64 == null) {
      _logger.w('Fingerprint enrollment capture failed');
      return null;
    }

    final fingerprintId = const Uuid().v4();
    final now = DateTime.now().toIso8601String();

    await _db.insertFingerprint(
      FingerprintsCompanion(
        id: Value(fingerprintId),
        staffId: Value(staffId),
        dataBase64: Value(result.templateBase64!),
        isActive: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(0),
        syncUpdatedAt: const Value.absent(),
      ),
    );

    _logger.i('Fingerprint enrolled: fingerprintId=$fingerprintId staffId=$staffId');
    getIt<ActivityLogService>().log(
      type: 'fingerprint_enrolled',
      message: 'Fingerprint enrolled for staff: $staffId',
      actorType: 'staff',
      actorId: staffId,
      sourceTable: 'fingerprints',
      recordId: fingerprintId,
    );
    return fingerprintId;
  }

  
  Future<String?> authenticate() async {
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

    final fingerprints = await _db.getActiveFingerprints();

    dev.log('[FingerprintAuth] Got ${fingerprints.length} active fingerprint(s) from DB',
        name: 'POS_AUTH');

    if (fingerprints.isEmpty) {
      dev.log('[FingerprintAuth] No fingerprints stored in local DB — no match possible',
          name: 'POS_AUTH');
      _logger.w('No fingerprints stored locally');
      return null;
    }

    Fingerprint? bestMatch;
    int bestScore = -1;

    for (final tpl in fingerprints) {
      dev.log('[FingerprintAuth] Verifying against templateId=${tpl.id}, staffId=${tpl.staffId}',
          name: 'POS_AUTH');
      final score = await _fingerprint.verify(tpl.dataBase64);
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
      return bestMatch.staffId;
    }

    dev.log('[FingerprintAuth] NO MATCH: bestScore=$bestScore (threshold=$matchThreshold)',
        name: 'POS_AUTH');
    _logger.w('No fingerprint match. Best score: $bestScore');
    return null;
  }

  /// Get all stored template IDs for a staff member.
  Future<List<String>> getFingerprintsForStaff(String staffId) async {
    final fingerprints = await _db.getFingerprintsByStaff(staffId);
    return fingerprints.map((t) => t.id).toList();
  }

  /// Delete a stored fingerprint .
  Future<void> deleteFingerprint(String fingerprintId) async {
    await _db.deleteFingerprint(fingerprintId);
    getIt<ActivityLogService>().log(
      type: 'fingerprint_deleted',
      message: 'Fingerprint deleted: $fingerprintId',
      sourceTable: 'fingerprints',
      recordId: fingerprintId,
    );
  }

  Future<void> deactivateFingerprint(String fingerprintId) async {
    final now = DateTime.now().toIso8601String();
    await _db.updateFingerprint(
      fingerprintId,
      FingerprintsCompanion(
        isActive: const Value(false),
        updatedAt: Value(now),
        syncStatus: const Value(0),
        syncUpdatedAt: Value(now),
      ),
    );
    getIt<ActivityLogService>().log(
      type: 'fingerprint_deactivated',
      message: 'Fingerprint deactivated: $fingerprintId',
      sourceTable: 'fingerprints',
      recordId: fingerprintId,
    );
  }

  /// Count unsynced fingerprints.
  Future<int> getUnsyncedCount() async {
    final unsynced = await _db.getUnsyncedFingerprints();
    return unsynced.length;
  }

  /// Count total active fingerprints stored locally.
  Future<int> getStoredFingerprintCount() async {
    final fingerprints = await _db.getActiveFingerprints();
    return fingerprints.length;
  }
}

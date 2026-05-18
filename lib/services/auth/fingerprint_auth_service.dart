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

  static const int matchThreshold = 60;

  FingerprintAuthService({
    required AppDatabase db,
    required PosFingerprintService fingerprint,
    Logger? logger,
  })  : _db = db,
        _fingerprint = fingerprint,
        _logger = logger ?? Logger();

  Future<void> init() async {
    await _fingerprint.init();
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
    final result = await _fingerprint.capture();
    if (result == null || !result.success || result.templateBase64 == null) {
      _logger.w('Fingerprint authentication capture failed');
      return null;
    }

    final fingerprints = await _db.getActiveFingerprints();

    if (fingerprints.isEmpty) {
      _logger.w('No fingerprints stored locally');
      return null;
    }

    Fingerprint? bestMatch;
    int bestScore = -1;

    for (final tpl in fingerprints) {
      final score = await _fingerprint.verify(tpl.dataBase64);
      if (score != null && score > bestScore) {
        bestScore = score;
        bestMatch = tpl;
      }
    }

    if (bestMatch != null && bestScore >= matchThreshold) {
      _logger.i(
          'Fingerprint matched: staffId=${bestMatch.staffId} score=$bestScore');
      return bestMatch.staffId;
    }

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

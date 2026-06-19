import 'dart:async';
import 'dart:developer' as dev;
import 'package:canteen_staff_enrollment/controllers/biodata_service.dart';
import 'package:canteen_staff_enrollment/controllers/injection_container.dart';
import 'package:canteen_staff_enrollment/models/staff.model.dart';
import 'package:canteen_staff_enrollment/services/pos/pos_fingerprint_service.dart';
import 'package:logger/logger.dart';

class FingerprintAuthService {
  final PosFingerprintService _fingerprint;
  // final EncryptionService _encryptionService = getIt<EncryptionService>();
  final Logger _logger;
  final StaffBioDataService _bioDataService = getIt<StaffBioDataService>();

  static const int matchThreshold = 80;

  FingerprintAuthService({
    required PosFingerprintService fingerprint,
    Logger? logger,
  }) : _fingerprint = fingerprint,
       _logger = logger ?? Logger();

  Future<bool> init() async {
    dev.log(
      '[FingerprintAuth] Initializing fingerprint device...',
      name: 'POS_AUTH',
    );
    const maxRetries = 4;
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final ok = await _fingerprint.init();
        if (ok) {
          dev.log(
            '[FingerprintAuth] Fingerprint device initialized successfully (attempt $attempt)',
            name: 'POS_AUTH',
          );
          return true;
        }
        dev.log(
          '[FingerprintAuth] Fingerprint device init returned false (attempt $attempt/$maxRetries)',
          name: 'POS_AUTH',
        );
      } on Exception catch (e) {
        dev.log(
          '[FingerprintAuth] Fingerprint device init error (attempt $attempt/$maxRetries): $e',
          name: 'POS_AUTH',
        );
      }
      if (attempt < maxRetries) {
        await Future.delayed(Duration(seconds: attempt));
      }
    }
    throw Exception(
      'Fingerprint device initialization failed after $maxRetries attempts',
    );
  }

  Future<bool> get isAvailable => _fingerprint.isAvailable();

  Future<int?> enroll(String staffId, Finger finger) async {
    final result = await _fingerprint.capture();
    if (result == null || !result.success || result.templateBase64 == null) {
      _logger.w('Fingerprint enrollment capture failed');
      return null;
    }

    final fingerprintId = DateTime.now().millisecondsSinceEpoch;
    final now = DateTime.now().toIso8601String();
    final base64data = result.templateBase64 ?? "";
    // final encryptedData = await _encryptionService.encrypt(result.templateBase64!);

    await _bioDataService.createBioData(staffId, [
      BioData(
        id: fingerprintId,
        staffId: staffId,
        finger: finger,
        data: base64data,
        isActive: true,
      ),
    ]);

    _logger.i('Fingerprint enrolled: id=$fingerprintId staffId=$staffId');

    return fingerprintId;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/pos/pos_fingerprint_service.dart';
import '../services/pos/pos_device_service.dart';
import '../services/auth/fingerprint_auth_service.dart';
import '../services/auth/pos_auth_service.dart';





final fingerprintDeviceProvider = Provider<PosFingerprintService>((ref) {
  return PosFingerprintService();
});

final scannerProvider = Provider<PosScannerService>((ref) {
  return PosScannerService();
});

class PosScannerService {
}

final deviceProvider = Provider<PosDeviceService>((ref) {
  return PosDeviceService();
});

final fingerprintAuthProvider = Provider<FingerprintAuthService>((ref) {
  final device = ref.watch(fingerprintDeviceProvider);
  return FingerprintAuthService( fingerprint: device);
});

final posAuthProvider = Provider<PosAuthService>((ref) {
  final fingerprint = ref.watch(fingerprintAuthProvider);
  return PosAuthService( fingerprintAuth: fingerprint);
});



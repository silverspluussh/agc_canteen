import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/injection_container.dart';
import '../services/database/database_service.dart';
import '../services/database/app_database.dart';
import '../services/pos/pos_fingerprint_service.dart';
import '../services/pos/pos_scanner_service.dart';
import '../services/pos/pos_device_service.dart';
import '../services/pos/device_info_service.dart';
import '../models/device_info.model.dart';
import '../services/auth/fingerprint_auth_service.dart';
import '../services/auth/nfc_auth_service.dart';
import '../services/auth/pos_auth_service.dart';
import '../services/nfc/nfc_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return DatabaseService.instance.db;
});

final staffListProvider = FutureProvider<List<StaffData>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getAllStaff();
});

final fingerprintDeviceProvider = Provider<PosFingerprintService>((ref) {
  return getIt<PosFingerprintService>();
});

final scannerProvider = Provider<PosScannerService>((ref) {
  return getIt<PosScannerService>();
});

final deviceProvider = Provider<PosDeviceService>((ref) {
  return getIt<PosDeviceService>();
});

final fingerprintAuthProvider = Provider<FingerprintAuthService>((ref) {
  return getIt<FingerprintAuthService>();
});

final nfcServiceProvider = Provider<NfcService>((ref) {
  return getIt<NfcService>();
});

final nfcAuthProvider = Provider<NfcAuthService>((ref) {
  return getIt<NfcAuthService>();
});

final posAuthProvider = Provider<PosAuthService>((ref) {
  return getIt<PosAuthService>();
});

final deviceInfoServiceProvider = Provider<DeviceInfoService>((ref) {
  return getIt<DeviceInfoService>();
});

final deviceInfoProvider = FutureProvider<DeviceInfo>((ref) async {
  final service = ref.watch(deviceInfoServiceProvider);
  return service.gatherDeviceInfo();
});

final departmentsProvider = StreamProvider<List<Department>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllDepartments();
});

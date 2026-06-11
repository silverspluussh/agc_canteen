import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database/database_service.dart';
import '../services/database/app_database.dart';
import '../services/pos/pos_fingerprint_service.dart';
import '../services/pos/pos_scanner_service.dart';
import '../services/pos/pos_device_service.dart';
import '../services/device_info_service.dart';
import '../models/device_info.model.dart';
import '../services/auth/fingerprint_auth_service.dart';
import '../services/auth/pos_auth_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return DatabaseService.instance.db;
});

final mealsProvider = FutureProvider<List<Meal>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getAllMeals();
});

final staffListProvider = FutureProvider<List<StaffData>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getAllStaff();
});

final fingerprintDeviceProvider = Provider<PosFingerprintService>((ref) {
  return PosFingerprintService();
});

final scannerProvider = Provider<PosScannerService>((ref) {
  return PosScannerService();
});

final deviceProvider = Provider<PosDeviceService>((ref) {
  return PosDeviceService();
});

final fingerprintAuthProvider = Provider<FingerprintAuthService>((ref) {
  final db = ref.watch(databaseProvider);
  final device = ref.watch(fingerprintDeviceProvider);
  return FingerprintAuthService(db: db, fingerprint: device);
});

final posAuthProvider = Provider<PosAuthService>((ref) {
  final db = ref.watch(databaseProvider);
  final fingerprint = ref.watch(fingerprintAuthProvider);
  return PosAuthService(db: db, fingerprintAuth: fingerprint);
});

final deviceInfoServiceProvider = Provider<DeviceInfoService>((ref) {
  return DeviceInfoService();
});

final deviceInfoProvider = FutureProvider<DeviceInfo>((ref) async {
  final service = ref.watch(deviceInfoServiceProvider);
  return service.gatherDeviceInfo();
});

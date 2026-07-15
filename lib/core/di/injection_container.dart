import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../services/auth/admin_auth_service.dart';
import '../../services/auth/fingerprint_auth_service.dart';
import '../../services/auth/nfc_auth_service.dart';
import '../../services/auth/pos_auth_service.dart';
import '../../services/nfc/nfc_service.dart';
import '../../services/database/activity_log_service.dart';
import '../../services/database/app_database.dart';
import '../../services/database/database_service.dart';
import '../../repositories/biodata.repo.dart';
import '../../repositories/orders.repo.dart';
import '../../services/sync_services/sync_from_remote_to_local.dart';
import '../../services/pos/pos_card_service.dart';
import '../../services/pos/pos_device_service.dart';
import '../../services/pos/device_info_service.dart';
import '../../services/pos/pos_fingerprint_service.dart';
import '../../services/print/print_service_manager.dart';
import '../../services/pos/pos_scanner_service.dart';
// import '../../services/encryption_service.dart';
import '../../services/sync_services/sync_from_local_to_remote.dart';
import '../network/dio_client.dart';
import '../network/network_api_dio.dart';
import 'securestorage.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  try {
    await DatabaseService.instance.init();
  } catch (e) {
    throw Exception('Database init failed: $e');
  }

  getIt.registerLazySingleton<AppDatabase>(() => DatabaseService.instance.db);

  getIt.registerLazySingleton<Dio>(() => DioClient.dio);

  getIt.registerLazySingleton<PosFingerprintService>(
      () => PosFingerprintService());
  getIt.registerLazySingleton<PosScannerService>(() => PosScannerService());
  getIt.registerLazySingleton<PrintServiceManager>(() => PrintServiceManager());
  try {
    await getIt<PrintServiceManager>().loadPrinterType();
  } catch (_) {}
  getIt.registerLazySingleton<PosCardService>(() => PosCardService());
  getIt.registerLazySingleton<PosDeviceService>(() => PosDeviceService());
  getIt.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());
  // getIt.registerLazySingleton<EncryptionService>(() => EncryptionService());
  getIt.registerLazySingleton<NetworkAPI>(() => NetworkAPI());
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  getIt.registerLazySingleton<FingerprintAuthService>(() => FingerprintAuthService(
        db: getIt<AppDatabase>(),
        fingerprint: getIt<PosFingerprintService>(),
      ));

  getIt.registerLazySingleton<NfcService>(() => NfcService());

  getIt.registerLazySingleton<NfcAuthService>(() => NfcAuthService(
        db: getIt<AppDatabase>(),
        nfc: getIt<NfcService>(),
      ));

  getIt.registerLazySingleton<PosAuthService>(() => PosAuthService(
        db: getIt<AppDatabase>(),
        fingerprintAuth: getIt<FingerprintAuthService>(),
        nfcAuth: getIt<NfcAuthService>(),
      ));

  getIt.registerLazySingleton<LocalToRemoteSyncService>(() => LocalToRemoteSyncService(
        db: getIt<AppDatabase>(),
        networkAPI: getIt<NetworkAPI>(),
        connectivity: getIt<Connectivity>(),
      ));

  getIt.registerLazySingleton<AdminAuthService>(() => AdminAuthService(
        networkAPI: getIt<NetworkAPI>(),
        storage: getIt<SecureStorage>(),
      ));

  getIt.registerLazySingleton<OrderService>(() => OrderService(
        networkAPI: getIt<NetworkAPI>(),
      ));

  getIt.registerLazySingleton<BioDataService>(() => BioDataService(
        networkAPI: getIt<NetworkAPI>(),
        db: getIt<AppDatabase>(),
      ));

  getIt.registerLazySingleton<RemoteToLocalSyncService>(() => RemoteToLocalSyncService(
        networkAPI: getIt<NetworkAPI>(),
        db: getIt<AppDatabase>(),
      ));

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  getIt.registerLazySingleton<ActivityLogService>(
      () => ActivityLogService(getIt<AppDatabase>()));
}

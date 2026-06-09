import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../services/auth/admin_auth_service.dart';
import '../../services/auth/fingerprint_auth_service.dart';
import '../../services/auth/pos_auth_service.dart';
import '../../services/activity_log_service.dart';
import '../../services/database/app_database.dart';
import '../../services/database/database_service.dart';
import '../../services/biodata_service.dart';
import '../../services/meal_service.dart';
import '../../services/order_service.dart';
import '../../services/remote_data_sync_service.dart';
import '../../services/pos/pos_card_service.dart';
import '../../services/pos/pos_device_service.dart';
import '../../services/device_info_service.dart';
import '../../services/pos/pos_fingerprint_service.dart';
import '../../services/pos/pos_print_service.dart';
import '../../services/pos/pos_scanner_service.dart';
// import '../../services/encryption_service.dart';
import '../../services/sync_service.dart';
import '../network/dio_client.dart';
import '../network/network_api_dio.dart';
import 'securestorage.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  await DatabaseService.instance.init();

  getIt.registerLazySingleton<AppDatabase>(() => DatabaseService.instance.db);

  getIt.registerLazySingleton<Dio>(() => DioClient.dio);

  getIt.registerLazySingleton<PosFingerprintService>(
      () => PosFingerprintService());
  getIt.registerLazySingleton<PosScannerService>(() => PosScannerService());
  getIt.registerLazySingleton<PosPrintService>(() => PosPrintService());
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

  getIt.registerLazySingleton<PosAuthService>(() => PosAuthService(
        db: getIt<AppDatabase>(),
        fingerprintAuth: getIt<FingerprintAuthService>(),
      ));

  getIt.registerLazySingleton<SyncService>(() => SyncService(
        db: getIt<AppDatabase>(),
        networkAPI: getIt<NetworkAPI>(),
        connectivity: getIt<Connectivity>(),
      ));

  getIt.registerLazySingleton<AdminAuthService>(() => AdminAuthService(
        networkAPI: getIt<NetworkAPI>(),
        storage: getIt<SecureStorage>(),
      ));

  getIt.registerLazySingleton<MealService>(() => MealService(
        networkAPI: getIt<NetworkAPI>(),
        db: getIt<AppDatabase>(),
      ));

  getIt.registerLazySingleton<OrderService>(() => OrderService(
        networkAPI: getIt<NetworkAPI>(),
      ));

  getIt.registerLazySingleton<BioDataService>(() => BioDataService(
        networkAPI: getIt<NetworkAPI>(),
      ));

  getIt.registerLazySingleton<RemoteDataSyncService>(() => RemoteDataSyncService(
        networkAPI: getIt<NetworkAPI>(),
        db: getIt<AppDatabase>(),
      ));

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  getIt.registerLazySingleton<ActivityLogService>(
      () => ActivityLogService(getIt<AppDatabase>()));
}

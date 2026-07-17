import 'package:canteen_staff_enrollment/repos/biodata_service.dart';
import 'package:canteen_staff_enrollment/repos/contractor_service.dart';
import 'package:canteen_staff_enrollment/repos/department_service.dart';
import 'package:canteen_staff_enrollment/repos/dependent_service.dart';
import 'package:canteen_staff_enrollment/repos/nfc_card_service.dart';
import 'package:canteen_staff_enrollment/repos/visitor_service.dart';
import 'package:canteen_staff_enrollment/core/network/dio_client.dart';
import 'package:canteen_staff_enrollment/core/network/network_api_dio.dart';
import 'package:canteen_staff_enrollment/core/network/securestorage.dart';
import 'package:canteen_staff_enrollment/repos/staff_service.dart';
import 'package:canteen_staff_enrollment/services/pos/pos_card_service.dart';
import 'package:canteen_staff_enrollment/services/pos/pos_device_service.dart';
import 'package:canteen_staff_enrollment/services/pos/pos_fingerprint_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../services/auth/admin_auth_service.dart';
import '../../services/auth/fingerprint_auth_service.dart';
import '../../services/auth/pos_auth_service.dart';


final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<Dio>(() => DioClient.dio);
  getIt.registerLazySingleton<PosFingerprintService>(
      () => PosFingerprintService());
  getIt.registerLazySingleton<PosCardService>(() => PosCardService());
  getIt.registerLazySingleton<PosDeviceService>(() => PosDeviceService());
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());
  getIt.registerLazySingleton<NetworkAPI>(() => NetworkAPI());
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<FingerprintAuthService>(() => FingerprintAuthService(    
        fingerprint: getIt<PosFingerprintService>(),
      ));
  getIt.registerLazySingleton<PosAuthService>(() => PosAuthService(
        fingerprintAuth: getIt<FingerprintAuthService>(),
      ));
  getIt.registerLazySingleton<AdminAuthService>(() => AdminAuthService(
        networkAPI: getIt<NetworkAPI>(),
        storage: getIt<SecureStorage>(),
      ));
  getIt.registerLazySingleton<DepartmentService>(() => DepartmentService(
        networkAPI: getIt<NetworkAPI>(),
      ));
  getIt.registerLazySingleton<StaffBioDataService>(() => StaffBioDataService(
        networkAPI: getIt<NetworkAPI>(),
      ));
      getIt.registerLazySingleton<StaffService>(() => StaffService(
        networkAPI: getIt<NetworkAPI>(),
      ));
  getIt.registerLazySingleton<ContractorService>(() => ContractorService(
        networkAPI: getIt<NetworkAPI>(),
      ));
  getIt.registerLazySingleton<VisitorService>(() => VisitorService(
        networkAPI: getIt<NetworkAPI>(),
      ));
  getIt.registerLazySingleton<DependentService>(() => DependentService(
        networkAPI: getIt<NetworkAPI>(),
      ));
  getIt.registerLazySingleton<NfcCardService>(() => NfcCardService(
        networkAPI: getIt<NetworkAPI>(),
      ));
}

import 'package:agc_canteen/core/di/injection_container.dart';
import 'package:agc_canteen/services/database/activity_log_service.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/print/print_service_manager.dart';
import 'package:agc_canteen/services/sync_services/sync_from_local_to_remote.dart';

/// Resets [getIt] and registers only the singletons a given test needs.
///
/// Services under test (e.g. `PosAuthService`, `AuthController`) reach into
/// `getIt` directly for `AppDatabase` / `PrintServiceManager` / etc., so
/// tests must populate the locator with fakes/in-memory instances before
/// exercising that code, and reset it afterwards to avoid leaking state
/// between tests.
Future<void> setupTestLocator({
  AppDatabase? db,
  PrintServiceManager? printer,
  LocalToRemoteSyncService? syncService,
  bool registerActivityLog = true,
}) async {
  await getIt.reset();
  if (db != null) {
    getIt.registerSingleton<AppDatabase>(db);
    if (registerActivityLog) {
      getIt.registerSingleton<ActivityLogService>(ActivityLogService(db));
    }
  }
  if (printer != null) {
    getIt.registerSingleton<PrintServiceManager>(printer);
  }
  if (syncService != null) {
    getIt.registerSingleton<LocalToRemoteSyncService>(syncService);
  }
}

Future<void> resetTestLocator() => getIt.reset();

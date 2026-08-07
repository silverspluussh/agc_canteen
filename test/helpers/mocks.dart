import 'dart:typed_data';

import 'package:agc_canteen/core/di/securestorage.dart';
import 'package:agc_canteen/core/network/network_api_dio.dart';
import 'package:agc_canteen/services/auth/fingerprint_auth_service.dart';
import 'package:agc_canteen/services/auth/nfc_auth_service.dart';
import 'package:agc_canteen/services/auth/pos_auth_service.dart';
import 'package:agc_canteen/services/nfc/nfc_service.dart';
import 'package:agc_canteen/services/pos/pos_fingerprint_service.dart';
import 'package:agc_canteen/services/pos/pos_print_service.dart';
import 'package:agc_canteen/services/print/external_thermal_print_service.dart';
import 'package:agc_canteen/services/print/print_service_manager.dart';
import 'package:agc_canteen/services/sync_services/sync_from_local_to_remote.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkAPI extends Mock implements NetworkAPI {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockConnectivity extends Mock implements Connectivity {}

class MockFingerprintAuthService extends Mock
    implements FingerprintAuthService {}

class MockPosFingerprintService extends Mock
    implements PosFingerprintService {}

class MockNfcAuthService extends Mock implements NfcAuthService {}

class MockNfcService extends Mock implements NfcService {}

class MockPosPrintService extends Mock implements PosPrintService {}

class MockExternalThermalPrintService extends Mock
    implements ExternalThermalPrintService {}

class MockPrintServiceManager extends Mock implements PrintServiceManager {}

class MockPosAuthService extends Mock implements PosAuthService {}

class MockLocalToRemoteSyncService extends Mock
    implements LocalToRemoteSyncService {}

/// Registers mocktail fallback values needed for `any()` matchers.
/// Call this once in a `setUpAll` before using `any()` with these types.
void registerCommonFallbackValues() {
  registerFallbackValue(<ConnectivityResult>[ConnectivityResult.none]);
  registerFallbackValue(Uint8List(0));
}

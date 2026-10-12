import 'package:agc_canteen/controllers/auth_settings_controller.dart';
import 'package:agc_canteen/services/auth/fingerprint_auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Phase A: the fingerprint match threshold is operator-configurable, default 80.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('defaults the match threshold to 80', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(authSettingsProvider.notifier).load();

    expect(container.read(authSettingsProvider).fingerMatchThreshold, 80);
  });

  test('loads a stored threshold and persists changes', () async {
    SharedPreferences.setMockInitialValues({
      FingerprintAuthService.matchThresholdPrefsKey: 90,
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(authSettingsProvider.notifier);
    await notifier.load();
    expect(container.read(authSettingsProvider).fingerMatchThreshold, 90);

    await notifier.setFingerMatchThreshold(75);
    expect(container.read(authSettingsProvider).fingerMatchThreshold, 75);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt(FingerprintAuthService.matchThresholdPrefsKey), 75);
  });

  test('changing the threshold preserves the enabled flags', () async {
    SharedPreferences.setMockInitialValues({
      'enable_nfc': true,
      'enable_finger': true,
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(authSettingsProvider.notifier);
    await notifier.load();
    await notifier.setFingerMatchThreshold(85);

    final settings = container.read(authSettingsProvider);
    expect(settings.enableNfc, isTrue);
    expect(settings.enableFinger, isTrue);
    expect(settings.fingerMatchThreshold, 85);
  });
}

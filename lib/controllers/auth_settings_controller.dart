import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth/fingerprint_auth_service.dart';

class AuthSettings {
  final bool enableNfc;
  final bool enableFinger;

  /// Minimum native comparison score (0–100) for a fingerprint to match.
  final int fingerMatchThreshold;

  const AuthSettings({
    this.enableNfc = false,
    this.enableFinger = true,
    this.fingerMatchThreshold = FingerprintAuthService.defaultMatchThreshold,
  });
}

class AuthSettingsController extends Notifier<AuthSettings> {
  @override
  AuthSettings build() => const AuthSettings();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AuthSettings(
      enableNfc: prefs.getBool('enable_nfc') ?? false,
      enableFinger: prefs.getBool('enable_finger') ?? true,
      fingerMatchThreshold:
          prefs.getInt(FingerprintAuthService.matchThresholdPrefsKey) ??
              FingerprintAuthService.defaultMatchThreshold,
    );
  }

  Future<void> setNfcEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_nfc', value);
    state = AuthSettings(
      enableNfc: value,
      enableFinger: state.enableFinger,
      fingerMatchThreshold: state.fingerMatchThreshold,
    );
  }

  Future<void> setFingerEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_finger', value);
    state = AuthSettings(
      enableNfc: state.enableNfc,
      enableFinger: value,
      fingerMatchThreshold: state.fingerMatchThreshold,
    );
  }

  Future<void> setFingerMatchThreshold(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(FingerprintAuthService.matchThresholdPrefsKey, value);
    state = AuthSettings(
      enableNfc: state.enableNfc,
      enableFinger: state.enableFinger,
      fingerMatchThreshold: value,
    );
  }
}

final authSettingsProvider =
    NotifierProvider<AuthSettingsController, AuthSettings>(
  AuthSettingsController.new,
);

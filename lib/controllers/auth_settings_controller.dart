import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSettings {
  final bool enableNfc;
  final bool enableFinger;

  const AuthSettings({
    this.enableNfc = true,
    this.enableFinger = true,
  });
}

class AuthSettingsController extends Notifier<AuthSettings> {
  @override
  AuthSettings build() => const AuthSettings();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AuthSettings(
      enableNfc: prefs.getBool('enable_nfc') ?? true,
      enableFinger: prefs.getBool('enable_finger') ?? true,
    );
  }

  Future<void> setNfcEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_nfc', value);
    state = AuthSettings(
      enableNfc: value,
      enableFinger: state.enableFinger,
    );
  }

  Future<void> setFingerEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_finger', value);
    state = AuthSettings(
      enableNfc: state.enableNfc,
      enableFinger: value,
    );
  }
}

final authSettingsProvider =
    NotifierProvider<AuthSettingsController, AuthSettings>(
  AuthSettingsController.new,
);

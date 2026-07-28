import 'package:shared_preferences/shared_preferences.dart';

/// Initializes the in-memory SharedPreferences mock used by services like
/// `PrintServiceManager` and `LocalToRemoteSyncService`.
void initMockSharedPreferences([Map<String, Object> values = const {}]) {
  SharedPreferences.setMockInitialValues(values);
}

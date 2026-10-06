import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/network_api_dio.dart';
import '../../core/utils/app_log.dart';

/// Talks to `GET /api/sync/version` and remembers the token locally.
///
/// The token is opaque: it is only ever compared for equality, never parsed, so
/// the client does not care how the server derives it.
class SyncVersionService {
  static const _versionKey = 'sync_version';
  static const _lastFullPullKey = 'sync_last_full_pull_at';

  final NetworkAPI _networkAPI;
  final Logger _logger;

  SyncVersionService({required NetworkAPI networkAPI, Logger? logger})
      : _networkAPI = networkAPI,
        _logger = logger ?? createAppLogger();

  /// Fetches the server's current version. Throws on a network/server error so
  /// the caller can fall back to a full pull.
  Future<String?> fetchVersion() async {
    final data = await _networkAPI.getData<dynamic>(
      '/sync/version',
      builder: (d) => d,
    );

    if (data is Map && data['version'] is String) {
      return data['version'] as String;
    }
    if (data is String) return data;

    _logger.w('SyncVersionService: unexpected version payload ($data)');
    return null;
  }

  Future<String?> get storedVersion async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_versionKey);
    } catch (e) {
      _logger.w('SyncVersionService: could not read stored version ($e)');
      return null;
    }
  }

  Future<void> saveVersion(String version) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_versionKey, version);
    } catch (e) {
      _logger.w('SyncVersionService: could not persist version ($e)');
    }
  }

  Future<DateTime?> get lastFullPullAt async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_lastFullPullKey);
      return raw == null ? null : DateTime.tryParse(raw);
    } catch (e) {
      _logger.w('SyncVersionService: could not read last full pull ($e)');
      return null;
    }
  }

  Future<void> markFullPull([DateTime? at]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _lastFullPullKey,
        (at ?? DateTime.now()).toIso8601String(),
      );
    } catch (e) {
      _logger.w('SyncVersionService: could not persist full pull time ($e)');
    }
  }
}

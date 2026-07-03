import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../core/di/injection_container.dart';
import '../../core/di/securestorage.dart';
import '../../core/network/api_exceptions_util.dart';
import '../../core/network/network_api_dio.dart';
import '../database/activity_log_service.dart';

enum AdminAuthStatus {
  unauthenticated,
  loading,
  authenticated,
  authenticatedOffline,
  error,
}

class AdminAuthResult {
  final AdminAuthStatus status;
  final String? token;
  final String? message;
  final String? sessionToken;

  const AdminAuthResult({required this.status, this.token, this.message, this.sessionToken});

  bool get isSuccess =>
      status == AdminAuthStatus.authenticated ||
      status == AdminAuthStatus.authenticatedOffline;

  factory AdminAuthResult.success(String token) =>
      AdminAuthResult(status: AdminAuthStatus.authenticated, token: token);

  factory AdminAuthResult.offline(String token) => AdminAuthResult(
    status: AdminAuthStatus.authenticatedOffline,
    token: token,
  );

  factory AdminAuthResult.failure(String message) =>
      AdminAuthResult(status: AdminAuthStatus.error, message: message);
}

class AdminAuthService {
  final NetworkAPI _networkAPI;
  final SecureStorage _storage;
  final Logger _logger;

  AdminAuthService({
    required NetworkAPI networkAPI,
    required SecureStorage storage,
    Logger? logger,
  }) : _networkAPI = networkAPI,
       _storage = storage,
       _logger = logger ?? Logger();

  String _hashCredentials(String email, String password) {
    final input = utf8.encode('${email.toLowerCase()}:$password');
    return sha256.convert(input).toString();
  }

  /// Defensive helper to extract tokens from various potential JSON wrappers/structures
  String? _extractToken(dynamic data, String key) {
    if (data == null) return null;
    if (data is Map) {
      if (data[key] != null) {
        return data[key].toString();
      }
      if (data['data'] is Map) {
        final dataMap = data['data'] as Map;
        if (dataMap[key] != null) {
          return dataMap[key].toString();
        }
        if (dataMap['attributes'] is Map) {
          final attrMap = dataMap['attributes'] as Map;
          if (attrMap[key] != null) {
            return attrMap[key].toString();
          }
        }
      }
    }
    return null;
  }

  Future<AdminAuthResult> login(String email, String password) async {
    log(  'Attempting login for email: $email');
    final lowerEmail = email.trim();

    try {
      final responseData = await _networkAPI.postData(
        '/auth/login',
        data: {'email': lowerEmail, 'password': password},

        builder: (data)  {
          return data;},
      );

      final token =
          _extractToken(responseData, 'accessToken') ??
          _extractToken(responseData, 'access_token') ??
          _extractToken(responseData, 'token');

      // Check for OTP flow — server returns sessionToken instead of accessToken
      final sessionToken =
          _extractToken(responseData, 'sessionToken') ??
          _extractToken(responseData, 'session_token');

      if (sessionToken != null && sessionToken.isNotEmpty && (token == null || token.isEmpty)) {
        return AdminAuthResult.failure('OTP required but OTP flow has been disabled');
      }

      if (token == null || token.isEmpty) {
        return AdminAuthResult.failure('Invalid server response: no token');
      }

      final refreshToken =
          _extractToken(responseData, 'refreshToken') ??
          _extractToken(responseData, 'refresh_token');

      await _storage.writeSecureToken(token);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _storage.writeSecureData('refresh_token', refreshToken);
      }
      await _storage.writeAdminCredentials(
        lowerEmail,
        _hashCredentials(lowerEmail, password),
      );

      _logger.i('Admin logged in remotely: $lowerEmail');
      getIt<ActivityLogService>().log(
        type: 'admin_login',
        message: 'Admin logged in online: $lowerEmail',
        actorType: 'admin',
        actorName: lowerEmail,
        sourceTable: 'users',
      );
      return AdminAuthResult.success(token);
    } on APIException catch (e) {
      _logger.w('Login API error for $lowerEmail: ${e.message}');
      if (e is NoInternetConnectionException) {
        return _offlineLogin(lowerEmail, password);
      }
      return AdminAuthResult.failure(e.message);
    } catch (e) {
      if (e.toString().contains('connection') ||
          e.toString().contains('SocketException')) {
        _logger.w(
          'Network connection error during login for $lowerEmail — attempting offline login',
        );
        return _offlineLogin(lowerEmail, password);
      }
      _logger.e('Unexpected login error for $lowerEmail', error: e);
      return AdminAuthResult.failure(e.toString());
    } 
  }

  // Future<AdminAuthResult> verifyOtp({
  //   required String sessionToken,
  //   required String otp,
  //   required String email,
  //   required String password,
  // }) async {
  //   final lowerEmail = email.trim().toLowerCase();

  //   try {
  //     final responseData = await _networkAPI.postData(
  //       '/auth/verify-otp',
  //       data: {'sessionToken': sessionToken, 'otp': otp},
  //       builder: (data) => data,
  //     );

  //     final token =
  //         _extractToken(responseData, 'accessToken') ??
  //         _extractToken(responseData, 'access_token') ??
  //         _extractToken(responseData, 'token');
  //     final refreshToken =
  //         _extractToken(responseData, 'refreshToken') ??
  //         _extractToken(responseData, 'refresh_token');

  //     if (token == null || token.isEmpty) {
  //       return AdminAuthResult.failure('Invalid server response: no token');
  //     }

  //     await _storage.writeSecureToken(token);
  //     if (refreshToken != null && refreshToken.isNotEmpty) {
  //       await _storage.writeSecureData('refresh_token', refreshToken);
  //     }
  //     await _storage.writeAdminCredentials(
  //       lowerEmail,
  //       _hashCredentials(lowerEmail, password),
  //     );

  //     _logger.i('Admin verified OTP and logged in: $lowerEmail');
  //     getIt<ActivityLogService>().log(
  //       type: 'admin_login_otp_verified',
  //       message: 'Admin verified OTP and logged in: $lowerEmail',
  //       actorType: 'admin',
  //       actorName: lowerEmail,
  //       sourceTable: 'users',
  //     );
  //     return AdminAuthResult.success(token);
  //   } on APIException catch (e) {
  //     _logger.w('OTP verification error for $lowerEmail: ${e.message}');
  //     return AdminAuthResult.failure(e.message);
  //   } catch (e) {
  //     _logger.e('Unexpected OTP verification error for $lowerEmail', error: e);
  //     return AdminAuthResult.failure(e.toString());
  //   }
  // }

  Future<String> fetchSecretKey() async {
    try {
      final responseData = await _networkAPI.getData(
        '/auth/bio-data-key',
        builder: (data) => data,
      );
      final secretKey = _extractToken(responseData, 'key');
      _logger.i('Fetched secret key for biometric data successfully');
      if (secretKey != null && secretKey.isNotEmpty) {
         await _storage.writeBioSecret(secretKey);
        return secretKey;
      } else {
        throw Exception('Secret key not found in response');
      }
    } catch (e) {
      _logger.e('Failed to fetch secret key', error: e);
      rethrow;
    }
  }
  
      
  
  Future<AdminAuthResult> tryAutoLogin() async {
    try {
      final token = await _storage.readSecureData('access_token');
      final refreshToken = await _storage.readSecureData('refresh_token');

      // 1. If we have a cached access token, verify if it's still valid on the server via auth/session
      if (token != null && token.isNotEmpty) {
        try {
          await _networkAPI.getData('/auth/session', builder: (data) => data);
          _logger.i('Auto-login: session is active and valid');
          getIt<ActivityLogService>().log(
            type: 'admin_auto_login',
            message: 'Admin auto-login via active session',
            actorType: 'admin',
            metadata: {'mode': 'session'},
          );
          return AdminAuthResult.success(token);
        } on NoInternetConnectionException {
          _logger.w(
            'Auto-login session check connection error — utilizing offline cache',
          );
          getIt<ActivityLogService>().log(
            type: 'admin_auto_login',
            message: 'Admin auto-login via offline cache (no connection)',
            actorType: 'admin',
            metadata: {'mode': 'offline', 'reason': 'no_connection'},
          );
          return AdminAuthResult.offline(token);
        } catch (e) {
          if (e.toString().contains('connection') ||
              e.toString().contains('SocketException')) {
            _logger.w(
              'Auto-login session check connection error — utilizing offline cache',
            );
            getIt<ActivityLogService>().log(
              type: 'admin_auto_login',
              message: 'Admin auto-login via offline cache (connection error)',
              actorType: 'admin',
              metadata: {'mode': 'offline', 'reason': 'connection_error'},
            );
            return AdminAuthResult.offline(token);
          }
          _logger.w(
            'Auto-login session check failed ($e), attempting token refresh',
          );
        }
      }

      // 2. If access token is missing, expired, or invalid on the server, attempt refresh
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final responseData = await _networkAPI.postData(
            'auth/refresh-token',
            data: {'refresh_token': refreshToken},

            builder: (data) => data,
          );

          final newAccessToken =
              _extractToken(responseData, 'accessToken') ??
              _extractToken(responseData, 'access_token') ??
              _extractToken(responseData, 'token');
          final newRefreshToken =
              _extractToken(responseData, 'refreshToken') ??
              _extractToken(responseData, 'refresh_token');

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await _storage.writeSecureToken(newAccessToken);
            if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
              await _storage.writeSecureData('refresh_token', newRefreshToken);
            }
            _logger.i('Auto-login: refreshed token successfully');
            getIt<ActivityLogService>().log(
              type: 'admin_auto_login',
              message: 'Admin auto-login via token refresh',
              actorType: 'admin',
              metadata: {'mode': 'token_refresh'},
            );
            return AdminAuthResult.success(newAccessToken);
          }
        } catch (e) {
          _logger.w('Auto-login: token refresh failed: $e');
        }
      }

      // 3. Fallback to offline credentials check if stored credentials exist
      final email = await _storage.readAdminEmail();
      final passHash = await _storage.readAdminPassHash();
      if (email != null && passHash != null) {
        final cachedToken = await _storage.readSecureData('access_token');
        _logger.i('Auto-login: using offline cached credentials fallback');
        getIt<ActivityLogService>().log(
          type: 'admin_auto_login',
          message: 'Admin auto-login via cached credentials: $email',
          actorType: 'admin',
          actorName: email,
          metadata: {'mode': 'cached_credentials'},
        );
        return AdminAuthResult.offline(cachedToken ?? 'offline_session');
      }

      _logger.i('Auto-login: no valid session or credentials found');
      return const AdminAuthResult(status: AdminAuthStatus.unauthenticated);
    } catch (e) {
      _logger.e('Auto-login unexpected error', error: e);
      return const AdminAuthResult(status: AdminAuthStatus.unauthenticated);
    }
  }

  Future<AdminAuthResult> _offlineLogin(String email, String password) async {
    final storedEmail = await _storage.readAdminEmail();
    final storedHash = await _storage.readAdminPassHash();

    if (storedEmail == null || storedHash == null) {
      return AdminAuthResult.failure(
        'No internet connection and no stored credentials. '
        'You must log in online at least once.',
      );
    }

    if (storedEmail != email) {
      return AdminAuthResult.failure(
        'No internet connection. Email does not '
        'match stored credentials.',
      );
    }

    final inputHash = _hashCredentials(email, password);
    if (storedHash != inputHash) {
      return AdminAuthResult.failure(
        'No internet connection. Invalid password.',
      );
    }

    final token = await _storage.readSecureData('access_token');
    _logger.i('Admin logged in offline: $email');
    getIt<ActivityLogService>().log(
      type: 'admin_login_offline',
      message: 'Admin logged in offline: $email',
      actorType: 'admin',
      actorName: email
    );
    return AdminAuthResult.offline(token ?? 'offline_session');
  }

  Future<void> logout() async {
    final cachedEmail = await _storage.readAdminEmail();
    try {
      final token = await _storage.readSecureData('access_token');
      if (token != null && token.isNotEmpty) {
        await _networkAPI.postData(
          '/auth/revoke-token',
          opts: Options(
            headers: {'Accept': 'application/json'},
            sendTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          ),
          builder: (data) => data,
        );
      }
    } catch (e) {
      _logger.w('Server token revocation failed or offline: $e');
    } finally {
      await _storage.clearSecureData();
      await _storage.clearAdminCredentials();
      await _storage.clearSecureEmail();
      await _storage.clearSecurePhone();
      _logger.i('Admin logged out — all credentials cleared');
      getIt<ActivityLogService>().log(
        type: 'admin_logout',
        message: 'Admin logged out${cachedEmail != null ? ": $cachedEmail" : ""}',
        actorType: 'admin',
        actorName: cachedEmail,
      );
    }
  }

  Future<String?> getCachedEmail() async {
    return await _storage.readAdminEmail();
  }
}

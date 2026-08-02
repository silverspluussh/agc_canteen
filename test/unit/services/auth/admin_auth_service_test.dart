import 'dart:convert';

import 'package:agc_canteen/core/network/api_exceptions_util.dart';
import 'package:agc_canteen/services/auth/admin_auth_service.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';
import '../../../helpers/test_service_locator.dart';

dynamic _identityBuilder(dynamic data) => data;

/// Mirrors the private `AdminAuthService._hashCredentials` so offline-login
/// tests can produce a matching stored hash without exposing the method.
String hashCredentials(String email, String password) {
  final input = utf8.encode('${email.toLowerCase()}:$password');
  return sha256.convert(input).toString();
}

void main() {
  late MockNetworkAPI api;
  late MockSecureStorage storage;
  late AppDatabase db;
  late AdminAuthService service;

  setUpAll(() {
    registerFallbackValue(_identityBuilder);
  });

  setUp(() async {
    api = MockNetworkAPI();
    storage = MockSecureStorage();
    db = createTestDatabase();
    await setupTestLocator(db: db);
    service = AdminAuthService(networkAPI: api, storage: storage);

    // Storage no-ops by default; individual tests override as needed.
    when(() => storage.writeSecureToken(any())).thenAnswer((_) async {});
    when(() => storage.writeSecureData(any(), any())).thenAnswer((_) async {});
    when(() => storage.writeAdminCredentials(any(), any()))
        .thenAnswer((_) async {});
    when(() => storage.readSecureData(any())).thenAnswer((_) async => null);
    when(() => storage.readAdminEmail()).thenAnswer((_) async => null);
    when(() => storage.readAdminPassHash()).thenAnswer((_) async => null);
    when(() => storage.clearSecureData()).thenAnswer((_) async {});
    when(() => storage.clearAdminCredentials()).thenAnswer((_) async {});
    when(() => storage.clearSecureEmail()).thenAnswer((_) async {});
    when(() => storage.clearSecurePhone()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await resetTestLocator();
    await db.close();
  });

  void stubPostData(dynamic responseData) {
    when(
      () => api.postData<dynamic>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        opts: any(named: 'opts'),
        builder: any(named: 'builder'),
      ),
    ).thenAnswer((_) async => responseData);
  }

  void stubPostDataThrows(Object error) {
    when(
      () => api.postData<dynamic>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        opts: any(named: 'opts'),
        builder: any(named: 'builder'),
      ),
    ).thenThrow(error);
  }

  group('login', () {
    test('stores the token and returns success on a valid response', () async {
      stubPostData({'accessToken': 'access-123', 'refreshToken': 'refresh-456'});

      final result = await service.login('user@example.com', 'password1');

      expect(result.isSuccess, isTrue);
      expect(result.status, AdminAuthStatus.authenticated);
      expect(result.token, 'access-123');
      verify(() => storage.writeSecureToken('access-123')).called(1);
      verify(() => storage.writeSecureData('refresh_token', 'refresh-456'))
          .called(1);
      verify(() => storage.writeAdminCredentials('user@example.com', any()))
          .called(1);
    });

    test('trims the email before use', () async {
      stubPostData({'accessToken': 'token'});

      await service.login('  user@example.com  ', 'password1');

      verify(() => storage.writeAdminCredentials('user@example.com', any()))
          .called(1);
    });

    test('returns failure when server responds with no token', () async {
      stubPostData({'message': 'nope'});

      final result = await service.login('user@example.com', 'password1');

      expect(result.isSuccess, isFalse);
      expect(result.status, AdminAuthStatus.error);
      expect(result.message, contains('no token'));
    });

    test('returns failure when only a sessionToken is present (OTP disabled)', () async {
      stubPostData({'sessionToken': 'session-abc'});

      final result = await service.login('user@example.com', 'password1');

      expect(result.isSuccess, isFalse);
      expect(result.message, contains('OTP'));
    });

    test('falls back to offline login on NoInternetConnectionException '
        'when cached credentials match', () async {
      stubPostDataThrows(NoInternetConnectionException('offline'));
      when(() => storage.readAdminEmail())
          .thenAnswer((_) async => 'user@example.com');
      when(() => storage.readAdminPassHash()).thenAnswer(
        (_) async => hashCredentials('user@example.com', 'password1'),
      );
      when(() => storage.readSecureData('access_token'))
          .thenAnswer((_) async => 'cached-token');

      final result = await service.login('user@example.com', 'password1');

      expect(result.isSuccess, isTrue);
      expect(result.status, AdminAuthStatus.authenticatedOffline);
      expect(result.token, 'cached-token');
    });

    test('offline login fails with wrong password against cached hash', () async {
      stubPostDataThrows(NoInternetConnectionException('offline'));
      when(() => storage.readAdminEmail())
          .thenAnswer((_) async => 'user@example.com');
      when(() => storage.readAdminPassHash()).thenAnswer(
        (_) async => hashCredentials('user@example.com', 'correct-password'),
      );

      final result = await service.login('user@example.com', 'wrong-password');

      expect(result.isSuccess, isFalse);
      expect(result.message, contains('Invalid password'));
    });

    test('offline login fails when no credentials were ever cached', () async {
      stubPostDataThrows(NoInternetConnectionException('offline'));

      final result = await service.login('user@example.com', 'password1');

      expect(result.isSuccess, isFalse);
      expect(result.message, contains('must log in online'));
    });

    test('propagates a generic API failure message for non-connection errors', () async {
      stubPostDataThrows(InvalidCredentials('bad creds'));

      final result = await service.login('user@example.com', 'password1');

      expect(result.isSuccess, isFalse);
      expect(result.message, 'bad creds');
    });
  });

  group('logout', () {
    test('clears all stored credentials even if token revocation fails', () async {
      when(() => storage.readAdminEmail())
          .thenAnswer((_) async => 'user@example.com');
      when(() => storage.readSecureData('access_token'))
          .thenAnswer((_) async => 'token-1');
      stubPostDataThrows(Exception('revoke failed'));

      await service.logout();

      verify(() => storage.clearSecureData()).called(1);
      verify(() => storage.clearAdminCredentials()).called(1);
      verify(() => storage.clearSecureEmail()).called(1);
      verify(() => storage.clearSecurePhone()).called(1);
    });
  });

  group('getCachedEmail', () {
    test('delegates to storage.readAdminEmail', () async {
      when(() => storage.readAdminEmail())
          .thenAnswer((_) async => 'cached@example.com');

      final email = await service.getCachedEmail();

      expect(email, 'cached@example.com');
    });
  });

  group('tryAutoLogin', () {
    void stubGetDataThrows(Object error) {
      when(
        () => api.getData<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          opts: any(named: 'opts'),
          builder: any(named: 'builder'),
        ),
      ).thenThrow(error);
    }

    test('does not unlock from cached credentials after revoked online session',
        () async {
      when(() => storage.readSecureData('access_token'))
          .thenAnswer((_) async => 'revoked-token');
      when(() => storage.readSecureData('refresh_token'))
          .thenAnswer((_) async => 'revoked-refresh');
      stubGetDataThrows(Exception('unauthorized'));
      stubPostDataThrows(Exception('refresh failed'));
      when(() => storage.readAdminEmail())
          .thenAnswer((_) async => 'user@example.com');
      when(() => storage.readAdminPassHash()).thenAnswer(
        (_) async => hashCredentials('user@example.com', 'password1'),
      );

      final result = await service.tryAutoLogin();

      expect(result.isSuccess, isFalse);
      expect(result.status, AdminAuthStatus.unauthenticated);
    });

    test('returns offline when session check fails due to no connection '
        'and a token is still cached', () async {
      when(() => storage.readSecureData('access_token'))
          .thenAnswer((_) async => 'cached-token');
      when(() => storage.readSecureData('refresh_token'))
          .thenAnswer((_) async => 'refresh');
      stubGetDataThrows(NoInternetConnectionException('offline'));

      final result = await service.tryAutoLogin();

      expect(result.isSuccess, isTrue);
      expect(result.status, AdminAuthStatus.authenticatedOffline);
      expect(result.token, 'cached-token');
    });
  });
}

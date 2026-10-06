import 'package:agc_canteen/core/di/securestorage.dart';
import 'package:dio/dio.dart';
import 'api_exceptions_util.dart';

class AuthInterceptor extends QueuedInterceptor {
  final SecureStorage _storage;

  AuthInterceptor({required SecureStorage storage}) : _storage = storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readSecureData('access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.response?.statusCode) {
      case 302:
        throw InvalidCredentials('Invalid credentials provided');
      case 400:
        throw InvalidCredentials(err.response?.data['message']);
      case 401:
        throw InvalidApiKeyException(err.response?.data['message']);
      case 403:
        throw LoginAttemptFailed(err.response?.data['message']);
      case 404:
        throw NotFoundException('Requested resource not found');
      case 405:
        throw NotAllowedException('Request method not allowed');
      case 408:
        throw TimeoutException('Request timed out, please try again.');

      default:
        handler.next(err);
    }
  }
}

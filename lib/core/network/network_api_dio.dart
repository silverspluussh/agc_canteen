import 'dart:developer';
import 'dart:io';
import 'package:agc_canteen/core/network/api_exceptions_util.dart';
import 'package:agc_canteen/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class NetworkAPI {
  NetworkAPI();
  Dio dioClient = DioClient.dio;

  Future<T> getData<T>(
    String path, {
    required T Function(dynamic data) builder,
    Map<String, dynamic>? queryParameters,
    Options? opts,
    dynamic data,
  }) async {
    try {
      final response = await dioClient.get(
        path,
        options: opts,
        queryParameters: queryParameters,
        data: data,
      );

      switch (response.statusCode) {
        case 200:
          final data = response.data;
          return builder(data["data"]);
        case 201:
          final data = response.data;
          return builder(data["data"]);
        case 300:
        case 301:
        case 302:
          throw InvalidCredentials("Invalid credentials provided");
        case 400:
          throw InvalidCredentials(response.data["message"]);
        case 401:
          throw InvalidApiKeyException(response.data["message"]);
        case 403:
          throw LoginAttemptFailed(response.data["message"]);
        case 404:
          throw NotFoundException(response.data["message"]);
        case 405:
          throw NotAllowedException(
            'Request method not allowed. Please contact support.',
          );
        case 408:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        case 500:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        default:
          throw InvalidApiKeyException(response.data["message"]);
      }
    } on SocketException catch (_) {
      throw NoInternetConnectionException(
        'No internet connection. Please check your connection and try again.',
      );
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        case DioExceptionType.connectionError:
          throw NoInternetConnectionException(
            'No internet connection. Please check your connection and try again.',
          );
        default:
          throw Exception(e.message);
      }
    }
  }

  Future<T> postData<T>(
    String path, {
    required T Function(dynamic data) builder,
    Map<String, dynamic>? queryParameters,
    Options? opts,
    dynamic data,
  }) async {
    try {
      final response = await dioClient.post(
        path,
        options: opts,
        queryParameters: queryParameters,
        data: data,
      );
      switch (response.statusCode) {
        case 200:
          final data = response.data;
          return builder(data);
        case 201:
          final data = response.data;
          return builder(data);

        case 300:
        case 301:
        case 302:
          throw InvalidCredentials("Invalid credentials provided");
        case 400:
          throw InvalidCredentials(response.data["message"]);
        case 401:
          throw InvalidApiKeyException(response.data["message"]);
        case 403:
          throw LoginAttemptFailed(response.data["message"]);
        case 404:
          log(response.data.toString());

          throw NotFoundException("Request not found");
        case 405:
          throw NotAllowedException(
            'Request method not allowed. Please contact support.',
          );
        case 408:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        case 409:
          throw InvalidCredentials(response.data["message"]);
        case 500:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );

        default:
          throw LoginAttemptFailed(response.data["message"]);
      }
    } on SocketException catch (_) {
      throw NoInternetConnectionException(
        'No internet connection. Please check your connection and try again.',
      );
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        case DioExceptionType.connectionError:
          throw NoInternetConnectionException(
            'No internet connection. Please check your connection and try again.',
          );
        case DioExceptionType.badResponse:
          throw NoInternetConnectionException(
            'There is an issue with the server.',
          );

        default:
          throw Exception(e.message);
      }
    }
  }

  Future<T> patchData<T>(
    String path, {
    required T Function(dynamic data) builder,
    Map<String, dynamic>? queryParameters,
    Options? opts,
    dynamic data,
  }) async {
    try {
      final response = await dioClient.patch(
        path,
        options: opts,
        queryParameters: queryParameters,
        data: data,
      );

      switch (response.statusCode) {
        case 201:
        case 200:
          final data = response.data;
          return builder(data);
        case 300:
        case 301:
        case 302:
          throw InvalidCredentials("Invalid credentials provided");

        case 400:
          throw InvalidCredentials(response.data["message"]);
        case 401:
          throw InvalidApiKeyException(response.data["message"]);
        case 403:
          throw LoginAttemptFailed(response.data["message"]);
        case 404:
          throw NotFoundException(response.data["message"]);
        case 405:
          throw NotAllowedException(
            'Request method not allowed. Please contact support.',
          );
        case 408:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        default:
          throw InvalidApiKeyException(response.data["message"]);
      }
    } on SocketException catch (_) {
      throw NoInternetConnectionException(
        'No internet connection. Please check your connection and try again.',
      );
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        case DioExceptionType.connectionError:
          throw NoInternetConnectionException(
            'No internet connection. Please check your connection and try again.',
          );
        case DioExceptionType.badResponse:
          throw NoInternetConnectionException(
            'There is an issue with the server.',
          );
        default:
          throw Exception(e.message);
      }
    }
  }

  Future<T> putData<T>(
    String path, {
    required T Function(dynamic data) builder,
    Map<String, dynamic>? queryParameters,
    Options? opts,
    dynamic data,
  }) async {
    try {
      final response = await dioClient.put(
        path,
        options: opts,
        queryParameters: queryParameters,
        data: data,
      );

      switch (response.statusCode) {
        case 201:
        case 200:
          final data = response.data;
          return builder(data);
        case 300:
        case 301:
        case 302:
          throw InvalidCredentials("Invalid credentials provided");

        case 400:
          throw InvalidCredentials(response.data["message"]);
        case 401:
          throw InvalidApiKeyException(response.data["message"]);
        case 403:
          throw LoginAttemptFailed(response.data["message"]);
        case 404:
          throw NotFoundException(response.data["message"]);
        case 405:
          throw NotAllowedException(
            'Request method not allowed. Please contact support.',
          );
        case 408:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        default:
          throw InvalidApiKeyException(response.data["message"]);
      }
    } on SocketException catch (_) {
      throw NoInternetConnectionException(
        'No internet connection. Please check your connection and try again.',
      );
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        case DioExceptionType.connectionError:
          throw NoInternetConnectionException(
            'No internet connection. Please check your connection and try again.',
          );
        case DioExceptionType.badResponse:
          throw NoInternetConnectionException(
            'There is an issue with the server.',
          );
        default:
          throw Exception(e.message);
      }
    }
  }

  Future<T> deleteData<T>(
    String path, {
    required T Function(dynamic data) builder,
    Map<String, dynamic>? queryParameters,
    Options? opts,
    dynamic data,
  }) async {
    try {
      final response = await dioClient.delete(
        path,
        options: opts,
        queryParameters: queryParameters,
      );
      switch (response.statusCode) {
        case 200:
          final data = response.data;
          return builder(data);
        case 400:
          throw InvalidCredentials(response.data["message"]);
        case 401:
          throw InvalidApiKeyException(response.data["message"]);
        case 403:
          throw LoginAttemptFailed(response.data["message"]);
        case 404:
          throw NotFoundException(response.data["message"]);
        case 405:
          throw NotAllowedException(
            'Request method not allowed. Please contact support.',
          );
        case 408:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        default:
          throw InvalidApiKeyException(response.data["message"]);
      }
    } on SocketException catch (_) {
      throw NoInternetConnectionException(
        'No internet connection. Please check your connection and try again.',
      );
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException(
            'Request timed out. Please check your connection and try again.',
          );
        case DioExceptionType.connectionError:
          throw NoInternetConnectionException(
            'No internet connection. Please check your connection and try again.',
          );
        default:
          throw Exception(e.message);
      }
    }
  }
}

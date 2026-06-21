import 'dart:io';
import 'package:agc_canteen/core/di/securestorage.dart';
import 'package:agc_canteen/core/network/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static String baseUrl = dotenv.env['BASE_URL']!;
  SecureStorage secureStorage = SecureStorage();

  static Dio? _dio;

  static Dio get dio {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status! < 500,
      ),
    )..interceptors.add(AuthInterceptor());
    return _dio!;
  }

  static void setupCertificatePinning() {
    _dio?.httpClientAdapter = IOHttpClientAdapter()
      ..createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) {
          return host == baseUrl;
        };
        return client;
      };
  }
}

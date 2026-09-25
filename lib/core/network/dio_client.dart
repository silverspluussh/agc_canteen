import 'package:agc_canteen/core/di/injection_container.dart';
import 'package:agc_canteen/core/di/securestorage.dart';
import 'package:agc_canteen/core/network/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static String baseUrl = dotenv.env['BASE_URL']!;

  static Dio? _dio;

  static SecureStorage _secureStorage() {
    if (getIt.isRegistered<SecureStorage>()) {
      return getIt<SecureStorage>();
    }
    return SecureStorage();
  }

  static Dio get dio {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status! < 500,
      ),
    )..interceptors.add(
        AuthInterceptor(storage: _secureStorage()),
      );
    return _dio!;
  }

  /// Trusts the on-prem internal CA (assets/certs/asantegold-ca.crt) for all
  /// HTTPS calls so the self-signed internal CA is accepted on Android/iOS.
  // static Future<void> configureTrust() async {
  //   final data = await rootBundle.load('assets/certs/asantegold-ca.crt');
  //   final context = SecurityContext(withTrustedRoots: true)
  //     ..setTrustedCertificatesBytes(
  //       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
  //     );
  //   dio.httpClientAdapter = IOHttpClientAdapter()
  //     ..createHttpClient = () => HttpClient(context: context);
  // }
}

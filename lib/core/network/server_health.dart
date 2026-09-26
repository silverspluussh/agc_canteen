import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_client.dart';

/// Result of a lightweight server reachability probe.
enum ServerStatus {
  /// Reached the server and it responded OK.
  ok,

  /// Hostname could not be resolved — almost always the wrong network/DNS.
  dnsFailure,

  /// Network exists but the server did not respond (routed away, firewall, down).
  unreachable,

  /// TLS/CA handshake failed.
  tlsError,

  /// Server responded with a non-2xx status.
  serverError,
}

/// Probes the on-prem API (`GET /api/healthz`) using the same Dio (and internal
/// CA) the app uses, so a success means DNS + TCP + TLS + server are all good.
///
/// This is advisory only — callers must not use it to block a signed-in user.
/// Only probe when the device actually has connectivity (see [Connectivity]).
class ServerHealth {
  static Future<ServerStatus> check({
    Duration timeout = const Duration(seconds: 8),
  }) async {
    // A dedicated Dio so the probe fails fast (short connect timeout) without
    // touching the global client's timeouts. It reuses the app's HTTP adapter,
    // which is configured with the internal CA by `DioClient.configureTrust()`.
    final dio = Dio(
      BaseOptions(
        baseUrl: DioClient.baseUrl,
        connectTimeout: timeout,
        sendTimeout: timeout,
        receiveTimeout: timeout,
        validateStatus: (_) => true,
      ),
    )..httpClientAdapter = DioClient.dio.httpClientAdapter;

    try {
      final res = await dio.get('/healthz');
      final status = res.statusCode ?? 0;
      final result = (status >= 200 && status < 300)
          ? ServerStatus.ok
          : ServerStatus.serverError;
      _log(result, httpStatus: status);
      return result;
    } on DioException catch (e) {
      final result = _classify(e);
      _log(result, error: e);
      return result;
    } catch (e) {
      _log(ServerStatus.unreachable, error: e);
      return ServerStatus.unreachable;
    }
  }

  static ServerStatus _classify(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerStatus.unreachable;
      case DioExceptionType.badCertificate:
        return ServerStatus.tlsError;
      case DioExceptionType.connectionError:
        final msg = e.error?.toString() ?? '';
        if (msg.contains('Failed host lookup') ||
            msg.contains('nodename') ||
            msg.contains('No address associated')) {
          return ServerStatus.dnsFailure;
        }
        return ServerStatus.unreachable;
      default:
        if ((e.error?.toString() ?? '').contains('HandshakeException')) {
          return ServerStatus.tlsError;
        }
        return ServerStatus.unreachable;
    }
  }

  /// Release-safe log (unlike `appLog`, which is debug-only) so field devices
  /// can be diagnosed from `adb logcat`.
  static void _log(ServerStatus status, {int? httpStatus, Object? error}) {
    debugPrint(
      'ServerHealth: ${status.name}'
      '${httpStatus != null ? ' (HTTP $httpStatus)' : ''}'
      '${error != null ? ' — $error' : ''}',
    );
  }
}

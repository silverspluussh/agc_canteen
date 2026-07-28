import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Debug-only structured log (no output in release builds).
void appLog(
  String message, {
  String? name,
  Object? error,
  StackTrace? stackTrace,
}) {
  if (kDebugMode) {
    dev.log(message, name: name ?? 'App', error: error, stackTrace: stackTrace);
  }
}

/// HTTP response log — full body in debug, status + payload size only in release.
void appLogHttp(
  String method,
  String path,
  int? statusCode,
  dynamic data,
) {
  if (kDebugMode) {
    dev.log('$method $path $statusCode: $data', name: 'NetworkAPI');
  } else {
    final size = data == null ? 0 : data.toString().length;
    dev.log('$method $path $statusCode (${size}B)', name: 'NetworkAPI');
  }
}

/// Logger that is silent in release builds.
Logger createAppLogger() =>
    Logger(level: kDebugMode ? Level.debug : Level.off);

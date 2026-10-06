import 'dart:async';
import 'package:agc_canteen/core/utils/app_log.dart';
import 'package:flutter/services.dart';

class FingerprintResult {
  final bool success;
  final Uint8List? data;
  final String? templateBase64;
  final String? imageBase64;
  final int? code;

  const FingerprintResult({
    required this.success,
    this.data,
    this.templateBase64,
    this.imageBase64,
    this.code,
  });

  factory FingerprintResult.fromMap(Map<String, dynamic> map) {
    return FingerprintResult(
      success: map['success'] as bool? ?? false,
      data: map['data'] != null
          ? Uint8List.fromList(List<int>.from(map['data'] as List))
          : null,
      templateBase64: map['templateBase64'] as String?,
      imageBase64: map['imageBase64'] as String?,
      code: map['code'] as int?,
    );
  }
}

class PosFingerprintService {
  static const _methodChannel =
      MethodChannel('com.silverware.agc_canteen/fingerprint');
  static const _eventChannel =
      EventChannel('com.silverware.agc_canteen/fingerprint_events');

  Stream<FingerprintResult> get captureStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      return FingerprintResult.fromMap(Map<String, dynamic>.from(event as Map));
    });
  }

  bool _initialized = false;

  static const _captureTimeout = Duration(seconds: 30);
  static const _verifyTimeout = Duration(seconds: 10);

  Future<bool> init() async {
    if (_initialized) {
      final available = await isAvailable();
      if (available) return true;
      _initialized = false;
    }
    try {
      appLog('[PosFingerprint] Calling native method channel: init()',
          name: 'POS_AUTH');
      final result = await _methodChannel.invokeMethod<bool>('init') ?? false;
      _initialized = result;
      appLog('[PosFingerprint] init() returned: $result', name: 'POS_AUTH');
      return result;
    } on PlatformException catch (e) {
      _initialized = false;
      appLog('[PosFingerprint] init() PlatformException: ${e.code} — ${e.message}',
          name: 'POS_AUTH');
      rethrow;
    }
  }

  Future<FingerprintResult?> capture({int templateIndex = 0}) async {
    try {
      if (!await isAvailable()) {
        _initialized = false;
        final ok = await init();
        if (!ok) return null;
      }
      appLog('[PosFingerprint] Calling native method channel: capture(templateIndex=$templateIndex) — waiting for finger...',
          name: 'POS_AUTH');
      final result = await _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
          'capture', {
        'templateIndex': templateIndex,
      }).timeout(
        _captureTimeout,
        onTimeout: () {
          appLog('[PosFingerprint] capture() timed out after ${_captureTimeout.inSeconds}s',
              name: 'POS_AUTH');
          unawaited(cancel());
          return null;
        },
      );
      appLog('[PosFingerprint] capture() returned: ${result != null ? "success=${result['success']}, template=${result['templateBase64'] != null}" : "null"}',
          name: 'POS_AUTH');
      if (result == null) return null;
      return FingerprintResult.fromMap(Map<String, dynamic>.from(result));
    } on PlatformException catch (e) {
      appLog('[PosFingerprint] capture() PlatformException: $e',
          name: 'POS_AUTH');
      return null;
    }
  }

  Future<int?> verify(
    String templateBase64, {
    int templateIndex = 0,
  }) async {
    try {
      appLog('[PosFingerprint] Calling native method channel: verify(templateLength=${templateBase64.length}, templateIndex=$templateIndex)',
          name: 'POS_AUTH');
      final result = await _methodChannel.invokeMethod<int>('verify', {
        'template': templateBase64,
        'templateIndex': templateIndex,
      }).timeout(
        _verifyTimeout,
        onTimeout: () {
          appLog('[PosFingerprint] verify() timed out after ${_verifyTimeout.inSeconds}s',
              name: 'POS_AUTH');
          return null;
        },
      );
      appLog('[PosFingerprint] verify() returned: score=$result', name: 'POS_AUTH');
      return result;
    } on PlatformException catch (e) {
      appLog('[PosFingerprint] verify() PlatformException: $e',
          name: 'POS_AUTH');
      return null;
    }
  }

  Future<FingerprintResult?> enroll({int templateIndex = 0}) async {
    try {
      final result = await _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
          'enroll', {
        'templateIndex': templateIndex,
      });
      if (result == null) return null;
      return FingerprintResult.fromMap(Map<String, dynamic>.from(result));
    } on PlatformException {
      return null;
    }
  }

  Future<void> cancel() async {
    try {
      await _methodChannel.invokeMethod('cancel');
    } on PlatformException {
      // ignore
    }
  }

  Future<bool> isAvailable() async {
    try {
      return await _methodChannel.invokeMethod<bool>('isAvailable') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<List<String>> getTemplateTypes() async {
    try {
      final result =
          await _methodChannel.invokeMethod<List<dynamic>>('getTemplateTypes');
      if (result == null) return [];
      return result.cast<String>();
    } on PlatformException {
      return [];
    }
  }
}

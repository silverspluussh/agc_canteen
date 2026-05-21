import 'dart:async';
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

  Future<bool> init() async {
    try {
      return await _methodChannel.invokeMethod<bool>('init') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<FingerprintResult?> capture({int templateIndex = 0}) async {
    try {
      final result = await _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
          'capture', {
        'templateIndex': templateIndex,
      });
      if (result == null) return null;
      return FingerprintResult.fromMap(Map<String, dynamic>.from(result));
    } on PlatformException {
      return null;
    }
  }

  Future<int?> verify(
    String templateBase64, {
    int templateIndex = 0,
  }) async {
    try {
      return await _methodChannel.invokeMethod<int>('verify', {
        'template': templateBase64,
        'templateIndex': templateIndex,
      });
    } on PlatformException {
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

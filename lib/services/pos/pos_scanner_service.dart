import 'dart:async';
import 'package:flutter/services.dart';

class ScannerResult {
  final String? barcode;
  final Uint8List? raw;

  const ScannerResult({this.barcode, this.raw});

  factory ScannerResult.fromMap(Map<String, dynamic> map) {
    return ScannerResult(
      barcode: map['barcode'] as String?,
      raw: map['raw'] != null
          ? Uint8List.fromList(List<int>.from(map['raw'] as List))
          : null,
    );
  }
}

class PosScannerService {
  static const _methodChannel =
      MethodChannel('com.silverware.agc_canteen/scanner');
  static const _eventChannel =
      EventChannel('com.silverware.agc_canteen/scanner_events');

  Stream<ScannerResult> get scanStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      return ScannerResult.fromMap(Map<String, dynamic>.from(event as Map));
    });
  }

  Future<bool> startScan() async {
    try {
      return await _methodChannel.invokeMethod<bool>('startScan') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> stopScan() async {
    try {
      return await _methodChannel.invokeMethod<bool>('stopScan') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> trigger(bool value) async {
    try {
      return await _methodChannel.invokeMethod<bool>('trigger', {
        'value': value,
      }) ??
          false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> isScanning() async {
    try {
      return await _methodChannel.invokeMethod<bool>('isScanning') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> sendHeartbeat() async {
    try {
      return await _methodChannel.invokeMethod<bool>('sendHeartbeat') ?? false;
    } on PlatformException {
      return false;
    }
  }
}

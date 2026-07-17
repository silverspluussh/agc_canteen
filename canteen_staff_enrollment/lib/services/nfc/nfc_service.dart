import 'dart:async';
import 'package:flutter/services.dart';

class NfcService {
  static const _channel = MethodChannel('com.silverware.canteen_staff_enrollment/nfc');
  static const _eventChannel = EventChannel('com.silverware.canteen_staff_enrollment/nfc_events');

  Future<bool> supportNfc() async {
    try {
      return await _channel.invokeMethod<bool>('supportNfc') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> isEnabled() async {
    try {
      return await _channel.invokeMethod<bool>('isEnabled') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Stream<Map<String, dynamic>> get tagStream {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) => Map<String, dynamic>.from(event as Map));
  }

  static String hexToDecimal(String hex) {
    final value = int.parse(hex, radix: 16);
    return value.toString();
  }

  static String reverseHex(String hex) {
    if (hex.length < 2 || hex.length % 2 != 0) return hex;
    final buffer = StringBuffer();
    for (int i = hex.length - 2; i >= 0; i -= 2) {
      buffer.write(hex.substring(i, i + 2));
    }
    return buffer.toString();
  }
}

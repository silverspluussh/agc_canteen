import 'dart:async';
import 'package:flutter/services.dart';

class NfcService {
  static const _channel = MethodChannel('com.silverware.agc_canteen/nfc');
  static const _eventChannel = EventChannel('com.silverware.agc_canteen/nfc_events');

  /// Checks if the device supports NFC hardware.
  Future<bool> supportNfc() async {
    try {
      return await _channel.invokeMethod<bool>('supportNfc') ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Checks if NFC is enabled on the device.
  Future<bool> isEnabled() async {
    try {
      return await _channel.invokeMethod<bool>('isEnabled') ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Stream of discovered NFC tags.
  /// Subscribing enables reader mode; cancelling all subscriptions disables it.
  Stream<Map<String, dynamic>> get tagStream {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) => Map<String, dynamic>.from(event as Map));
  }

  /// Converts a hex tag ID to decimal string (matching PdaX NfcActivity behavior).
  static String hexToDecimal(String hex) {
    final value = int.parse(hex, radix: 16);
    return value.toString();
  }

  /// Reverses byte order of a hex string (matching PdaX NFCUtils.reverse).
  static String reverseHex(String hex) {
    if (hex.length < 2 || hex.length % 2 != 0) return hex;
    final buffer = StringBuffer();
    for (int i = hex.length - 2; i >= 0; i -= 2) {
      buffer.write(hex.substring(i, i + 2));
    }
    return buffer.toString();
  }
}

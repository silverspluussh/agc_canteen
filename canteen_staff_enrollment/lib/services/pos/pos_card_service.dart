import 'package:flutter/services.dart';

class PosCardService {
  static const _channel = MethodChannel('com.silverware.agc_canteen/card');

  // ─── IC Smart Card (ISO 7816) ────────────────────────────

  Future<Uint8List?> icReset() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('icReset');
      if (result == null || result.isEmpty) return null;
      return Uint8List.fromList(List<int>.from(result));
    } on PlatformException {
      return null;
    }
  }

  Future<Uint8List?> icApdu(Uint8List apdu) async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('icApdu', {
        'apdu': apdu.toList(),
      });
      if (result == null || result.isEmpty) return null;
      return Uint8List.fromList(List<int>.from(result));
    } on PlatformException {
      return null;
    }
  }

  Future<int> icWrite(Uint8List apdu) async {
    try {
      return await _channel.invokeMethod<int>('icWrite', {
        'apdu': apdu.toList(),
      }) ?? 0;
    } on PlatformException {
      return 0;
    }
  }

  // ─── PSAM Secure Access Module ────────────────────────────

  Future<Uint8List?> psamReset({int slot = 1}) async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('psamReset', {
        'slot': slot,
      });
      if (result == null || result.isEmpty) return null;
      return Uint8List.fromList(List<int>.from(result));
    } on PlatformException {
      return null;
    }
  }

  Future<Uint8List?> psamApdu(Uint8List apdu, {int slot = 1}) async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('psamApdu', {
        'slot': slot,
        'apdu': apdu.toList(),
      });
      if (result == null || result.isEmpty) return null;
      return Uint8List.fromList(List<int>.from(result));
    } on PlatformException {
      return null;
    }
  }

  Future<Uint8List?> psamClose({int slot = 1}) async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('psamClose', {
        'slot': slot,
      });
      if (result == null || result.isEmpty) return null;
      return Uint8List.fromList(List<int>.from(result));
    } on PlatformException {
      return null;
    }
  }

  // ─── Magnetic Swipe Card ──────────────────────────────────

  Future<Uint8List?> swipeCard() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('swipeCard');
      if (result == null || result.isEmpty) return null;
      return Uint8List.fromList(List<int>.from(result));
    } on PlatformException {
      return null;
    }
  }
}

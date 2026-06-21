import 'package:flutter/services.dart';

/// ISO 7816-4 APDU command builder for IC smart cards.
class ApduHelper {
  ApduHelper._();

  /// SELECT command — selects a file/application on the card.
  /// [fileId] is typically a 2-byte DF/EF identifier.
  static Uint8List selectFile(Uint8List fileId) {
    final apdu = Uint8List(6 + fileId.length);
    apdu[0] = 0x00;
    apdu[1] = 0xA4;
    apdu[2] = 0x04;
    apdu[3] = 0x00;
    apdu[4] = fileId.length;
    apdu.setAll(5, fileId);
    return apdu;
  }

  /// READ BINARY — reads [length] bytes from [offset] on the current EF.
  /// INS = 0xB0, P1/P2 = offset (MSB/LSB), Le = length.
  static Uint8List readBinary(int offset, int length) {
    final msb = (offset >> 8) & 0xFF;
    final lsb = offset & 0xFF;
    return Uint8List.fromList([0x00, 0xB0, msb, lsb, length]);
  }

  /// UPDATE BINARY — writes [data] to the current EF at [offset].
  /// INS = 0xD6, P1/P2 = offset (MSB/LSB).
  static Uint8List updateBinary(int offset, Uint8List data) {
    final msb = (offset >> 8) & 0xFF;
    final lsb = offset & 0xFF;
    final apdu = Uint8List(5 + data.length);
    apdu[0] = 0x00;
    apdu[1] = 0xD6;
    apdu[2] = msb;
    apdu[3] = lsb;
    apdu[4] = data.length;
    apdu.setAll(5, data);
    return apdu;
  }

  /// VERIFY — submits a PIN/password for card authentication.
  /// INS = 0x20, P1 = 0x00, P2 = 0x00.
  static Uint8List verify(Uint8List pin) {
    final apdu = Uint8List(5 + pin.length);
    apdu[0] = 0x00;
    apdu[1] = 0x20;
    apdu[2] = 0x00;
    apdu[3] = 0x00;
    apdu[4] = pin.length;
    apdu.setAll(5, pin);
    return apdu;
  }

  /// GET RESPONSE — retrieves data when card returns 0x61XX status.
  static Uint8List getResponse(int length) {
    return Uint8List.fromList([0x00, 0xC0, 0x00, 0x00, length]);
  }
}

class PosCardService {
  static const _channel = MethodChannel('com.silverware.agc_canteen/card');

  // ─── IC Smart Card (ISO 7816) — low-level APDU ─────────────

  /// Resets the IC card and returns the ATR (Answer to Reset).
  Future<Uint8List?> icReset() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('icReset');
      if (result == null || result.isEmpty) return null;
      return Uint8List.fromList(List<int>.from(result));
    } on PlatformException {
      return null;
    }
  }

  /// Sends a raw APDU command to the IC card and returns the response.
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

  /// Writes a raw APDU to the IC card and returns a status code.
  Future<int> icWrite(Uint8List apdu) async {
    try {
      return await _channel.invokeMethod<int>('icWrite', {
        'apdu': apdu.toList(),
      }) ?? 0;
    } on PlatformException {
      return 0;
    }
  }

  // ─── IC Smart Card — high-level operations ──────────────────

  /// Selects a file/application on the card by its [fileId].
  Future<Uint8List?> selectFile(Uint8List fileId) async {
    return icApdu(ApduHelper.selectFile(fileId));
  }

  /// Reads [length] bytes from the card at [offset].
  Future<Uint8List?> readBinary(int offset, int length) async {
    return icApdu(ApduHelper.readBinary(offset, length));
  }

  /// Writes [data] to the card at [offset]. Returns status code.
  Future<int> updateBinary(int offset, Uint8List data) async {
    return icWrite(ApduHelper.updateBinary(offset, data));
  }

  /// Clears [length] bytes at [offset] by writing zeros. Returns status code.
  Future<int> eraseData(int offset, int length) async {
    final zeros = Uint8List(length);
    return updateBinary(offset, zeros);
  }

  /// Submits a PIN/password for card authentication. Returns card response.
  Future<Uint8List?> verify(Uint8List pin) async {
    return icApdu(ApduHelper.verify(pin));
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

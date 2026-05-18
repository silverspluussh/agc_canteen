import 'package:flutter/services.dart';

class PosPrintService {
  static const _channel = MethodChannel('com.silverware.agc_canteen/print');

  Future<bool> printRawBytes(Uint8List bytes) async {
    try {
      return await _channel.invokeMethod<bool>(
        'printRawBytes',
        {'bytes': bytes.toList()},
      ) ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> cutPaper() async {
    try {
      return await _channel.invokeMethod<bool>('cutPaper') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> openCashDrawer() async {
    try {
      return await _channel.invokeMethod<bool>('openCashDrawer') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<Map<String, dynamic>?> checkPrinterState() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('checkPrinterState');
      return result != null ? Map<String, dynamic>.from(result) : null;
    } on PlatformException {
      return null;
    }
  }

  Future<String?> getFirmwareVersion() async {
    try {
      return await _channel.invokeMethod<String>('getFirmwareVersion');
    } on PlatformException {
      return null;
    }
  }
}

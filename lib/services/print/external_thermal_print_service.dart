import 'package:flutter/services.dart';
import 'abstract_print_service.dart';

class ExternalThermalPrintService extends AbstractPrintService {
  static const _channel = MethodChannel(
    'com.silverware.agc_canteen/external_print',
  );

  @override
  Future<bool> printRawBytes(Uint8List bytes) async {
    try {
      return await _channel.invokeMethod<bool>(
            'printRawBytes',
            {'bytes': bytes.toList()},
          ) ??
          false;
    } on Exception {
      return false;
    }
  }

  @override
  Future<bool> cutPaper() async {
    try {
      return await _channel.invokeMethod<bool>('cutPaper') ?? false;
    } on Exception {
      return false;
    }
  }

  @override
  Future<bool> openCashDrawer() async {
    try {
      return await _channel.invokeMethod<bool>('openCashDrawer') ?? false;
    } on Exception {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> checkPrinterState() async {
    try {
      final result =
          await _channel.invokeMethod<Map<dynamic, dynamic>>('checkPrinterState');
      return result != null ? Map<String, dynamic>.from(result) : null;
    } on Exception {
      return null;
    }
  }

  @override
  Future<String?> getFirmwareVersion() async {
    try {
      return await _channel.invokeMethod<String>('getFirmwareVersion');
    } on Exception {
      return null;
    }
  }

  @override
  Future<bool> isAvailable() async {
    try {
      return await _channel.invokeMethod<bool>('isAvailable') ?? false;
    } on Exception {
      return false;
    }
  }
}

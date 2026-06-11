import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'abstract_print_service.dart';
import '../pos/pos_print_service.dart';
import 'external_thermal_print_service.dart';

enum PrinterType { inbuilt, external }

class PrintServiceManager extends ChangeNotifier implements AbstractPrintService {
  static const _printerTypeKey = 'printer_type';

  final PosPrintService _inbuiltPrinter;
  final ExternalThermalPrintService _externalPrinter;

  PrinterType _printerType = PrinterType.inbuilt;

  PrintServiceManager({
    PosPrintService? inbuiltPrinter,
    ExternalThermalPrintService? externalPrinter,
  })  : _inbuiltPrinter = inbuiltPrinter ?? PosPrintService(),
        _externalPrinter = externalPrinter ?? ExternalThermalPrintService();

  PrinterType get printerType => _printerType;

  Future<void> loadPrinterType() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_printerTypeKey);
    if (stored == PrinterType.external.name) {
      _printerType = PrinterType.external;
    } else {
      _printerType = PrinterType.inbuilt;
    }
    notifyListeners();
  }

  Future<void> setPrinterType(PrinterType type) async {
    if (type == PrinterType.external) {
      final available = await _externalPrinter.isAvailable();
      if (!available) {
        _printerType = PrinterType.inbuilt;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_printerTypeKey, PrinterType.inbuilt.name);
        notifyListeners();
        return;
      }
    }
    _printerType = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_printerTypeKey, type.name);
    notifyListeners();
  }

  AbstractPrintService get _active =>
      _printerType == PrinterType.external ? _externalPrinter : _inbuiltPrinter;

  Future<AbstractPrintService> get _resolvedForPrint async {
    if (_printerType == PrinterType.external) {
      final available = await _externalPrinter.isAvailable();
      if (!available) return _inbuiltPrinter;
      return _externalPrinter;
    }
    return _inbuiltPrinter;
  }

  @override
  Future<bool> printRawBytes(Uint8List bytes) async {
    final printer = await _resolvedForPrint;
    return printer.printRawBytes(bytes);
  }

  @override
  Future<bool> cutPaper() async {
    final printer = await _resolvedForPrint;
    return printer.cutPaper();
  }

  @override
  Future<bool> openCashDrawer() async {
    final printer = await _resolvedForPrint;
    return printer.openCashDrawer();
  }

  @override
  Future<Map<String, dynamic>?> checkPrinterState() =>
      _active.checkPrinterState();

  @override
  Future<String?> getFirmwareVersion() => _active.getFirmwareVersion();

  @override
  Future<bool> isAvailable() => _active.isAvailable();
}

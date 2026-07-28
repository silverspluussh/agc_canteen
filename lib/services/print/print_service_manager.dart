import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'abstract_print_service.dart';
import '../pos/pos_print_service.dart';
import 'external_thermal_print_service.dart';

enum PrinterType { inbuilt, external }

/// Result of attempting to switch printer type, used to drive UI feedback
/// (e.g. a SnackBar explaining why a switch to External was rejected).
enum SetPrinterTypeResult { success, noDeviceConnected }

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

  ExternalThermalPrintService get externalPrinter => _externalPrinter;
  PosPrintService get inbuiltPrinter => _inbuiltPrinter;

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

  Future<void>? _loadFuture;

  /// Loads persisted printer preference on first use (deferred from app startup).
  Future<void> ensureLoaded() {
    return _loadFuture ??= loadPrinterType();
  }

  /// Switches printer type. Returns [SetPrinterTypeResult.noDeviceConnected]
  /// (and stays on the previous type) when External is requested but no
  /// external printer is currently connected, so the UI can explain why the
  /// switch didn't happen instead of silently reverting.
  Future<SetPrinterTypeResult> setPrinterType(PrinterType type) async {
    if (type == PrinterType.external) {
      final available = await _externalPrinter.isAvailable();
      if (!available) {
        notifyListeners();
        return SetPrinterTypeResult.noDeviceConnected;
      }
    }
    _printerType = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_printerTypeKey, type.name);
    notifyListeners();
    return SetPrinterTypeResult.success;
  }

  AbstractPrintService get _active =>
      _printerType == PrinterType.external ? _externalPrinter : _inbuiltPrinter;

  Future<AbstractPrintService> get _resolvedForPrint async {
    await ensureLoaded();
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
  Future<Map<String, dynamic>?> checkPrinterState() async {
    final printer = await _resolvedForPrint;
    return printer.checkPrinterState();
  }

  @override
  Future<String?> getFirmwareVersion() async {
    final printer = await _resolvedForPrint;
    return printer.getFirmwareVersion();
  }

  @override
  Future<bool> isAvailable() => _active.isAvailable();

  /// Sends a short ESC/POS test receipt to whichever printer is currently
  /// resolved (respects the same fallback-to-inbuilt logic as real prints).
  Future<bool> testPrint() async {
    final bytes = _buildTestReceipt();
    final ok = await printRawBytes(bytes);
    if (ok) await cutPaper();
    return ok;
  }

  Uint8List _buildTestReceipt() {
    const init = [0x1B, 0x40]; // ESC @ (initialize)
    const alignCenter = [0x1B, 0x61, 0x01];
    const alignLeft = [0x1B, 0x61, 0x00];
    final text = 'ASG Canteen\nPrinter Test\n${DateTime.now()}\n\n\n'
        .codeUnits;
    return Uint8List.fromList([
      ...init,
      ...alignCenter,
      ...text,
      ...alignLeft,
    ]);
  }
}

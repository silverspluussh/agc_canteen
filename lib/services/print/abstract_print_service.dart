import 'dart:typed_data';

abstract class AbstractPrintService {
  Future<bool> printRawBytes(Uint8List bytes);
  Future<bool> cutPaper();
  Future<bool> openCashDrawer();
  Future<Map<String, dynamic>?> checkPrinterState();
  Future<String?> getFirmwareVersion();
  Future<bool> isAvailable();
}

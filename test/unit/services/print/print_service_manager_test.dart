import 'dart:typed_data';

import 'package:agc_canteen/services/print/print_service_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/shared_prefs.dart';

void main() {
  late MockPosPrintService inbuilt;
  late MockExternalThermalPrintService external;
  late PrintServiceManager manager;

  setUpAll(() {
    registerCommonFallbackValues();
  });

  setUp(() {
    initMockSharedPreferences();
    inbuilt = MockPosPrintService();
    external = MockExternalThermalPrintService();
    manager = PrintServiceManager(
      inbuiltPrinter: inbuilt,
      externalPrinter: external,
    );
  });

  group('printer type persistence', () {
    test('defaults to inbuilt when nothing is stored', () async {
      await manager.loadPrinterType();
      expect(manager.printerType, PrinterType.inbuilt);
    });

    test('loads external from prefs when previously persisted', () async {
      initMockSharedPreferences({'printer_type': 'external'});
      manager = PrintServiceManager(
        inbuiltPrinter: inbuilt,
        externalPrinter: external,
      );

      await manager.loadPrinterType();

      expect(manager.printerType, PrinterType.external);
    });

    test('ensureLoaded only loads once', () async {
      await manager.ensureLoaded();
      await manager.ensureLoaded();
      // No exceptions and printer type resolved to a default; the
      // underlying load only happens once (loadPrinterType is idempotent
      // to call, so we can't directly count calls, but this guards against
      // regressions that make ensureLoaded throw on repeated calls).
      expect(manager.printerType, PrinterType.inbuilt);
    });
  });

  group('setPrinterType', () {
    test('switches to external when a device is connected and persists it', () async {
      when(() => external.isAvailable()).thenAnswer((_) async => true);

      final result = await manager.setPrinterType(PrinterType.external);

      expect(result, SetPrinterTypeResult.success);
      expect(manager.printerType, PrinterType.external);
    });

    test('refuses to switch to external when no device is connected', () async {
      when(() => external.isAvailable()).thenAnswer((_) async => false);

      final result = await manager.setPrinterType(PrinterType.external);

      expect(result, SetPrinterTypeResult.noDeviceConnected);
      expect(manager.printerType, PrinterType.inbuilt);
    });

    test('switching to inbuilt always succeeds', () async {
      final result = await manager.setPrinterType(PrinterType.inbuilt);

      expect(result, SetPrinterTypeResult.success);
      expect(manager.printerType, PrinterType.inbuilt);
    });
  });

  group('print delegation', () {
    test('printRawBytes uses the inbuilt printer by default', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      when(() => inbuilt.printRawBytes(bytes)).thenAnswer((_) async => true);

      final ok = await manager.printRawBytes(bytes);

      expect(ok, isTrue);
      verify(() => inbuilt.printRawBytes(bytes)).called(1);
      verifyNever(() => external.printRawBytes(any()));
    });

    test('printRawBytes uses the external printer once selected and available', () async {
      when(() => external.isAvailable()).thenAnswer((_) async => true);
      await manager.setPrinterType(PrinterType.external);

      final bytes = Uint8List.fromList([4, 5, 6]);
      when(() => external.printRawBytes(bytes)).thenAnswer((_) async => true);

      final ok = await manager.printRawBytes(bytes);

      expect(ok, isTrue);
      verify(() => external.printRawBytes(bytes)).called(1);
      verifyNever(() => inbuilt.printRawBytes(any()));
    });

    test('falls back to inbuilt when external was selected but disconnects', () async {
      when(() => external.isAvailable()).thenAnswer((_) async => true);
      await manager.setPrinterType(PrinterType.external);

      // External printer drops mid-session.
      when(() => external.isAvailable()).thenAnswer((_) async => false);
      final bytes = Uint8List.fromList([7, 8, 9]);
      when(() => inbuilt.printRawBytes(bytes)).thenAnswer((_) async => true);

      final ok = await manager.printRawBytes(bytes);

      expect(ok, isTrue);
      verify(() => inbuilt.printRawBytes(bytes)).called(1);
      verifyNever(() => external.printRawBytes(any()));
    });

    test('cutPaper and openCashDrawer delegate to the resolved printer', () async {
      when(() => inbuilt.cutPaper()).thenAnswer((_) async => true);
      when(() => inbuilt.openCashDrawer()).thenAnswer((_) async => true);

      expect(await manager.cutPaper(), isTrue);
      expect(await manager.openCashDrawer(), isTrue);
      verify(() => inbuilt.cutPaper()).called(1);
      verify(() => inbuilt.openCashDrawer()).called(1);
    });
  });

  group('testPrint', () {
    test('sends a receipt and cuts the paper on success', () async {
      when(() => inbuilt.printRawBytes(any())).thenAnswer((_) async => true);
      when(() => inbuilt.cutPaper()).thenAnswer((_) async => true);

      final ok = await manager.testPrint();

      expect(ok, isTrue);
      verify(() => inbuilt.printRawBytes(any())).called(1);
      verify(() => inbuilt.cutPaper()).called(1);
    });

    test('does not cut the paper when printing fails', () async {
      when(() => inbuilt.printRawBytes(any())).thenAnswer((_) async => false);

      final ok = await manager.testPrint();

      expect(ok, isFalse);
      verifyNever(() => inbuilt.cutPaper());
    });
  });
}

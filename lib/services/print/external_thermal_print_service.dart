import 'package:flutter/services.dart';
import 'abstract_print_service.dart';

/// Connection transport used for the external thermal printer.
enum ExternalConnectionType { usb, bluetooth }

/// A USB device candidate returned by [ExternalThermalPrintService.scanUsbDevices].
class UsbPrinterDevice {
  const UsbPrinterDevice({
    required this.deviceName,
    required this.vendorId,
    required this.productId,
  });

  factory UsbPrinterDevice.fromMap(Map<dynamic, dynamic> map) {
    return UsbPrinterDevice(
      deviceName: map['deviceName']?.toString() ?? '',
      vendorId: (map['vendorId'] as num?)?.toInt() ?? 0,
      productId: (map['productId'] as num?)?.toInt() ?? 0,
    );
  }

  final String deviceName;
  final int vendorId;
  final int productId;
}

/// A Bluetooth Classic device candidate (bonded or discovered).
class BluetoothPrinterDevice {
  const BluetoothPrinterDevice({
    required this.name,
    required this.address,
    required this.bonded,
  });

  factory BluetoothPrinterDevice.fromMap(Map<dynamic, dynamic> map) {
    return BluetoothPrinterDevice(
      name: map['name']?.toString() ?? 'Unknown device',
      address: map['address']?.toString() ?? '',
      bonded: map['bonded'] == true,
    );
  }

  final String name;
  final String address;
  final bool bonded;
}

/// Current connection state of the external printer.
class ExternalConnectionInfo {
  const ExternalConnectionInfo({
    required this.connected,
    this.type,
    this.name,
    this.address,
  });

  factory ExternalConnectionInfo.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const ExternalConnectionInfo(connected: false);
    final typeStr = map['type']?.toString();
    return ExternalConnectionInfo(
      connected: map['connected'] == true,
      type: typeStr == 'bluetooth'
          ? ExternalConnectionType.bluetooth
          : typeStr == 'usb'
          ? ExternalConnectionType.usb
          : null,
      name: map['name']?.toString(),
      address: map['address']?.toString(),
    );
  }

  final bool connected;
  final ExternalConnectionType? type;
  final String? name;
  final String? address;
}

class ExternalThermalPrintService extends AbstractPrintService {
  static const _channel = MethodChannel(
    'com.silverware.agc_canteen/external_print',
  );

  /// Fired when native code reports a Bluetooth device found during discovery
  /// or a bond-state change. Set by the settings page while it is visible.
  void Function(BluetoothPrinterDevice device)? onBluetoothDeviceFound;
  void Function(String address, bool bonded)? onBondStateChanged;
  void Function()? onDiscoveryFinished;

  bool _handlerAttached = false;

  void _ensureHandler() {
    if (_handlerAttached) return;
    _handlerAttached = true;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'bluetoothDeviceFound':
          final map = call.arguments as Map<dynamic, dynamic>?;
          if (map != null) {
            onBluetoothDeviceFound?.call(BluetoothPrinterDevice.fromMap(map));
          }
          break;
        case 'bluetoothBondStateChanged':
          final map = call.arguments as Map<dynamic, dynamic>?;
          if (map != null) {
            onBondStateChanged?.call(
              map['address']?.toString() ?? '',
              map['bonded'] == true,
            );
          }
          break;
        case 'bluetoothDiscoveryFinished':
          onDiscoveryFinished?.call();
          break;
      }
      return null;
    });
  }

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
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'checkPrinterState',
      );
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

  /// Current connection details (type, device name/address, connected).
  Future<ExternalConnectionInfo> getConnectionInfo() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getConnectionInfo',
      );
      return ExternalConnectionInfo.fromMap(result);
    } on Exception {
      return const ExternalConnectionInfo(connected: false);
    }
  }

  Future<bool> disconnect() async {
    try {
      return await _channel.invokeMethod<bool>('disconnect') ?? false;
    } on Exception {
      return false;
    }
  }

  // ── USB ──────────────────────────────────────────────────────────────

  Future<List<UsbPrinterDevice>> scanUsbDevices() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>(
        'scanForDevices',
      );
      return (result ?? [])
          .map((e) => UsbPrinterDevice.fromMap(e as Map<dynamic, dynamic>))
          .toList();
    } on Exception {
      return [];
    }
  }

  Future<bool> connectUsb(String deviceName) async {
    try {
      return await _channel.invokeMethod<bool>('connectUsb', {
            'deviceName': deviceName,
          }) ??
          false;
    } on Exception {
      return false;
    }
  }

  // ── Bluetooth ────────────────────────────────────────────────────────

  /// Whether the device's Bluetooth adapter is on and Classic BT is supported.
  Future<bool> isBluetoothSupported() async {
    try {
      return await _channel.invokeMethod<bool>('isBluetoothSupported') ??
          false;
    } on Exception {
      return false;
    }
  }

  Future<List<BluetoothPrinterDevice>> getBondedBluetoothDevices() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>(
        'getBondedBluetoothDevices',
      );
      return (result ?? [])
          .map(
            (e) => BluetoothPrinterDevice.fromMap(e as Map<dynamic, dynamic>),
          )
          .toList();
    } on Exception {
      return [];
    }
  }

  /// Starts Bluetooth Classic discovery. Results stream via
  /// [onBluetoothDeviceFound] and completion via [onDiscoveryFinished].
  Future<bool> startBluetoothDiscovery() async {
    _ensureHandler();
    try {
      return await _channel.invokeMethod<bool>('startBluetoothDiscovery') ??
          false;
    } on Exception {
      return false;
    }
  }

  Future<void> stopBluetoothDiscovery() async {
    try {
      await _channel.invokeMethod('stopBluetoothDiscovery');
    } on Exception {
      // ignore
    }
  }

  /// Attempts an in-app pair. Returns true if pairing was *initiated*
  /// (bond result arrives asynchronously via [onBondStateChanged]).
  /// Some OEM/handheld devices restrict this — caller should offer the
  /// system Bluetooth settings fallback if this returns false.
  Future<bool> pairBluetoothDevice(String address) async {
    _ensureHandler();
    try {
      return await _channel.invokeMethod<bool>('pairBluetoothDevice', {
            'address': address,
          }) ??
          false;
    } on Exception {
      return false;
    }
  }

  Future<bool> connectBluetooth(String address) async {
    try {
      return await _channel.invokeMethod<bool>('connectBluetooth', {
            'address': address,
          }) ??
          false;
    } on Exception {
      return false;
    }
  }

  /// Opens the system Bluetooth settings screen so the user can pair a
  /// printer outside the app when in-app pairing is restricted by the OEM.
  Future<void> openBluetoothSettings() async {
    try {
      await _channel.invokeMethod('openBluetoothSettings');
    } on Exception {
      // ignore
    }
  }
}

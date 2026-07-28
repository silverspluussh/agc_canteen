import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/injection_container.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/print/external_thermal_print_service.dart';
import '../../services/print/print_service_manager.dart';

const _connectionTypeKey = 'external_connection_type';

/// Dedicated printer management page: built-in vs external (USB/Bluetooth),
/// with scan/pair/connect flows and a test print action. Replaces the old
/// printer type switch that used to live on the POS Settings page.
class PrinterSettingsPage extends ConsumerStatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  ConsumerState<PrinterSettingsPage> createState() =>
      _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends ConsumerState<PrinterSettingsPage>
    with WidgetsBindingObserver {
  late final PrintServiceManager _printManager;
  late final ExternalThermalPrintService _external;

  ExternalConnectionType _connectionType = ExternalConnectionType.bluetooth;

  bool _isLoading = true;
  bool _isBusy = false;
  String? _busyLabel;

  // Built-in
  Map<String, dynamic>? _builtInState;
  String? _builtInFirmware;

  // External / shared
  ExternalConnectionInfo _connectionInfo = const ExternalConnectionInfo(
    connected: false,
  );

  // USB
  List<UsbPrinterDevice> _usbDevices = [];

  // Bluetooth
  bool _bluetoothSupported = false;
  List<BluetoothPrinterDevice> _bondedDevices = [];
  final List<BluetoothPrinterDevice> _discoveredDevices = [];
  bool _isDiscovering = false;
  String? _pairingAddress;
  bool _lastPairFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _printManager = getIt<PrintServiceManager>();
    _external = _printManager.externalPrinter;
    _external.onBluetoothDeviceFound = _onBluetoothDeviceFound;
    _external.onBondStateChanged = _onBondStateChanged;
    _external.onDiscoveryFinished = () {
      if (mounted) setState(() => _isDiscovering = false);
    };
    _loadAll();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _external.onBluetoothDeviceFound = null;
    _external.onBondStateChanged = null;
    _external.onDiscoveryFinished = null;
    if (_isDiscovering) _external.stopBluetoothDiscovery();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _printManager.printerType == PrinterType.external &&
        _connectionType == ExternalConnectionType.bluetooth) {
      _refreshBondedDevices();
    }
  }

  void _onBluetoothDeviceFound(BluetoothPrinterDevice device) {
    if (!mounted) return;
    setState(() {
      if (device.bonded) {
        if (!_bondedDevices.any((d) => d.address == device.address)) {
          _bondedDevices = [..._bondedDevices, device];
        }
      } else if (!_discoveredDevices.any(
        (d) => d.address == device.address,
      )) {
        _discoveredDevices.add(device);
      }
    });
  }

  void _onBondStateChanged(String address, bool bonded) {
    if (!mounted) return;
    setState(() {
      _pairingAddress = null;
      _lastPairFailed = !bonded;
    });
    if (bonded) {
      _refreshBondedDevices();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paired successfully. You can now connect.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pairing failed. Try Bluetooth settings instead.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    await _printManager.ensureLoaded();
    final prefs = await SharedPreferences.getInstance();
    final storedType = prefs.getString(_connectionTypeKey);
    _connectionType = storedType == ExternalConnectionType.usb.name
        ? ExternalConnectionType.usb
        : ExternalConnectionType.bluetooth;

    await Future.wait([
      _loadBuiltInState(),
      _loadConnectionInfo(),
      _loadUsbDevices(),
      _loadBluetoothInfo(),
    ]);

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadBuiltInState() async {
    try {
      final state = await _printManager.inbuiltPrinter.checkPrinterState();
      final fw = await _printManager.inbuiltPrinter.getFirmwareVersion();
      if (mounted) {
        setState(() {
          _builtInState = state;
          _builtInFirmware = fw;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadConnectionInfo() async {
    final info = await _external.getConnectionInfo();
    if (mounted) setState(() => _connectionInfo = info);
  }

  Future<void> _loadUsbDevices() async {
    final devices = await _external.scanUsbDevices();
    if (mounted) setState(() => _usbDevices = devices);
  }

  Future<void> _loadBluetoothInfo() async {
    final supported = await _external.isBluetoothSupported();
    final bonded = await _external.getBondedBluetoothDevices();
    if (mounted) {
      setState(() {
        _bluetoothSupported = supported;
        _bondedDevices = bonded;
      });
    }
  }

  Future<void> _refreshBondedDevices() async {
    final bonded = await _external.getBondedBluetoothDevices();
    if (mounted) setState(() => _bondedDevices = bonded);
  }

  Future<void> _runBusy(String label, Future<void> Function() action) async {
    setState(() {
      _isBusy = true;
      _busyLabel = label;
    });
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
          _busyLabel = null;
        });
      }
    }
  }

  Future<void> _setPrinterType(PrinterType type) async {
    final result = await _printManager.setPrinterType(type);
    if (!mounted) return;
    setState(() {});
    if (result == SetPrinterTypeResult.noDeviceConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No external printer connected yet. Scan and connect a '
            'device below, then switch to External.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _setConnectionType(ExternalConnectionType type) async {
    setState(() => _connectionType = type);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_connectionTypeKey, type.name);
  }

  Future<void> _scanUsb() async {
    await _runBusy('Scanning USB…', () async {
      await _loadUsbDevices();
    });
  }

  Future<void> _connectUsb(UsbPrinterDevice device) async {
    await _runBusy('Connecting…', () async {
      final ok = await _external.connectUsb(device.deviceName);
      await _loadConnectionInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ok ? 'Connected to printer' : 'Connection failed'),
            backgroundColor: ok ? Colors.green : Colors.red,
          ),
        );
      }
    });
  }

  Future<void> _scanBluetooth() async {
    setState(() {
      _discoveredDevices.clear();
      _isDiscovering = true;
    });
    final started = await _external.startBluetoothDiscovery();
    if (!started && mounted) {
      setState(() => _isDiscovering = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not start Bluetooth scan. Make sure Bluetooth is on '
            'and permission is granted.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
    await _refreshBondedDevices();
  }

  Future<void> _pairAndConnect(BluetoothPrinterDevice device) async {
    if (device.bonded) {
      await _connectBluetooth(device);
      return;
    }
    setState(() {
      _pairingAddress = device.address;
      _lastPairFailed = false;
    });
    final initiated = await _external.pairBluetoothDevice(device.address);
    if (!initiated) {
      if (mounted) {
        setState(() {
          _pairingAddress = null;
          _lastPairFailed = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This device does not allow pairing from within the app. '
              'Use "Open Bluetooth settings" to pair, then refresh.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
    // Bond result (success/failure) arrives asynchronously via
    // onBondStateChanged and is handled there.
  }

  Future<void> _connectBluetooth(BluetoothPrinterDevice device) async {
    await _runBusy('Connecting…', () async {
      final ok = await _external.connectBluetooth(device.address);
      await _loadConnectionInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ok ? 'Connected to ${device.name}' : 'Connection failed',
            ),
            backgroundColor: ok ? Colors.green : Colors.red,
          ),
        );
      }
    });
  }

  Future<void> _disconnect() async {
    await _runBusy('Disconnecting…', () async {
      await _external.disconnect();
      await _loadConnectionInfo();
    });
  }

  Future<void> _testPrint() async {
    await _runBusy('Printing test receipt…', () async {
      final ok = await _printManager.testPrint();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ok ? 'Test receipt sent' : 'Test print failed'),
            backgroundColor: ok ? Colors.green : Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(l10n.printerSettings),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isLoading ? null : _loadAll,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAll,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 30),
                children: [
                  AnimatedBuilder(
                    animation: _printManager,
                    builder: (context, _) => _PrinterTypeSelector(
                      currentType: _printManager.printerType,
                      onChanged: _setPrinterType,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isBusy)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 10),
                          Text(_busyLabel ?? 'Working…'),
                        ],
                      ),
                    ),
                  AnimatedBuilder(
                    animation: _printManager,
                    builder: (context, _) {
                      return _printManager.printerType == PrinterType.inbuilt
                          ? _buildBuiltInSection(l10n)
                          : _buildExternalSection(l10n);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBuiltInSection(AppLocalizations l10n) {
    final isInit = _builtInState != null || _builtInFirmware != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusCard(
          title: 'Built-in printer (HFPos SDK)',
          connected: isInit,
          connectedLabel: l10n.printerConnected,
          disconnectedLabel: l10n.printerDisconnected,
          details: [
            if (_builtInFirmware != null)
              _InfoRow(label: l10n.posFirmwareVersion, value: _builtInFirmware!),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isBusy ? null : _testPrint,
            icon: const Icon(Icons.receipt_long),
            label: const Text('Test print'),
          ),
        ),
      ],
    );
  }

  Widget _buildExternalSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusCard(
          title: 'External printer',
          connected: _connectionInfo.connected,
          connectedLabel: _connectionInfo.connected
              ? '${l10n.printerConnected}: ${_connectionInfo.name ?? _connectionInfo.address ?? "printer"}'
              : l10n.printerConnected,
          disconnectedLabel: l10n.printerDisconnected,
          details: [
            if (_connectionInfo.connected)
              _InfoRow(
                label: 'Connection',
                value: _connectionInfo.type == ExternalConnectionType.bluetooth
                    ? 'Bluetooth'
                    : 'USB',
              ),
          ],
          trailing: _connectionInfo.connected
              ? TextButton(
                  onPressed: _isBusy ? null : _disconnect,
                  child: Text(l10n.disconnectPrinter),
                )
              : null,
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connection type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<ExternalConnectionType>(
                  segments: const [
                    ButtonSegment(
                      value: ExternalConnectionType.bluetooth,
                      label: Text('Bluetooth'),
                      icon: Icon(Icons.bluetooth),
                    ),
                    ButtonSegment(
                      value: ExternalConnectionType.usb,
                      label: Text('USB'),
                      icon: Icon(Icons.usb),
                    ),
                  ],
                  selected: {_connectionType},
                  onSelectionChanged: (v) => _setConnectionType(v.first),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_connectionType == ExternalConnectionType.usb)
          _buildUsbSection()
        else
          _buildBluetoothSection(),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: (_isBusy || !_connectionInfo.connected)
                ? null
                : _testPrint,
            icon: const Icon(Icons.receipt_long),
            label: const Text('Test print'),
          ),
        ),
      ],
    );
  }

  Widget _buildUsbSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'USB printers',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _isBusy ? null : _scanUsb,
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Scan'),
                ),
              ],
            ),
            const Divider(height: 16),
            if (_usbDevices.isEmpty)
              const _EmptyPlaceholder(
                label: 'Plug in a USB thermal printer, then tap Scan.',
              )
            else
              ..._usbDevices.map(
                (d) => _DeviceTile(
                  icon: Icons.usb,
                  title: d.deviceName,
                  subtitle:
                      'VID: 0x${d.vendorId.toRadixString(16)}  PID: 0x${d.productId.toRadixString(16)}',
                  trailing: FilledButton(
                    onPressed: _isBusy ? null : () => _connectUsb(d),
                    child: const Text('Connect'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothSection() {
    final unpaired = _discoveredDevices
        .where((d) => !_bondedDevices.any((b) => b.address == d.address))
        .toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_bluetoothSupported)
              const _EmptyPlaceholder(
                label: 'Bluetooth is off or unavailable. Turn it on to scan.',
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isBusy ? null : _scanBluetooth,
                    icon: _isDiscovering
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search, size: 18),
                    label: Text(_isDiscovering ? 'Scanning…' : 'Scan in app'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isBusy
                        ? null
                        : () => _external.openBluetoothSettings(),
                    icon: const Icon(Icons.settings_bluetooth, size: 18),
                    label: const Text('Bluetooth settings'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Paired devices',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: _isBusy ? null : _refreshBondedDevices,
                  tooltip: 'Refresh paired devices',
                ),
              ],
            ),
            const Divider(height: 8),
            if (_bondedDevices.isEmpty)
              const _EmptyPlaceholder(
                label: 'No paired printers yet. Scan or pair in Bluetooth '
                    'settings, then refresh.',
              )
            else
              ..._bondedDevices.map(
                (d) => _DeviceTile(
                  icon: Icons.bluetooth_connected,
                  title: d.name,
                  subtitle: d.address,
                  isActive:
                      _connectionInfo.connected &&
                      _connectionInfo.address == d.address,
                  trailing: FilledButton(
                    onPressed: _isBusy ? null : () => _connectBluetooth(d),
                    child: const Text('Connect'),
                  ),
                ),
              ),
            if (unpaired.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Discovered (not paired)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Divider(height: 8),
              ...unpaired.map(
                (d) => _DeviceTile(
                  icon: Icons.bluetooth,
                  title: d.name,
                  subtitle: d.address,
                  trailing: _pairingAddress == d.address
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : OutlinedButton(
                          onPressed: _isBusy ? null : () => _pairAndConnect(d),
                          child: const Text('Pair'),
                        ),
                ),
              ),
            ],
            if (_lastPairFailed) ...[
              const SizedBox(height: 8),
              Text(
                "Can't pair here? Some POS units restrict pairing to system "
                'settings. Use "Bluetooth settings" above, then Refresh.',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrinterTypeSelector extends StatelessWidget {
  const _PrinterTypeSelector({required this.currentType, required this.onChanged});

  final PrinterType currentType;
  final ValueChanged<PrinterType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Printer type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(height: 16),
            SegmentedButton<PrinterType>(
              segments: const [
                ButtonSegment(
                  value: PrinterType.inbuilt,
                  label: Text('Built-in'),
                  icon: Icon(Icons.print),
                ),
                ButtonSegment(
                  value: PrinterType.external,
                  label: Text('External'),
                  icon: Icon(Icons.print_outlined),
                ),
              ],
              selected: {currentType},
              onSelectionChanged: (v) => onChanged(v.first),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.connected,
    required this.connectedLabel,
    required this.disconnectedLabel,
    this.details = const [],
    this.trailing,
  });

  final String title;
  final bool connected;
  final String connectedLabel;
  final String disconnectedLabel;
  final List<Widget> details;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final statusColor = connected ? Colors.green : Theme.of(context).colorScheme.error;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.15),
                  child: Icon(
                    connected ? Icons.check_circle : Icons.warning_amber,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        connected ? connectedLabel : disconnectedLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
            if (details.isNotEmpty) ...[
              const Divider(height: 20),
              ...details,
            ],
          ],
        ),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.isActive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.08)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: isActive ? Border.all(color: Colors.green, width: 1) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? Colors.green : colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: colorScheme.outline),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$label :",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }
}

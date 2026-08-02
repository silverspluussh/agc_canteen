import 'dart:async';
import 'package:agc_canteen/controllers/providers.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/database/activity_log_service.dart';
import '../../services/database/app_database.dart' show AppDatabase, PosDevice;
import '../../services/pos/pos_device_service.dart';
import '../../services/pos/pos_fingerprint_service.dart';
import '../../services/pos/pos_scanner_service.dart';
import '../../services/sync_services/sync_from_remote_to_local.dart';
import '../settings/pos_selection_dialog.dart';

class PosSettingsPage extends ConsumerStatefulWidget {
  const PosSettingsPage({super.key});

  @override
  ConsumerState<PosSettingsPage> createState() => _PosSettingsPageState();
}

class _PosSettingsPageState extends ConsumerState<PosSettingsPage> {
  late final PosDeviceService _deviceService;
  late final PosFingerprintService _fingerprintService;
  late final PosScannerService _scannerService;
  late final AppDatabase _db;

  // ignore: unused_field
  bool _fingerprintAvailable = false;
  // ignore: unused_field
  bool _isScanning = false;
  // ignore: unused_field
  List<PosDevice> _dbDevices = [];
  // ignore: unused_field
  bool _isLoading = true;
  bool _isToggling = false;

  @override
  void initState() {
    super.initState();
    _deviceService = getIt<PosDeviceService>();
    _fingerprintService = getIt<PosFingerprintService>();
    _scannerService = getIt<PosScannerService>();
    _db = getIt<AppDatabase>();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);

    await Future.wait([_loadPeripherals(), _loadDbDevices()]);

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadPeripherals() async {
    try {
      final fpAvailable = await _fingerprintService.isAvailable();
      final scanning = await _scannerService.isScanning();
      if (mounted) {
        setState(() {
          _fingerprintAvailable = fpAvailable;
          _isScanning = scanning;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadDbDevices() async {
    try {
      final devices = await _db.getAllPosDevices();
      if (mounted) setState(() => _dbDevices = devices);
    } catch (_) {}
  }

  Future<void> _initFingerprint() async {
    try {
      await _fingerprintService.init();
      if (mounted) {
        await _loadPeripherals();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint initialized'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint init failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleDevice(bool activate) async {
    setState(() => _isToggling = true);
    if (activate) {
      await _deviceService.init();
    }
    getIt<ActivityLogService>().log(
      type: 'pos_device_toggle',
      message:
          'POS device ${activate ? "activated" : "deactivated"} from settings',
      actorType: 'admin',
      metadata: {'activate': activate},
    );
    if (mounted) {
      setState(() => _isToggling = false);
      await _loadAll();
    }
  }

  Future<void> _changePosDevice() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change POS Device'),
        content: const Text(
          'This will clear all local data (orders, staff, meals, fingerprints) '
          'and re-sync from the server with the new device assignment.\n\n'
          'This action cannot be undone. Continue?',
        ),
        actions: [
          SizedBox(
            width: 120,
            child: OutlineButton(
              color: Colors.red,
              onPressed: () => Navigator.pop(ctx, false),
              label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ),
          PrimaryButton(
            height: 45,
            width: 140,
            onPressed: () => Navigator.pop(ctx, true),
            label: const Text(
              'Clear & Change',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Clear local data BEFORE selecting the new profile. Selecting first then
    // clearing wiped the just-saved POS row (and all local data), leaving the
    // device unregistered and unable to place orders until reconfigured.
    try {
      await _db.clearAll();
    } catch (_) {}

    if (!mounted) return;

    final selected = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PosSelectionDialog(),
    );
    if (selected != true || !mounted) return;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('POS device changed. Re-syncing all data...'),
          backgroundColor: Colors.green,
        ),
      );
      _loadAll();
      ref.invalidate(departmentsProvider);
      unawaited(getIt<RemoteToLocalSyncService>().syncAll());
    }
  }

  String _syncLabel(int syncStatus) {
    switch (syncStatus) {
      case 2:
        return AppLocalizations.of(context).posSynced;
      case 1:
        return AppLocalizations.of(context).syncing;
      case 3:
        return AppLocalizations.of(context).error;
      default:
        return AppLocalizations.of(context).pending;
    }
  }

  Widget _buildChangePosCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.swap_horiz,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Change Assigned Device',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            const Text(
              'Select a different POS device profile. This will clear all '
              'local data and re-sync from the server.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _changePosDevice,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                ),
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Change POS Device'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(l10n.posSettings),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadAll,
          ),
        ],
      ),
      body: ref
          .watch(deviceInfoProvider)
          .when(
            data: (deviceInfo) {
              return RefreshIndicator(
                onRefresh: _loadAll,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    SizedBox(height: 15),
                    _DeviceStatusCard(
                      isInitialized: deviceInfo.isPhysicalDevice,
                      isToggling: _isToggling,
                      onToggle: _toggleDevice,
                    ),

                    POSDeviceAccountCard(device: _dbDevices.first),

                    if (_dbDevices.isNotEmpty) _buildChangePosCard(context),

                    const SizedBox(height: 20),
                    _PrinterSettingsLinkCard(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed('/printer-settings'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _initFingerprint,
                        icon: const Icon(Icons.fingerprint),
                        label: const Text('Initialize Fingerprint Scanner'),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, stk) {
              return Text('Error: $error');
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          ),
    );
  }
}

class _DeviceStatusCard extends StatelessWidget {
  const _DeviceStatusCard({
    required this.isInitialized,
    required this.isToggling,
    required this.onToggle,
  });

  final bool isInitialized;
  final bool isToggling;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final statusColor = isInitialized ? Colors.green : colorScheme.error;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: statusColor.withValues(alpha: 0.15),
              child: Icon(
                isInitialized ? Icons.check_circle : Icons.warning_amber,
                color: statusColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.status,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isInitialized ? l10n.success : l10n.pending,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isToggling)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Switch(
                value: isInitialized,
                activeColor: colorScheme.primary,
                inactiveTrackColor: Colors.grey,
                onChanged: onToggle,
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _DeviceInfoCard extends StatelessWidget {
  const _DeviceInfoCard({required this.title, required this.info});

  final String title;
  final Map<String, dynamic> info;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: title),
            const Divider(height: 16),
            if (info.isEmpty)
              _EmptyPlaceholder(label: l10n.noData)
            else ...[
              _InfoRow(label: 'Model', value: info['model']?.toString() ?? '—'),
              if (info['isInit'] != null)
                _InfoRow(
                  label: l10n.status,
                  value: (info['isInit'] == true) ? l10n.success : l10n.pending,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrinterSettingsLinkCard extends StatelessWidget {
  const _PrinterSettingsLinkCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(Icons.print_outlined, color: colorScheme.primary),
        ),
        title: Text(
          l10n.printerSettings,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text('Manage built-in and external printers'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _PeripheralsCard extends StatelessWidget {
  const _PeripheralsCard({
    required this.fingerprintAvailable,
    required this.isScanning,
  });

  final bool fingerprintAvailable;
  final bool isScanning;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: l10n.posPeripherals),
            const Divider(height: 16),
            _PeripheralRow(
              icon: Icons.fingerprint,
              label: l10n.posFingerprintScanner,
              available: fingerprintAvailable,
            ),
          ],
        ),
      ),
    );
  }
}

class _PeripheralRow extends StatelessWidget {
  const _PeripheralRow({
    required this.icon,
    required this.label,
    required this.available,
  });

  final IconData icon;
  final String label;
  final bool? available;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final Color statusColor;
    final String statusLabel;
    final IconData statusIcon;

    if (available == true) {
      statusColor = Colors.green;
      statusLabel = l10n.posAvailable;
      statusIcon = Icons.check_circle;
    } else if (available == false) {
      statusColor = colorScheme.error;
      statusLabel = l10n.posUnavailable;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.grey;
      statusLabel = '—';
      statusIcon = Icons.help_outline;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class POSDeviceAccountCard extends StatelessWidget {
  const POSDeviceAccountCard({super.key, required this.device});

  final PosDevice device;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(label: "POS Name", value: device.name),
            _InfoRow(label: "Serial Number", value: device.serialNumber),
            _InfoRow(label: "Model", value: device.model ?? "-"),
            _InfoRow(label: "Mac Address", value: device.macAddress ?? "-"),
            _InfoRow(
              label: "Assigned Kitchen",
              value: device.kitchenName ?? "Not assigned",
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({
    required this.device,
    required this.syncLabel,
    required this.syncColor,
  });

  final PosDevice device;
  final String syncLabel;
  final Color syncColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  device.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: syncColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  syncLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: syncColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _InfoRow(label: 'Serial', value: device.serialNumber),
          if (device.model != null && device.model!.isNotEmpty)
            _InfoRow(label: 'Model', value: device.model!),
          if (device.macAddress != null && device.macAddress!.isNotEmpty)
            _InfoRow(label: 'MAC', value: device.macAddress!),
          _InfoRow(
            label: AppLocalizations.of(context).status,
            value: device.status,
          ),
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
              style: Theme.of(context).textTheme.labelLarge!.copyWith(),
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
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }
}


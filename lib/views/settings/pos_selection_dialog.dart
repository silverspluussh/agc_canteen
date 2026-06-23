import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../services/remote_data_sync_service.dart';

class PosSelectionDialog extends StatefulWidget {
  const PosSelectionDialog({super.key});

  @override
  State<PosSelectionDialog> createState() => _PosSelectionDialogState();
}

class _PosSelectionDialogState extends State<PosSelectionDialog> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _profiles = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    try {
      final service = getIt<RemoteDataSyncService>();
      final profiles = await service.fetchAllPosProfiles();
      if (mounted) {
        setState(() {
          _profiles = profiles;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _selectProfile(Map<String, dynamic> profile) async {
    setState(() => _saving = true);
    try {
      final service = getIt<RemoteDataSyncService>();
      await service.saveSelectedPosProfile(profile);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Failed to save: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.primary,
            title: const Text('Select POS Device'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: _buildBody(theme),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Fetching POS device profiles...'),
          ],
        ),
      );
    }

    if (_error != null && _profiles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56, color: Colors.red),
              const SizedBox(height: 16),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _fetchProfiles();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_profiles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.devices_other, size: 56, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No POS device profiles found on the server.\n'
                'Please register a device first.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _fetchProfiles();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: theme.colorScheme.primaryContainer.withOpacity(0.3),
          child: Text(
            'Multiple devices found. Select the one assigned to this terminal.',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _profiles.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final profile = _profiles[index];
              final name = profile['name'] as String? ?? 'Unknown';
              final serial = profile['serialNumber'] as String? ?? '—';
              final model = profile['model'] as String? ?? '—';
              final kitchen = profile['kitchen'] as Map<String, dynamic>?;
              final kitchenName = kitchen?['name'] as String? ?? '—';

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.devices,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                title: Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Kitchen: $kitchenName'),
                    Text('Model: $model  ·  S/N: $serial'),
                  ],
                ),
                isThreeLine: true,
                trailing: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: _saving ? null : () => _selectProfile(profile),
              );
            },
          ),
        ),
        if (_error != null && _profiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

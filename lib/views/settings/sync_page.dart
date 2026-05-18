import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/di/injection_container.dart';
import '../../services/activity_log_service.dart';
import '../../services/sync_service.dart';

class SyncPage extends ConsumerStatefulWidget {
  const SyncPage({super.key});

  @override
  ConsumerState<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends ConsumerState<SyncPage> {
  late final SyncService _syncService;
  SyncStatus _status = SyncStatus.idle;
  SyncResult? _lastResult;
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _syncService = getIt<SyncService>();
    _loadSyncInfo();
  }

  Future<void> _loadSyncInfo() async {
    final lastSync = await _syncService.lastSync;
    if (mounted) {
      setState(() {
        _lastSyncTime = lastSync;
      });
    }
  }

  Future<void> _startSync() async {
    setState(() => _status = SyncStatus.syncing);
    getIt<ActivityLogService>().log(
      type: 'sync_started',
      message: 'Data synchronization started',
    );
    try {
      final result = await _syncService.syncAll();
      if (mounted) {
        setState(() {
          _status = result.isSuccess ? SyncStatus.success : SyncStatus.error;
          _lastResult = result;
        });
        await _loadSyncInfo();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = SyncStatus.error;
          _lastResult = SyncResult(
            pushed: {},
            pulled: {},
            errors: [e.toString()],
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lastSyncStr = _lastSyncTime != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(_lastSyncTime!)
        : AppLocalizations.of(context).never;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).dataSynchronization),
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: Column(
        children: [
          // ── Sync Header ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: cs.outlineVariant)),
            ),
            child: Column(
              children: [
                _SyncStatusIcon(status: _status),
                const SizedBox(height: 16),
                Text(
                  _status == SyncStatus.syncing
                      ? AppLocalizations.of(context).syncing
                      : AppLocalizations.of(context).systemReady,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppLocalizations.of(context).lastSuccessfulSync}: $lastSyncStr',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _status == SyncStatus.syncing
                        ? null
                        : _startSync,
                    icon: _status == SyncStatus.syncing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.sync, color: Colors.white),
                    label: Text(
                      _status == SyncStatus.syncing
                          ? AppLocalizations.of(context).syncing
                          : AppLocalizations.of(context).syncNow,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Sync Details ──────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_lastResult != null) ...[
                  _SectionHeader(
                    title: AppLocalizations.of(context).syncResults,
                    icon: Icons.assessment_outlined,
                  ),
                  const SizedBox(height: 12),
                  if (_lastResult!.errors.isNotEmpty)
                    _ErrorBox(errors: _lastResult!.errors),
                  _ResultGrid(result: _lastResult!),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Components ───────────────────────────────────────────────────────────────

class _SyncStatusIcon extends StatelessWidget {
  final SyncStatus status;
  const _SyncStatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: status == SyncStatus.error
            ? cs.errorContainer
            : status == SyncStatus.success
            ? Colors.green.withOpacity(0.1)
            : cs.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: status == SyncStatus.syncing
          ? SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: cs.primary,
                strokeWidth: 3,
              ),
            )
          : Icon(
              status == SyncStatus.error
                  ? Icons.error_outline
                  : status == SyncStatus.success
                  ? Icons.check_circle_outline
                  : Icons.sync_rounded,
              size: 48,
              color: Colors.white,
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final List<String> errors;
  const _ErrorBox({required this.errors});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).syncErrors,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...errors.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $e',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultGrid extends StatelessWidget {
  final SyncResult result;
  const _ResultGrid({required this.result});

  @override
  Widget build(BuildContext context) {
    final tables = <String>{
      ...result.pushed.keys,
      ...result.pulled.keys,
    }.toList();
    if (tables.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            AppLocalizations.of(context).noDataChanges,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2,
      ),
      itemCount: tables.length,
      itemBuilder: (ctx, i) {
        final table = tables[i];
        final pushed = result.pushed[table] ?? 0;
        final pulled = result.pulled[table] ?? 0;
        return _TableResultCard(table: table, pushed: pushed, pulled: pulled);
      },
    );
  }
}

class _TableResultCard extends StatelessWidget {
  final String table;
  final int pushed, pulled;
  const _TableResultCard({
    required this.table,
    required this.pushed,
    required this.pulled,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            table.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.arrow_upward, size: 12, color: cs.primary),
              Text(
                ' $pushed ${AppLocalizations.of(context).pushedRecords}',
                style: const TextStyle(fontSize: 11),
              ),
              const Spacer(),
              Icon(Icons.arrow_downward, size: 12, color: Colors.green),
              Text(
                ' $pulled ${AppLocalizations.of(context).pulledRecords}',
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

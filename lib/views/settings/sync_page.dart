import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../core/di/injection_container.dart';
import '../../services/database/app_database.dart';
import '../../services/sync_service.dart';

class SyncPage extends ConsumerStatefulWidget {
  const SyncPage({super.key});

  @override
  ConsumerState<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends ConsumerState<SyncPage> {
  late final SyncService _syncService;
  late final AppDatabase _db;

  int _unsyncedOrders = 0;
  int _unsyncedGroupOrders = 0;
  DateTime? _lastSyncTime;
  bool _syncingOrders = false;
  bool _syncingGroupOrders = false;

  @override
  void initState() {
    super.initState();
    _syncService = getIt<SyncService>();
    _db = getIt<AppDatabase>();
    _loadCounts();
    _loadLastSync();
  }

  Future<void> _loadCounts() async {
    final orders = await _db.getUnsyncedOrders();
    final groupOrders = await _db.getUnsyncedGroupOrders();
    if (mounted) {
      setState(() {
        _unsyncedOrders = orders.length;
        _unsyncedGroupOrders = groupOrders.length;
      });
    }
  }

  Future<void> _loadLastSync() async {
    final lastSync = await _syncService.lastSync;
    if (mounted) setState(() => _lastSyncTime = lastSync);
  }

  Future<void> _syncOrders() async {
    setState(() => _syncingOrders = true);
    final result = await _syncService.syncSingleOrders();
    if (mounted) {
      _showResultSnackBar(result, 'Single orders');
      setState(() => _syncingOrders = false);
      await _loadCounts();
      await _loadLastSync();
    }
  }

  Future<void> _syncGroupOrders() async {
    setState(() => _syncingGroupOrders = true);
    final result = await _syncService.syncGroupOrders();
    if (mounted) {
      _showResultSnackBar(result, 'Group orders');
      setState(() => _syncingGroupOrders = false);
      await _loadCounts();
      await _loadLastSync();
    }
  }

  void _showResultSnackBar(SyncResult result, String label) {
    final total = result.pushed.values.fold<int>(0, (s, v) => s + v);
    final ok = result.errors.isEmpty;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(ok ? '$label: $total pushed' : '${result.errors.first}'),
        backgroundColor: ok ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _viewUnsynced(bool single) async {
    final db = _db;
    final staff = await db.getAllStaff();
    String staffName(String id) {
      final s = staff.where((e) => e.id == id).firstOrNull;
      return s != null ? '${s.firstName} ${s.lastName}' : id;
    }

    if (!mounted) return;

    final title = single ? 'Unsynced Single Orders' : 'Unsynced Group Orders';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (_, scrollCtrl) {
            return FutureBuilder(
              future: single ? _buildOrderList(staffName) : _buildGroupOrderList(),
              builder: (context, snapshot) {
                final children = snapshot.data ?? <Widget>[];
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : children.isEmpty
                              ? const Center(child: Text('No unsynced orders'))
                              : ListView.separated(
                                  controller: scrollCtrl,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: children.length,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (_, i) => children[i],
                                ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<Widget>> _buildOrderList(String Function(String) staffName) async {
    final orders = await _db.getUnsyncedOrders();
    return orders.map((o) {
      return ListTile(
        dense: true,
        title: Text(o.orderCode, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${o.mealType} · ${o.groupCount} items · GH₵ ${o.total.toStringAsFixed(2)} · ${staffName(o.orderedById)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(o.createdAt.substring(0, 10), style: const TextStyle(fontSize: 11, color: Colors.grey)),
      );
    }).toList();
  }

  Future<List<Widget>> _buildGroupOrderList() async {
    final orders = await _db.getUnsyncedGroupOrders();
    return orders.map((o) {
      return ListTile(
        dense: true,
        title: Text(o.orderCode, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${o.mealType} · ${o.groupCount} items · GH₵ ${o.total.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(o.createdAt.substring(0, 10), style: const TextStyle(fontSize: 11, color: Colors.grey)),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final lastSyncStr = _lastSyncTime != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(_lastSyncTime!)
        : l10n.never;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        title: Text(l10n.dataSynchronization),
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SyncStatCard(
            icon: Icons.receipt_long,
            label: 'Single Orders',
            count: _unsyncedOrders,
            syncing: _syncingOrders,
            onSync: _unsyncedOrders > 0 ? _syncOrders : null,
            onView: _unsyncedOrders > 0 ? () => _viewUnsynced(true) : null,
          ),
          const SizedBox(height: 12),
          _SyncStatCard(
            icon: Icons.group_work,
            label: 'Group Orders',
            count: _unsyncedGroupOrders,
            syncing: _syncingGroupOrders,
            onSync: _unsyncedGroupOrders > 0 ? _syncGroupOrders : null,
            onView: _unsyncedGroupOrders > 0 ? () => _viewUnsynced(false) : null,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history, size: 18, color: cs.primary),
                      const SizedBox(width: 8),
                      const Text('Last Sync', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(lastSyncStr, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(onPressed:() async {
                setState(() {});
                final result = await _syncService.syncAll();
                if (mounted) {
                  _showResultSnackBar(result, 'All data');
                  await _loadCounts();
                  await _loadLastSync();
                }
                
              }, label: Text(l10n.syncNow, style: const TextStyle(color: Colors.white)),
              prefixChild: const Icon(Icons.sync, color: Colors.white),
               )
       
        ],
      ),
    );
  }
}

class _SyncStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final bool syncing;
  final VoidCallback? onSync;
  final VoidCallback? onView;

  const _SyncStatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.syncing,
    this.onSync,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: count > 0
                        ? Colors.orange.withOpacity(0.12)
                        : Colors.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: count > 0 ? Colors.orange : Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              count > 0 ? '$count unsynced' : 'All synced',
              style: TextStyle(
                fontSize: 12,
                color: count > 0 ? Colors.orange : Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onView != null)
                  IconButton(
                    onPressed: onView,
                    icon: const Icon(Icons.visibility_outlined, size: 20),
                    tooltip: 'View unsynced',
                  ),
                const SizedBox(width: 4),
                
                PrimaryButton(onPressed: syncing ? null : onSync,
                width:80 ,
                height: 40,
                label: syncing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sync',
                          style:
                              TextStyle(color: Colors.white, fontSize: 13)),
              
                )

                
              ],
            ),
          ],
        ),
      ),
    );
    
  }
}

import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
  bool _syncingAll = false;

  int get _totalUnsynced => _unsyncedOrders + _unsyncedGroupOrders;

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
    //final groupOrders = await _db.getUnsyncedGroupOrders();
    if (mounted) {
      setState(() {
        _unsyncedOrders = orders.length;
        _unsyncedGroupOrders = 0;
      });
    }
  }

  Future<void> _loadLastSync() async {
    final lastSync = await _syncService.lastSync;
    if (mounted) setState(() => _lastSyncTime = lastSync);
  }

  Future<void> _syncOrders() async {
    setState(() => _syncingOrders = true);
    try {
      final result = await _syncService.syncSingleOrders();
      if (mounted) _showResultSnackBar(result, 'Single orders');
    } finally {
      if (mounted) {
       
        setState(() => _syncingOrders = false);
        await _loadCounts();
        await _loadLastSync();
      }
    }
  }

  Future<void> _syncGroupOrders() async {
    setState(() => _syncingGroupOrders = true);
    try {
      final result = await _syncService.syncGroupOrders();
      if (mounted) _showResultSnackBar(result, 'Group orders');
    } finally {
      if (mounted) {
        setState(() => _syncingGroupOrders = false);
        await _loadCounts();
        await _loadLastSync();
      }
    }
  }

  Future<void> _syncAll() async {
    setState(() => _syncingAll = true);
    try {
      final result = await _syncService.syncAll();
      if (mounted) _showResultSnackBar(result, 'All data');
    } finally {
      if (mounted) {
        setState(() => _syncingAll = false);
        await _loadCounts();
        await _loadLastSync();
      }
    }
  }

  void _showResultSnackBar(SyncResult result, String label) {
    final total = result.pushed.values.fold<int>(0, (s, v) => s + v);
    final ok = result.errors.isEmpty;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(ok ? '$label: $total pushed' : result.errors.first),
        backgroundColor: ok ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _viewUnsynced(bool single) async {
    final staff = await _db.getAllStaff();
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
              future:
                  single ? _buildOrderList(staffName) : _buildGroupOrderList(),
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
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${children.length} orders',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : children.isEmpty
                              ? const Center(
                                  child: Text('No unsynced orders'),
                                )
                              : ListView.separated(
                                  controller: scrollCtrl,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: children.length,
                                  separatorBuilder: (_, _) =>
                                      const Divider(height: 1),
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

  Future<List<Widget>> _buildOrderList(
    String Function(String) staffName,
  ) async {
    final orders = await _db.getUnsyncedOrders();
    return orders.map((o) {
      return ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.orange.withOpacity(0.1),
          child: const Icon(Icons.receipt_long, size: 18, color: Colors.orange),
        ),
        title: Text(
          o.orderCode,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${o.mealType} · ${o.groupCount} item${o.groupCount != 1 ? 's' : ''} · GH₵ ${o.total.toStringAsFixed(2)} · ${staffName(o.orderedById)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          o.createdAt.substring(0, 10),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      );
    }).toList();
  }

  Future<List<Widget>> _buildGroupOrderList() async {
    final orders = await _db.getUnsyncedGroupOrders();
    return orders.map((o) {
      return ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: const Icon(Icons.group_work, size: 18, color: Colors.blue),
        ),
        title: Text(
          o.orderCode,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${o.mealType} · ${o.groupCount} items · GH₵ ${o.total.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          o.createdAt.substring(0, 10),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadCounts();
          await _loadLastSync();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // ── Summary header ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withOpacity(0.85),
                    cs.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dataSynchronization,
                          style: TextStyle(
                            color: cs.onPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _totalUnsynced > 0
                              ? '$_totalUnsynced pending item${_totalUnsynced != 1 ? 's' : ''}'
                              : 'Everything is up to date',
                          style: TextStyle(
                            color: cs.onPrimary.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cs.onPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _totalUnsynced > 0
                          ? Icons.sync_problem_rounded
                          : Icons.check_circle_rounded,
                      color: cs.onPrimary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Order sync cards ──
            _sectionHeader('Orders to Sync'),
            const SizedBox(height: 10),
            _SyncStatCard(
              icon: Icons.receipt_long_outlined,
              label: 'Staff Orders',
              count: _unsyncedOrders,
              syncing: _syncingOrders,
              onSync: _unsyncedOrders > 0 ? _syncOrders : null,
              onView: _unsyncedOrders > 0 ? () => _viewUnsynced(true) : null,
            ),
            // const SizedBox(height: 12),
            // _SyncStatCard(
            //   icon: Icons.group_work_outlined,
            //   label: 'Group Orders',
            //   count: _unsyncedGroupOrders,
            //   syncing: _syncingGroupOrders,
            //   onSync: _unsyncedGroupOrders > 0 ? _syncGroupOrders : null,
            //   onView:
            //       _unsyncedGroupOrders > 0 ? () => _viewUnsynced(false) : null,
            // ),

            const SizedBox(height: 24),

            // ── Last sync info ──
            _sectionHeader('Last Synchronization'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cs.outlineVariant.withOpacity(0.4),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      size: 20,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Sync',
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lastSyncStr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _loadLastSync();
                    },
                    icon: Icon(Icons.refresh_rounded, color: cs.primary),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Sync All button ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: PrimaryButton(
                onPressed: _syncingAll ? null : _syncAll,
                label: _syncingAll
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Syncing...',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sync_rounded,
                              color: Colors.white, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            l10n.syncNow,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          letterSpacing: 0.5,
        ),
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
    final hasPending = count > 0;
    final accentColor = hasPending ? Colors.orange : Colors.green;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withOpacity(hasPending ? 0.4 : 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasPending ? '$count pending' : 'Up to date',
                      style: TextStyle(
                        fontSize: 13,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasPending)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ),
              if (!hasPending)
                Icon(Icons.check_circle, size: 22, color: accentColor),
            ],
          ),
          if (hasPending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: OutlinedButton.icon(
                      onPressed: onView,
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('View', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: accentColor,
                        side: BorderSide(color: accentColor.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: syncing ? null : onSync,
                      icon: syncing
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.sync_rounded,
                              size: 16, color: Colors.white),
                      label: syncing
                          ? const SizedBox.shrink()
                          : const Text('Sync',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

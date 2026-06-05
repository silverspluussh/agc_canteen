import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../controllers/providers.dart';
import '../../services/database/app_database.dart';

final _currency = NumberFormat('#,##0.00', 'en_US');
String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

class _ReportOrderItem {
  final String mealName;
  final int qty;
  final double price;
  const _ReportOrderItem(this.mealName, this.qty, this.price);
}

class _ReportOrder {
  final String id, orderCode, status, orderType, mealType;
  final double total;
  final int groupCount;
  final int syncStatus;
  final String? description, staffName;
  final DateTime createdAt;
  final List<_ReportOrderItem> items;

  const _ReportOrder({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.orderType,
    required this.mealType,
    required this.total,
    required this.groupCount,
    required this.syncStatus,
    this.description,
    this.staffName,
    required this.createdAt,
    required this.items,
  });

  bool get isSynced => syncStatus == 2;
}

final _reportOrdersProvider = FutureProvider<List<_ReportOrder>>((ref) async {
  final db = GetIt.instance<AppDatabase>();

  final orders = await db.getAllOrders();
  final groupOrders = await db.getAllGroupOrders();
  final staffList = await db.getAllStaff();
  final meals = await db.getAllMeals();

  String staffName(String id) {
    final s = staffList.where((e) => e.id == id).firstOrNull;
    return s != null ? '${s.firstName} ${s.lastName}' : id;
  }

  String mealName(String id) {
    return meals.where((e) => e.id == id).firstOrNull?.name ?? id;
  }

  final results = <_ReportOrder>[];

  for (final o in orders) {
    final items = await db.getOrderItems(o.id);
    results.add(_ReportOrder(
      id: o.id,
      orderCode: o.orderCode,
      status: o.status,
      orderType: o.orderType,
      mealType: o.mealType,
      total: o.total,
      groupCount: o.groupCount,
      syncStatus: o.syncStatus,
      description: o.description,
      staffName: staffName(o.orderedById),
      createdAt: DateTime.tryParse(o.createdAt) ?? DateTime.now(),
      items: items
          .map((i) => _ReportOrderItem(mealName(i.mealId), i.qty, i.price))
          .toList(),
    ));
  }

  for (final o in groupOrders) {
    final items = await db.getGroupOrderItems(o.id);
    results.add(_ReportOrder(
      id: o.id,
      orderCode: o.orderCode,
      status: o.status,
      orderType: o.orderType,
      mealType: o.mealType,
      total: o.total,
      groupCount: o.groupCount,
      syncStatus: o.syncStatus,
      description: o.description,
      staffName: null,
      createdAt: DateTime.tryParse(o.createdAt) ?? DateTime.now(),
      items: items
          .map((i) => _ReportOrderItem(mealName(i.mealId), i.qty, i.price))
          .toList(),
    ));
  }

  results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return results;
});

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        title: Text(AppLocalizations.of(context).orders),
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
      ),
      body: const _OrdersTab(),
    );
  }
}

class _OrdersTab extends ConsumerStatefulWidget {
  const _OrdersTab();

  @override
  ConsumerState<_OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends ConsumerState<_OrdersTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _statusFilter;
  String? _mealTypeFilter;
  String? _syncFilter;
  DateTimeRange? _dateRangeFilter;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(
      () => setState(() => _query = _searchCtrl.text.trim().toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_ReportOrder> _filter(List<_ReportOrder> orders) {
    return orders.where((o) {
      final q = _query;
      final matchQ = q.isEmpty ||
          o.orderCode.toLowerCase().contains(q) ||
          o.mealType.toLowerCase().contains(q) ||
          (o.staffName?.toLowerCase().contains(q) ?? false) ||
          o.status.toLowerCase().contains(q);
      final matchS = _statusFilter == null || o.status == _statusFilter;
      final matchM = _mealTypeFilter == null || o.mealType == _mealTypeFilter;
      final matchDate = _dateRangeFilter == null ||
          ((o.createdAt.isAtSameMomentAs(_dateRangeFilter!.start) ||
                  o.createdAt.isAfter(_dateRangeFilter!.start)) &&
              o.createdAt
                  .isBefore(_dateRangeFilter!.end.add(const Duration(days: 1))));
      final matchSync = _syncFilter == null ||
          (_syncFilter == 'synced' ? o.isSynced : !o.isSynced);
      return matchQ && matchS && matchM && matchSync && matchDate;
    }).toList();
  }

  Future<void> _showFilterModal() async {
    String? tempStatus = _statusFilter;
    String? tempSync = _syncFilter;
    DateTimeRange? tempDateRange = _dateRangeFilter;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).filterOrders,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context).status,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      null,
                      'completed',
                      'pending',
                      'cancelled'
                    ].map((status) {
                      final isSelected = tempStatus == status;
                      return ChoiceChip(
                        label: Text(
                          status == null
                              ? AppLocalizations.of(context).all
                              : status == 'completed'
                                  ? AppLocalizations.of(context).completed
                                  : status == 'pending'
                                      ? AppLocalizations.of(context).pending
                                      : AppLocalizations.of(context).cancelled,
                       style:  TextStyle(
                                    color: isSelected ? Colors.white: null,
                                  ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(
                            () => tempStatus = selected ? status : null,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sync Status',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [null, 'synced', 'unsynced'].map((sync) {
                      final isSelected = tempSync == sync;
                      return ChoiceChip(
                        label: Text(
                          sync == null
                              ? AppLocalizations.of(context).all
                              : sync == 'synced'
                                  ? 'Synced'
                                  : 'Unsynced',
                                  style:  TextStyle(
                                    color: isSelected ? Colors.white: null,
                                  ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(
                            () => tempSync = selected ? sync : null,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context).selectDateRange,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDateRange: tempDateRange,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: Theme.of(context)
                                  .colorScheme
                                  .copyWith(
                                    primary:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setModalState(() => tempDateRange = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tempDateRange == null
                                ? 'Select Date Range'
                                : '${DateFormat('dd MMM y').format(tempDateRange!.start)} - ${DateFormat('dd MMM y').format(tempDateRange!.end)}',
                          ),
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (tempDateRange != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            setModalState(() => tempDateRange = null),
                        child: const Text(
                          'Clear Date',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 20),
                  ],
                  const SizedBox(height: 10),
                   PrimaryButton(
                    onPressed: () {
                      setState(() {
                          _statusFilter = tempStatus;
                          _syncFilter = tempSync;
                          _dateRangeFilter = tempDateRange;
                        });
                        Navigator.pop(context);
                    },
                    label: Text(
                      "Apply Filters",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                 
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ordersAsync = ref.watch(_reportOrdersProvider);

    return ordersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Failed to load orders: $e')),
      data: (allOrders) {
        final items = _filter(allOrders);
        final total = items.fold<double>(0, (s, o) => s + o.total);
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _SearchBar(
                    controller: _searchCtrl,
                    hint: AppLocalizations.of(context).searchOrderHint,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0, top: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: _showFilterModal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (items.isNotEmpty)
              _SummaryStrip(
                '${items.length} ${AppLocalizations.of(context).orders}',
                '${AppLocalizations.of(context).total}: GH₵ ${_currency.format(total)}',
              ),
            Expanded(
              child: items.isEmpty
                  ? _EmptyView(
                      Icons.receipt_long_outlined,
                      AppLocalizations.of(context).noOrders,
                    )
                  : RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(_reportOrdersProvider);
                      
                    },
                    child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 16, endIndent: 16),
                        itemBuilder: (_, i) => _OrderTile(order: items[i]),
                      ),
                  ),
            ),
          ],
        );
      },
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});
  final _ReportOrder order;

  Color _statusColor(String s) => switch (s) {
        'completed' => Colors.green,
        'pending' => Colors.orange,
        'cancelled' => Colors.red,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final o = order;
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final date = DateFormat('dd-MM-yy, hh:mm a').format(o.createdAt);
    final subtitle = o.staffName != null
        ? '$date  ·  ${_cap(o.mealType)}  ·   ${o.staffName}'
        : '$date  ·  ${_cap(o.mealType)}  ·  Group order';

    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: cs.primaryContainer,
        child: Icon(Icons.receipt_long, color: cs.primary, size: 15),
      ),
      title: Text(
        o.orderCode,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 10),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _StatusBadge(o.status, _statusColor(o.status)),
          const SizedBox(height: 5),
          const Icon(Icons.expand_more, size: 10),
        ],
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      children: [
        if (o.description != null && o.description!.isNotEmpty)
              _DetailRow("${l10n.description} : ", o.description!),
        
        const Divider(height: 8),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                l10n.item,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                l10n.quantity,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                l10n.total,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const Divider(height: 8),
        ...o.items.map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(item.mealName, style: const TextStyle(fontSize: 12)),
                ),
                Expanded(
                  child: Text(
                    '×${item.qty}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'GH₵ ${_currency.format(item.price * item.qty)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return _Padded(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => controller.clear(),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _Padded extends StatelessWidget {
  const _Padded({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip(this.left, this.right);
  final String left, right;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              left,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            Text(
              right,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label == 'completed'
            ? AppLocalizations.of(context).completed
            : label == 'pending'
                ? AppLocalizations.of(context).pending
                : label == 'cancelled'
                    ? AppLocalizations.of(context).cancelled
                    : _cap(label),
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(label, style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

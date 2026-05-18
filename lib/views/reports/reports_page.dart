import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/generated/app_localizations.dart';

final _currency = NumberFormat('#,##0.00', 'en_US');
String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

// ── Mock Data Models ──────────────────────────────────────────────────────────

class _MockOrderItem {
  final String mealName;
  final int qty;
  final double price;
  const _MockOrderItem(this.mealName, this.qty, this.price);
}

class _MockOrder {
  final String id, orderCode, status, orderType, mealType;
  final double total;
  final int groupCount;
  final String? description;
  final String staffName;
  final DateTime createdAt;
  final List<_MockOrderItem> items;
  const _MockOrder({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.orderType,
    required this.mealType,
    required this.total,
    required this.groupCount,
    this.description,
    required this.staffName,
    required this.createdAt,
    required this.items,
  });
}

class _MockChargeback {
  final String id, orderCode, mealType, staffName, mealName;
  final double price;
  final DateTime createdAt;
  const _MockChargeback({
    required this.id,
    required this.orderCode,
    required this.mealType,
    required this.staffName,
    required this.mealName,
    required this.price,
    required this.createdAt,
  });
}

// ── Mock Datasets ─────────────────────────────────────────────────────────────

final _mockOrders = <_MockOrder>[
  _MockOrder(
    id: '1',
    orderCode: 'ORD-2025-001',
    status: 'completed',
    orderType: 'regular',
    mealType: 'lunch',
    total: 87.50,
    groupCount: 3,
    staffName: 'Kwame Asante',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    items: const [
      _MockOrderItem('Jollof Rice', 2, 25.00),
      _MockOrderItem('Grilled Chicken', 2, 18.75),
      _MockOrderItem('Mineral Water', 3, 5.00),
    ],
  ),
  _MockOrder(
    id: '2',
    orderCode: 'ORD-2025-002',
    status: 'pending',
    orderType: 'group',
    mealType: 'breakfast',
    total: 120.00,
    groupCount: 5,
    staffName: 'Abena Mensah',
    description: 'VIP table — extra napkins',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    items: const [
      _MockOrderItem('Waakye', 5, 18.00),
      _MockOrderItem('Boiled Eggs', 5, 5.00),
      _MockOrderItem('Milo', 5, 7.00),
    ],
  ),
  _MockOrder(
    id: '3',
    orderCode: 'ORD-2025-003',
    status: 'cancelled',
    orderType: 'regular',
    mealType: 'dinner',
    total: 45.00,
    groupCount: 1,
    staffName: 'Kofi Boateng',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    items: const [
      _MockOrderItem('Banku & Tilapia', 1, 35.00),
      _MockOrderItem('Sobolo', 1, 10.00),
    ],
  ),
  _MockOrder(
    id: '4',
    orderCode: 'ORD-2025-004',
    status: 'completed',
    orderType: 'regular',
    mealType: 'lunch',
    total: 62.00,
    groupCount: 2,
    staffName: 'Ama Osei',
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    items: const [
      _MockOrderItem('Fufu & Light Soup', 2, 28.00),
      _MockOrderItem('Soft Drink', 2, 6.00),
    ],
  ),
  _MockOrder(
    id: '5',
    orderCode: 'ORD-2025-005',
    status: 'completed',
    orderType: 'group',
    mealType: 'breakfast',
    total: 200.00,
    groupCount: 8,
    staffName: 'Yaw Darko',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    items: const [
      _MockOrderItem('Hausa Koko', 8, 12.00),
      _MockOrderItem('Koose', 8, 8.00),
      _MockOrderItem('Bread', 8, 5.00),
    ],
  ),
];

final _mockChargebacks = <_MockChargeback>[
  _MockChargeback(
    id: 'CB-001',
    orderCode: 'ORD-2025-001',
    mealType: 'lunch',
    staffName: 'Kwame Asante',
    mealName: 'Jollof Rice',
    price: 25.00,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  _MockChargeback(
    id: 'CB-002',
    orderCode: 'ORD-2025-003',
    mealType: 'dinner',
    staffName: 'Kofi Boateng',
    mealName: 'Banku & Tilapia',
    price: 35.00,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  _MockChargeback(
    id: 'CB-003',
    orderCode: 'ORD-2025-006',
    mealType: 'breakfast',
    staffName: 'Efua Kyei',
    mealName: 'Waakye',
    price: 18.00,
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
  ),
  _MockChargeback(
    id: 'CB-004',
    orderCode: 'ORD-2025-007',
    mealType: 'lunch',
    staffName: 'Nana Adu',
    mealName: 'Fufu & Light Soup',
    price: 28.00,
    createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
  ),
];

// ══════════════════════════════════════════════════════════════════════════════
// PAGE
// ══════════════════════════════════════════════════════════════════════════════

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          title: Text(AppLocalizations.of(context).reports),
          leading: const BackButton(color: Colors.white),
          centerTitle: true,
          bottom: TabBar(
            labelColor: cs.onPrimary,
            unselectedLabelColor: cs.onPrimary.withOpacity(0.6),
            indicatorColor: cs.onPrimary,
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: const Icon(Icons.receipt_long, color: Colors.white),
                child: Text(
                  AppLocalizations.of(context).orders,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                icon: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                ),
                child: Text(
                  AppLocalizations.of(context).chargebacks,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(children: [_OrdersTab(), _ChargebacksTab()]),
      ),
    );
  }
}

class _OrdersTab extends StatefulWidget {
  const _OrdersTab();
  @override
  State<_OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<_OrdersTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _statusFilter;
  String? _mealTypeFilter;
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

  List<_MockOrder> get _filtered => _mockOrders.where((o) {
    final q = _query;
    final matchQ =
        q.isEmpty ||
        o.orderCode.toLowerCase().contains(q) ||
        o.mealType.toLowerCase().contains(q) ||
        o.staffName.toLowerCase().contains(q) ||
        o.status.toLowerCase().contains(q);
    final matchS = _statusFilter == null || o.status == _statusFilter;
    final matchM = _mealTypeFilter == null || o.mealType == _mealTypeFilter;
    final matchDate =
        _dateRangeFilter == null ||
        ((o.createdAt.isAtSameMomentAs(_dateRangeFilter!.start) ||
                o.createdAt.isAfter(_dateRangeFilter!.start)) &&
            o.createdAt.isBefore(
              _dateRangeFilter!.end.add(const Duration(days: 1)),
            ));
    return matchQ && matchS && matchM && matchDate;
  }).toList();

  Future<void> _showFilterModal() async {
    String? tempStatus = _statusFilter;
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
                    children: [null, 'completed', 'pending', 'cancelled'].map((
                      status,
                    ) {
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
                              colorScheme: Theme.of(context).colorScheme
                                  .copyWith(
                                    primary: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          _statusFilter = tempStatus;
                          _dateRangeFilter = tempDateRange;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
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
    final items = _filtered;
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

        // Filter chips
        SizedBox(height: 10),
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
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (_, i) => _OrderTile(order: items[i]),
                ),
        ),
      ],
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});
  final _MockOrder order;

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
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: cs.primaryContainer,
        child: Icon(Icons.receipt_long, color: cs.primary, size: 18),
      ),
      title: Text(
        o.orderCode,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        '$date  ·  ${_cap(o.mealType)}  ·   ${o.staffName}',
        style: const TextStyle(fontSize: 10),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _StatusBadge(o.status, _statusColor(o.status)),
          SizedBox(height: 5),

          const Icon(Icons.expand_more, size: 10),
        ],
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      children: [
        const Divider(height: 1),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                l10n.item,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                l10n.quantity,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                l10n.subtotal,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
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
                  child: Text(
                    item.mealName,
                    style: const TextStyle(fontSize: 12),
                  ),
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
        const Divider(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (o.description != null)
              Expanded(
                child: Text(
                  'Note: ${o.description}',
                  style: TextStyle(fontSize: 11, color: cs.outline),
                ),
              ),
            Text(
              '${l10n.total}: GH₵ ${_currency.format(o.total)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cs.primary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// CHARGEBACKS TAB
// ══════════════════════════════════════════════════════════════════════════════

class _ChargebacksTab extends StatefulWidget {
  const _ChargebacksTab();
  @override
  State<_ChargebacksTab> createState() => _ChargebacksTabState();
}

class _ChargebacksTabState extends State<_ChargebacksTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _mealTypeFilter;
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

  List<_MockChargeback> get _filtered => _mockChargebacks.where((c) {
    final q = _query;
    final matchQ =
        q.isEmpty ||
        c.orderCode.toLowerCase().contains(q) ||
        c.staffName.toLowerCase().contains(q) ||
        c.mealName.toLowerCase().contains(q) ||
        c.mealType.toLowerCase().contains(q);
    final matchM = _mealTypeFilter == null || c.mealType == _mealTypeFilter;
    final matchDate =
        _dateRangeFilter == null ||
        ((c.createdAt.isAtSameMomentAs(_dateRangeFilter!.start) ||
                c.createdAt.isAfter(_dateRangeFilter!.start)) &&
            c.createdAt.isBefore(
              _dateRangeFilter!.end.add(const Duration(days: 1)),
            ));
    return matchQ && matchM && matchDate;
  }).toList();

  Future<void> _showFilterModal() async {
    String? tempMealType = _mealTypeFilter;
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
                        AppLocalizations.of(context).filterChargebacks,
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
                    AppLocalizations.of(context).mealType,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [null, 'breakfast', 'lunch', 'dinner'].map((
                      meal,
                    ) {
                      final isSelected = tempMealType == meal;
                      return ChoiceChip(
                        label: Text(
                          meal == null
                              ? AppLocalizations.of(context).all
                              : meal == 'breakfast'
                              ? AppLocalizations.of(context).breakfast
                              : meal == 'lunch'
                              ? AppLocalizations.of(context).lunch
                              : AppLocalizations.of(context).dinner,
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(
                            () => tempMealType = selected ? meal : null,
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
                              colorScheme: Theme.of(context).colorScheme
                                  .copyWith(
                                    primary: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          _mealTypeFilter = tempMealType;
                          _dateRangeFilter = tempDateRange;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context).applyFilters),
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
    final items = _filtered;
    final total = items.fold<double>(0, (s, c) => s + c.price);
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _SearchBar(
                controller: _searchCtrl,
                hint: l10n.searchOrderHint,
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

        SizedBox(height: 12),
        if (items.isNotEmpty)
          _SummaryStrip(
            '${items.length} ${AppLocalizations.of(context).chargebacks}',
            '${AppLocalizations.of(context).total}: GH₵ ${_currency.format(total)}',
          ),
        Expanded(
          child: items.isEmpty
              ? _EmptyView(
                  Icons.warning_amber_outlined,
                  AppLocalizations.of(context).noChargebacks,
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (_, i) => _ChargebackTile(cb: items[i]),
                ),
        ),
      ],
    );
  }
}

class _ChargebackTile extends StatelessWidget {
  const _ChargebackTile({required this.cb});
  final _MockChargeback cb;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final date = DateFormat('dd-MM-yy, hh:mm a').format(cb.createdAt);
    return ExpansionTile(
      leading: CircleAvatar(
        radius: 15,
        backgroundColor: cs.errorContainer,
        child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              cb.orderCode,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Text(
            'GH₵ ${_currency.format(cb.price)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: cs.error,
              fontSize: 10,
            ),
          ),
        ],
      ),
      subtitle: Text(
        '$date  ·  ${_cap(cb.mealType)}',
        style: const TextStyle(fontSize: 11),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      children: [
        const Divider(height: 1),
        const SizedBox(height: 8),
        _DetailRow(AppLocalizations.of(context).orderCode, cb.orderCode),
        _DetailRow(AppLocalizations.of(context).mealName, cb.mealName),
        _DetailRow(AppLocalizations.of(context).mealType, _cap(cb.mealType)),
        _DetailRow(AppLocalizations.of(context).staffName, cb.staffName),
        _DetailRow(
          AppLocalizations.of(context).totalAmount,
          'GH₵ ${_currency.format(cb.price)}',
        ),
        _DetailRow(AppLocalizations.of(context).date, date),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13),
          prefixIcon: const Icon(Icons.search, size: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.selected, this.onTap, [this.color]);
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effective = color ?? Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: selected ? effective : effective.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? effective : effective.withOpacity(0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: selected ? Colors.white : effective,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip(this.left, this.right);
  final String left, right;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            right,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
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
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
          Icon(
            icon,
            size: 56,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

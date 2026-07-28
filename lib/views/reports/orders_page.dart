import 'dart:typed_data';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../core/utils/search_debouncer.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/unified_report_order_row.dart';
import '../../services/database/app_database.dart';
import '../../services/print/print_service_manager.dart';

final _currency = NumberFormat('#,##0.00', 'en_US');
String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

Future<void> _printReportReceipt(_ReportOrder order) async {
  try {
    final printer = GetIt.instance<PrintServiceManager>();
    final now = DateTime.now();
    String pad(int n) => n.toString().padLeft(2, '0');
    final date = '${now.year}-${pad(now.month)}-${pad(now.day)} '
        '${pad(now.hour)}:${pad(now.minute)}';

    final orderTypeLabel = order.orderType == 'takeout' ? 'Takeout' : 'Dine-in';
    final mealTypeLabel = _cap(order.mealType);
    final staffLabel = order.staffName ?? 'Group order';
    final isGroup = order.staffName == null;

    final b = BytesBuilder();

    void ln(String s) => b.add('$s\n'.codeUnits);
    void boldOn() => b.add(const [0x1B, 0x45, 0x01]);
    void boldOff() => b.add(const [0x1B, 0x45, 0x00]);
    void centerOn() => b.add(const [0x1B, 0x61, 0x01]);
    void centerOff() => b.add(const [0x1B, 0x61, 0x00]);
    void doubleOn() => b.add(const [0x1D, 0x21, 0x11]);
    void doubleOff() => b.add(const [0x1D, 0x21, 0x00]);

    centerOn();
    ln('====================');
    ln('    AGC CANTEEN');
    if (isGroup) {
      ln('  [Group Order]');
    }
    ln('====================');
    centerOn();
    boldOn();
    doubleOn();
    ln(order.orderCode);
    doubleOff();
    boldOff();
    ln('Time:  $date');
    ln('Staff: $staffLabel');
    ln('Meal:  $mealTypeLabel');
    ln('Type:  $orderTypeLabel');
    ln('--------------------');
    if (isGroup) {
      ln('People: ${order.groupCount}');
      ln('--------------------');
    }
 

    final bytes = Uint8List.fromList(b.toBytes());
    final printed = await printer.printRawBytes(bytes);
    if (printed) {
      await printer.cutPaper();
    }
  } catch (_) {}
}

class _ReportOrder {
  final int id;
  final String orderCode, status, orderType, mealType;
  final double total;
  final int groupCount;
  final int syncStatus;
  final String? description, staffName;
  final DateTime createdAt;

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
  });

  bool get isSynced => syncStatus == 2;
}

const _ordersPageSize = 50;

Future<({
  Map<int, String> staffNames,
  Map<int, String> visitorNames,
  Map<int, String> dependentNames,
  Map<int, String> contractorNames,
})> _buildEntityNameMaps(AppDatabase db) async {
  final staffList = await db.getAllStaff();
  final visitorList = await db.getAllVisitors();
  final dependentList = await db.getAllDependents();
  final contractorList = await db.getAllContractorStaff();

  return (
    staffNames: {
      for (final s in staffList) s.id: '${s.firstName} ${s.lastName}',
    },
    visitorNames: {for (final v in visitorList) v.id: v.name},
    dependentNames: {for (final d in dependentList) d.id: d.fullname},
    contractorNames: {for (final c in contractorList) c.id: c.name},
  );
}

String _resolveStaffName(
  UnifiedReportOrderRow row,
  ({
    Map<int, String> staffNames,
    Map<int, String> visitorNames,
    Map<int, String> dependentNames,
    Map<int, String> contractorNames,
  }) names,
) {
  final id = row.orderedById!;
  switch (row.employeeType) {
    case 'visitor':
      return names.visitorNames[id] ?? id.toString();
    case 'dependent':
      return names.dependentNames[id] ?? id.toString();
    case 'contractor':
      return names.contractorNames[id] ?? id.toString();
    default:
      return names.staffNames[id] ?? id.toString();
  }
}

_ReportOrder _mapRow(
  UnifiedReportOrderRow row,
  ({
    Map<int, String> staffNames,
    Map<int, String> visitorNames,
    Map<int, String> dependentNames,
    Map<int, String> contractorNames,
  }) names,
) {
  return _ReportOrder(
    id: row.id,
    orderCode: row.orderCode,
    status: row.status,
    orderType: row.orderType,
    mealType: row.mealType,
    total: row.total,
    groupCount: row.groupCount,
    syncStatus: row.syncStatus,
    description: row.description,
    staffName: row.isGroup
        ? null
        : _resolveStaffName(row, names),
    createdAt: DateTime.tryParse(row.createdAt) ?? DateTime.now(),
  );
}

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
  final _searchDebouncer = SearchDebouncer();
  String _query = '';
  String? _statusFilter;
  String? _mealTypeFilter;
  String? _syncFilter;
  DateTimeRange? _dateRangeFilter;

  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  List<_ReportOrder> _loadedOrders = [];
  int _totalCount = 0;
  double _totalRevenue = 0;
  String? _loadError;

  ({
    Map<int, String> staffNames,
    Map<int, String> visitorNames,
    Map<int, String> dependentNames,
    Map<int, String> contractorNames,
  })? _nameMaps;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      _searchDebouncer(() {
        if (mounted) {
          setState(
            () => _query = _searchCtrl.text.trim().toLowerCase(),
          );
        }
      });
    });
    _loadOrders(reset: true);
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  String? _dateFromIso() =>
      _dateRangeFilter?.start.toIso8601String();

  String? _dateToInclusiveIso() {
    if (_dateRangeFilter == null) return null;
    final end = _dateRangeFilter!.end;
    return DateTime(end.year, end.month, end.day, 23, 59, 59)
        .toIso8601String();
  }

  bool? _syncedDbFilter() {
    if (_syncFilter == 'synced') return true;
    if (_syncFilter == 'unsynced') return false;
    return null;
  }

  Future<void> _loadOrders({bool reset = false}) async {
    if (reset) {
      _offset = 0;
      _hasMore = true;
      _loadedOrders = [];
      _nameMaps = null;
    } else if (!_hasMore) {
      return;
    }

    setState(() {
      _loadError = null;
      if (reset) {
        _loading = true;
      } else {
        _loadingMore = true;
      }
    });

    try {
      final db = GetIt.instance<AppDatabase>();
      _nameMaps ??= await _buildEntityNameMaps(db);
      final names = _nameMaps!;

      final rows = await db.queryUnifiedOrdersPage(
        createdAtFrom: _dateFromIso(),
        createdAtToInclusive: _dateToInclusiveIso(),
        status: _statusFilter,
        synced: _syncedDbFilter(),
        mealType: _mealTypeFilter,
        limit: _ordersPageSize,
        offset: _offset,
      );

      if (reset) {
        _totalCount = await db.countUnifiedOrders(
          createdAtFrom: _dateFromIso(),
          createdAtToInclusive: _dateToInclusiveIso(),
          status: _statusFilter,
          synced: _syncedDbFilter(),
          mealType: _mealTypeFilter,
        );
        _totalRevenue = await db.sumUnifiedOrdersRevenue(
          createdAtFrom: _dateFromIso(),
          createdAtToInclusive: _dateToInclusiveIso(),
          status: _statusFilter,
          synced: _syncedDbFilter(),
          mealType: _mealTypeFilter,
        );
      }

      final mapped = rows.map((r) => _mapRow(r, names)).toList();
      _offset += rows.length;
      _hasMore = _offset < _totalCount;

      setState(() {
        if (reset) {
          _loadedOrders = mapped;
        } else {
          _loadedOrders = [..._loadedOrders, ...mapped];
        }
        _loading = false;
        _loadingMore = false;
      });
    } catch (e) {
      setState(() {
        _loadError = e.toString();
        _loading = false;
        _loadingMore = false;
      });
    }
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
      final matchSync = _syncFilter == null ||
          (_syncFilter == 'synced' ? o.isSynced : !o.isSynced);
      return matchQ && matchS && matchM && matchSync;
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
                        _loadOrders(reset: true);
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

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null) {
      return Center(child: Text('Failed to load orders: $_loadError'));
    }

    final items = _filter(_loadedOrders);
    final total = _totalRevenue;

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
        if (_totalCount > 0)
          _SummaryStrip(
            '${_totalCount} ${AppLocalizations.of(context).orders}',
            '${AppLocalizations.of(context).total}: GH₵ ${_currency.format(total)}',
          ),
        Expanded(
          child: items.isEmpty
              ? _EmptyView(
                  Icons.receipt_long_outlined,
                  AppLocalizations.of(context).noOrders,
                  onRefresh: () => _loadOrders(reset: true),
                )
              : RefreshIndicator(
                  onRefresh: () => _loadOrders(reset: true),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: items.length + (_hasMore ? 1 : 0),
                    separatorBuilder: (_, index) {
                      if (index >= items.length - 1) {
                        return const SizedBox.shrink();
                      }
                      return const Divider(height: 1, indent: 16, endIndent: 16);
                    },
                    itemBuilder: (_, i) {
                      if (i >= items.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: _loadingMore
                                ? const CircularProgressIndicator()
                                : OutlinedButton(
                                    onPressed: () => _loadOrders(),
                                    child: const Text('Load more'),
                                  ),
                          ),
                        );
                      }
                      return _OrderTile(order: items[i]);
                    },
                  ),
                ),
        ),
      ],
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
   
        const Divider(height: 8),
       
        TextButton.icon(
          onPressed: () => _printReportReceipt(o),
          icon: Icon(Icons.print, size: 18, color: cs.primary),
          label: Text(
            'Print Receipt',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cs.primary,
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
  const _EmptyView(this.icon, this.label, {this.onRefresh});
  final IconData icon;
  final String label;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64),
          const SizedBox(height: 16),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 15,),
          if (onRefresh != null)
            SizedBox(
              width: 150,
              child: PrimaryButton(
                onPressed: onRefresh,
                label: const Text("Refresh"),
              ),
            ),
        ],
      ),
    );
  }
}

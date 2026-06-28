import 'dart:async';
import 'dart:typed_data';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/injection_container.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../controllers/providers.dart';
import '../../services/database/activity_log_service.dart';
import '../../services/database/app_database.dart';
import '../../services/print/print_service_manager.dart';
import '../../services/sync_services/sync_service.dart';
import '../reports/orders_page.dart';

const _mealTypes = [
  'breakfast',
  'lunch',
  'dinner',
  'midnight',
  'snack',
  'beverage',
  'la_carte',
];

Future<void> _printManualReceipt({
  required String orderCode,
  required String mealType,
  required String staffName,
  String? description,
  bool isGroup = false,
}) async {
  try {
    final printer = getIt<PrintServiceManager>();
    final now = DateTime.now();
    final pad = (int n) => n.toString().padLeft(2, '0');
    final date = '${now.year}-${pad(now.month)}-${pad(now.day)} '
        '${pad(now.hour)}:${pad(now.minute)}';

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
    if (isGroup) ln('   [Group Order]');
    ln('====================');
    centerOn();
    boldOn();
    doubleOn();
    ln(orderCode);
    doubleOff();
    boldOff();
    ln('Time:  $date');
    ln('Staff: $staffName');
    ln('Meal:  ${mealType[0].toUpperCase()}${mealType.substring(1)}');
    ln('--------------------');
    if (description != null && description.isNotEmpty) {
      ln('Description: $description');
    }
    ln('--------------------');
    ln('     THANK YOU!');
    ln('');

    final bytes = Uint8List.fromList(b.toBytes());
    final printed = await printer.printRawBytes(bytes);
    if (printed) {
      await printer.cutPaper();
    }
  } catch (_) {}
}

class ManualOrderPage extends StatelessWidget {
  const ManualOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          title: Text(l10n.manualPosOrder),
          leading: const BackButton(color: Colors.white),
          centerTitle: true,
          bottom: TabBar(
            labelColor: cs.onPrimary,
            unselectedLabelColor: cs.onPrimary.withOpacity(0.6),
            indicatorColor: cs.onPrimary,
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: const Icon(Icons.person, color: Colors.white),
                child: Text(
                  l10n.singleOrder,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(color: Colors.white),
                ),
              ),
              Tab(
                icon: const Icon(Icons.group, color: Colors.white),
                child: Text(
                  l10n.groupOrder,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
       // body: _SingleOrderTab(),
       body: const TabBarView(children: [_SingleOrderTab(), _GroupOrderTab()]),
      ),
    );
  }
}

class _SingleOrderTab extends ConsumerStatefulWidget {
  const _SingleOrderTab();

  @override
  ConsumerState<_SingleOrderTab> createState() => _SingleOrderTabState();
}

class _SingleOrderTabState extends ConsumerState<_SingleOrderTab> {
  String? _mealType;
  StaffData? _selectedStaff;
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStaff == null || _mealType == null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final desc = _descriptionController.text.trim();

    try {
      final db = getIt<AppDatabase>();
      final allTypes = await db.getAllMealTypes();
      final price = allTypes
          .where((t) => t.name.toLowerCase() == _mealType!.toLowerCase())
          .firstOrNull
          ?.price ?? 0;
      final now = DateTime.now().toIso8601String();
      final orderId = DateTime.now().millisecondsSinceEpoch;
      final orderCode = await _generateOrderCode();

      final order = OrdersCompanion(
        id: Value(orderId),
        uuid: Value(const Uuid().v4()),
        orderCode: Value(orderCode),
        status: const Value('completed'),
        orderType: const Value('single'),
        mealType: Value(_mealType!),
        total: Value(price),
        groupCount: const Value(1),
        description: Value(desc.isEmpty ? _mealType! : desc),
        orderedById: Value(_selectedStaff!.id),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(0),
        syncUpdatedAt: const Value.absent(),
      );

      await db.insertOrder(order);

      ref.invalidate(reportOrdersProvider);

      unawaited(getIt<SyncService>().syncSingleOrders());

      unawaited(_printManualReceipt(
        orderCode: orderCode,
        mealType: _mealType!,
        staffName: _selectedStaff!.firstName,
        description: desc.isEmpty ? _mealType! : desc,
      ));

      getIt<ActivityLogService>().log(
        type: 'order_placed',
        message: 'Manual order placed: $orderCode',
        actorType: 'staff',
        actorId: _selectedStaff!.id,
        sourceTable: 'orders',
        recordId: orderId.toString(),
        metadata: {
          'order_code': orderCode,
          'meal_type': _mealType,
          'order_type': 'manual_pos',
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Order $orderCode placed successfully'),
          backgroundColor: Colors.green,
        ),
      );

      _resetForm();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetForm() {
    _descriptionController.clear();
    setState(() {
      _mealType = null;
      _selectedStaff = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final staff = ref.watch(staffListProvider);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionLabel(l10n.mealType),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _mealType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select meal type',
            ),
            items: _mealTypes
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(_formatMealType(t)),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() {
              _mealType = v;
            }),
            validator: (v) => v == null ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          _sectionLabel('Staff'),
          const SizedBox(height: 8),
          staff.when(
            data: (list) => DropdownButtonFormField<StaffData>(
              value: _selectedStaff,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select staff',
              ),
              items: list
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text('${s.firstName} ${s.lastName}'),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedStaff = v),
              validator: (v) => v == null ? 'Required' : null,
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Failed to load staff: $e'),
          ),
         
          const SizedBox(height: 30),

          PrimaryButton(
            onPressed: _submit,
            label: Text('Place Order', style: TextStyle(color: Colors.white)),
            prefixChild: const Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  String _formatMealType(String type) {
    return type[0].toUpperCase() + type.substring(1).replaceAll('_', ' ');
  }

  Future<String> _generateOrderCode() async {
    return getIt<AppDatabase>().nextOrderCode();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}


class _GroupOrderTab extends ConsumerStatefulWidget {
  const _GroupOrderTab();

  @override
  ConsumerState<_GroupOrderTab> createState() => _GroupOrderTabState();
}

class _GroupOrderTabState extends ConsumerState<_GroupOrderTab> {
  String? _mealType;
  StaffData? _selectedStaff;
  final _totalQtyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _totalQtyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int get _totalQty => int.tryParse(_totalQtyController.text) ?? 0;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_mealType == null || _selectedStaff == null) return;

    if (_totalQty < 1) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Group count must be at least 1'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final desc = _descriptionController.text.trim();
    final db = getIt<AppDatabase>();
    final allTypes = await db.getAllMealTypes();
    final price = allTypes
        .where((t) => t.name.toLowerCase() == _mealType!.toLowerCase())
        .firstOrNull
        ?.price ?? 0;
    final now = DateTime.now().toIso8601String();
    final staffName = '${_selectedStaff!.firstName} ${_selectedStaff!.lastName}';
    final codes = <String>[];

    try {
      for (int i = 0; i < _totalQty; i++) {
        final orderId = DateTime.now().millisecondsSinceEpoch;
        final orderCode = await _generateOrderCode();
        codes.add(orderCode);

        await db.insertOrder(
          OrdersCompanion(
            id: Value(orderId),
            uuid: Value(const Uuid().v4()),
            orderCode: Value(orderCode),
            status: const Value('completed'),
            orderType: const Value('group'),
            mealType: Value(_mealType!),
            total: Value(price),
            groupCount: const Value(1),
            description: Value(
              desc.isEmpty ? '[Group] $_mealType (${i + 1}/$_totalQty)' : '[Group] $desc (${i + 1}/$_totalQty)',
            ),
            orderedById: Value(_selectedStaff!.id),
            createdAt: Value(now),
            updatedAt: Value(now),
            syncStatus: const Value(0),
            syncUpdatedAt: const Value.absent(),
          ),
        );

        unawaited(_printManualReceipt(
          orderCode: orderCode,
          mealType: _mealType!,
          staffName: staffName,
          description: desc.isEmpty ? _mealType! : desc,
          isGroup: true,
        ));
      }

      ref.invalidate(reportOrdersProvider);
      unawaited(getIt<SyncService>().syncSingleOrders());

      getIt<ActivityLogService>().log(
        type: 'group_order_placed',
        message: 'Manual group: $_totalQty vouchers ($_mealType)',
        actorType: 'staff',
        actorId: _selectedStaff!.id,
        actorName: staffName,
        sourceTable: 'orders',
        metadata: {
          'order_codes': codes,
          'meal_type': _mealType,
          'group_count': _totalQty,
          'order_type': 'manual_group_pos',
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('$_totalQty vouchers printed ($_mealType)'),
          backgroundColor: Colors.green,
        ),
      );

      _resetForm();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _resetForm() {
    _totalQtyController.clear();
    _descriptionController.clear();
    setState(() {
      _mealType = null;
      _selectedStaff = null;
    });
  }

  Future<String> _generateOrderCode() async {
    return getIt<AppDatabase>().nextOrderCode();
  }

  String _formatMealType(String type) {
    return type[0].toUpperCase() + type.substring(1).replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final staff = ref.watch(staffListProvider);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionLabel(l10n.mealType),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _mealType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select meal type',
            ),
            items: _mealTypes
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(_formatMealType(t)),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _mealType = v),
            validator: (v) => v == null ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          _sectionLabel('Staff'),
          const SizedBox(height: 8),
          staff.when(
            data: (list) => DropdownButtonFormField<StaffData>(
              value: _selectedStaff,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select staff',
              ),
              items: list
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text('${s.firstName} ${s.lastName}'),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedStaff = v),
              validator: (v) => v == null ? 'Required' : null,
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Failed to load staff: $e'),
          ),
          const SizedBox(height: 20),
          _sectionLabel('Number of Vouchers'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _totalQtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter number of vouchers',
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              final n = int.tryParse(v);
              if (n == null || n < 1) return 'Must be at least 1';
              return null;
            },
          ),
         
          const SizedBox(height: 20),

          PrimaryButton(
            onPressed: _isSubmitting ? null : _submit,
            label: Text(
              _isSubmitting ? 'Printing...' : 'Place Group Order',
              style: const TextStyle(color: Colors.white),
            ),
            prefixChild: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

import 'dart:async';
import 'dart:typed_data';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/injection_container.dart';
import '../../core/enums/employee_type.enum.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/database/activity_log_service.dart';
import '../../services/database/app_database.dart';
import '../../services/print/print_service_manager.dart';
import '../../services/sync_services/sync_from_local_to_remote.dart';
import '../widgets/staff_search_field.widget.dart';
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

    centerOn();
    ln('====================');
    ln('    AGC CANTEEN');
    if (isGroup) ln('   [Group Order]');
    ln('====================');
    centerOn();
    boldOn();
    ln(orderCode);
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

class _SingleOrderTab extends StatefulWidget {
  const _SingleOrderTab();

  @override
  State<_SingleOrderTab> createState() => _SingleOrderTabState();
}

class _SingleOrderTabState extends State<_SingleOrderTab> {
  MealType? _selectedMealType;
  StaffData? _selectedStaff;
  List<MealType> _mealTypes = [];
  bool _loadingMealTypes = true;
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMealTypes());
  }

  Future<void> _loadMealTypes() async {
    try {
      final db = getIt<AppDatabase>();
      final types = await db.getAllMealTypes();
      if (mounted) setState(() { _mealTypes = types; _loadingMealTypes = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingMealTypes = false);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStaff == null || _selectedMealType == null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final mealTypeName = _selectedMealType!.name;
    final price = _selectedMealType!.price;
    if (price <= 0) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Meal type "$mealTypeName" has no price set'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final desc = _descriptionController.text.trim();

    try {
      final db = getIt<AppDatabase>();
      final now = DateTime.now().toIso8601String();
      final orderId = DateTime.now().millisecondsSinceEpoch;
      final orderCode = await _generateOrderCode();
      if (orderCode == null) {
        if (!mounted) return;
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text(
              'POS device is not registered. Please complete device setup in Settings.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final order = OrdersCompanion(
        id: Value(orderId),
        uuid: Value(const Uuid().v4()),
        orderCode: Value(orderCode),
        status: const Value('completed'),
        orderType: const Value('single'),
        mealType: Value(mealTypeName),
        total: Value(price),
        groupCount: const Value(1),
        description: Value(desc.isEmpty ? mealTypeName : desc),
        orderedById: Value(_selectedStaff!.id),
        employeeType: Value(_selectedStaff!.employeeType),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(0),
        syncUpdatedAt: const Value.absent(),
      );

      await db.insertOrder(order);

      unawaited(getIt<LocalToRemoteSyncService>().syncSingleOrders());

      unawaited(_printManualReceipt(
        orderCode: orderCode,
        mealType: mealTypeName,
        staffName: _selectedStaff!.firstName,
        description: desc.isEmpty ? mealTypeName : desc,
      ));

      getIt<ActivityLogService>().log(
        type: 'order_placed',
        message: 'Manual order placed: $orderCode',
        actorType: EmployeeType.permanent.name,
        actorId: _selectedStaff!.id,
        sourceTable: 'orders',
        recordId: orderId.toString(),
        metadata: {
          'order_code': orderCode,
          'meal_type': mealTypeName,
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
      _selectedMealType = null;
      _selectedStaff = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionLabel(l10n.mealType),
          const SizedBox(height: 8),
          if (_loadingMealTypes)
            const LinearProgressIndicator()
          else
          DropdownButtonFormField<MealType>(
            value: _selectedMealType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select meal type',
            ),
            items: _mealTypes
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(_formatMealType(t.name)),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() {
              _selectedMealType = v;
            }),
            validator: (v) => v == null ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          _sectionLabel('Staff'),
          const SizedBox(height: 8),
          StaffSearchField(
            value: _selectedStaff,
            onChanged: (staff) => setState(() => _selectedStaff = staff),
            validator: (v) => v == null ? 'Required' : null,
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

  Future<String?> _generateOrderCode() async {
    final db = getIt<AppDatabase>();
    final devices = await db.getAllPosDevices();
    final pos = devices.firstOrNull;
    if (pos == null || pos.kitchenId == null) return null;
    return db.nextOrderCode('', pos.id, pos.kitchenId!);
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}


class _GroupOrderTab extends StatefulWidget {
  const _GroupOrderTab();

  @override
  State<_GroupOrderTab> createState() => _GroupOrderTabState();
}

class _GroupOrderTabState extends State<_GroupOrderTab> {
  MealType? _selectedMealType;
  StaffData? _selectedStaff;
  List<MealType> _mealTypes = [];
  bool _loadingMealTypes = true;
  final _totalQtyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMealTypes());
  }

  Future<void> _loadMealTypes() async {
    try {
      final db = getIt<AppDatabase>();
      final types = await db.getAllMealTypes();
      if (mounted) setState(() { _mealTypes = types; _loadingMealTypes = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingMealTypes = false);
    }
  }

  @override
  void dispose() {
    _totalQtyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int get _totalQty => int.tryParse(_totalQtyController.text) ?? 0;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMealType == null || _selectedStaff == null) return;

    if (_totalQty < 1) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Group count must be at least 1'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final mealTypeName = _selectedMealType!.name;
    final price = _selectedMealType!.price;
    if (price <= 0) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Meal type "$mealTypeName" has no price set'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final desc = _descriptionController.text.trim();
    final db = getIt<AppDatabase>();
    final now = DateTime.now().toIso8601String();
    final staffName = '${_selectedStaff!.firstName} ${_selectedStaff!.lastName}';

    try {
      final posDevices = await db.getAllPosDevices();
      final pos = posDevices.firstOrNull;
      if (pos == null || pos.kitchenId == null) {
        if (!mounted) return;
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text(
              'POS device is not registered. Please complete device setup in Settings.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final orderCodes = <String>[];

      await db.transaction(() async {
        for (int i = 0; i < _totalQty; i++) {
          final orderCode = await db.nextOrderCode('', pos.id, pos.kitchenId!);
          orderCodes.add(orderCode);

          await db.insertOrder(
            OrdersCompanion(
              id: Value(DateTime.now().millisecondsSinceEpoch + i),
              uuid: Value(const Uuid().v4()),
              orderCode: Value(orderCode),
              status: const Value('completed'),
              orderType: const Value('group'),
              mealType: Value(mealTypeName),
              total: Value(price),
              groupCount: const Value(1),
              description: Value(
                desc.isEmpty
                    ? '[Group] $mealTypeName (${i + 1}/$_totalQty)'
                    : '[Group] $desc (${i + 1}/$_totalQty)',
              ),
              orderedById: Value(_selectedStaff!.id),
              employeeType: Value(_selectedStaff!.employeeType),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(0),
              syncUpdatedAt: const Value.absent(),
            ),
          );

          unawaited(_printManualReceipt(
            orderCode: orderCode,
            mealType: mealTypeName,
            staffName: staffName,
            description: desc.isEmpty ? mealTypeName : desc,
            isGroup: true,
          ));
        }
      });

      unawaited(getIt<LocalToRemoteSyncService>().syncSingleOrders());

      getIt<ActivityLogService>().log(
        type: 'group_order_placed',
        message: 'Manual group: $_totalQty vouchers ($mealTypeName)',
        actorType: EmployeeType.permanent.name,
        actorId: _selectedStaff!.id,
        actorName: staffName,
        sourceTable: 'orders',
        metadata: {
          'order_codes': orderCodes,
          'meal_type': mealTypeName,
          'group_count': _totalQty,
          'order_type': 'manual_group_pos',
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('$_totalQty vouchers printed ($mealTypeName)'),
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
      _selectedMealType = null;
      _selectedStaff = null;
    });
  }

  String _formatMealType(String type) {
    return type[0].toUpperCase() + type.substring(1).replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionLabel(l10n.mealType),
          const SizedBox(height: 8),
          if (_loadingMealTypes)
            const LinearProgressIndicator()
          else
          DropdownButtonFormField<MealType>(
            value: _selectedMealType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select meal type',
            ),
            items: _mealTypes
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(_formatMealType(t.name)),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _selectedMealType = v),
            validator: (v) => v == null ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          _sectionLabel('Staff'),
          const SizedBox(height: 8),
          StaffSearchField(
            value: _selectedStaff,
            onChanged: (staff) => setState(() => _selectedStaff = staff),
            validator: (v) => v == null ? 'Required' : null,
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

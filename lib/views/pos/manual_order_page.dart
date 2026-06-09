import 'dart:async';
import 'dart:typed_data';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../core/di/injection_container.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../controllers/providers.dart';
import '../../services/activity_log_service.dart';
import '../../services/database/app_database.dart';
import '../../services/pos/pos_print_service.dart';

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
  required String mealName,
  required double price,
  required String staffName,
  required String orderType,
  String? description,
}) async {
  try {
    final printer = getIt<PosPrintService>();
    final now = DateTime.now();
    final pad = (int n) => n.toString().padLeft(2, '0');
    final date = '${now.year}-${pad(now.month)}-${pad(now.day)} '
        '${pad(now.hour)}:${pad(now.minute)}';

    final orderTypeLabel = orderType == 'takeout' ? 'Takeout' : 'Dine-in';

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
    ln('  [Manual Order]');
    ln('====================');
    centerOn();
    boldOn();
    doubleOn();
    ln(orderCode);
    doubleOff();
    boldOff();
    // centerOff();
    ln('Time:  $date');
    ln('Staff: $staffName');
    ln('Type:  $orderTypeLabel');
    ln('--------------------');
    boldOn();
    ln(mealName);
    boldOff();
    if (description != null && description.isNotEmpty) {
      ln('Description: $description');
    }
    // ln('     \$${price.toStringAsFixed(2)}');
    ln('--------------------');
    boldOn();
    ln('TOTAL: \$${price.toStringAsFixed(2)}');
    boldOff();
    ln('====================');
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
  String _orderType = 'dine_in';
  String? _mealType;
  StaffData? _selectedStaff;
  Meal? _selectedMeal;
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStaff == null || _selectedMeal == null || _mealType == null) {
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
      final now = DateTime.now().toIso8601String();
      final orderId = const Uuid().v4();
      final orderCode = _generateOrderCode();
      final orderItemId = const Uuid().v4();

      final order = OrdersCompanion(
        id: Value(orderId),
        orderCode: Value(orderCode),
        status: const Value('completed'),
        orderType: Value(_orderType),
        mealType: Value(_mealType!),
        total: Value(_selectedMeal!.price),
        groupCount: const Value(1),
        description: Value(desc.isEmpty ? _selectedMeal!.name : desc),
        orderedById: Value(_selectedStaff!.id),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(0),
        syncUpdatedAt: const Value.absent(),
      );

      final orderItem = OrderItemsCompanion(
        id: Value(orderItemId),
        price: Value(_selectedMeal!.price),
        qty: const Value(1),
        mealId: Value(_selectedMeal!.id),
        orderId: Value(orderId),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(0),
        syncUpdatedAt: const Value.absent(),
      );

      await db.insertOrder(order, [orderItem]);

      unawaited(_printManualReceipt(
        orderCode: orderCode,
        mealName: _selectedMeal!.name,
        orderType: _orderType,
        price: _selectedMeal!.price,
        staffName: _selectedStaff!.firstName,
        description: desc.isEmpty ? _selectedMeal!.name : desc,
      ));

      getIt<ActivityLogService>().log(
        type: 'order_placed',
        message: 'Manual order placed: $orderCode — ${_selectedMeal!.name}',
        actorType: 'staff',
        actorId: _selectedStaff!.id,
        sourceTable: 'orders',
        recordId: orderId,
        metadata: {
          'order_code': orderCode,
          'meal_id': _selectedMeal!.id,
          'meal_name': _selectedMeal!.name,
          'meal_type': _mealType,
          'total': _selectedMeal!.price,
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
      _orderType = 'dine_in';
      _mealType = null;
      _selectedStaff = null;
      _selectedMeal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final meals = ref.watch(mealsProvider);
    final staff = ref.watch(staffListProvider);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionLabel('Order Type'),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'dine_in',
                label: Text('Dine-in'),
                icon: Icon(Icons.table_restaurant),
              ),
              ButtonSegment(
                value: 'takeout',
                label: Text('Takeout'),
                icon: Icon(Icons.takeout_dining),
              ),
            ],
            selected: {_orderType},
            onSelectionChanged: (v) => setState(() => _orderType = v.first),
          ),
          const SizedBox(height: 20),
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
              _selectedMeal = null;
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
          const SizedBox(height: 20),
          _sectionLabel('Meal'),
          const SizedBox(height: 8),
          meals.when(
            data: (list) {
              final available = (_mealType == null || _mealType!.isEmpty)
                  ? list
                  : list.where(
                      (m) =>
                          m.mealType.toLowerCase() == _mealType!.toLowerCase(),
                    );
              return DropdownButtonFormField<Meal>(
                value: _selectedMeal,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select meal',
                ),
                items: available
                    .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedMeal = v),
                validator: (v) => v == null ? 'Required' : null,
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Failed to load meals: $e'),
          ),
          const SizedBox(height: 20),
          _sectionLabel(l10n.description),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: _selectedMeal?.mealType == 'la_carte'
                  ? 'Describe what you want to order'
                  : 'Optional notes',
            ),
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

  String _generateOrderCode() {
    final suffix = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000))
        .toString();
    return 'AGC$suffix';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}

class _MealWithQuantity {
  final Meal meal;
  int quantity;

  _MealWithQuantity({required this.meal, this.quantity = 1});
}

class _GroupOrderTab extends ConsumerStatefulWidget {
  const _GroupOrderTab();

  @override
  ConsumerState<_GroupOrderTab> createState() => _GroupOrderTabState();
}

class _GroupOrderTabState extends ConsumerState<_GroupOrderTab> {
  String _orderType = 'dine_in';
  String? _mealType;
  final _totalQtyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Meal? _pendingMeal;
  final _pendingQtyController = TextEditingController(text: '1');
  final List<_MealWithQuantity> _selectedMeals = [];

  @override
  void dispose() {
    _totalQtyController.dispose();
    _descriptionController.dispose();
    _pendingQtyController.dispose();
    super.dispose();
  }

  int get _totalQty => int.tryParse(_totalQtyController.text) ?? 0;
  int get _mealsQtySum => _selectedMeals.fold(0, (s, m) => s + m.quantity);

  void _addMeal() {
    if (_pendingMeal == null) return;
    final pqty = int.tryParse(_pendingQtyController.text) ?? 0;
    if (pqty < 1) return;

    final remaining = _totalQty - _mealsQtySum;
    if (pqty > remaining) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Quantity exceeds remaining slots ($remaining)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final existing = _selectedMeals.indexWhere(
      (m) => m.meal.id == _pendingMeal!.id,
    );
    if (existing >= 0) {
      final newQty = _selectedMeals[existing].quantity + pqty;
      if (newQty > _totalQty) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text('Total would exceed the group count ($_totalQty)'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() {
        _selectedMeals[existing].quantity = newQty;
        _pendingMeal = null;
        _pendingQtyController.text = '1';
      });
    } else {
      setState(() {
        _selectedMeals.add(
          _MealWithQuantity(meal: _pendingMeal!, quantity: pqty),
        );
        _pendingMeal = null;
        _pendingQtyController.text = '1';
      });
    }
  }

  void _removeMeal(int index) {
    setState(() => _selectedMeals.removeAt(index));
  }

  void _updateMealQty(int index, int delta) {
    final current = _selectedMeals[index].quantity;
    final next = current + delta;
    if (next < 1) return;
    if (_mealsQtySum - current + next > _totalQty) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Total would exceed the group count ($_totalQty)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _selectedMeals[index].quantity = next);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_mealType == null) return;

    if (_totalQty < 1) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Total quantity must be at least 1'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedMeals.isEmpty) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Add at least one meal'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_mealsQtySum != _totalQty) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            'Total quantity ($_totalQty) must match sum of meal quantities ($_mealsQtySum)',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final desc = _descriptionController.text.trim();

    try {
      final db = getIt<AppDatabase>();
      final now = DateTime.now().toIso8601String();
      final orderId = const Uuid().v4();
      final orderCode = _generateOrderCode();

      final totalPrice = _selectedMeals.fold<double>(
        0,
        (s, m) => s + (m.meal.price * m.quantity),
      );

      final order = GroupOrdersCompanion(
        id: Value(orderId),
        orderCode: Value(orderCode),
        status: const Value('completed'),
        orderType: Value(_orderType),
        mealType: Value(_mealType!),
        total: Value(totalPrice),
        groupCount: Value(_totalQty),
        description: Value(desc.isEmpty ? 'Group order' : desc),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(0),
        syncUpdatedAt: const Value.absent(),
      );

      final items = _selectedMeals
          .map(
            (m) => GroupOrderItemsCompanion(
              id: Value(const Uuid().v4()),
              price: Value(m.meal.price),
              qty: Value(m.quantity),
              mealId: Value(m.meal.id),
              groupOrderId: Value(orderId),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(0),
              syncUpdatedAt: const Value.absent(),
            ),
          )
          .toList();

      await db.insertGroupOrder(order, items);

      final mealName = '${_mealsQtySum}x ${_selectedMeals.map((m) => '${m.meal.name}(${m.quantity})').join(', ')}';
      unawaited(_printManualReceipt(
        orderCode: orderCode,
        mealName: mealName.length > 40 ? '${mealName.substring(0, 40)}...' : mealName,
        price: totalPrice,
        staffName: 'Manual Group',
        description: desc.isEmpty ? 'Group order' : desc,
        orderType: _orderType,
      ));

      getIt<ActivityLogService>().log(
        type: 'group_order_placed',
        message: 'Manual group order placed: $orderCode — $_mealsQtySum items',
        sourceTable: 'group_orders',
        recordId: orderId,
        metadata: {
          'order_code': orderCode,
          'meal_type': _mealType,
          'total': totalPrice,
          'group_count': _totalQty,
          'order_type': 'manual_group_pos',
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Group order $orderCode placed successfully'),
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
    _totalQtyController.clear();
    _descriptionController.clear();
    _pendingQtyController.text = '1';
    setState(() {
      _orderType = 'dine_in';
      _mealType = null;
      _pendingMeal = null;
      _selectedMeals.clear();
    });
  }

  String _generateOrderCode() {
    final suffix = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000))
        .toString();
    return 'AGC$suffix';
  }

  String _formatMealType(String type) {
    return type[0].toUpperCase() + type.substring(1).replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final meals = ref.watch(mealsProvider);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionLabel('Order Type'),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'dine_in',
                label: Text('Dine-in'),
                icon: Icon(Icons.table_restaurant),
              ),
              ButtonSegment(
                value: 'takeout',
                label: Text('Takeout'),
                icon: Icon(Icons.takeout_dining),
              ),
            ],
            selected: {_orderType},
            onSelectionChanged: (v) => setState(() => _orderType = v.first),
          ),
          const SizedBox(height: 20),
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
          _sectionLabel('Total Quantity'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _totalQtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter total number of people/items',
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              final n = int.tryParse(v);
              if (n == null || n < 1) return 'Must be at least 1';
              return null;
            },
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.restaurant_menu, size: 18),
              const SizedBox(width: 8),
              Text(
                'Meals (${_mealsQtySum}/$_totalQty)',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: meals.when(
                  data: (list) {
                    final available = (_mealType == null || _mealType!.isEmpty)
                        ? list
                        : list.where(
                            (m) =>
                                m.mealType.toLowerCase() ==
                                _mealType!.toLowerCase(),
                          );
                    return DropdownButtonFormField<Meal>(
                      value: _pendingMeal,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Add meal',
                        isDense: true,
                      ),
                      items: available
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                m.name,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _pendingMeal = v),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => const Text('Error'),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: _pendingQtyController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Qty',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _pendingMeal != null ? _addMeal : null,
                icon: const Icon(Icons.add, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._selectedMeals.asMap().entries.map((entry) {
            final idx = entry.key;
            final mq = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          mq.meal.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _updateMealQty(idx, -1),
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 22,
                        color: cs.primary,
                      ),
                      SizedBox(
                        width: 32,
                        child: Text(
                          '${mq.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _updateMealQty(idx, 1),
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 22,
                        color: cs.primary,
                      ),
                      IconButton(
                        onPressed: () => _removeMeal(idx),
                        icon: const Icon(Icons.delete_outline),
                        iconSize: 20,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          _sectionLabel(l10n.description),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Optional notes',
            ),
          ),
          const SizedBox(height: 20),

          PrimaryButton(
            onPressed: _submit,
            label: const Text(
              'Place Group Order',
              style: TextStyle(color: Colors.white),
            ),
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
}

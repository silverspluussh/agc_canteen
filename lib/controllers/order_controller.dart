import 'dart:async';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../core/di/injection_container.dart';
import '../services/activity_log_service.dart';
import '../services/database/app_database.dart';
import '../services/print/print_service_manager.dart';
import '../views/reports/orders_page.dart';

enum OrderStep { browsing, confirming, processing, completed }

class OrderState {
  final OrderStep step;
  final Meal? selectedMeal;
  final String? error;
  final String? lastOrderCode;

  const OrderState({
    this.step = OrderStep.browsing,
    this.selectedMeal,
    this.error,
    this.lastOrderCode,
  });

  OrderState copyWith({
    OrderStep? step,
    Meal? selectedMeal,
    String? error,
    String? lastOrderCode,
    bool clearMeal = false,
  }) {
    return OrderState(
      step: step ?? this.step,
      selectedMeal: clearMeal ? null : (selectedMeal ?? this.selectedMeal),
      error: error ?? this.error,
      lastOrderCode: lastOrderCode ?? this.lastOrderCode,
    );
  }

  bool get isEmpty => selectedMeal == null;
  bool get isNotEmpty => selectedMeal != null;
  double get total => selectedMeal?.price ?? 0.0;
}

class OrderController extends Notifier<OrderState> {
  AppDatabase get _db => getIt<AppDatabase>();
  PrintServiceManager get _printer => getIt<PrintServiceManager>();

  @override
  OrderState build() => const OrderState();

  void selectMeal(Meal meal) {
    state = state.copyWith(
      step: OrderStep.browsing,
      selectedMeal: meal,
      error: null,
    );
    getIt<ActivityLogService>().log(
      type: 'meal_selected',
      message: 'Meal selected: ${meal.name}',
      actorType: 'staff',
      sourceTable: 'meals',
      recordId: meal.id,
      metadata: {
        'meal_name': meal.name,
        'meal_type': meal.mealType,
        'price': meal.price,
      },
    );
  }

  void removeMeal() {
    final meal = state.selectedMeal;
    state = state.copyWith(
      step: OrderStep.browsing,
      clearMeal: true,
      error: null,
    );
    if (meal != null) {
      getIt<ActivityLogService>().log(
        type: 'meal_deselected',
        message: 'Meal deselected: ${meal.name}',
        actorType: 'staff',
        sourceTable: 'meals',
        recordId: meal.id,
        metadata: {'meal_name': meal.name},
      );
    }
  }

  void requestConfirmation() {
    if (state.isEmpty) return;
    state = state.copyWith(step: OrderStep.confirming, error: null);
  }

  void cancelConfirmation() {
    state = state.copyWith(step: OrderStep.browsing, error: null);
  }

  void changeMeal() {
    state = state.copyWith(step: OrderStep.browsing, error: null);
  }

  Future<void> completeOrder(
    String staffId,
    String staffName, {
    String? description,
    String orderType = 'dine_in',
  }) async {
    if (state.isEmpty) return;

    state = state.copyWith(step: OrderStep.processing, error: null);

    try {
      final meal = state.selectedMeal!;
      final now = DateTime.now().toIso8601String();
      final orderId = const Uuid().v4();
      final orderCode = _generateOrderCode();
      final orderItemId = const Uuid().v4();

      final nowDateTime = DateTime.now();
      final todayPrefix =
          '${nowDateTime.year}-${_pad(nowDateTime.month)}-${_pad(nowDateTime.day)}';

      final isOvercharge = await _isDuplicateMealTypeToday(
        staffId: staffId,
        mealType: meal.mealType,
        todayPrefix: todayPrefix,
      );

      final order = OrdersCompanion(
        id: Value(orderId),
        orderCode: Value(orderCode),
        status: const Value('completed'),
        orderType: Value(orderType),
        mealType: Value(meal.mealType),
        total: Value(meal.price),
        groupCount: const Value(1),
        description: Value(description ?? meal.name),
        orderedById: Value(staffId),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(0),
        syncUpdatedAt: const Value.absent(),
      );

      final orderItem = OrderItemsCompanion(
        id: Value(orderItemId),
        price: Value(meal.price),
        qty: const Value(1),
        mealId: Value(meal.id),
        orderId: Value(orderId),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(0),
        syncUpdatedAt: const Value.absent(),
      );

      await _db.insertOrder(order, [orderItem]);

      ref.invalidate(reportOrdersProvider);

      if (isOvercharge) {
        _recordOvercharge(orderCode: orderCode, meal: meal, staffId: staffId);
      }

      await _printReceipt(
        orderCode: orderCode,
        mealName: meal.name,
        price: meal.price,
        staffName: staffName,
        description: description,
        orderType: orderType,
      );

      state = state.copyWith(
        step: OrderStep.completed,
        lastOrderCode: orderCode,
      );

      getIt<ActivityLogService>().log(
        type: 'order_placed',
        message: 'Order placed: $orderCode — ${meal.name}',
        actorType: 'staff',
        actorId: staffId,
        actorName: staffName,
        sourceTable: 'orders',
        recordId: orderId,
        metadata: {
          'order_code': orderCode,
          'meal_id': meal.id,
          'meal_name': meal.name,
          'meal_type': meal.mealType,
          'total': meal.price,
          'order_type': 'pos',
        },
      );
    } catch (e) {
      state = state.copyWith(
        step: OrderStep.browsing,
        error: 'Failed to place order: $e',
      );
    }
  }

  Future<bool> _isDuplicateMealTypeToday({
    required String staffId,
    required String mealType,
    required String todayPrefix,
  }) async {
    final existing =
        await (_db.select(_db.orders)
              ..where(
                (o) =>
                    o.orderedById.equals(staffId) &
                    o.mealType.equals(mealType) &
                    o.createdAt.like('$todayPrefix%'),
              )
              ..limit(1))
            .get();
    return existing.isNotEmpty;
  }

  void _recordOvercharge({
    required String orderCode,
    required Meal meal,
    required String staffId,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      final overchargeId = const Uuid().v4();
      await _db.insertOvercharge(
        OverchargesCompanion(
          id: Value(overchargeId),
          mealType: Value(meal.mealType),
          orderCode: Value(orderCode),
          price: Value(meal.price),
          staffId: Value(staffId),
          mealId: Value(meal.id),
          createdAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value(0),
          syncUpdatedAt: Value(now),
        ),
      );
      getIt<ActivityLogService>().log(
        type: 'overcharge_recorded',
        message: 'Overcharge: $orderCode — ${meal.name} (${meal.mealType})',
        actorType: 'staff',
        actorId: staffId,
        sourceTable: 'overcharges',
        recordId: overchargeId,
        metadata: {
          'order_code': orderCode,
          'meal_name': meal.name,
          'meal_type': meal.mealType,
          'price': meal.price,
        },
      );
    } catch (e) {
      getIt<ActivityLogService>().log(
        type: 'overcharge_failed',
        message: 'Failed to record overcharge $orderCode: $e',
        sourceTable: 'overcharges',
        metadata: {'order_code': orderCode, 'error': e.toString()},
      );
    }
  }

  void reset() {
    state = const OrderState();
  }

  String _generateOrderCode() {
    final suffix = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000))
        .toString();
    return 'AGC$suffix';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  Future<void> _printReceipt({
    required String orderCode,
    required String mealName,
    required double price,
    required String staffName,
    required String orderType,
    String? description,
  }) async {
    try {
      final bytes = await _buildReceipt(
        orderCode: orderCode,
        mealName: mealName,
        price: price,
        staffName: staffName,
        description: description,
        orderType: orderType,
      );
      final printed = await _printer.printRawBytes(bytes);
      dev.log(
        '[OrderController] printRawBytes result: $printed',
        name: 'POS_AUTH',
      );
      if (printed) {
        await _printer.cutPaper();
        dev.log('[OrderController] Receipt cut', name: 'POS_AUTH');
      }
    } catch (e, st) {
      dev.log(
        '[OrderController] Print FAILED: $e',
        name: 'POS_AUTH',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<Uint8List> _buildReceipt({
    required String orderCode,
    required String mealName,
    required double price,
    required String staffName,
    required String orderType,
    String? description,
  }) async {
    final now = DateTime.now();
    final date =
        '${now.year}-${_pad(now.month)}-${_pad(now.day)} '
        '${_pad(now.hour)}:${_pad(now.minute)}';

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
    ln('===================='); 
    ln('');
    centerOn();
    boldOn();
    doubleOn();
    ln(orderCode);
    doubleOff();
    boldOff();
    // centerOff();
    ln('');
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
    // ln('');
    // ln('');
    ln('');

    return Uint8List.fromList(b.toBytes());
  }
}

final orderProvider = NotifierProvider<OrderController, OrderState>(
  OrderController.new,
);

import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../core/di/injection_container.dart';
import '../controllers/auth_controller.dart';
import '../services/activity_log_service.dart';
import '../services/database/app_database.dart';
import '../services/pos/pos_print_service.dart';

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
  PosPrintService get _printer => getIt<PosPrintService>();

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
      metadata: {'meal_name': meal.name, 'meal_type': meal.mealType, 'price': meal.price},
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

  Future<void> completeOrder(String staffId, String staffName,
      {String? description}) async {
    if (state.isEmpty) return;

    state = state.copyWith(step: OrderStep.processing, error: null);

    try {
      final meal = state.selectedMeal!;
      final now = DateTime.now().toIso8601String();
      final orderId = const Uuid().v4();
      final orderCode = _generateOrderCode();
      final orderItemId = const Uuid().v4();

      final order = OrdersCompanion(
        id: Value(orderId),
        orderCode: Value(orderCode),
        status: const Value('completed'),
        orderType: const Value('pos'),
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

      await _printReceipt(orderCode, description ?? meal.name, meal.price, staffName);

      state = state.copyWith(
        step: OrderStep.completed,
        lastOrderCode: orderCode,
      );
      ref.read(authProvider.notifier).completeOrder();

    } catch (e) {
      state = state.copyWith(
        step: OrderStep.browsing,
        error: 'Failed to place order: $e',
      );
    }
  }

  void reset() {
    state = const OrderState();
  }

  String _generateOrderCode() {
    final now = DateTime.now();
    final day = '${now.year}${_pad(now.month)}${_pad(now.day)}';
    final time = '${_pad(now.hour)}${_pad(now.minute)}${_pad(now.second)}';
    return 'POS-$day-$time';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  Future<void> _printReceipt(
    String orderCode,
    String mealName,
    double price,
    String staffName,
  ) async {
    try {
      final bytes = await _buildReceipt(orderCode, mealName, price, staffName);
      await _printer.printRawBytes(bytes);
    } catch (_) {}
  }

  Future<Uint8List> _buildReceipt(
    String orderCode,
    String mealName,
    double price,
    String staffName,
  ) async {
    final now = DateTime.now();
    final date = '${now.year}-${_pad(now.month)}-${_pad(now.day)} '
        '${_pad(now.hour)}:${_pad(now.minute)}';

    final buffer = StringBuffer();
    buffer.writeln('====================');
    buffer.writeln('    AGC CANTEEN');
    buffer.writeln('====================');
    buffer.writeln('Order: $orderCode');
    buffer.writeln('Time:  $date');
    buffer.writeln('Staff: $staffName');
    buffer.writeln('--------------------');
    buffer.writeln('1x  $mealName');
    buffer.writeln('     \$${price.toStringAsFixed(2)}');
    buffer.writeln('--------------------');
    buffer.writeln('TOTAL: \$${price.toStringAsFixed(2)}');
    buffer.writeln('====================');
    buffer.writeln('     THANK YOU!');
    buffer.writeln('');
    buffer.writeln('');
    buffer.writeln('');

    return Uint8List.fromList(buffer.toString().codeUnits);
  }
}

final orderProvider =
    NotifierProvider<OrderController, OrderState>(OrderController.new);

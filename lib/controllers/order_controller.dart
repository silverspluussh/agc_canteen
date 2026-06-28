import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OrderStep { browsing }

class OrderState {
  final OrderStep step;

  const OrderState({this.step = OrderStep.browsing});
}

class OrderController extends Notifier<OrderState> {
  @override
  OrderState build() => const OrderState();
}

final orderProvider = NotifierProvider<OrderController, OrderState>(
  OrderController.new,
);

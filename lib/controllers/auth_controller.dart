import 'dart:async';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../core/di/injection_container.dart';
import '../services/database/activity_log_service.dart';
import '../services/auth/pos_auth_service.dart';
import '../services/database/app_database.dart';
import '../services/print/print_service_manager.dart';
import '../services/sync_services/sync_service.dart';
import 'providers.dart';

enum AuthStep {
  unauthenticated,
  authenticating,
  placingOrder,
  completed,
  error,
}

class AuthState {
  final AuthStep step;
  final StaffAuthResult? staff;
  final String? error;
  final String? orderCode;
  final String? mealType;
  final String? orderTime;

  const AuthState({
    this.step = AuthStep.unauthenticated,
    this.staff,
    this.error,
    this.orderCode,
    this.mealType,
    this.orderTime,
  });

  AuthState copyWith({
    AuthStep? step,
    StaffAuthResult? staff,
    String? error,
    String? orderCode,
    String? mealType,
    String? orderTime,
    bool clearStaff = false,
  }) {
    return AuthState(
      step: step ?? this.step,
      staff: clearStaff ? null : (staff ?? this.staff),
      error: error ?? this.error,
      orderCode: orderCode ?? this.orderCode,
      mealType: mealType ?? this.mealType,
      orderTime: orderTime ?? this.orderTime,
    );
  }

  bool get isUnauthenticated => step == AuthStep.unauthenticated;
  bool get isAuthenticating => step == AuthStep.authenticating;
  bool get isPlacingOrder => step == AuthStep.placingOrder;
  bool get isCompleted => step == AuthStep.completed;
  bool get hasError => step == AuthStep.error;
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> authenticate() async {
    dev.log(
      '[AuthController] authenticate() called — setting state to authenticating',
      name: 'POS_AUTH',
    );
    state = state.copyWith(step: AuthStep.authenticating, error: null);

    try {
      final posAuth = ref.read(posAuthProvider);

      dev.log(
        '[AuthController] Calling posAuth.authenticateWithFingerprint()',
        name: 'POS_AUTH',
      );
      final result = await posAuth.authenticateWithFingerprint();

      dev.log(
        '[AuthController] authenticateWithFingerprint returned: '
        'result=${result.isAuthenticated ? "staffId=${result.staffId}, name=${result.firstName} ${result.lastName}" : "failure=${result.failureReason?.name}"}',
        name: 'POS_AUTH',
      );

      if (!result.isAuthenticated) {
        final reason = result.failureReason;
        final errorMessage = switch (reason) {
          AuthFailureReason.notEnrolled =>
            'Fingerprint not recognized. Please enroll your fingerprint.',
          AuthFailureReason.notInKitchen =>
            'Staff is not assigned to this kitchen.',
          null => 'Authentication failed.',
        };
        dev.log(
          '[AuthController] Auth failed ($reason) — setting error state',
          name: 'POS_AUTH',
        );
        getIt<ActivityLogService>().log(
          type: 'staff_auth_failure',
          message: 'Staff authentication failed: ${reason?.name ?? "unknown"}',
          actorType: 'staff',
          metadata: {'reason': reason?.name},
        );
        state = state.copyWith(step: AuthStep.error, error: errorMessage);
        return;
      }

      dev.log(
        '[AuthController] Auth SUCCESS — placing order immediately',
        name: 'POS_AUTH',
      );
      state = state.copyWith(staff: result);

      getIt<ActivityLogService>().log(
        type: 'staff_auth_success',
        message: 'Staff authenticated: ${result.firstName} ${result.lastName}',
        actorType: 'staff',
        actorId: result.staffId,
        actorName: '${result.firstName} ${result.lastName}',
      );

      await _placeVoucherOrder(result);
    } catch (e, st) {
      dev.log(
        '[AuthController] Auth EXCEPTION: $e',
        name: 'POS_AUTH',
        error: e,
        stackTrace: st,
      );
      getIt<ActivityLogService>().log(
        type: 'staff_auth_failure',
        message: 'Staff authentication error: $e',
        actorType: 'staff',
        metadata: {'reason': 'exception', 'error': e.toString()},
      );
      state = state.copyWith(step: AuthStep.error, error: e.toString());
    }
  }

  Future<void> _placeVoucherOrder(StaffAuthResult staff) async {
    state = state.copyWith(step: AuthStep.placingOrder);

    try {
      final db = getIt<AppDatabase>();
      final printer = getIt<PrintServiceManager>();
      final sync = getIt<SyncService>();

      final result = await _resolveCurrentMealType(db);
      if (result == null) {
        state = state.copyWith(
          step: AuthStep.error,
          error: 'No meal type available at this time.',
        );
        return;
      }
      final (mealType, price) = result;

      final now = DateTime.now();
      final nowIso = now.toIso8601String();
      final orderId = DateTime.now().millisecondsSinceEpoch;
      final orderCode = await db.nextOrderCode();
      final staffName = '${staff.firstName} ${staff.lastName}';

      await db.insertOrder(
        OrdersCompanion(
          id: Value(orderId),
          uuid: Value(const Uuid().v4()),
          orderCode: Value(orderCode),
          status: const Value('completed'),
          orderType: const Value('single'),
          mealType: Value(mealType),
          total: Value(price),
          groupCount: const Value(1),
          description: Value(mealType),
          orderedById: Value(staff.staffId!),
          createdAt: Value(nowIso),
          updatedAt: Value(nowIso),
          syncStatus: const Value(0),
          syncUpdatedAt: const Value.absent(),
        ),
      );

      unawaited(sync.syncSingleOrders());

      await _printVoucher(
        printer: printer,
        orderCode: orderCode,
        staffName: staffName,
        mealType: mealType,
        orderTime: now,
      );

      getIt<ActivityLogService>().log(
        type: 'order_placed',
        message: 'Voucher printed: $orderCode — $staffName ($mealType)',
        actorType: 'staff',
        actorId: staff.staffId,
        actorName: staffName,
        sourceTable: 'orders',
        recordId: orderId.toString(),
        metadata: {
          'order_code': orderCode,
          'meal_type': mealType,
          'order_type': 'voucher_fingerprint',
        },
      );

      final pad = (int n) => n.toString().padLeft(2, '0');
      final timeLabel =
          '${pad(now.hour)}:${pad(now.minute)} '
          '${now.year}-${pad(now.month)}-${pad(now.day)}';

      state = state.copyWith(
        step: AuthStep.completed,
        orderCode: orderCode,
        mealType: mealType,
        orderTime: timeLabel,
      );
    } catch (e, st) {
      dev.log(
        '[AuthController] Place voucher order FAILED: $e',
        name: 'POS_AUTH',
        error: e,
        stackTrace: st,
      );
      state = state.copyWith(
        step: AuthStep.error,
        error: 'Failed to print voucher: $e',
      );
    }
  }

  Future<(String, double)?> _resolveCurrentMealType(AppDatabase db) async {
    final mealTypes = await db.getAllMealTypes();

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    for (final mt in mealTypes) {
      debugPrint(mt.toJsonString());
      if (mt.status != 'active') continue;

      TimeOfDay parse(String time) {
        final parts = time.trim().split(':');
        return TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 0,
          minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
        );
      }

      final start = parse(mt.beginTime);
      final end = parse(mt.endTime);
      final startMins = start.hour * 60 + start.minute;
      final endMins = end.hour * 60 + end.minute;

      bool active;
      if (startMins <= endMins) {
        active = currentMinutes >= startMins && currentMinutes < endMins;
      } else {
        active = currentMinutes >= startMins || currentMinutes < endMins;
      }

      if (active) return (mt.name.toLowerCase(), mt.price);
    }
    return null;
  }

  Future<void> _printVoucher({
    required PrintServiceManager printer,
    required String orderCode,
    required String staffName,
    required String mealType,
    required DateTime orderTime,
  }) async {
    final pad = (int n) => n.toString().padLeft(2, '0');
    final date =
        '${orderTime.year}-${pad(orderTime.month)}-${pad(orderTime.day)} '
        '${pad(orderTime.hour)}:${pad(orderTime.minute)}';

    final b = BytesBuilder();

    void ln(String s) => b.add('$s\n'.codeUnits);
    void boldOn() => b.add(const [0x1B, 0x45, 0x01]);
    void boldOff() => b.add(const [0x1B, 0x45, 0x00]);
    void centerOn() => b.add(const [0x1B, 0x61, 0x01]);
    void doubleOn() => b.add(const [0x1D, 0x21, 0x11]);
    void doubleOff() => b.add(const [0x1D, 0x21, 0x00]);

    final mealLabel =
        mealType[0].toUpperCase() + mealType.substring(1).replaceAll('_', ' ');

    centerOn();
    ln('====================');
    ln('    AGC CANTEEN');
    ln('====================');
    centerOn();
    boldOn();
    doubleOn();
    ln(orderCode);
    doubleOff();
    boldOff();
    ln('Time:  $date');
    ln('Staff: $staffName');
    ln('Meal:  $mealLabel');

    final bytes = Uint8List.fromList(b.toBytes());
    final printed = await printer.printRawBytes(bytes);
    if (printed) {
      await printer.cutPaper();
    }
  }

  void reset() {
    if (state.staff != null) {
      final staff = state.staff!;
      getIt<ActivityLogService>().log(
        type: 'staff_sign_out',
        message: 'Staff session reset: ${staff.firstName} ${staff.lastName}',
        actorType: 'staff',
        actorId: staff.staffId,
        actorName: '${staff.firstName} ${staff.lastName}',
      );
    }
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(step: AuthStep.unauthenticated, error: null);
  }
}

final authProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../core/di/injection_container.dart';
import '../core/utils/app_log.dart';
import '../services/database/activity_log_service.dart';
import '../services/auth/pos_auth_service.dart';
import '../services/database/app_database.dart';
import '../services/meal_time_service.dart';
import '../services/print/print_service_manager.dart';
import '../services/sync_services/sync_from_local_to_remote.dart';
import 'providers.dart';

enum AuthStep {
  unauthenticated,
  authenticating,
  authenticated,
  placingOrder,
  completed,
  error,
}

class AuthState {
  final AuthStep step;
  final AuthResult? staff;
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

  /// Sentinel used so [copyWith] can distinguish "error not passed" (keep
  /// the current value) from "error explicitly passed as null" (clear it).
  /// A plain `String? error` param can't tell those apart, since both look
  /// like `null` — which previously made `error: null` (used throughout
  /// this file, including `clearError()`) silently keep the old message.
  static const Object _unset = Object();

  AuthState copyWith({
    AuthStep? step,
    AuthResult? staff,
    Object? error = _unset,
    String? orderCode,
    String? mealType,
    String? orderTime,
    bool clearStaff = false,
  }) {
    return AuthState(
      step: step ?? this.step,
      staff: clearStaff ? null : (staff ?? this.staff),
      error: identical(error, _unset) ? this.error : error as String?,
      orderCode: orderCode ?? this.orderCode,
      mealType: mealType ?? this.mealType,
      orderTime: orderTime ?? this.orderTime,
    );
  }

  bool get isUnauthenticated => step == AuthStep.unauthenticated;
  bool get isAuthenticating => step == AuthStep.authenticating;
  bool get isStaffReady => step == AuthStep.authenticated;
  bool get isPlacingOrder => step == AuthStep.placingOrder;
  bool get isCompleted => step == AuthStep.completed;
  bool get hasError => step == AuthStep.error;
}

class AuthController extends Notifier<AuthState> {
  int _authSessionId = 0;

  @override
  AuthState build() => const AuthState();

  /// Cancels any in-progress authentication and resets state to [AuthStep.unauthenticated].
  Future<void> cancel() async {
    _authSessionId++;
    final posAuth = ref.read(posAuthProvider);
    await posAuth.cancelAuth();
    state = const AuthState();
  }

  Future<void> authenticate({int? departmentId}) async {
    final sessionId = _authSessionId;
    appLog(
      '[AuthController] authenticate(departmentId=$departmentId) called — setting state to authenticating',
      name: 'POS_AUTH',
    );
    state = state.copyWith(step: AuthStep.authenticating, error: null);

    try {
      final posAuth = ref.read(posAuthProvider);

      appLog(
        '[AuthController] Calling posAuth.authenticateWithFingerprint()',
        name: 'POS_AUTH',
      );
      final result = await posAuth.authenticateWithFingerprint(departmentId: departmentId);
      if (sessionId != _authSessionId) return;

      appLog(
        '[AuthController] authenticateWithFingerprint returned: '
        'result=${result.isAuthenticated ? "entityId=${result.entityId}, type=${result.entityType?.name}, name=${result.displayName}" : "failure=${result.failureReason?.name}"}',
        name: 'POS_AUTH',
      );

      if (!result.isAuthenticated) {
        final reason = result.failureReason;
        final errorMessage = switch (reason) {
          AuthFailureReason.notEnrolled =>
            'Fingerprint not recognized. Please enroll your fingerprint.',
          AuthFailureReason.entityNotFound =>
            'Matched person record was not found locally. Please sync staff data.',
          null => 'Authentication failed.',
        };
        appLog(
          '[AuthController] Auth failed ($reason) — setting error state',
          name: 'POS_AUTH',
        );
        getIt<ActivityLogService>().log(
          type: 'staff_auth_failure',
          message: 'Staff authentication failed: ${reason?.name ?? "unknown"}',
          actorType: 'Staff',
          metadata: {'reason': reason?.name},
        );
        state = state.copyWith(step: AuthStep.error, error: errorMessage);
        return;
      }

      appLog(
        '[AuthController] Auth SUCCESS — placing order immediately',
        name: 'POS_AUTH',
      );
      state = state.copyWith(staff: result);

      getIt<ActivityLogService>().log(
        type: 'staff_auth_success',
        message: 'Authenticated: ${result.displayName}',
        actorType: result.entityType?.entityName ?? 'Staff',
        actorId: result.entityId,
        actorName: result.displayName,
      );

      await _placeVoucherOrder(result);
    } catch (e, st) {
      appLog(
        '[AuthController] Auth EXCEPTION: $e',
        name: 'POS_AUTH',
        error: e,
        stackTrace: st,
      );
      getIt<ActivityLogService>().log(
        type: 'staff_auth_failure',
        message: 'Staff authentication error: $e',
        actorType: 'Staff',
        metadata: {'reason': 'exception', 'error': e.toString()},
      );
      state = state.copyWith(step: AuthStep.error, error: e.toString());
    }
  }

  /// Authenticates via NFC and places a voucher order.
  Future<void> authenticateWithNfc({int? departmentId}) async {
    final sessionId = _authSessionId;
    state = state.copyWith(step: AuthStep.authenticating, error: null);

    try {
      final posAuth = ref.read(posAuthProvider);
      final result = await posAuth.authenticateWithNfc(departmentId: departmentId);
      if (sessionId != _authSessionId) return;

      if (!result.isAuthenticated) {
        final reason = result.failureReason;
        final errorMessage = switch (reason) {
          AuthFailureReason.notEnrolled =>
            'Card not recognized. Please register your NFC card.',
          AuthFailureReason.entityNotFound =>
            'Card holder record was not found locally. Please sync staff data.',
          null => 'Authentication failed.',
        };
        getIt<ActivityLogService>().log(
          type: 'nfc_auth_failure',
          message: 'NFC auth failed: ${reason?.name ?? "unknown"}',
          actorType: 'Staff',
          metadata: {'reason': reason?.name},
        );
        state = state.copyWith(step: AuthStep.error, error: errorMessage);
        return;
      }

      state = state.copyWith(staff: result);

      getIt<ActivityLogService>().log(
        type: 'nfc_auth_success',
        message: 'NFC authenticated: ${result.displayName}',
        actorType: result.entityType?.entityName ?? 'Staff',
        actorId: result.entityId,
        actorName: result.displayName,
      );

      await _placeNfcVoucherOrder(result);
    } catch (e, st) {
      appLog('[AuthController] NFC auth exception: $e', name: 'POS_AUTH', error: e, stackTrace: st);
      getIt<ActivityLogService>().log(
        type: 'nfc_auth_failure',
        message: 'NFC auth error: $e',
        actorType: 'Staff',
        metadata: {'reason': 'exception', 'error': e.toString()},
      );
      state = state.copyWith(step: AuthStep.error, error: e.toString());
    }
  }

  /// Authenticates via NFC without placing an order — stops at [AuthStep.authenticated].
  Future<void> authenticateWithNfcOnly({int? departmentId}) async {
    final sessionId = _authSessionId;
    state = state.copyWith(step: AuthStep.authenticating, error: null);

    try {
      final posAuth = ref.read(posAuthProvider);
      final result = await posAuth.authenticateWithNfc(departmentId: departmentId);
      if (sessionId != _authSessionId) return;

      if (!result.isAuthenticated) {
        final reason = result.failureReason;
        final errorMessage = switch (reason) {
          AuthFailureReason.notEnrolled =>
            'Card not recognized.',
          AuthFailureReason.entityNotFound =>
            'Card holder record was not found locally. Please sync staff data.',
          null => 'Authentication failed.',
        };
        state = state.copyWith(step: AuthStep.error, error: errorMessage);
        return;
      }

      state = state.copyWith(step: AuthStep.authenticated, staff: result);

      getIt<ActivityLogService>().log(
        type: 'nfc_auth_success',
        message: 'NFC authenticated: ${result.displayName}',
        actorType: result.entityType?.entityName ?? 'Staff',
        actorId: result.entityId,
        actorName: result.displayName,
      );
    } catch (e, st) {
      appLog('[AuthController] NFC auth exception: $e', name: 'POS_AUTH', error: e, stackTrace: st);
      state = state.copyWith(step: AuthStep.error, error: e.toString());
    }
  }

  /// Authenticates staff without placing an order — stops at [AuthStep.authenticated].
  Future<void> authenticateOnly({int? departmentId}) async {
    final sessionId = _authSessionId;
    state = state.copyWith(step: AuthStep.authenticating, error: null);

    try {
      final posAuth = ref.read(posAuthProvider);
      final result = await posAuth.authenticateWithFingerprint(departmentId: departmentId);
      if (sessionId != _authSessionId) return;

      if (!result.isAuthenticated) {
        final reason = result.failureReason;
        final errorMessage = switch (reason) {
          AuthFailureReason.notEnrolled =>
            'Fingerprint not recognized.',
          AuthFailureReason.entityNotFound =>
            'Matched person record was not found locally. Please sync staff data.',
          null => 'Authentication failed.',
        };
        state = state.copyWith(step: AuthStep.error, error: errorMessage);
        return;
      }

      state = state.copyWith(step: AuthStep.authenticated, staff: result);

      getIt<ActivityLogService>().log(
        type: 'staff_auth_success',
        message: 'Authenticated: ${result.displayName}',
        actorType: result.entityType?.entityName ?? 'Staff',
        actorId: result.entityId,
        actorName: result.displayName,
      );
    } catch (e, st) {
      appLog('[AuthController] Auth exception: $e', name: 'POS_AUTH', error: e, stackTrace: st);
      state = state.copyWith(step: AuthStep.error, error: e.toString());
    }
  }

  Future<void> _placeVoucherOrder(AuthResult staff) async {
    state = state.copyWith(step: AuthStep.placingOrder);

    try {
      final db = getIt<AppDatabase>();
      final printer = getIt<PrintServiceManager>();
      final sync = getIt<LocalToRemoteSyncService>();

      final result = await _resolveCurrentMealType(db);
      if (result == null) {
        state = state.copyWith(
          step: AuthStep.error,
          error: 'No meals available at this time. Please try again later.',
        );
        return;
      }
      final (mealTypeId, mealType, price) = result;

      // Check shift meal restrictions for staff-type employees
      if (staff.entityType != null && staff.entityType!.isStaffType) {
        final staffData = await db.getStaff(staff.entityId!);
        if (staffData != null && staffData.shiftId != null) {
          final allowedMealTypeIds = await db.getShiftMealTypeIds(staffData.shiftId!);
          if (allowedMealTypeIds.isNotEmpty && !allowedMealTypeIds.contains(mealTypeId)) {
            final shiftName = (await db.getShift(staffData.shiftId!))?.name ?? 'assigned shift';
            state = state.copyWith(
              step: AuthStep.error,
              error: 'This meal is not allowed for your $shiftName shift.',
            );
            return;
          }
        }
      }

      final now = DateTime.now();
      final nowIso = now.toIso8601String();
      final orderId = DateTime.now().millisecondsSinceEpoch;
      final posDevice = await _loadRegisteredPosDevice(db);
      if (posDevice == null) {
        state = state.copyWith(
          step: AuthStep.error,
          error: _posNotRegisteredError,
        );
        return;
      }
      final orderCode = await db.nextOrderCode(
        staff.entityType?.entityName.substring(0, 1) ?? '',
        posDevice.id,
        posDevice.kitchenId!,
      );
      final staffName = staff.displayName ?? 'Unknown';

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
          orderedById: Value(staff.entityId!),
          employeeType: Value(staff.entityType!.name),
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
        actorType: staff.entityType?.entityName ?? 'Staff',
        actorId: staff.entityId,
        actorName: staffName,
        sourceTable: 'orders',
        recordId: orderId.toString(),
        metadata: {
          'order_code': orderCode,
          'meal_type': mealType,
          'order_type': 'voucher_fingerprint',
        },
      );

      String pad(int n) => n.toString().padLeft(2, '0');
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
      appLog(
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

  static const _posNotRegisteredError =
      'POS device is not registered. Please complete device setup in Settings.';

  Future<PosDevice?> _loadRegisteredPosDevice(AppDatabase db) async {
    final posDevice = (await db.getAllPosDevices()).firstOrNull;
    if (posDevice == null || posDevice.kitchenId == null) return null;
    return posDevice;
  }

  Future<(int, String, double)?> _resolveCurrentMealType(AppDatabase db) async {
    final mealTypes = await db.getAllMealTypes();
    return resolveActiveMealType(mealTypes);
  }

  Future<void> _placeNfcVoucherOrder(AuthResult staff) async {
    state = state.copyWith(step: AuthStep.placingOrder);

    try {
      final db = getIt<AppDatabase>();
      final printer = getIt<PrintServiceManager>();
      final sync = getIt<LocalToRemoteSyncService>();

      final result = await _resolveCurrentMealType(db);
      if (result == null) {
        state = state.copyWith(
          step: AuthStep.error,
          error: 'No meals available at this time. Please try again later.',
        );
        return;
      }
      final (mealTypeId, mealType, price) = result;

      // Check shift meal restrictions for staff-type employees
      if (staff.entityType != null && staff.entityType!.isStaffType) {
        final staffData = await db.getStaff(staff.entityId!);
        if (staffData != null && staffData.shiftId != null) {
          final allowedMealTypeIds = await db.getShiftMealTypeIds(staffData.shiftId!);
          if (allowedMealTypeIds.isNotEmpty && !allowedMealTypeIds.contains(mealTypeId)) {
            final shiftName = (await db.getShift(staffData.shiftId!))?.name ?? 'assigned shift';
            state = state.copyWith(
              step: AuthStep.error,
              error: 'This meal is not allowed for your $shiftName shift.',
            );
            return;
          }
        }
      }

      final now = DateTime.now();
      final nowIso = now.toIso8601String();
      final orderId = DateTime.now().millisecondsSinceEpoch;
      final posDevice = await _loadRegisteredPosDevice(db);
      if (posDevice == null) {
        state = state.copyWith(
          step: AuthStep.error,
          error: _posNotRegisteredError,
        );
        return;
      }
      final orderCode = await db.nextOrderCode(
        staff.entityType?.entityName.substring(0, 1) ?? '',
        posDevice.id,
        posDevice.kitchenId!,
      );
      final staffName = staff.displayName ?? 'Unknown';

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
          orderedById: Value(staff.entityId!),
          employeeType: Value(staff.entityType!.name),
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
        actorType: staff.entityType?.entityName ?? 'Staff',
        actorId: staff.entityId,
        actorName: staffName,
        sourceTable: 'orders',
        recordId: orderId.toString(),
        metadata: {
          'order_code': orderCode,
          'meal_type': mealType,
          'order_type': 'voucher_nfc',
        },
      );

      String pad(int n) => n.toString().padLeft(2, '0');
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
      appLog('[AuthController] Place NFC voucher order FAILED: $e', name: 'POS_AUTH', error: e, stackTrace: st);
      state = state.copyWith(
        step: AuthStep.error,
        error: 'Failed to print voucher: $e',
      );
    }
  }

  Future<void> _printVoucher({
    required PrintServiceManager printer,
    required String orderCode,
    required String staffName,
    required String mealType,
    required DateTime orderTime,
  }) async {
    String pad(int n) => n.toString().padLeft(2, '0');
    final date =
        '${orderTime.year}-${pad(orderTime.month)}-${pad(orderTime.day)} '
        '${pad(orderTime.hour)}:${pad(orderTime.minute)}';

    final b = BytesBuilder();

    void ln(String s) => b.add('$s\n'.codeUnits);
    void boldOn() => b.add(const [0x1B, 0x45, 0x01]);
    void boldOff() => b.add(const [0x1B, 0x45, 0x00]);
    void centerOn() => b.add(const [0x1B, 0x61, 0x01]);

    final mealLabel =
        mealType[0].toUpperCase() + mealType.substring(1).replaceAll('_', ' ');

    centerOn();
    ln('====================');
    ln('    ASG CANTEEN');
    ln('====================');
    centerOn();
    boldOn();
    ln(orderCode);
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
      unawaited( getIt<ActivityLogService>().log(
        type: 'staff_sign_out',
        message: 'Session reset: ${staff.displayName}',
        actorType: staff.entityType?.entityName ?? 'Staff',
        actorId: staff.entityId,
        actorName: staff.displayName,
      ));
     
    }
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(step: AuthStep.unauthenticated, error: null);
  }

  void setOrderDetails({
    String? orderCode,
    String? mealType,
    String? orderTime,
  }) {
    state = state.copyWith(
      step: AuthStep.completed,
      orderCode: orderCode ?? state.orderCode,
      mealType: mealType ?? state.mealType,
      orderTime: orderTime ?? state.orderTime,
    );
  }
}

final authProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

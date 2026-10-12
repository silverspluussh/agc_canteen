import 'dart:developer';

import 'package:agc_canteen/core/network/api_exceptions_util.dart';
import 'package:agc_canteen/core/network/network_api_dio.dart';
import 'package:agc_canteen/models/work_function.model.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Read/push access for the function-order flow.
///
/// The active-function list is cached locally so the picker works offline, and
/// refreshed from the server whenever a sync runs.
class FunctionOrderRepository {
  final AppDatabase db;
  final NetworkAPI networkAPI;

  FunctionOrderRepository({required this.db, required this.networkAPI});

  // ─── Work functions ──────────────────────────────────────────────────

  /// Pulls today's scheduled functions (with their orderable state, guest
  /// allowance and issued counts) and replaces the cache.
  ///
  /// Returns the number of functions cached, or rethrows when offline (the
  /// existing cache is left untouched so the POS can keep trading on
  /// stale-but-valid data and still enforce the window locally).
  Future<int?> syncActiveWorkFunctions() async {
    try {
      final response = await networkAPI.getData<Map<String, dynamic>>(
        '/hr/work-functions/schedule',
        builder: (data) => data as Map<String, dynamic>,
      );

      final raw = response['data'];
      final list = raw is Map && raw['workFunctions'] is List
          ? raw['workFunctions'] as List<dynamic>
          : (raw is List ? raw : const <dynamic>[]);

      final rows = list
          .whereType<Map<String, dynamic>>()
          .map(WorkFunctionModel.fromMap)
          .map(
            (fn) => WorkFunctionsCompanion.insert(
              id: Value(fn.id),
              functionName: fn.functionName,
              functionLocation: Value(fn.functionLocation),
              catererId: Value(fn.catererId),
              ratePerVoucher: Value(fn.ratePerVoucher),
              totalQuantity: Value(fn.totalQuantity),
              functionDate: fn.functionDate,
              functionStartTime: fn.functionStartTime,
              functionEndTime: fn.functionEndTime,
              status: fn.status,
              guestAllowance: Value(fn.guestAllowance),
              guestIssued: Value(fn.guestIssued),
              state: Value(fn.state),
              preparedAt: Value(fn.preparedAt),
              syncStatus: const Value(2),
              syncUpdatedAt: Value(DateTime.now().toIso8601String()),
            ),
          )
          .toList();

      await db.replaceWorkFunctions(rows);

      return rows.length;
    } on APIException catch (e) {
      log('FunctionOrderRepository: work function schedule pull failed (${e.message})');
      rethrow;
    }
  }

  /// Today's cached functions regardless of window, so the picker can show their
  /// state (open / upcoming / closed).
  Future<List<WorkFunctionModel>> todaysFunctions({DateTime? now}) async {
    final rows = await db.getTodaysWorkFunctions(now);
    return rows.map(_toModel).toList();
  }

  // ─── Function orders ────────────────────────────────────────────────

  /// Records a function order locally and queues it for sync.
  ///
  /// [ratePerVoucher] is snapshotted here rather than trusted later, so a later
  /// change to the function's rate cannot alter this order. The POS owns the
  /// voucher identity: the printed code is derived from a fresh uuid so two
  /// devices can never mint the same code and the server stores it as-is.
  Future<int> createFunctionOrder({
    required WorkFunctionModel function,
    required int orderedById,
    required String employeeType,
    required String mealType,
    int quantity = 1,
    String? description,
    bool isGuest = false,
    String? guestName,
  }) async {
    final now = DateTime.now();
    final id = await db.nextLocalId('function_orders');
    final uuid = const Uuid().v4();
    final orderCode =
        'FN-${uuid.replaceAll('-', '').substring(0, 12).toUpperCase()}';
    final rate = function.ratePerVoucher;
    final iso = now.toIso8601String();

    await db.insertFunctionOrder(
      FunctionOrdersCompanion.insert(
        id: Value(id),
        uuid: uuid,
        orderCode: orderCode,
        functionId: function.id,
        functionName: function.functionName,
        status: 'completed',
        mealType: mealType,
        quantity: Value(quantity),
        rate: Value(rate),
        total: Value(rate * quantity),
        description: Value(description ?? mealType),
        orderedById: orderedById,
        employeeType: employeeType,
        isGuest: Value(isGuest),
        guestName: Value(guestName),
        createdAt: iso,
        updatedAt: iso,
        syncStatus: const Value(0),
      ),
    );

    return id;
  }

  /// Whether this person already has a registered voucher for the function,
  /// per the synced issued-person set plus this device's optimistic inserts.
  Future<bool> hasIssuedVoucher({
    required int functionId,
    required String employeeType,
    required int personId,
  }) =>
      db.hasIssuedPerson(functionId, employeeType, personId);

  /// Optimistically records that this device issued a voucher for a person, so
  /// the local one-per-person check holds before the next sync.
  Future<void> recordIssuedPerson({
    required int functionId,
    required String employeeType,
    required int personId,
  }) =>
      db.insertIssuedPerson(
        FunctionIssuedPersonsCompanion.insert(
          functionId: functionId,
          employeeType: employeeType,
          personId: personId,
        ),
      );

  /// Remaining guest vouchers for a function (soft cap: permissive).
  Future<int> guestRemaining(WorkFunctionModel function) async {
    final pending = await db.countLocalPendingGuestOrders(function.id);
    final remaining = function.guestAllowance - function.guestIssued - pending;
    return remaining < 0 ? 0 : remaining;
  }

  WorkFunctionModel _toModel(WorkFunction row) {
    return WorkFunctionModel(
      id: row.id,
      functionName: row.functionName,
      functionLocation: row.functionLocation,
      catererId: row.catererId,
      ratePerVoucher: row.ratePerVoucher,
      totalQuantity: row.totalQuantity,
      functionDate: row.functionDate,
      functionStartTime: row.functionStartTime,
      functionEndTime: row.functionEndTime,
      status: row.status,
      guestAllowance: row.guestAllowance,
      guestIssued: row.guestIssued,
      state: row.state,
      preparedAt: row.preparedAt,
    );
  }
}

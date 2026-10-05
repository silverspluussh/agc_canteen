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

  /// Pulls the functions that can be ordered right now and replaces the cache.
  ///
  /// Returns the number of functions cached, or null when offline (the existing
  /// cache is left untouched so the POS can keep trading on stale-but-valid
  /// data and still enforce the window locally).
  Future<int?> syncActiveWorkFunctions() async {
    try {
      final response = await networkAPI.getData<Map<String, dynamic>>(
        '/hr/work-functions/active',
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
              syncStatus: const Value(2),
              syncUpdatedAt: Value(DateTime.now().toIso8601String()),
            ),
          )
          .toList();

      await db.replaceWorkFunctions(rows);

      return rows.length;
    } on APIException catch (e) {
      log('FunctionOrderRepository: active function pull failed (${e.message})');
      rethrow;
    }
  }

  /// Cached functions that are orderable at [now].
  Future<List<WorkFunctionModel>> orderableFunctions({DateTime? now}) async {
    final rows = await db.getOrderableWorkFunctions(now);
    return rows.map(_toModel).toList();
  }

  Future<WorkFunctionModel?> functionById(int id) async {
    final row = await db.getWorkFunction(id);
    return row == null ? null : _toModel(row);
  }

  // ─── Function orders ────────────────────────────────────────────────

  /// Records a function order locally and queues it for sync.
  ///
  /// [ratePerVoucher] is snapshotted here rather than trusted later, so a later
  /// change to the function's rate cannot alter this order.
  Future<int> createFunctionOrder({
    required WorkFunctionModel function,
    required int orderedById,
    required String employeeType,
    required String mealType,
    int quantity = 1,
    String? description,
    required int posId,
  }) async {
    final now = DateTime.now();
    final id = await db.nextLocalId('function_orders');
    final orderCode = await db.nextFunctionOrderCode(
      functionId: function.id,
      posId: posId,
    );
    final rate = function.ratePerVoucher;
    final iso = now.toIso8601String();

    await db.insertFunctionOrder(
      FunctionOrdersCompanion.insert(
        id: Value(id),
        uuid: const Uuid().v4(),
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
        createdAt: iso,
        updatedAt: iso,
        syncStatus: const Value(0),
      ),
    );

    return id;
  }

  Future<int> countTodayFor({
    required int personId,
    required String employeeType,
    DateTime? now,
  }) {
    final at = now ?? DateTime.now();
    final dayPrefix =
        '${at.year.toString().padLeft(4, '0')}-'
        '${at.month.toString().padLeft(2, '0')}-'
        '${at.day.toString().padLeft(2, '0')}';
    return db.countFunctionOrdersByPerson(
      personId: personId,
      employeeType: employeeType,
      dayPrefix: dayPrefix,
    );
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
    );
  }
}

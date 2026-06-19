import 'dart:convert';
import 'dart:developer';
import 'package:agc_canteen/core/network/api_exceptions_util.dart';
import 'package:drift/drift.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/app_database.dart';
import 'activity_log_service.dart';
import 'auth/admin_auth_service.dart';
import '../core/di/injection_container.dart';
import '../core/network/network_api_dio.dart';

enum SyncStatus { idle, syncing, success, error }

class SyncResult {
  final Map<String, int> pushed;
  final Map<String, int> pulled;
  final List<String> errors;

  const SyncResult({
    required this.pushed,
    required this.pulled,
    required this.errors,
  });

  bool get isSuccess => errors.isEmpty;
}

class SyncService {
  final AppDatabase _db;
  final NetworkAPI _networkAPI;
  final Connectivity _connectivity;
  final Logger _logger;

  static const _lastSyncKey = 'last_sync_timestamp';

  SyncService({
    required AppDatabase db,
    required NetworkAPI networkAPI,
    Connectivity? connectivity,
    Logger? logger,
  }) : _db = db,
       _networkAPI = networkAPI,
       _connectivity = connectivity ?? Connectivity(),
       _logger = logger ?? Logger();

  Future<DateTime?> get lastSync async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString(_lastSyncKey);
    return timestamp != null ? DateTime.tryParse(timestamp) : null;
  }

  Future<void> _saveLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
  }

  Future<SyncResult> syncAll() async {
    final pushed = <String, int>{};
    final pulled = <String, int>{};
    final errors = <String>[];

    if (!await isOnline) {
      getIt<ActivityLogService>().log(
        type: 'sync_offline',
        message: 'Sync aborted: no internet connection',
        metadata: {
          'errors': ['No internet connection'],
        },
      );
      return SyncResult(
        pushed: pushed,
        pulled: pulled,
        errors: ['No internet connection'],
      );
    }

    const tableOrder = [
      'sites',
      'kitchens',
      'menu_types',
      'meals',
      'staff',
      'users',
      'orders',
      'order_items',
      'group_orders',
      'group_order_items',
      'overcharges',
      'pos_devices',
    ];

    try {
      for (final table in tableOrder) {
        _logger.i('Syncing table: $table');

        final pushCount = await _pushTable(table);
        pushed[table] = pushCount;

        final pullCount = await _pullTable(table);
        pulled[table] = pullCount;
      }

      await _saveLastSync();
      final totalPushed = pushed.values.fold<int>(0, (a, b) => a + b);
      final totalPulled = pulled.values.fold<int>(0, (a, b) => a + b);
      _logger.i('Sync done: pushed=$totalPushed, pulled=$totalPulled');
      getIt<ActivityLogService>().log(
        type: 'sync_completed',
        message: 'Sync completed: $totalPushed pushed, $totalPulled pulled',
        metadata: {'pushed': totalPushed, 'pulled': totalPulled},
      );
    } catch (e, st) {
      _logger.e('Sync failed', error: e, stackTrace: st);
      errors.add(e.toString());
      getIt<ActivityLogService>().log(
        type: 'sync_failed',
        message: 'Sync failed: $e',
        metadata: {
          'errors': [e.toString()],
        },
      );
    }

    return SyncResult(pushed: pushed, pulled: pulled, errors: errors);
  }

  Future<SyncResult> syncSingleOrders() async {
    final pushed = <String, int>{};
    final pulled = <String, int>{};
    final errors = <String>[];

    if (!await isOnline) {
      return SyncResult(
        pushed: pushed,
        pulled: pulled,
        errors: ['No internet connection'],
      );
    }

    try {
      final orders = await _db.getUnsyncedOrders();
      if (orders.isEmpty) {
        return SyncResult(pushed: pushed, pulled: pulled, errors: errors);
      }

      final List<Map<String, dynamic>> payloads = [];
      for (final order in orders) {
        payloads.add(await _buildSingleOrderPayload(order));
      }
      try {
        await _networkAPI.postData(
          '/pos/order/create-bulk',
          data: {'orders': payloads},
          builder: (data) => data,
        );

        for (final order in orders) {
          await _db.markOrderSynced(order.id);
        }
        pushed['orders'] = orders.length;
      } on APIException catch (e) {
        _logger.w('Failed to push bulk orders: ${e.message}');
        for (final order in orders) {
          errors.add('Order ${order.orderCode}: ${e.message}');
          await _db.markOrderFailed(order.id);
        }
      } catch (e) {
        _logger.w('Failed to push bulk orders: $e');
        for (final order in orders) {
          errors.add('Order ${order.orderCode}: $e');
          await _db.markOrderFailed(order.id);
        }
      }

      await _saveLastSync();
    } catch (e) {
      errors.add(e.toString());
    }

    return SyncResult(pushed: pushed, pulled: pulled, errors: errors);
  }

  Future<SyncResult> syncGroupOrders() async {
    final pushed = <String, int>{};
    final pulled = <String, int>{};
    final errors = <String>[];

    if (!await isOnline) {
      return SyncResult(
        pushed: pushed,
        pulled: pulled,
        errors: ['No internet connection'],
      );
    }

    try {
      final groupOrders = await _db.getUnsyncedGroupOrders();
      int pushedCount = 0;

      for (final order in groupOrders) {
        try {
          final payload = await _buildGroupOrderPayload(order);
          await _networkAPI.postData(
            '/pos/order/create-group',
            data: payload,
            builder: (data) => data,
          );
          await _db.markGroupOrderSynced(order.id);
          pushedCount++;
        } catch (e) {
          _logger.w('Failed to push group order ${order.orderCode}: $e');
          errors.add('Group order ${order.orderCode}: $e');
          await _db.markGroupOrderFailed(order.id);
        }
      }

      pushed['group_orders'] = pushedCount;
      await _saveLastSync();
    } catch (e) {
      errors.add(e.toString());
    }

    return SyncResult(pushed: pushed, pulled: pulled, errors: errors);
  }

  Future<int> _resolveMealTypeIdFromMealId(String mealId) async {
    final meal = await _db.getMeal(mealId);
    if (meal != null && meal.mealTypeId.isNotEmpty) {
      return int.tryParse(meal.mealTypeId) ?? 0;
    }
    return 0;
  }

  Future<int> _resolveOrderedBy() async {
    try {
      final cachedEmail = await getIt<AdminAuthService>().getCachedEmail();
      if (cachedEmail != null) {
        final allUsers = await _db.getAllUsers();
        final match = allUsers.where(
          (u) => (u.email?.toLowerCase() ?? '') == cachedEmail.toLowerCase(),
        );
        if (match.isNotEmpty) {
          return int.tryParse(match.first.id) ?? 0;
        }
      }
    } catch (_) {}
    return 0;
  }

  Future<Map<String, dynamic>> _buildSingleOrderPayload(Order order) async {
    final items = await _db.getOrderItems(order.id);
    final posId = await _db.getAllPosDevices().then(
      (pos) => pos.firstOrNull?.id,
    );
    final mealTypeId = items.isNotEmpty
        ? await _resolveMealTypeIdFromMealId(items.first.mealId)
        : 0;
    return {
      'uuid': order.uuid,
      'orderType': order.orderType,
      'mealTypeId': mealTypeId,
      'total': order.total,
      'orderedBy': int.tryParse(order.orderedById) ?? 0,
      'description': order.description ?? '',
      'isAlaCarte': order.orderType == 'alacarte',
      'posProfileId': int.tryParse(posId ?? '') ?? 0,
      'createdAt':'',
      'items': items
          .map(
            (i) => {
              'mealId': int.tryParse(i.mealId) ?? 0,
              'unitPrice': i.price,
              'quantity': i.qty
            },
          )
          .toList(),
    };
  }

  Future<Map<String, dynamic>> _buildGroupOrderPayload(GroupOrder order) async {
    final items = await _db.getGroupOrderItems(order.id);
    final mealTypeId = items.isNotEmpty
        ? await _resolveMealTypeIdFromMealId(items.first.mealId)
        : 0;
    final posId = await _db.getAllPosDevices().then(
      (pos) => pos.firstOrNull?.id,
    );
    return {
      'uuid': order.uuid,
      'orderType': order.orderType,
      'mealTypeId': mealTypeId,
      'total': order.total,
      'orderedBy': await _resolveOrderedBy(),
      'items': items
          .map(
            (i) => {
              'mealId': int.tryParse(i.mealId) ?? 0,
              'unitPrice': i.price,
              'quantity': i.qty,
            },
          )
          .toList(),
      'posProfileId': int.tryParse(posId ?? '') ?? 0,
    };
  }

  Future<int> _pushTable(String table) async {
    final unsynced = await _getUnsyncedRecords(table);
    if (unsynced.isEmpty) return 0;

    int pushed = 0;
    for (final record in unsynced) {
      try {
        final data = _toJsonMap(record);
        final id = record['id'] as String? ?? '';
        if (id.isEmpty) continue;

        await _networkAPI.postData(
          '/api/sync/$table',
          data: data,
          builder: (data) => data,
        );
        await _markSynced(table, id);
        pushed++;
      } catch (e) {
        _logger.w('Failed to push $table record: $e');
        final id = record['id'] as String?;
        if (id != null) await _markFailed(table, id);
      }
    }
    return pushed;
  }

  Future<int> _pullTable(String table) async {
    final lastSyncVal = await lastSync;
    final queryParams = <String, dynamic>{};
    if (lastSyncVal != null) {
      queryParams['since'] = lastSyncVal.toIso8601String();
    }

    try {
      final responseData = await _networkAPI.getData(
        '/api/sync/$table',
        queryParameters: queryParams,
        builder: (data) => data,
      );

      final List<dynamic> records = responseData is List ? responseData : [];
      if (records.isEmpty) return 0;

      int pulled = 0;
      for (final record in records) {
        await _upsertTable(table, record as Map<String, dynamic>);
        pulled++;
      }
      return pulled;
    } catch (e) {
      _logger.w('Failed to pull $table: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> _getUnsyncedRecords(String table) async {
    switch (table) {
      case 'sites':
        return (await _db.getUnsyncedSites()).map(_rowToMap).toList();
      case 'kitchens':
        return (await _db.getUnsyncedKitchens()).map(_rowToMap).toList();
      case 'menu_types':
        return (await _db.getUnsyncedMenuTypes()).map(_rowToMap).toList();
      case 'meals':
        return (await _db.getUnsyncedMeals()).map(_rowToMap).toList();
      case 'staff':
        return (await _db.getUnsyncedStaff()).map(_rowToMap).toList();
      case 'users':
        return (await _db.getUnsyncedUsers()).map(_rowToMap).toList();
      case 'orders':
        return (await _db.getUnsyncedOrders()).map(_rowToMap).toList();
      case 'order_items':
        return (await _db.getUnsyncedOrderItems()).map(_rowToMap).toList();
      case 'overcharges':
        return (await _db.getUnsyncedOvercharges()).map(_rowToMap).toList();
      case 'pos_devices':
        return (await _db.getUnsyncedPosDevices()).map(_rowToMap).toList();
      case 'group_orders':
        return (await _db.getUnsyncedGroupOrders()).map(_rowToMap).toList();
      case 'group_order_items':
        return (await _db.getUnsyncedGroupOrderItems()).map(_rowToMap).toList();
      default:
        return [];
    }
  }

  Future<void> _markSynced(String table, String id) async {
    switch (table) {
      case 'sites':
        await _db.markSiteSynced(id);
      case 'kitchens':
        await _db.markKitchenSynced(id);
      case 'menu_types':
        await _db.markMenuTypeSynced(id);
      case 'meals':
        await _db.markMealSynced(id);
      case 'staff':
        await _db.markStaffSynced(id);
      case 'users':
        await _db.markUserSynced(id);
      case 'orders':
        await _db.markOrderSynced(id);
      case 'order_items':
        await _db.markOrderItemSynced(id);
      case 'overcharges':
        await _db.markOverchargeSynced(id);
      case 'pos_devices':
        await _db.markPosDeviceSynced();
        return;
      case 'group_orders':
        await _db.markGroupOrderSynced(id);
      case 'group_order_items':
        await _db.markGroupOrderItemSynced(id);
    }
  }

  Future<void> _markFailed(String table, String id) async {
    switch (table) {
      case 'sites':
        await _db.markSiteFailed(id);
      case 'kitchens':
        await _db.markKitchenFailed(id);
      case 'menu_types':
        await _db.markMenuTypeFailed(id);
      case 'meals':
        await _db.markMealFailed(id);
      case 'staff':
        await _db.markStaffFailed(id);
      case 'users':
        await _db.markUserFailed(id);
      case 'orders':
        await _db.markOrderFailed(id);
      case 'order_items':
        await _db.markOrderItemFailed(id);
      case 'overcharges':
        await _db.markOverchargeFailed(id);
      case 'pos_devices':
        await _db.markPosDeviceFailed();
        return;
      case 'group_orders':
        await _db.markGroupOrderFailed(id);
      case 'group_order_items':
        await _db.markGroupOrderItemFailed(id);
    }
  }

  Future<void> _upsertTable(String table, Map<String, dynamic> data) async {
    final now = DateTime.now().toIso8601String();

    switch (table) {
      case 'sites':
        await _db.insertSite(
          SitesCompanion(
            id: Value(data['id'] as String),
            name: Value(data['name'] as String),
            location: Value.absentIfNull(data['location'] as String?),
            noOfEmployees: Value(
              (data['no_of_employees'] as num?)?.toInt() ?? 0,
            ),
            isActive: Value((data['is_active'] as bool?) ?? true),
            startDate: Value.absentIfNull(data['start_date'] as String?),
            endDate: Value.absentIfNull(data['end_date'] as String?),
            createdAt: Value(data['created_at'] as String),
            updatedAt: Value(data['updated_at'] as String),
            syncStatus: const Value(2),
            syncUpdatedAt: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
      case 'kitchens':
        await _db.insertKitchen(
          KitchensCompanion(
            id: Value(data['id'] as String),
            name: Value(data['name'] as String),
            minTierRequired: Value((data['min_tier_required'] as num).toInt()),
            status: Value(data['status'] as String),
            companyId: Value(data['company_id'] as String),
            createdAt: Value(data['created_at'] as String),
            updatedAt: Value(data['updated_at'] as String),
            syncStatus: const Value(2),
            syncUpdatedAt: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
      case 'menu_types':
        await _db.insertMenuType(
          MenuTypesCompanion(
            id: Value(data['id'] as String),
            name: Value(data['name'] as String),
            remarks: Value.absentIfNull(data['remarks'] as String?),
            status: Value(data['status'] as String),
            createdAt: Value(data['created_at'] as String),
            updatedAt: Value(data['updated_at'] as String),
            syncStatus: const Value(2),
            syncUpdatedAt: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
      case 'meals':
        await _db.insertMeal(
          MealsCompanion(
            id: Value(data['id'] as String),
            name: Value(data['name'] as String),
            status: Value(data['status'] as String),
            mealType: Value(data['meal_type'] as String),
            mealTypeId: Value(data['meal_type_id'] as String? ?? ''),
            remarks: Value.absentIfNull(data['remarks'] as String?),
            price: Value((data['price'] as num).toDouble()),
            photoUrl: Value.absentIfNull(data['photo_url'] as String?),
            menuTypeId: Value(data['menu_type_id'] as String),
            createdAt: Value(data['created_at'] as String),
            updatedAt: Value(data['updated_at'] as String),
            syncStatus: const Value(2),
            syncUpdatedAt: Value(now),
          ),
          (data['kitchen_ids'] as List<dynamic>?)?.cast<String>() ?? [],
        );
      case 'staff':
        await _db.insertStaff(
          StaffCompanion(
            id: Value(data['id'] as String),
            firstName: Value(data['first_name'] as String),
            lastName: Value(data['last_name'] as String),
            phone: Value.absentIfNull(data['phone'] as String?),
            email: Value.absentIfNull(data['email'] as String?),
            syncStatus: const Value(2),
            syncUpdatedAt: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
      case 'users':
        await _db.insertUser(
          UsersCompanion(
            id: Value(data['id'] as String),
            firstName: Value(data['first_name'] as String),
            lastName: Value(data['last_name'] as String),
            email: Value.absentIfNull(data['email'] as String?),
            phone: Value.absentIfNull(data['phone'] as String?),
            role: Value(data['role'] as String),
            isActive: Value((data['is_active'] as bool?) ?? true),
            lastLoginAt: Value.absentIfNull(data['last_login_at'] as String?),
            actStartDate: Value.absentIfNull(data['act_start_date'] as String?),
            actEndDate: Value.absentIfNull(data['act_end_date'] as String?),
            createdAt: Value(data['created_at'] as String),
            updatedAt: Value(data['updated_at'] as String),
            syncStatus: const Value(2),
            syncUpdatedAt: Value(now),
          ),
          (data['kitchen_ids'] as List<dynamic>?)?.cast<String>() ?? [],
        );
      case 'orders':
        await _db.insertOrder(
          OrdersCompanion(
            id: Value(data['id'] as String),
            uuid: Value(data['uuid'] as String),
            orderCode: Value(data['order_code'] as String),
            status: Value(data['status'] as String),
            orderType: Value(data['order_type'] as String),
            mealType: Value(data['meal_type'] as String),
            total: Value((data['total'] as num).toDouble()),
            groupCount: Value((data['group_count'] as num).toInt()),
            description: Value.absentIfNull(data['description'] as String?),
            orderedById: Value(data['ordered_by_id'] as String),
            createdAt: Value(data['created_at'] as String),
            updatedAt: Value(data['updated_at'] as String),
            syncStatus: const Value(2),
            syncUpdatedAt: Value(now),
          ),
          (data['order_items'] as List<dynamic>?)?.map((item) {
                final i = item as Map<String, dynamic>;
                return OrderItemsCompanion(
                  id: Value(i['id'] as String),
                  price: Value((i['price'] as num).toDouble()),
                  qty: Value((i['qty'] as num).toInt()),
                  mealId: Value(i['meal_id'] as String),
                  orderId: Value(data['id'] as String),
                  createdAt: Value(i['created_at'] as String),
                  updatedAt: Value(i['updated_at'] as String),
                  syncStatus: const Value(2),
                  syncUpdatedAt: Value(now),
                );
              }).toList() ??
              [],
        );
      case 'overcharges':
        await _db.insertOvercharge(
          OverchargesCompanion(
            id: Value(data['id'] as String),
            mealType: Value(data['meal_type'] as String),
            orderCode: Value(data['order_code'] as String),
            price: Value((data['price'] as num).toDouble()),
            staffId: Value(data['staff_id'] as String),
            mealId: Value(data['meal_id'] as String),
            createdAt: Value(data['created_at'] as String),
            updatedAt: Value(data['updated_at'] as String),
            syncStatus: const Value(2),
            syncUpdatedAt: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
      case 'pos_devices':
        await _db.insertPosDevice(
          PosDevicesCompanion(
            id: Value(data['id'] as String),
            name: Value(data['name'] as String),
            serialNumber: Value(data['serial_number'] as String),
            model: Value.absentIfNull(data['model'] as String?),
            status: Value(data['status'] as String),
            macAddress: Value.absentIfNull(data['mac_address'] as String?),
            kitchenId: Value.absentIfNull(data['kitchen_id'] as String?),
            kitchenName: Value.absentIfNull(data['kitchen_name'] as String?),
            createdAt: Value(data['created_at'] as String),
            updatedAt: Value(data['updated_at'] as String),
            syncStatus: const Value(2),
            syncUpdatedAt: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
    }
  }

  Map<String, dynamic> _rowToMap(dynamic row) {
    final encoded = const JsonEncoder().convert(row.toJson());
    return const JsonDecoder().convert(encoded) as Map<String, dynamic>;
  }

  Map<String, dynamic> _toJsonMap(Map<String, dynamic> record) {
    final copy = Map<String, dynamic>.from(record);
    copy.remove('sync_status');
    copy.remove('sync_updated_at');
    return copy;
  }
}

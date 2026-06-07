import 'dart:async';

import 'package:drift/drift.dart';
import 'package:logger/logger.dart';

import '../core/network/network_api_dio.dart';
import 'database/app_database.dart';

typedef _SyncTask = Future<bool> Function();

class _SyncJob {
  final String name;
  final _SyncTask execute;

  const _SyncJob({required this.name, required this.execute});
}

class RemoteDataSyncService {
  final NetworkAPI _networkAPI;
  final AppDatabase _db;
  final Logger _logger;
  final List<_SyncJob> _jobs = [];

  RemoteDataSyncService({
    required NetworkAPI networkAPI,
    required AppDatabase db,
    Logger? logger,
  }) : _networkAPI = networkAPI,
       _db = db,
       _logger = logger ?? Logger() {
    _jobs.add(_SyncJob(name: 'staff', execute: _syncStaff));
    _jobs.add(_SyncJob(name: 'meals', execute: _syncMeals));
  }

  void registerSyncJob(String name, _SyncTask execute) {
    _jobs.add(_SyncJob(name: name, execute: execute));
  }

  Future<void> syncAll({bool background = true}) async {
    if (background) {
      unawaited(_runAll());
    } else {
      await _runAll();
    }
  }

  Future<void> syncStaffOnly() async {
    await _syncStaff();
  }

  Future<void> syncMealsOnly() async {
    await _syncMeals();
  }

  Future<void> _runAll() async {
    _logger.i('RemoteDataSyncService: starting background sync');
    for (final job in _jobs) {
      try {
        final updated = await job.execute();
        _logger.i(
          'RemoteDataSyncService: ${job.name} sync ${updated ? "updated" : "skipped (no remote data)"}',
        );
      } catch (e, _) {
        _logger.w('RemoteDataSyncService: ${job.name} sync failed ($e)');
      }
    }
    _logger.i('RemoteDataSyncService: background sync completed');
  }

  // ─── Staff Sync ────────────────────────────────────────────

  Future<bool> _syncStaff() async {
    try {
      _logger.i('RemoteDataSyncService: fetching remote staff...');
      final responseData = await _networkAPI.getData(
        '/hr/staffs',
        queryParameters: {'limit': '500', 'offset': '0'},
        builder: (data) => data,
      );

      List<dynamic>? staffList;
      if (responseData is List) {
        staffList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        staffList = responseData['data'] as List<dynamic>;
      } else if (responseData is Map && responseData['staffs'] is List) {
        staffList = responseData['staffs'] as List<dynamic>;
      }

      if (staffList == null || staffList.isEmpty) {
        _logger.w('RemoteDataSyncService: no remote staff data available');
        return false;
      }

      _logger.i(
        'RemoteDataSyncService: received ${staffList.length} remote staff records, upserting...',
      );

      await _db.transaction(() async {
        if (staffList?.isEmpty ?? true) {
          _logger.w(
            'RemoteDataSyncService: staff list is empty, skipping staff sync',
          );
          return;
        }
        for (final item in staffList!) {
          if (item is Map<String, dynamic>) {
            await _upsertStaffData(item);
          }
        }
      });

      _logger.i('RemoteDataSyncService: staff sync completed');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteDataSyncService: staff fetch failed ($e), keeping local data',
      );
      return false;
    }
  }

  Future<void> _upsertStaffData(Map<String, dynamic> staffMap) async {
    try {
      _logger.i('RemoteDataSyncService: upserting staff data: $staffMap');
      final staffId = staffMap['id']?.toString() ?? '';
      if (staffId.isEmpty) return;

      final now = DateTime.now().toIso8601String();
      final existing = await _db.getStaff(staffId);

      final companion = StaffCompanion(
        id: Value(staffId),
        firstName: Value(
          staffMap['first_name'] as String? ??
              staffMap['firstName'] as String? ??
              '',
        ),
        lastName: Value(
          staffMap['last_name'] as String? ??
              staffMap['lastName'] as String? ??
              '',
        ),
        phone: Value.absentIfNull(staffMap['phone'] as String?),
        email: Value.absentIfNull(staffMap['email'] as String?),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      if (existing != null) {
        await _db.updateStaff(staffId, companion);
      } else {
        await _db.insertStaff(companion, mode: InsertMode.insertOrReplace);
      }
    } catch (e, stack) {
      _logger.e(
        'RemoteDataSyncService: failed to upsert staff: $e',
        stackTrace: stack,
      );
    }
  }

  // ─── Meals & Menu Types Sync ───────────────────────────────

  Future<bool> _syncMeals() async {
    var anyUpdated = false;

    final menuTypesUpdated = await _syncMenuTypesFromRemote();
    final mealsUpdated = await _syncMealsFromRemote();

    anyUpdated = menuTypesUpdated || mealsUpdated;
    return anyUpdated;
  }

  Future<bool> _syncMenuTypesFromRemote() async {
    try {
      _logger.i('RemoteDataSyncService: fetching remote menu types...');
      final responseData = await _networkAPI.getData(
        '/caterer/menu-types',
        queryParameters: {
          'searchTerm': '',
          'limit': '100',
          'offset': '0',
          'status': '',
        },
        builder: (data) => data,
      );

      List<dynamic>? menuTypesList;
      if (responseData is List) {
        menuTypesList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        menuTypesList = responseData['data'] as List<dynamic>;
      }

      if (menuTypesList == null || menuTypesList.isEmpty) {
        _logger.w('RemoteDataSyncService: no remote menu types available');
        return false;
      }

      _logger.i(
        'RemoteDataSyncService: received ${menuTypesList.length} remote menu types, upserting...',
      );

      for (final item in menuTypesList) {
        if (item is Map<String, dynamic>) {
          await _upsertMenuTypeData(item);
        }
      }

      _logger.i('RemoteDataSyncService: menu types sync completed');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteDataSyncService: menu types fetch failed ($e), keeping local data',
      );
      return false;
    }
  }

  Future<void> _upsertMenuTypeData(Map<String, dynamic> menuTypeMap) async {
    try {
      final menuTypeId = menuTypeMap['id']?.toString() ?? '';
      if (menuTypeId.isEmpty) return;

      final companion = MenuTypesCompanion(
        id: Value(menuTypeId),
        name: Value(menuTypeMap['name'] as String? ?? 'Menu Type'),
        remarks: Value.absentIfNull(menuTypeMap['remarks'] as String?),
        status: Value(menuTypeMap['status'] as String? ?? 'active'),
        createdAt: Value(
          menuTypeMap['created_at'] as String? ??
              menuTypeMap['createdAt'] as String? ??
              DateTime.now().toIso8601String(),
        ),
        updatedAt: Value(
          menuTypeMap['updated_at'] as String? ??
              menuTypeMap['updatedAt'] as String? ??
              DateTime.now().toIso8601String(),
        ),
        syncStatus: const Value(2),
      );

      await _db.insertMenuType(companion, mode: InsertMode.insertOrReplace);
    } catch (e, stack) {
      _logger.e(
        'RemoteDataSyncService: failed to upsert menu type: $e',
        stackTrace: stack,
      );
    }
  }

  Future<bool> _syncMealsFromRemote() async {
    try {
      _logger.i('RemoteDataSyncService: fetching remote meals...');
      final responseData = await _networkAPI.getData(
        '/caterer/meals',
        queryParameters: {
          'searchTerm': '',
          'limit': '500',
          'offset': '0',
          'status': '',
          'mealType': '',
          'menuType': '',
          'startDate': '',
          'endDate': '',
        },
        builder: (data) => data,
      );

      List<dynamic>? mealsList;
      if (responseData is List) {
        mealsList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        mealsList = responseData['data'] as List<dynamic>;
      }

      if (mealsList == null || mealsList.isEmpty) {
        _logger.w('RemoteDataSyncService: no remote meals available');
        return false;
      }

      _logger.i(
        'RemoteDataSyncService: received ${mealsList.length} remote meals, upserting...',
      );

      for (final item in mealsList) {
        if (item is Map<String, dynamic>) {
          await _upsertMealData(item);
        }
      }

      _logger.i('RemoteDataSyncService: meals sync completed');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteDataSyncService: meals fetch failed ($e), keeping local data',
      );
      return false;
    }
  }

  Future<void> _upsertMealData(Map<String, dynamic> mealMap) async {
    try {
      final mealId = mealMap['id']?.toString() ?? '';
      if (mealId.isEmpty) return;

      // 1. Upsert MenuType for FK constraint
      String menuTypeId = 'default_menu';
      final menuTypeMap = mealMap['menuType'] as Map<String, dynamic>?;
      if (menuTypeMap != null) {
        menuTypeId = menuTypeMap['id']?.toString() ?? 'default_menu';
        await _db.insertMenuType(
          MenuTypesCompanion(
            id: Value(menuTypeId),
            name: Value(menuTypeMap['name'] as String? ?? 'Menu'),
            remarks: Value.absentIfNull(menuTypeMap['remarks'] as String?),
            status: Value(menuTypeMap['status'] as String? ?? 'active'),
            createdAt: Value(
              menuTypeMap['created_at'] as String? ??
                  menuTypeMap['createdAt'] as String? ??
                  DateTime.now().toIso8601String(),
            ),
            updatedAt: Value(
              menuTypeMap['updated_at'] as String? ??
                  menuTypeMap['updatedAt'] as String? ??
                  DateTime.now().toIso8601String(),
            ),
            syncStatus: const Value(2),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 2. Ensure default site exists for kitchen FK
      const defaultSiteId = '1';
      final existingSite = await _db.getSite(defaultSiteId);
      if (existingSite == null) {
        final now = DateTime.now().toIso8601String();
        await _db.insertSite(
          SitesCompanion(
            id: const Value(defaultSiteId),
            name: const Value('Default Site'),
            createdAt: Value(now),
            updatedAt: Value(now),
            syncStatus: const Value(2),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 3. Upsert Kitchens and collect IDs
      final kitchensList = mealMap['kitchens'] as List<dynamic>? ?? [];
      final List<String> kitchenIds = [];
      for (final k in kitchensList) {
        if (k is Map) {
          final kitchenId = k['id']?.toString() ?? '';
          if (kitchenId.isNotEmpty) {
            kitchenIds.add(kitchenId);
            final existingKitchen = await _db.getKitchen(kitchenId);
            if (existingKitchen == null) {
              final minTier =
                  int.tryParse(
                    k['minTierRequired']?.toString() ??
                        k['min_tier_required']?.toString() ??
                        '1',
                  ) ??
                  1;
              await _db.insertKitchen(
                KitchensCompanion(
                  id: Value(kitchenId),
                  name: Value(k['name'] as String? ?? 'Kitchen'),
                  minTierRequired: Value(minTier),
                  status: Value(k['status'] as String? ?? 'active'),
                  companyId: const Value(defaultSiteId),
                  createdAt: Value(
                    k['created_at'] as String? ??
                        k['createdAt'] as String? ??
                        DateTime.now().toIso8601String(),
                  ),
                  updatedAt: Value(
                    k['updated_at'] as String? ??
                        k['updatedAt'] as String? ??
                        DateTime.now().toIso8601String(),
                  ),
                  syncStatus: const Value(2),
                ),
                mode: InsertMode.insertOrReplace,
              );
            }
          }
        }
      }

      // 4. Upsert Meal entity
      final priceNum = mealMap['price'] as num? ?? 0.0;
      final existingMeal = await _db.getMeal(mealId);
      final mealCompanion = MealsCompanion(
        id: Value(mealId),
        name: Value(mealMap['name'] as String? ?? 'Meal'),
        status: Value(mealMap['status'] as String? ?? 'available'),
        mealType: Value(
          mealMap['mealType'] as String? ??
              mealMap['meal_type'] as String? ??
              'breakfast',
        ),
        remarks: Value.absentIfNull(mealMap['remarks'] as String?),
        price: Value(priceNum.toDouble()),
        photoUrl: Value.absentIfNull(
          mealMap['photoUrl'] as String? ?? mealMap['photo_url'] as String?,
        ),
        menuTypeId: Value(menuTypeId),
        createdAt: Value(
          mealMap['created_at'] as String? ??
              mealMap['createdAt'] as String? ??
              DateTime.now().toIso8601String(),
        ),
        updatedAt: Value(
          mealMap['updated_at'] as String? ??
              mealMap['updatedAt'] as String? ??
              DateTime.now().toIso8601String(),
        ),
        syncStatus: const Value(2),
      );

      if (existingMeal != null) {
        await _db.updateMeal(mealCompanion, kitchenIds);
      } else {
        await _db.insertMeal(mealCompanion, kitchenIds);
      }
    } catch (e, stack) {
      _logger.e(
        'RemoteDataSyncService: failed to upsert meal: $e',
        stackTrace: stack,
      );
    }
  }
}

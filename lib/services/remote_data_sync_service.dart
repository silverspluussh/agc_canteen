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
    _jobs.add(_SyncJob(name: 'posDevice', execute: _syncPosDevice));
    _jobs.add(_SyncJob(name: 'staff', execute: _syncStaff));
    _jobs.add(_SyncJob(name: 'meals', execute: _syncMeals));
    _jobs.add(_SyncJob(name: 'bioData', execute: _syncBioData));
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

      final posDevices = await _db.getAllPosDevices();
      final posKitchenId =
          posDevices.isNotEmpty ? posDevices.first.kitchenId : null;

      final responseData = await _networkAPI.getData(
        '/hr/staffs',
        queryParameters: {
          'limit': '1000',
          'offset': '0',
          if (posKitchenId != null && posKitchenId.isNotEmpty)
            'kitchenId': posKitchenId,
        },
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
      // _logger.i('RemoteDataSyncService: upserting staff data: $staffMap');
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

  // ─── Bio-Data Sync ────────────────────────────────────────────

  Future<bool> _syncBioData() async {
    try {
      _logger.i('RemoteDataSyncService: fetching remote bio-data...');

      final posDevices = await _db.getAllPosDevices();
      final posKitchenId =
          posDevices.isNotEmpty ? posDevices.first.kitchenId : null;
      _logger.i('RemoteDataSyncService: kitchen id $posKitchenId');

      final responseData = await _networkAPI.getData(
        '/hr/bio-data',
        queryParameters: {
          if (posKitchenId != null && posKitchenId.isNotEmpty)
            'kitchenId': posKitchenId,
        },
        builder: (data) => data,
      );

      List<dynamic>? bioDataList;
      if (responseData is List) {
        bioDataList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        bioDataList = responseData['data'] as List<dynamic>;
      }

      if (bioDataList == null || bioDataList.isEmpty) {
        _logger.w('RemoteDataSyncService: no remote bio-data available');
        return false;
      }

      _logger.i(
        'RemoteDataSyncService: received ${bioDataList.length} remote bio-data records, upserting...',
      );

      await _db.transaction(() async {
        for (final item in bioDataList!) {
          if (item is Map<String, dynamic>) {
            await _upsertBioData(item);
          }
        }
      });

      _logger.i('RemoteDataSyncService: bio-data sync completed');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteDataSyncService: bio-data fetch failed ($e), keeping local data',
      );
      return false;
    }
  }

  Future<void> _upsertBioData(Map<String, dynamic> bioDataMap) async {
    try {
      final id = bioDataMap['id'];
      if (id == null) return;

      final intId = id is int ? id : int.tryParse(id.toString()) ?? 0;
      if (intId == 0) return;

      final now = DateTime.now().toIso8601String();

      final companion = BioDataEntriesCompanion(
        id: Value(intId),
        staffId: Value(bioDataMap['staffId']?.toString() ?? ''),
        finger: Value(bioDataMap['finger']?.toString() ?? ''),
        dataBase64: Value(bioDataMap['data']?.toString() ?? ''),
        isActive: Value(bioDataMap['isActive'] as bool? ?? true),
        createdAt: Value(bioDataMap['createdAt']?.toString() ?? now),
        updatedAt: Value(bioDataMap['updatedAt']?.toString() ?? now),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      await _db.upsertBioData(companion);
    } catch (e, stack) {
      _logger.e(
        'RemoteDataSyncService: failed to upsert bio-data: $e',
        stackTrace: stack,
      );
    }
  }

  // ─── Meals & Menu Types Sync ───────────────────────────────

  Future<bool> _syncMeals() async {
    var anyUpdated = false;

    final menuTypesUpdated = await _syncMenuTypesFromRemote();
    final mealTypesUpdated = await _syncMealTypesFromRemote();
    final mealsUpdated = await _syncMealsFromRemote();

    anyUpdated = menuTypesUpdated || mealTypesUpdated || mealsUpdated;
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

      final remoteIds = <String>{};
      for (final item in menuTypesList) {
        if (item is Map<String, dynamic>) {
          await _upsertMenuTypeData(item);
          final id = item['id']?.toString();
          if (id != null && id.isNotEmpty) remoteIds.add(id);
        }
      }

      if (remoteIds.isNotEmpty) {
        await _db.deleteMenuTypesNotIn(remoteIds);
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

  Future<bool> _syncMealTypesFromRemote() async {
    try {
      _logger.i('RemoteDataSyncService: fetching remote meal types...');
      final responseData = await _networkAPI.getData(
        '/caterer/meal-types',
        queryParameters: {
          'searchTerm': '',
          'limit': '100',
          'offset': '0',
          'status': '',
        },
        builder: (data) => data,
      );

      List<dynamic>? mealTypesList;
      if (responseData is List) {
        mealTypesList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        mealTypesList = responseData['data'] as List<dynamic>;
      }

      if (mealTypesList == null || mealTypesList.isEmpty) {
        _logger.w('RemoteDataSyncService: no remote meal types available');
        return false;
      }

      _logger.i(
        'RemoteDataSyncService: received ${mealTypesList.length} remote meal types, upserting...',
      );

      final remoteIds = <String>{};
      for (final item in mealTypesList) {
        if (item is Map<String, dynamic>) {
          await _upsertMealTypeData(item);
          final id = item['id']?.toString();
          if (id != null && id.isNotEmpty) remoteIds.add(id);
        }
      }

      if (remoteIds.isNotEmpty) {
        await _db.deleteMealTypesNotIn(remoteIds);
      }

      _logger.i('RemoteDataSyncService: meal types sync completed');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteDataSyncService: meal types fetch failed ($e), keeping local data',
      );
      return false;
    }
  }

  Future<void> _upsertMealTypeData(Map<String, dynamic> mealTypeMap) async {
    try {
      final mealTypeId = mealTypeMap['id']?.toString() ?? '';
      if (mealTypeId.isEmpty) return;

      await _db.insertMealType(
        MealTypesCompanion(
          id: Value(mealTypeId),
          name: Value(mealTypeMap['name'] as String? ?? 'Meal Type'),
          status: Value(mealTypeMap['status'] as String? ?? 'active'),
          beginTime: Value(mealTypeMap['begin_time'] as String? ?? mealTypeMap['beginTime'] as String? ?? '00:00:00'),
          endTime: Value(mealTypeMap['end_time'] as String? ?? mealTypeMap['endTime'] as String? ?? '23:59:59'),
          remarks: Value.absentIfNull(mealTypeMap['remarks'] as String?),
          createdAt: Value(
            mealTypeMap['created_at'] as String? ??
                mealTypeMap['createdAt'] as String? ??
                DateTime.now().toIso8601String(),
          ),
          updatedAt: Value(
            mealTypeMap['updated_at'] as String? ??
                mealTypeMap['updatedAt'] as String? ??
                DateTime.now().toIso8601String(),
          ),
          syncStatus: const Value(2),
        ),
        mode: InsertMode.insertOrReplace,
      );
    } catch (e, stack) {
      _logger.e(
        'RemoteDataSyncService: failed to upsert meal type: $e',
        stackTrace: stack,
      );
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

      final posDevices = await _db.getAllPosDevices();
      final posKitchenId =
          posDevices.isNotEmpty ? posDevices.first.kitchenId : null;

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
          if (posKitchenId != null && posKitchenId.isNotEmpty)
            'kitchenId': posKitchenId,
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

      final mealIds = <String>{};
      for (final item in mealsList) {
        if (item is Map<String, dynamic>) {
          await _upsertMealData(item);
          final id = item['id']?.toString();
          if (id != null && id.isNotEmpty) mealIds.add(id);
        }
      }

      if (mealIds.isNotEmpty) {
        await _db.deleteMealsNotIn(mealIds);
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

      // 2. Upsert MealType for FK constraint
      String mealTypeId = '';
      final mealTypeObj = mealMap['mealType'] as Map<String, dynamic>?;
      if (mealTypeObj != null) {
        mealTypeId = mealTypeObj['id']?.toString() ?? '';
        final hasBeginTime = mealTypeObj.containsKey('beginTime') || mealTypeObj.containsKey('begin_time');
        final hasEndTime = mealTypeObj.containsKey('endTime') || mealTypeObj.containsKey('end_time');
        final existing = await _db.getMealType(mealTypeId);
        await _db.insertMealType(
          MealTypesCompanion(
            id: Value(mealTypeId),
            name: Value(mealTypeObj['name'] as String? ?? existing?.name ?? 'Meal Type'),
            status: Value(mealTypeObj['status'] as String? ?? existing?.status ?? 'active'),
            beginTime: Value(
              hasBeginTime
                  ? (mealTypeObj['begin_time'] as String? ?? mealTypeObj['beginTime'] as String? ?? existing?.beginTime ?? '00:00:00')
                  : (existing?.beginTime ?? '00:00:00'),
            ),
            endTime: Value(
              hasEndTime
                  ? (mealTypeObj['end_time'] as String? ?? mealTypeObj['endTime'] as String? ?? existing?.endTime ?? '23:59:59')
                  : (existing?.endTime ?? '23:59:59'),
            ),
            remarks: Value.absentIfNull(mealTypeObj['remarks'] as String?),
            createdAt: Value(
              mealTypeObj['created_at'] as String? ??
                  mealTypeObj['createdAt'] as String? ??
                  existing?.createdAt ??
                  DateTime.now().toIso8601String(),
            ),
            updatedAt: Value(
              mealTypeObj['updated_at'] as String? ??
                  mealTypeObj['updatedAt'] as String? ??
                  existing?.updatedAt ??
                  DateTime.now().toIso8601String(),
            ),
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
          mealTypeObj?['name'] as String? ?? 'breakfast',
        ),
        mealTypeId: Value(mealTypeId),
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

  // ─── PosDevice Sync ────────────────────────────────────────

  Future<bool> get isPosDeviceRegistered async {
    final devices = await _db.getAllPosDevices();
    return devices.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> fetchAllPosProfiles() async {
    _logger.i('RemoteDataSyncService: fetching all POS device profiles...');
    final data = await _networkAPI.getData<dynamic>(
      '/pos/profiles',
      builder: (d) => d,
    );
    if (data is List && data.isNotEmpty) {
      return data.cast<Map<String, dynamic>>();
    } else if (data is Map && data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception('No POS device profiles returned from server');
  }

  Future<void> saveSelectedPosProfile(Map<String, dynamic> deviceMap) async {
    final id = deviceMap['id']?.toString() ?? '';
    if (id.isEmpty) throw Exception('Selected device profile has no id');

    final now = DateTime.now().toIso8601String();

    final kitchenMap = deviceMap['kitchen'] as Map<String, dynamic>?;
    final posKitchenId = kitchenMap?['id']?.toString() ?? '';
    final posKitchenName = kitchenMap?['name']?.toString() ?? '';

    if (posKitchenId.isNotEmpty) {
      await _db.insertKitchen(
        KitchensCompanion(
          id: Value(posKitchenId),
          name: Value(posKitchenName),
          minTierRequired: Value(
            int.tryParse(kitchenMap?['minTierRequired']?.toString() ?? '1') ?? 1,
          ),
          status: Value(kitchenMap?['status'] as String? ?? 'active'),
          createdAt: Value(kitchenMap?['createdAt'] as String? ?? now),
          updatedAt: Value(kitchenMap?['updatedAt'] as String? ?? now),
          syncStatus: const Value(2),
        ),
        mode: InsertMode.insertOrReplace,
      );
      _logger.i('RemoteDataSyncService: kitchen $posKitchenId ($posKitchenName) stored from POS selection');
    }

    await _db.insertPosDevice(
      PosDevicesCompanion(
        id: Value(id),
        name: Value(deviceMap['name'] as String? ?? ''),
        serialNumber: Value(deviceMap['serialNumber'] as String? ?? ''),
        model: Value.absentIfNull(deviceMap['model'] as String?),
        status: Value(deviceMap['status'] as String? ?? 'active'),
        macAddress: Value.absentIfNull(deviceMap['macAddress'] as String?),
        kitchenId: Value.absentIfNull(posKitchenId.isNotEmpty ? posKitchenId : null),
        kitchenName: Value.absentIfNull(posKitchenName.isNotEmpty ? posKitchenName : null),
        createdAt: Value(deviceMap['createdAt'] as String? ?? now),
        updatedAt: Value(deviceMap['updatedAt'] as String? ?? now),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      ),
      mode: InsertMode.insertOrReplace,
    );

    _logger.i('RemoteDataSyncService: POS device profile saved from selection ($id)');
  }

  Future<bool> _syncPosDevice() async {
    try {
      final devices = await _db.getAllPosDevices();
      if (devices.isNotEmpty) {
        _logger.i('RemoteDataSyncService: POS device already registered, skipping auto-fetch');
        return true;
      }

      _logger.i('RemoteDataSyncService: no local POS device, skipping sync (needs manual selection)');
      return false;
    } catch (e) {
      _logger.w('RemoteDataSyncService: POS device sync failed ($e)');
      return false;
    }
  }
}

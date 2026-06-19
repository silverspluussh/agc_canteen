import 'dart:async';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:logger/logger.dart';

import '../core/network/network_api_dio.dart';
import 'database/app_database.dart';
import 'device_info_service.dart';

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
  final DeviceInfoService _deviceInfoService;
  final List<_SyncJob> _jobs = [];

  RemoteDataSyncService({
    required NetworkAPI networkAPI,
    required AppDatabase db,
    DeviceInfoService? deviceInfoService,
    Logger? logger,
  }) : _networkAPI = networkAPI,
       _db = db,
       _deviceInfoService = deviceInfoService ?? DeviceInfoService(),
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
      _logger.e(staffList);
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
              _logger.e("Meal response data:$mealMap");

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

      // 2. Upsert Kitchens and collect IDs
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

      // 3. Upsert Meal entity
      final priceNum = mealMap['price'] as num? ?? 0.0;
      final existingMeal = await _db.getMeal(mealId);
      final mealCompanion = MealsCompanion(
        id: Value(mealId),
        name: Value(mealMap['name'] as String? ?? 'Meal'),
        status: Value(mealMap['status'] as String? ?? 'available'),
        mealType: Value(
          mealMap['mealType']['name'] as String? ??
              mealMap['mealType']['name'] as String? ??
              'breakfast',
        ),
        mealTypeId: Value(
          mealMap['mealType']['id']?.toString() ?? '',
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

  // ─── PosDevice Sync ────────────────────────────────────────

  Future<bool> _syncPosDevice() async {
    try {
      _logger.i('RemoteDataSyncService: fetching POS device profile...');

      final deviceInfo = await _deviceInfoService.gatherDeviceInfo();
      final deviceModel = deviceInfo.model ?? '';
      if (deviceModel.isEmpty) {
        _logger.w('RemoteDataSyncService: no device model available');
        return false;
      }

      final data = await _networkAPI.getData<dynamic>(
        '/pos/profiles',
        queryParameters: {'model': deviceModel},
        builder: (d) => d,
      );
      Map<String, dynamic>? deviceMap;
      if (data is List && data.isNotEmpty) {

        deviceMap = data.first as Map<String, dynamic>;
      } else if (data is Map<String, dynamic>) {
        deviceMap = data;
      }

      if (deviceMap == null) {
        _logger.w('RemoteDataSyncService: no POS device profile found');
        return false;
      }

      final id = deviceMap['id']?.toString() ?? '';
      if (id.isEmpty) {
        _logger.w('RemoteDataSyncService: device profile has no id');
        return false;
      }

      _logger.e(deviceMap);

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
              int.tryParse(
                    kitchenMap?['minTierRequired']?.toString() ?? '1',
                  ) ??
                  1,
            ),
            status: Value(kitchenMap?['status'] as String? ?? 'active'),
            createdAt: Value(kitchenMap?['createdAt'] as String? ?? now),
            updatedAt: Value(kitchenMap?['updatedAt'] as String? ?? now),
            syncStatus: const Value(2),
          ),
          mode: InsertMode.insertOrReplace,
        );

        _logger.i(
          'RemoteDataSyncService: kitchen $posKitchenId ($posKitchenName) stored from POS device profile',
        );
      }

      await _db.insertPosDevice(
        PosDevicesCompanion(
          id: Value(id),
          name: Value(deviceMap['name'] as String? ?? ''),
          serialNumber: Value(deviceMap['serialNumber'] as String? ?? ''),
          model: Value.absentIfNull(deviceMap['model'] as String?),
          status: Value(deviceMap['status'] as String? ?? 'active'),
          macAddress: Value.absentIfNull(deviceMap['macAddress'] as String?),
          kitchenId: Value.absentIfNull(
            posKitchenId.isNotEmpty ? posKitchenId : null,
          ),
          kitchenName: Value.absentIfNull(
            posKitchenName.isNotEmpty ? posKitchenName : null,
          ),
          createdAt: Value(deviceMap['createdAt'] as String? ?? now),
          updatedAt: Value(deviceMap['updatedAt'] as String? ?? now),
          syncStatus: const Value(2),
          syncUpdatedAt: Value(now),
        ),
        mode: InsertMode.insertOrReplace,
      );

      _logger.i('RemoteDataSyncService: POS device profile synced ($id)');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteDataSyncService: POS device sync failed ($e), keeping local data',
      );
      return false;
    }
  }
}

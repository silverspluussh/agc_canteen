import 'dart:async';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:logger/logger.dart';

import '../../core/network/network_api_dio.dart';
import '../database/app_database.dart';

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
    _jobs.add(_SyncJob(name: 'mealTypes', execute: _syncMealTypes));
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
          if (posKitchenId != null && posKitchenId != 0)
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
      final staffId = (staffMap['id'] as num?)?.toInt() ?? 0;
      if (staffId == 0) return;

      final now = DateTime.now().toIso8601String();
      final existing = await _db.getStaff(staffId);

      final companion = StaffCompanion(
        id: Value(staffId),
        empId: Value(staffMap['emp_id'] as String? ?? staffMap['empId'] as String? ?? ''),
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
        employeeType: Value(staffMap['employee_type'] as String? ?? staffMap['employeeType'] as String? ?? ''),
        companyId: Value.absentIfNull((staffMap['company_id'] as num?)?.toInt() ?? (staffMap['companyId'] as num?)?.toInt()),
        jobTitle: Value.absentIfNull(staffMap['job_title'] as String? ?? staffMap['jobTitle'] as String?),
        empStatus: Value.absentIfNull(staffMap['emp_status'] as String? ?? staffMap['empStatus'] as String?),
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

  // ─── Meal Types Sync ───────────────────────────────────────

  Future<bool> _syncMealTypes() async {
    try {
      _logger.i('RemoteDataSyncService: fetching remote meal types...');

      final responseData = await _networkAPI.getData(
        '/caterer/meal-types',
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
        'RemoteDataSyncService: received ${mealTypesList.length} remote meal types, replacing local...',
      );

      await _db.transaction(() async {
        await _db.delete(_db.mealTypes).go();
        for (final item in mealTypesList!) {
          if (item is Map<String, dynamic>) {
            await _upsertMealTypeData(item);
          }
        }
      });

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
      final id = (mealTypeMap['id'] as num?)?.toInt() ?? 0;
      if (id == 0) return;

      final now = DateTime.now().toIso8601String();

      final companion = MealTypesCompanion(
        id: Value(id),
        name: Value(mealTypeMap['name'] as String? ?? ''),
        status: Value(mealTypeMap['status'] as String? ?? 'active'),
        beginTime: Value(mealTypeMap['beginTime'] as String? ?? ''),
        endTime: Value(mealTypeMap['endTime'] as String? ?? ''),
        price: Value((mealTypeMap['price'] as num?)?.toDouble() ?? 0),
        remarks: Value.absentIfNull(mealTypeMap['remarks'] as String?),
        createdAt: Value(mealTypeMap['created_at'] as String? ?? now),
        updatedAt: Value(mealTypeMap['updated_at'] as String? ?? now),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      await _db.insertMealType(companion, mode: InsertMode.insertOrReplace);
    } catch (e, stack) {
      _logger.e(
        'RemoteDataSyncService: failed to upsert meal type: $e',
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
          if (posKitchenId != null && posKitchenId != 0)
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
        staffId: Value((bioDataMap['staffId'] as num?)?.toInt() ?? 0),
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
    final id = (deviceMap['id'] as num?)?.toInt() ?? 0;
    if (id == 0) throw Exception('Selected device profile has no id');

    final now = DateTime.now().toIso8601String();

    final kitchenMap = deviceMap['kitchen'] as Map<String, dynamic>?;
    final posKitchenId = (kitchenMap?['id'] as num?)?.toInt() ?? 0;
    final posKitchenName = kitchenMap?['name']?.toString() ?? '';

    if (posKitchenId != 0) {
      await _db.insertKitchen(
        KitchensCompanion(
          id: Value(posKitchenId),
          name: Value(posKitchenName),
          minTierRequired: Value(
            (kitchenMap?['minTierRequired'] as num?)?.toInt() ?? 1,
          ),
          status: Value(kitchenMap?['status'] as String? ?? 'active'),
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
        kitchenId: Value.absentIfNull(posKitchenId != 0 ? posKitchenId : null),
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

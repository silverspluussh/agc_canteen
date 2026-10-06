import 'dart:async';
import 'package:agc_canteen/models/sync.model.dart';
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import '../../core/network/network_api_dio.dart';
import '../database/app_database.dart';

class RemoteToLocalSyncService {
  final NetworkAPI _networkAPI;
  final AppDatabase _db;
  final Logger _logger;
  final Future<bool> Function()? _isOnline;
  final List<SyncJob> _jobs = [];

  RemoteToLocalSyncService({
    required NetworkAPI networkAPI,
    required AppDatabase db,
    Logger? logger,
    Future<bool> Function()? isOnline,
  }) : _networkAPI = networkAPI,
       _db = db,
       _logger = logger ?? Logger(),
       _isOnline = isOnline {
    _jobs.add(SyncJob(name: 'posDevice', execute: _syncPosDevice));
    _jobs.add(SyncJob(name: 'departments', execute: _syncDepartments));
    _jobs.add(SyncJob(name: 'staff', execute: _syncStaff));
    _jobs.add(SyncJob(name: 'mealTypes', execute: _syncMealTypes));
    _jobs.add(SyncJob(name: 'bioData', execute: _syncBioData));
    _jobs.add(SyncJob(name: 'cards', execute: _syncCards));
    _jobs.add(SyncJob(name: 'visitors', execute: _syncVisitors));
    _jobs.add(SyncJob(name: 'contractorStaff', execute: _syncContractorStaff));
    _jobs.add(SyncJob(name: 'dependents', execute: _syncDependents));
    _jobs.add(SyncJob(name: 'shifts', execute: _syncShifts));
    _jobs.add(SyncJob(name: 'workFunctions', execute: _syncWorkFunctions));
  }

  void registerSyncJob(String name, SyncTask execute) {
    _jobs.add(SyncJob(name: name, execute: execute));
  }

  /// The in-flight whole-sync run, if any.
  Future<void>? _currentRun;

  /// Guards a full run so two triggers cannot execute the same jobs at once.
  ///
  /// Startup fires syncDepartmentsOnly() and syncAll() back to back, and the
  /// manual sync screen can be opened while a background run is still going.
  /// Without this, the same job ran concurrently with itself and interleaved
  /// upserts and delete-not-in passes over the same tables — which is exactly
  /// how a partial page can delete rows a concurrent job just wrote.
  ///
  /// Concurrent callers coalesce: they wait for the run in flight and then
  /// perform a single follow-up run rather than piling up.
  /// Whether the terminal currently has a usable connection. Defaults to true
  /// when no probe was injected, so tests/legacy callers keep running.
  Future<bool> get isOnline async {
    if (_isOnline == null) return true;
    try {
      return await _isOnline();
    } catch (e) {
      _logger.w('RemoteToLocalSyncService: connectivity probe failed ($e)');
      return false;
    }
  }

  Future<void> syncAll({bool background = true}) async {
    // Skip the whole run while offline: every job would fail at the socket and
    // the scheduler would log a wall of errors on each tick. Reconnect triggers
    // a catch-up run.
    if (!await isOnline) {
      _logger.i('RemoteToLocalSyncService: offline, skipping sync');
      return;
    }

    if (background) {
      unawaited(_guardedRun());
    } else {
      await _guardedRun();
    }
  }

  Future<void> _guardedRun() async {
    // Check-and-set with no await in between, so two callers cannot both pass.
    while (_currentRun != null) {
      await _currentRun;
    }

    final run = _runAll();
    _currentRun = run;

    try {
      await run;
    } finally {
      _currentRun = null;
    }
  }

  /// Runs [action] once any in-flight whole-sync run has finished.
  ///
  /// A single-entity refresh triggered while the full sync is mid-flight used to
  /// race it over the same tables.
  Future<void> _afterCurrentRun(Future<void> Function() action) async {
    while (_currentRun != null) {
      await _currentRun;
    }

    await action();
  }

  Future<void> _runAll() async {
    _logger.i('RemoteToLocalSyncService: starting sync');
    for (final job in _jobs) {
      try {
        final updated = await job.execute();
        _logger.i(
          'RemoteToLocalSyncService: ${job.name} sync ${updated ? "updated" : "skipped"}',
        );
      } catch (e) {
        _logger.w('RemoteToLocalSyncService: ${job.name} sync failed ($e)');
      }
    }
    _logger.i('RemoteToLocalSyncService: sync completed');
  }

  /// Removes local rows the server no longer has — but only when this pull is
  /// provably the whole dataset.
  ///
  /// These endpoints are read one page at a time (`limit` + `offset: 0`). When
  /// the server holds more rows than the page, everything past it is missing from
  /// [remoteIds], and `deleteXNotIn` then treated those perfectly valid rows as
  /// deleted: data disappeared on every sync and came back only if the operator
  /// happened to filter differently.
  ///
  /// A short page proves we saw everything, so purging is safe. A full page means
  /// there may be more, so the cleanup is skipped and the gap is logged instead of
  /// silently destroying rows.
  Future<void> _purgeMissingRows({
    required String label,
    required int received,
    required int limit,
    required Set<int> remoteIds,
    required Future<int> Function(Set<int>) purge,
  }) async {
    if (received >= limit) {
      _logger.w(
        'RemoteToLocalSyncService: $label pull filled its page ($received of $limit); '
        'skipping stale-row cleanup because rows beyond this page would be deleted',
      );
      return;
    }

    final deleted = await purge(remoteIds);

    if (deleted > 0) {
      _logger.i('RemoteToLocalSyncService: removed $deleted stale $label records');
    }
  }

  Future<void> syncStaffOnly() async {
    await _afterCurrentRun(() => _syncStaff());
  }

  Future<void> syncMealTypesOnly() async {
    await _afterCurrentRun(() => _syncMealTypes());
  }

  Future<void> syncBioDataOnly() async {
    await _afterCurrentRun(() => _syncBioData());
  }

  /// Refreshes the cached list of orderable work functions. Safe to call often;
  /// the server returns only functions that can be ordered right now.
  Future<void> syncWorkFunctionsOnly() async {
    await _afterCurrentRun(_syncWorkFunctions);
  }

  Future<void> syncCardsOnly() async {
    await _afterCurrentRun(() => _syncCards());
  }

  Future<void> syncVisitorsOnly() async {
    await _syncVisitors();
  }

  Future<void> syncContractorStaffOnly() async {
    await _syncContractorStaff();
  }

  Future<void> syncDependentsOnly() async {
    await _syncDependents();
  }

  Future<void> syncShiftsOnly() async {
    await _syncShifts();
  }

  Future<void> syncDepartmentsOnly() async {
    await _afterCurrentRun(_syncDepartments);
  }

  // ─── Departments Sync ──────────────────────────────────────

  Future<bool> _syncDepartments() async {
    try {
      _logger.i('RemoteToLocalSyncService: fetching remote departments...');

      final responseData = await _networkAPI.getData(
        '/hr/departments',
        builder: (data) => data,
        queryParameters: {'limit': 100, 'offset': 0},
      );

      List<dynamic>? list;
      if (responseData is List) {
        list = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        list = responseData['data'] as List<dynamic>;
      }

      if (list == null || list.isEmpty) {
        _logger.w('RemoteToLocalSyncService: no remote departments available');
        return false;
      }

      _logger.i(
        'RemoteToLocalSyncService: received ${list.length} remote departments, upserting...',
      );

      await _db.transaction(() async {
        final remoteIds = <int>{};
        for (final item in list!) {
          if (item is Map<String, dynamic>) {
            await _upsertDepartmentData(item);
            final id = _safeParseInt(item['id']);
            if (id != null && id != 0) remoteIds.add(id);
          }
        }
        await _purgeMissingRows(
          label: 'department',
          received: list?.length ?? 0,
          limit: 100,
          remoteIds: remoteIds,
          purge: _db.deleteDepartmentsNotIn,
        );
      });

      _logger.i('RemoteToLocalSyncService: departments sync completed');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteToLocalSyncService: departments fetch failed ($e), keeping local data',
      );
      return false;
    }
  }

  Future<void> _upsertDepartmentData(Map<String, dynamic> map) async {
    try {
      final id = _safeParseInt(map['id']) ?? 0;
      if (id == 0) return;

      final now = DateTime.now().toIso8601String();

      final companion = DepartmentsCompanion(
        id: Value(id),
        name: Value(map['name'] as String? ?? ''),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      await _db.insertDepartment(companion, mode: InsertMode.insertOrReplace);
    } catch (e, stack) {
      _logger.e(
        'RemoteToLocalSyncService: failed to upsert department: $e',
        stackTrace: stack,
      );
    }
  }

  // ─── Staff Sync ────────────────────────────────────────────

  Future<bool> _syncStaff() async {
    try {
      _logger.i('RemoteToLocalSyncService: fetching remote staff...');

      final posDevices = await _db.getAllPosDevices();
      final posKitchenId = posDevices.isNotEmpty
          ? posDevices.first.kitchenId
          : null;

      final responseData = await _networkAPI.getData(
        '/hr/staff/sync',
        queryParameters: {
          // 'active': 'true',
          // 'limit':2500,
          // 'offset':0,
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
        _logger.w('RemoteToLocalSyncService: no remote staff data available');
        return false;
      }

      _logger.i(
        'RemoteToLocalSyncService: received ${staffList.length} remote staff records, upserting...',
      );

      await _db.transaction(() async {
        if (staffList?.isEmpty ?? true) {
          _logger.w(
            'RemoteToLocalSyncService: staff list is empty, skipping staff sync',
          );
          return;
        }
        final remoteIds = <int>{};
        for (final item in staffList!) {
          if (item is Map<String, dynamic>) {
            await _upsertStaffData(item);
            final id = _safeParseInt(item['id']);
            if (id != null && id != 0) remoteIds.add(id);
          }
        }
        final deleted = await _db.deleteStaffNotIn(remoteIds);
        if (deleted > 0) {
          _logger.i(
            'RemoteToLocalSyncService: removed $deleted stale staff records',
          );
        }
      });

      _logger.i('RemoteToLocalSyncService: staff sync completed');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteToLocalSyncService: staff fetch failed ($e), keeping local data',
      );
      return false;
    }
  }

  Future<void> _upsertStaffData(Map<String, dynamic> staffMap) async {
    try {
      final staffId = _safeParseInt(staffMap['id']) ?? 0;
      if (staffId == 0) return;

      final now = DateTime.now().toIso8601String();
      final existing = await _db.getStaff(staffId);

      final fullName = staffMap['fullName'] as String? ?? '';
      final firstName =
          staffMap['first_name'] as String? ??
          staffMap['firstName'] as String? ??
          fullName.split(' ').first;
      final lastName =
          staffMap['last_name'] as String? ??
          staffMap['lastName'] as String? ??
          (fullName.contains(' ') ? fullName.split(' ').skip(1).join(' ') : '');

      final departmentMap = staffMap['department'] as Map<String, dynamic>?;
      final departmentId = _safeParseInt(departmentMap?['id']);

      final shiftMap = staffMap['shift'] as Map<String, dynamic>?;
      final shiftId = _safeParseInt(shiftMap?['id']);

      final manualQuota = _activeManualQuota(staffMap['quotas']);

      final companion = StaffCompanion(
        id: Value(staffId),
        empId: Value(
          staffMap['emp_id'] as String? ?? staffMap['empId'] as String? ?? '',
        ),
        firstName: Value(firstName),
        lastName: Value(lastName),
        employeeType: Value(
          staffMap['employee_type'] as String? ??
              staffMap['employeeType'] as String? ??
              '',
        ),
        companyId: Value.absentIfNull(
          _safeParseInt(staffMap['company_id']) ??
              _safeParseInt(staffMap['companyId']),
        ),
        departmentId: Value.absentIfNull(departmentId),
        shiftId: Value.absentIfNull(shiftId),
        manualDailyQuota: Value(manualQuota?.daily ?? 0),
        manualMonthlyQuota: Value(manualQuota?.monthly ?? 0),
        quotaPeriodStart: Value.absentIfNull(manualQuota?.periodStart),
        quotaPeriodEnd: Value.absentIfNull(manualQuota?.periodEnd),
        jobTitle: Value.absentIfNull(
          staffMap['job_title'] as String? ?? staffMap['jobTitle'] as String?,
        ),
        empStatus: Value.absentIfNull(
          staffMap['emp_status'] as String? ?? staffMap['empStatus'] as String?,
        ),
        allowGroupOrder: Value.absentIfNull(
          staffMap['allow_group_order'] as bool? ?? staffMap['allowGroupOrder'] as bool?,
        ),
        maxOrderCount: Value.absentIfNull(
          staffMap['max_order_count'] as int? ?? staffMap['maxOrderCount'] as int?,
        ),
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
        'RemoteToLocalSyncService: failed to upsert staff: $e',
        stackTrace: stack,
      );
    }
  }

  // ─── Meal Types Sync ───────────────────────────────────────

  Future<bool> _syncMealTypes() async {
    try {
      _logger.i('RemoteToLocalSyncService: fetching remote meal types...');

      final responseData = await _networkAPI.getData(
        '/caterer/meal-types',
        builder: (data) => data,
        queryParameters: {'active': 'true',  'limit':30,
          'offset':0},
      );

      List<dynamic>? mealTypesList;
      if (responseData is List) {
        mealTypesList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        mealTypesList = responseData['data'] as List<dynamic>;
      }

      if (mealTypesList == null || mealTypesList.isEmpty) {
        _logger.w('RemoteToLocalSyncService: no remote meal types available');
        return false;
      }

      _logger.i(
        'RemoteToLocalSyncService: received ${mealTypesList.length} remote meal types, replacing local...',
      );

      await _db.transaction(() async {
        final remoteIds = <int>{};
        for (final item in mealTypesList!) {
          if (item is Map<String, dynamic>) {
            await _upsertMealTypeData(item);
            final id = _safeParseInt(item['id']);
            if (id != null && id != 0) remoteIds.add(id);
          }
        }
        await _purgeMissingRows(
          label: 'meal type',
          received: mealTypesList?.length ?? 0,
          limit: 30,
          remoteIds: remoteIds,
          purge: _db.deleteMealTypesNotIn,
        );
      });

      _logger.i('RemoteToLocalSyncService: meal types sync completed');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteToLocalSyncService: meal types fetch failed ($e), keeping local data',
      );
      return false;
    }
  }

  Future<void> _upsertMealTypeData(Map<String, dynamic> mealTypeMap) async {
    try {
      final id = _safeParseInt(mealTypeMap['id']) ?? 0;
      if (id == 0) return;

      final now = DateTime.now().toIso8601String();

      final companion = MealTypesCompanion(
        id: Value(id),
        name: Value(mealTypeMap['name'] as String? ?? ''),
        status: Value(mealTypeMap['status'] as String? ?? 'active'),
        beginTime: Value(mealTypeMap['beginTime'] as String? ?? ''),
        endTime: Value(mealTypeMap['endTime'] as String? ?? ''),
        price: Value(_safeParseDouble(mealTypeMap['price']) ?? 0),
        remarks: Value.absentIfNull(mealTypeMap['remarks'] as String?),
        createdAt: Value(mealTypeMap['created_at'] as String? ?? now),
        updatedAt: Value(mealTypeMap['updated_at'] as String? ?? now),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      await _db.insertMealType(companion, mode: InsertMode.insertOrReplace);
    } catch (e, stack) {
      _logger.e(
        'RemoteToLocalSyncService: failed to upsert meal type: $e',
        stackTrace: stack,
      );
    }
  }

  // ─── Bio-Data Sync ────────────────────────────────────────────

  Future<bool> _syncBioData() async {
    try {
      _logger.i('RemoteToLocalSyncService: fetching remote bio-data...');

      final posDevices = await _db.getAllPosDevices();
      final posKitchenId = posDevices.isNotEmpty
          ? posDevices.first.kitchenId
          : null;
      _logger.i('RemoteToLocalSyncService: kitchen id $posKitchenId');

      final responseData = await _networkAPI.getData(
        '/hr/bio-data/sync',
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
        _logger.w('RemoteToLocalSyncService: no remote bio-data available');
        return false;
      }

      _logger.i(
        'RemoteToLocalSyncService: received ${bioDataList.length } remote bio-data records, upserting...',
      );

      await _db.transaction(() async {
        final remoteIds = <int>{};
        for (final item in bioDataList!) {
          if (item is Map<String, dynamic>) {
            await _upsertBioData(item);
            final id = _safeParseInt(item['id']);
            if (id != null && id != 0) remoteIds.add(id);
          }
        }
        final deleted = await _db.deleteStaffBioDataNotIn(remoteIds);
        if (deleted > 0) {
          _logger.i(
            'RemoteToLocalSyncService: removed $deleted stale staff bio-data records',
          );
        }
      });

      _logger.i('RemoteToLocalSyncService: bio-data sync completed');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteToLocalSyncService: bio-data fetch failed ($e), keeping local data',
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
        staffId: Value.absentIfNull(_safeParseInt(bioDataMap['staffId'])),
        dependentId: Value.absentIfNull(
          _safeParseInt(bioDataMap['dependentId']),
        ),
        contractorStaffId: Value.absentIfNull(
          _safeParseInt(bioDataMap['contractorStaffId']),
        ),
        visitorId: Value.absentIfNull(_safeParseInt(bioDataMap['visitorId'])),
        finger: Value(bioDataMap['finger']?.toString() ?? ''),
        dataBase64: Value(bioDataMap['data']?.toString() ?? ''),
        isActive: Value(bioDataMap['isActive'] as bool? ?? true),
        departmentId: Value.absentIfNull(_safeParseInt(bioDataMap['departmentId'])),
        departmentName: Value.absentIfNull(bioDataMap['departmentName'] as String?),
        personnelName: Value.absentIfNull(bioDataMap['personnelName'] as String?),
        createdAt: Value(bioDataMap['createdAt']?.toString() ?? now),
        updatedAt: Value(bioDataMap['updatedAt']?.toString() ?? now),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      await _db.upsertBioData(companion);
    } catch (e, stack) {
      _logger.e(
        'RemoteToLocalSyncService: failed to upsert bio-data: $e',
        stackTrace: stack,
      );
    }
  }

  // ─── NFC Cards Sync ───────────────────────────────────────────

  Future<bool> _syncCards() async {
    try {

      final posDevices = await _db.getAllPosDevices();
      final posKitchenId = posDevices.isNotEmpty
          ? posDevices.first.kitchenId
          : null;
      final responseData = await _networkAPI.getData(
        '/hr/nfc-cards/sync',
        queryParameters: {
           if (posKitchenId != null && posKitchenId != 0)
            'kitchenId': posKitchenId       
          },
        builder: (data) => data,
      );

      List<dynamic>? list;
      if (responseData is List) {
        list = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        list = responseData['data'] as List<dynamic>;
      }

      if (list == null || list.isEmpty) {
        _logger.w('RemoteToLocalSyncService: no remote NFC cards available');
        return false;
      }

      _logger.i(
        'RemoteToLocalSyncService: received ${list.length} remote NFC cards, upserting...',
      );

      await _db.transaction(() async {
        final remoteIds = <int>{};
        for (final item in list!) {
          if (item is Map<String, dynamic>) {
            await _upsertCardData(item);
            final id = _safeParseInt(item['id']);
            if (id != null && id != 0) remoteIds.add(id);
          }
        }
        await _purgeMissingRows(
          label: 'NFC card',
          received: list?.length  ?? 0,
          limit: 100,
          remoteIds: remoteIds,
          purge: _db.deleteCardsNotIn,
        );
      });

      _logger.i('RemoteToLocalSyncService: NFC cards sync completed');
      return true;
    } catch (e) {
      _logger.w(
        'RemoteToLocalSyncService: NFC cards fetch failed ($e), keeping local data',
      );
      return false;
    }
  }

  Future<void> _upsertCardData(Map<String, dynamic> map) async {
    try {
      final id = _safeParseInt(map['id']) ?? 0;
      if (id == 0) return;

      final now = DateTime.now().toIso8601String();

      final companion = CardsCompanion(
        id: Value(id),
        tagId: Value.absentIfNull(map['tagId'] as String?),
        code: Value(_safeParseDouble(map['code']) ?? 0),
        reversedCode: Value.absentIfNull(
          _safeParseDouble(map['reversedCode']),
        ),
        status: Value(map['status'] as String? ?? 'active'),
        isAssigned: Value.absentIfNull(map['isAssigned'] as bool?),
        assignedToId: Value.absentIfNull(
          _safeParseInt(map['assignedToId']),
        ),
        assignedToType: Value.absentIfNull(
          map['assignedToType'] as String?,
        ),
        departmentId: Value.absentIfNull(_safeParseInt(map['departmentId'])),
        departmentName: Value.absentIfNull(map['departmentName'] as String?),
        personnelName: Value.absentIfNull(map['personnelName'] as String?),
        issuedDate: Value.absentIfNull(map['issuedDate'] as String?),
        createdAt: Value.absentIfNull(map['createdAt'] as String?),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      await _db.insertCard(companion, mode: InsertMode.insertOrReplace);
    } catch (e, stack) {
      _logger.e(
        'RemoteToLocalSyncService: failed to upsert NFC card: $e',
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
    _logger.i('RemoteToLocalSyncService: fetching all POS device profiles...');
    final data = await _networkAPI.getData<dynamic>(
      '/pos/profiles',
      queryParameters: {'status': 'active', 'limit': 100, 'offset': 0},
      builder: (d) {
        _logger.i('fetchAllPosProfiles: $d');
        return d;
      },
    );
    if (data is List && data.isNotEmpty) {
      return data.cast<Map<String, dynamic>>();
    } else if (data is Map && data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception('No POS device profiles returned from server');
  }

  Future<void> saveSelectedPosProfile(Map<String, dynamic> deviceMap) async {
    final rawId = deviceMap['id'];
    final id = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    if (id == 0) throw Exception('Selected device profile has no id');

    final now = DateTime.now().toIso8601String();

    final kitchenMap = deviceMap['kitchen'] as Map<String, dynamic>?;
    final rawKitchenId = kitchenMap?['id'];
    final posKitchenId = rawKitchenId is int
        ? rawKitchenId
        : int.tryParse(rawKitchenId?.toString() ?? '') ?? 0;
    final posKitchenName = kitchenMap?['name']?.toString() ?? '';

    if (posKitchenId != 0) {
      await _db.insertKitchen(
        KitchensCompanion(
          id: Value(posKitchenId),
          name: Value(posKitchenName),
          minTierRequired: Value(
            _safeParseInt(kitchenMap?['minTierRequired']) ?? 1,
          ),
          status: Value(kitchenMap?['status'] as String? ?? 'active'),
          syncStatus: const Value(2),
        ),
        mode: InsertMode.insertOrReplace,
      );
      _logger.i(
        'RemoteToLocalSyncService: kitchen $posKitchenId ($posKitchenName) stored from POS selection',
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
        kitchenId: Value.absentIfNull(posKitchenId != 0 ? posKitchenId : null),
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

    _logger.i(
      'RemoteToLocalSyncService: POS device profile saved from selection ($id)',
    );
  }

  Future<bool> _syncPosDevice() async {
    try {
      final devices = await _db.getAllPosDevices();
      if (devices.isNotEmpty) {
        _logger.i(
          'RemoteToLocalSyncService: POS device already registered, skipping auto-fetch',
        );
        return true;
      }

      _logger.i(
        'RemoteToLocalSyncService: no local POS device, skipping sync (needs manual selection)',
      );
      return false;
    } catch (e) {
      _logger.w('RemoteToLocalSyncService: POS device sync failed ($e)');
      return false;
    }
  }

  // ─── Visitors Sync ─────────────────────────────────────────

  Future<bool> _syncVisitors() async {
    try {
      _logger.i('RemoteToLocalSyncService: fetching remote visitors...');
      final posDevices = await _db.getAllPosDevices();
      final posKitchenId = posDevices.isNotEmpty
          ? posDevices.first.kitchenId
          : null;

      final responseData = await _networkAPI.getData(
        '/hr/visitor/sync',
        builder: (data) => data,
        queryParameters: {
        
          if (posKitchenId != null && posKitchenId != 0)
            'kitchenId': posKitchenId,
        },
      );

      List<dynamic>? list;
      if (responseData is List) {
        list = responseData;
      } else if (responseData is Map && responseData['visitors'] is List) {
        list = responseData['visitors'] as List<dynamic>;
      }

      if (list == null || list.isEmpty) {
        _logger.w('RemoteToLocalSyncService: no remote visitors available');
        return false;
      }

      await _db.transaction(() async {
        final remoteIds = <int>{};
        for (final item in list!) {
          if (item is Map<String, dynamic>) {
            await _upsertVisitorData(item);
            final id = _safeParseInt(item['id']);
            if (id != null && id != 0) remoteIds.add(id);
          }
        }
        final deleted = await _db.deleteVisitorsNotIn(remoteIds);
        if (deleted > 0) {
          _logger.i(
            'RemoteToLocalSyncService: removed $deleted stale visitors',
          );
        }
      });

      _logger.i('RemoteToLocalSyncService: visitors sync completed');
      return true;
    } catch (e) {
      _logger.w('RemoteToLocalSyncService: visitors fetch failed ($e)');
      return false;
    }
  }

  Future<void> _upsertVisitorData(Map<String, dynamic> map) async {
    try {
      final id = _safeParseInt(map['id']) ?? 0;
      if (id == 0) return;

      final now = DateTime.now().toIso8601String();
      final companion = VisitorsCompanion(
        id: Value(id),
        name: Value(map['name'] as String? ?? ''),
        gender: Value.absentIfNull(map['gender'] as String?),
        startDate: Value.absentIfNull(map['startDate'] as String?),
        endTime: Value.absentIfNull(map['endDate'] as String?),
        dailyQuota: Value.absentIfNull(
          _safeParseInt(map['dailyQuota']) ?? _safeParseInt(map['daily_quota']),
        ),
        company: Value.absentIfNull(map['company'] as String?),
        companyId: Value.absentIfNull(_safeParseInt(map['companyId'])),
        department: Value.absentIfNull(map['department'] as String?),
        departmentId: Value.absentIfNull(_safeParseInt(map['departmentId'])),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      await _db.insertVisitor(companion, mode: InsertMode.insertOrReplace);

      // Upsert kitchens
      final visitorKitchens = map['kitchens'] as List<dynamic>?;
      if (visitorKitchens != null) {
        await _db.deleteVisitorKitchensByVisitor(id);
        for (final kitchen in visitorKitchens) {
          if (kitchen is Map<String, dynamic>) {
            final kitchenId = _safeParseInt(kitchen['id']);
            if (kitchenId != null) {
              await _db.insertVisitorKitchen(
                VisitorKitchensCompanion(
                  visitorId: Value(id),
                  kitchenId: Value(kitchenId),
                ),
              );
            }
          }
        }
      }

      // Upsert bioData
      final visitorBioData = map['bioData'] as List<dynamic>?;
      if (visitorBioData != null) {
        await _db.deleteBioDataByVisitor(id);
        for (final bio in visitorBioData) {
          if (bio is Map<String, dynamic>) {
            final bioId = _safeParseInt(bio['id']) ?? 0;
            if (bioId == 0) continue;
            await _db.upsertBioData(
              BioDataEntriesCompanion(
                id: Value(bioId),
                visitorId: Value(id),
                finger: Value(bio['finger']?.toString() ?? ''),
                dataBase64: Value(bio['data']?.toString() ?? ''),
                isActive: Value(bio['isActive'] as bool? ?? true),
                departmentId: Value.absentIfNull(_safeParseInt(bio['departmentId'])),
                departmentName: Value.absentIfNull(bio['departmentName'] as String?),
                personnelName: Value.absentIfNull(bio['personnelName'] as String?),
                createdAt: Value(bio['createdAt']?.toString() ?? now),
                updatedAt: Value(bio['updatedAt']?.toString() ?? now),
                syncStatus: const Value(2),
                syncUpdatedAt: Value(now),
              ),
            );
          }
        }
      }
    } catch (e, stack) {
      _logger.e(
        'RemoteToLocalSyncService: failed to upsert visitor: $e',
        stackTrace: stack,
      );
    }
  }

  // ─── ContractorStaff Sync ──────────────────────────────────

  Future<bool> _syncContractorStaff() async {
    try {
      _logger.i(
        'RemoteToLocalSyncService: fetching remote contractor staff...',
      );

      final posDevices = await _db.getAllPosDevices();
      final posKitchenId = posDevices.isNotEmpty
          ? posDevices.first.kitchenId
          : null;
      final responseData = await _networkAPI.getData(
        '/hr/contractor-staff/sync',
        queryParameters: {
         
          if (posKitchenId != null && posKitchenId != 0)
            'kitchenId': posKitchenId,
        },
        builder: (data) => data,
      );

      List<dynamic>? list;
      if (responseData is List) {
        list = responseData;
      } else if (responseData is Map &&
          responseData['contractorStaffs'] is List) {
        list = responseData['contractorStaffs'] as List<dynamic>;
      }

      if (list == null || list.isEmpty) {
        _logger.w(
          'RemoteToLocalSyncService: no remote contractor staff available',
        );
        return false;
      }

      await _db.transaction(() async {
        final remoteIds = <int>{};
        for (final item in list!) {
          if (item is Map<String, dynamic>) {
            await _upsertContractorStaffData(item);
            final id = _safeParseInt(item['id']);
            if (id != null && id != 0) remoteIds.add(id);
          }
        }
        final deleted = await _db.deleteContractorStaffNotIn(remoteIds);
        if (deleted > 0) {
          _logger.i(
            'RemoteToLocalSyncService: removed $deleted stale contractor staff',
          );
        }
      });

      _logger.i('RemoteToLocalSyncService: contractor staff sync completed');
      return true;
    } catch (e) {
      _logger.w('RemoteToLocalSyncService: contractor staff fetch failed ($e)');
      return false;
    }
  }

  Future<void> _upsertContractorStaffData(Map<String, dynamic> map) async {
    try {
      final id = _safeParseInt(map['id']) ?? 0;
      if (id == 0) return;

      final now = DateTime.now().toIso8601String();
      final companion = ContractorStaffTableCompanion(
        id: Value(id),
        name: Value(map['name'] as String? ?? ''),
        gender: Value.absentIfNull(map['gender'] as String?),
        contractorId: Value.absentIfNull(_safeParseInt(map['contractorId'])),
        contractorName: Value.absentIfNull(map['contractorName'] as String?),
        companyId: Value.absentIfNull(_safeParseInt(map['companyId'])),
        company: Value.absentIfNull(map['company'] as String?),
        departmentId: Value.absentIfNull(_safeParseInt(map['departmentId'])),
        department: Value.absentIfNull(map['department'] as String?),
        startDate: Value(map['startDate'] as String? ?? now),
        endDate: Value(map['endDate'] as String? ?? now),
        isCharged: Value(map['isCharged'] as bool? ?? false),
        dailyQuota: Value.absentIfNull(
          _safeParseInt(map['dailyQuota']) ?? _safeParseInt(map['daily_quota']),
        ),
        allowGroupOrder: Value.absentIfNull(
          map['allowGroupOrder'] as bool? ?? map['allow_group_order'] as bool?,
        ),
        maxOrderCount: Value.absentIfNull(
          _safeParseInt(map['maxOrderCount']) ??
              _safeParseInt(map['max_order_count']),
        ),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      await _db.insertContractorStaff(
        companion,
        mode: InsertMode.insertOrReplace,
      );

      // Upsert kitchens
      final csKitchens = map['kitchens'] as List<dynamic>?;
      if (csKitchens != null) {
        await _db.deleteContractorStaffKitchensByContractorStaff(id);
        for (final kitchen in csKitchens) {
          if (kitchen is Map<String, dynamic>) {
            final kitchenId = _safeParseInt(kitchen['id']);
            if (kitchenId != null) {
              await _db.insertContractorStaffKitchen(
                ContractorStaffKitchensCompanion(
                  contractorStaffId: Value(id),
                  kitchenId: Value(kitchenId),
                ),
              );
            }
          }
        }
      }

      // Upsert bioData
      final csBioData = map['bioData'] as List<dynamic>?;
      if (csBioData != null) {
        await _db.deleteBioDataByContractorStaff(id);
        for (final bio in csBioData) {
          if (bio is Map<String, dynamic>) {
            final bioId = _safeParseInt(bio['id']) ?? 0;
            if (bioId == 0) continue;
            await _db.upsertBioData(
              BioDataEntriesCompanion(
                id: Value(bioId),
                contractorStaffId: Value(id),
                finger: Value(bio['finger']?.toString() ?? ''),
                dataBase64: Value(bio['data']?.toString() ?? ''),
                isActive: Value(bio['isActive'] as bool? ?? true),
                departmentId: Value.absentIfNull(_safeParseInt(bio['departmentId'])),
                departmentName: Value.absentIfNull(bio['departmentName'] as String?),
                personnelName: Value.absentIfNull(bio['personnelName'] as String?),
                createdAt: Value(bio['createdAt']?.toString() ?? now),
                updatedAt: Value(bio['updatedAt']?.toString() ?? now),
                syncStatus: const Value(2),
                syncUpdatedAt: Value(now),
              ),
            );
          }
        }
      }
    } catch (e, stack) {
      _logger.e(
        'RemoteToLocalSyncService: failed to upsert contractor staff: $e',
        stackTrace: stack,
      );
    }
  }

  // ─── Dependents Sync ───────────────────────────────────────

  Future<bool> _syncDependents() async {
    try {
      _logger.i('RemoteToLocalSyncService: fetching remote dependents...');
      final posDevices = await _db.getAllPosDevices();
      final posKitchenId = posDevices.isNotEmpty
          ? posDevices.first.kitchenId
          : null;
      final responseData = await _networkAPI.getData(
        '/hr/dependent/sync',
        builder: (data) => data,
        queryParameters: {
        
          if (posKitchenId != null && posKitchenId != 0)
            'kitchenId': posKitchenId,

        },
      );

      List<dynamic>? list;
      if (responseData is List) {
        list = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        list = responseData['data'] as List<dynamic>;
      }

      if (list == null || list.isEmpty) {
        _logger.w('RemoteToLocalSyncService: no remote dependents available');
        return false;
      }

      await _db.transaction(() async {
        final remoteIds = <int>{};
        for (final item in list!) {
          if (item is Map<String, dynamic>) {
            await _upsertDependentData(item);
            final id = _safeParseInt(item['id']);
            if (id != null && id != 0) remoteIds.add(id);
          }
        }
        final deleted = await _db.deleteDependentsNotIn(remoteIds);
        if (deleted > 0) {
          _logger.i(
            'RemoteToLocalSyncService: removed $deleted stale dependents',
          );
        }
      });

      _logger.i('RemoteToLocalSyncService: dependents sync completed');
      return true;
    } catch (e) {
      _logger.w('RemoteToLocalSyncService: dependents fetch failed ($e)');
      return false;
    }
  }

  Future<void> _upsertDependentData(Map<String, dynamic> map) async {
    try {
      final id = _safeParseInt(map['id']) ?? 0;
      if (id == 0) return;

      final now = DateTime.now().toIso8601String();
      final companion = DependentsCompanion(
        id: Value(id),
        fullname: Value(map['fullName'] as String? ?? ''),
        status: Value(map['status'] as String? ?? 'active'),
        gender: Value.absentIfNull(map['gender'] as String?),
        staffId: Value.absentIfNull(_safeParseInt(map['staffId'])),
        contractorStaffId: Value.absentIfNull(
          _safeParseInt(map['contractorStaffId']),
        ),
        parentStatus: Value.absentIfNull(map['parentStatus'] as String?),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      await _db.insertDependent(companion, mode: InsertMode.insertOrReplace);

      // Upsert visits (renewable stay windows; quota is per visit)
      final depVisits = map['visits'] as List<dynamic>?;
      if (depVisits != null) {
        final remoteVisitIds = <int>{};
        for (final visit in depVisits) {
          if (visit is Map<String, dynamic>) {
            final visitId = _safeParseInt(visit['id']) ?? 0;
            if (visitId == 0) continue;
            remoteVisitIds.add(visitId);
            await _db.insertDependentVisit(
              DependentVisitsCompanion(
                id: Value(visitId),
                dependentId: Value(id),
                startDate: Value(visit['startDate']?.toString() ?? now),
                endDate: Value(visit['endDate']?.toString() ?? now),
                status: Value(visit['status']?.toString() ?? 'scheduled'),
                syncStatus: const Value(2),
                syncUpdatedAt: Value(now),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }
        await _db.deleteDependentVisitsNotIn(id, remoteVisitIds);
      }

      // Upsert kitchens
      final depKitchens = map['kitchens'] as List<dynamic>?;
      if (depKitchens != null) {
        await _db.deleteDependentKitchensByDependent(id);
        for (final kitchen in depKitchens) {
          if (kitchen is Map<String, dynamic>) {
            final kitchenId = _safeParseInt(kitchen['id']);
            if (kitchenId != null) {
              await _db.insertDependentKitchen(
                DependentKitchensCompanion(
                  dependentId: Value(id),
                  kitchenId: Value(kitchenId),
                ),
              );
            }
          }
        }
      }

      // Upsert bioData
      final depBioData = map['bioData'] as List<dynamic>?;
      if (depBioData != null) {
        await _db.deleteBioDataByDependent(id);
        for (final bio in depBioData) {
          if (bio is Map<String, dynamic>) {
            final bioId = _safeParseInt(bio['id']) ?? 0;
            if (bioId == 0) continue;
            await _db.upsertBioData(
              BioDataEntriesCompanion(
                id: Value(bioId),
                dependentId: Value(id),
                finger: Value(bio['finger']?.toString() ?? ''),
                dataBase64: Value(bio['data']?.toString() ?? ''),
                isActive: Value(bio['isActive'] as bool? ?? true),
                departmentId: Value.absentIfNull(_safeParseInt(bio['departmentId'])),
                departmentName: Value.absentIfNull(bio['departmentName'] as String?),
                personnelName: Value.absentIfNull(bio['personnelName'] as String?),
                createdAt: Value(bio['createdAt']?.toString() ?? now),
                updatedAt: Value(bio['updatedAt']?.toString() ?? now),
                syncStatus: const Value(2),
                syncUpdatedAt: Value(now),
              ),
            );
          }
        }
      }
    } catch (e, stack) {
      _logger.e(
        'RemoteToLocalSyncService: failed to upsert dependent: $e',
        stackTrace: stack,
      );
    }
  }

  // ─── Shifts Sync ───────────────────────────────────────────

  /// Caches the functions that can be ordered at this moment.
  ///
  /// Runs on every sync so the POS picker never offers a function whose window
  /// has closed. On failure the existing cache is left intact: the POS still
  /// re-validates the window locally, so a stale cache cannot authorise an order.
  Future<bool> _syncWorkFunctions() async {
    try {
      _logger.i('RemoteToLocalSyncService: fetching active work functions...');

      final responseData = await _networkAPI.getData(
        '/hr/work-functions/active',
        builder: (data) => data,
      );

      List<dynamic>? functionList;
      if (responseData is Map && responseData['data'] is Map) {
        final inner = responseData['data'];
        if (inner['workFunctions'] is List) {
          functionList = inner['workFunctions'] as List<dynamic>;
        }
      } else if (responseData is Map && responseData['workFunctions'] is List) {
        functionList = responseData['workFunctions'] as List<dynamic>;
      }

      if (functionList == null) {
        _logger.w(
          'RemoteToLocalSyncService: unexpected active work function payload',
        );
        return false;
      }

      final now = DateTime.now().toIso8601String();
      final rows = <WorkFunctionsCompanion>[];

      for (final item in functionList) {
        if (item is! Map) continue;
        final map = item;
        final id = _safeParseInt(map['id']);
        if (id == null) continue;

        rows.add(
          WorkFunctionsCompanion.insert(
            id: Value(id),
            functionName: (map['functionName'] as String?) ?? '',
            functionLocation: Value(map['functionLocation'] as String?),
            catererId: Value(_safeParseInt(map['catererId'])),
            ratePerVoucher: Value(
              _safeParseDouble(map['ratePerVoucher']) ?? 0,
            ),
            totalQuantity: Value(_safeParseInt(map['totalQuantity']) ?? 0),
            functionDate: _isoDate(map['functionDate']) ?? '',
            functionStartTime: _timeOnly(map['functionStartTime']),
            functionEndTime: _timeOnly(map['functionEndTime']),
            status: (map['status'] as String?) ?? 'scheduled',
            syncStatus: const Value(2),
            syncUpdatedAt: Value(now),
          ),
        );
      }

      await _db.replaceWorkFunctions(rows);
      _logger.i(
        'RemoteToLocalSyncService: cached ${rows.length} orderable work function(s)',
      );

      return true;
    } catch (e, stack) {
      _logger.e(
        'RemoteToLocalSyncService: failed to sync active work functions: $e',
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Normalises H:i, H:i:s or a full ISO timestamp to H:i:ss for local
  /// string comparison against the current clock.
  String _timeOnly(dynamic value) {
    if (value == null) return '';
    final text = value.toString();
    if (text.contains('T')) {
      final time = text.substring(text.indexOf('T') + 1);
      return time.length >= 8 ? time.substring(0, 8) : time.padRight(8, ':0');
    }
    if (text.length == 5) return '$text:00';
    return text;
  }

  Future<bool> _syncShifts() async {
    try {
      _logger.i('RemoteToLocalSyncService: fetching remote shifts...');

      final responseData = await _networkAPI.getData(
        '/hr/shifts',
        builder: (data) => data,
        queryParameters: {'limit': 50, 'offset': 0},
      );

      List<dynamic>? list;
      if (responseData is List) {
        list = responseData;
      } else if (responseData is Map && responseData['shifts'] is List) {
        list = responseData['shifts'] as List<dynamic>;
      }

      if (list == null || list.isEmpty) {
        _logger.w('RemoteToLocalSyncService: no remote shifts available');
        return false;
      }

      await _db.transaction(() async {
        final remoteIds = <int>{};
        for (final item in list!) {
          if (item is Map<String, dynamic>) {
            await _upsertShiftData(item);
            final id = _safeParseInt(item['id']);
            if (id != null && id != 0) remoteIds.add(id);
          }
        }
        await _purgeMissingRows(
          label: 'shift',
          received: list?.length ?? 0,
          limit: 50,
          remoteIds: remoteIds,
          purge: _db.deleteShiftsNotIn,
        );
      });

      _logger.i('RemoteToLocalSyncService: shifts sync completed');
      return true;
    } catch (e) {
      _logger.w('RemoteToLocalSyncService: shifts fetch failed ($e)');
      return false;
    }
  }

  Future<void> _upsertShiftData(Map<String, dynamic> map) async {
    _logger.i('RemoteToLocalSyncService: upserting shift data: $map');
    try {
      final id = _safeParseInt(map['id']) ?? 0;
      if (id == 0) return;

      final now = DateTime.now().toIso8601String();
      final mealTypeIds =
          (map['mealTypeAllowed'] as List<dynamic>?)
              ?.map((e) => _safeParseInt(e['id']) ?? 0)
              .toList() ??
          [];

      final companion = ShiftsCompanion(
        id: Value(id),
        name: Value(map['name'] as String? ?? ''),
        hours: Value(_safeParseInt(map['hours']) ?? 0),
        companyId: Value.absentIfNull(_safeParseInt(map['companyId'])),
        dailyMealQuota: Value(
          _safeParseInt(map['dailyMealQuota']) ??
              _safeParseInt(map['daily_meal_quota']) ??
              0,
        ),
        workingDaysPerMonth: Value(
          _safeParseInt(map['workingDaysPerMonth']) ??
              _safeParseInt(map['working_days_per_month']) ??
              0,
        ),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(now),
      );

      await _db.insertShift(
        companion,
        mealTypeIds: mealTypeIds,
        mode: InsertMode.insertOrReplace,
      );
    } catch (e, stack) {
      _logger.e(
        'RemoteToLocalSyncService: failed to upsert shift: $e',
        stackTrace: stack,
      );
    }
  }

  int? _safeParseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// The manual (no-shift) quota period covering today, if the server has one.
  ///
  /// Shift-derived staff read their allowance from the Shifts row, so only
  /// `source == 'manual'` rows are considered here. Legacy per-meal-type rows
  /// carry no period and are ignored, matching the server's own gate.
  _ManualQuota? _activeManualQuota(dynamic quotas) {
    if (quotas is! List) return null;

    final now = DateTime.now();
    final today = _dateOnly(now);

    _ManualQuota? best;

    for (final item in quotas) {
      if (item is! Map) continue;

      final source =
          (item['source'] as String?)?.trim().toLowerCase() ?? '';
      if (source != 'manual') continue;

      final start = _parseDate(item['periodStart'] ?? item['period_start']);
      final end = _parseDate(item['periodEnd'] ?? item['period_end']);

      final startDay = start == null ? null : _dateOnly(start);
      final endDay = end == null ? null : _dateOnly(end);

      // A window that has not opened yet, or has already closed, is not the
      // period in force. An open-ended window is treated as still running.
      if (startDay != null && startDay.isAfter(today)) continue;
      if (endDay != null && endDay.isBefore(today)) continue;

      // Prefer the most specific window when several overlap.
      if (best == null ||
          (startDay != null && startDay.isAfter(best.start))) {
        best = _ManualQuota(
          daily: _safeParseInt(item['dailyQuota'] ?? item['daily_quota']) ?? 0,
          monthly:
              _safeParseInt(item['monthlyQuota'] ?? item['monthly_quota']) ??
              _safeParseInt(item['total'] ?? item['totalOrderQty']) ??
              0,
          periodStart: _isoDate(item['periodStart'] ?? item['period_start']),
          periodEnd: _isoDate(item['periodEnd'] ?? item['period_end']),
          start: startDay ?? DateTime(1970),
        );
      }
    }

    return best;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  String? _isoDate(dynamic value) {
    final parsed = _parseDate(value);
    if (parsed == null) return null;
    return '${parsed.year.toString().padLeft(4, '0')}-'
        '${parsed.month.toString().padLeft(2, '0')}-'
        '${parsed.day.toString().padLeft(2, '0')}';
  }

  double? _safeParseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

/// A person-level quota period set directly on a staff member with no shift.
class _ManualQuota {
  const _ManualQuota({
    required this.daily,
    required this.monthly,
    required this.periodStart,
    required this.periodEnd,
    required this.start,
  });

  final int daily;
  final int monthly;
  final String? periodStart;
  final String? periodEnd;
  final DateTime start;
}

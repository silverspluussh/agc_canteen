import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'tables.dart';
import '../../models/biodata_fingerprint_summary.dart';
import '../../models/work_function.model.dart';
import '../../models/unified_report_order_row.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Sites,
    Departments,
    Shifts,
    ShiftMealTypes,
    Kitchens,
    MenuTypes,
    MealTypes,
    Staff,
    StaffKitchens,
    Dependents,
    DependentVisits,
    DependentKitchens,
    Cards,
    Users,
    UserKitchens,
    Orders,
    WorkFunctions,
    FunctionOrders,
    PosDevices,
    ActivityLogs,
    GroupOrders,
    Contractors,
    ContractorStaffTable,
    ContractorStaffKitchens,
    Visitors,
    VisitorKitchens,
    BioDataEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Max push attempts before an order is parked in the terminal state (4).
  static const int _maxOrderSyncAttempts = 5;

  /// Same cap for bio-data rows: without it a permanently-bad payload was
  /// re-pushed on every sync pass and the error log grew without bound.
  static const int _maxBioDataSyncAttempts = 5;

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createPerformanceIndexes();
    },
    onUpgrade: (m, from, to) async {
      // A database created before ContractorStaffTable existed (the schema was
      // reset in an earlier release) has no upgrade path that creates it, so
      // contractor-staff sync silently failed on such terminals. Ensure the
      // table exists before any of its column migrations below run.
      final contractorStaffTableCreated = await _ensureContractorStaffTable(m);
      if (from < 2) {
        await _createPerformanceIndexes();
      }
      if (from < 3 && !contractorStaffTableCreated) {
        await m.addColumn(
          contractorStaffTable,
          contractorStaffTable.allowGroupOrder,
        );
        await m.addColumn(
          contractorStaffTable,
          contractorStaffTable.maxOrderCount,
        );
      }
      if (from < 4) {
        await m.addColumn(orders, orders.syncAttempts);
        await m.addColumn(orders, orders.lastSyncError);
      }
      if (from < 5) {
        await m.addColumn(shifts, shifts.dailyMealQuota);
        await m.addColumn(shifts, shifts.workingDaysPerMonth);
        await m.addColumn(dependents, dependents.contractorStaffId);
        await m.addColumn(dependents, dependents.parentStatus);
        await m.createTable(dependentVisits);
        if (!contractorStaffTableCreated) {
          await m.addColumn(
            contractorStaffTable,
            contractorStaffTable.dailyQuota,
          );
        }
        await m.addColumn(visitors, visitors.dailyQuota);
      }
      if (from < 6) {
        await m.addColumn(staff, staff.manualDailyQuota);
        await m.addColumn(staff, staff.manualMonthlyQuota);
        await m.addColumn(staff, staff.quotaPeriodStart);
        await m.addColumn(staff, staff.quotaPeriodEnd);
      }
      if (from < 7) {
        await m.createTable(workFunctions);
        await m.createTable(functionOrders);
      }
      if (from < 8) {
        await m.addColumn(bioDataEntries, bioDataEntries.uuid);
        await m.addColumn(bioDataEntries, bioDataEntries.syncAttempts);
        await m.addColumn(bioDataEntries, bioDataEntries.lastSyncError);
        // Backfill a stable idempotency key for rows captured before this
        // version. Without it those rows would keep pushing a null uuid and the
        // server would mint a fresh one per attempt.
        await _backfillBioDataUuids();
        await _quarantineLegacyGroupOrders();
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
      await customStatement('PRAGMA synchronous = NORMAL');
    },
  );

  /// Creates [contractorStaffTable] when an upgraded database is missing it.
  ///
  /// [Migrator.createTable] is not idempotent, so check sqlite_master first.
  /// Returns true when the table had to be created (its full current schema is
  /// created, so the later `addColumn` migrations for it must be skipped).
  Future<bool> _ensureContractorStaffTable(Migrator m) async {
    final existing = await customSelect(
      "SELECT name FROM sqlite_master "
      "WHERE type = 'table' AND name = 'contractor_staff_table'",
    ).getSingleOrNull();
    if (existing != null) return false;

    await m.createTable(contractorStaffTable);
    return true;
  }

  /// Gives every pre-existing bio-data row a durable uuid, derived from its own
  /// id so the value is deterministic and never collides.
  Future<void> _backfillBioDataUuids() async {
    final missing = await (select(bioDataEntries)
          ..where((t) => t.uuid.isNull()))
        .get();

    for (final row in missing) {
      await (update(bioDataEntries)..where((t) => t.id.equals(row.id))).write(
        BioDataEntriesCompanion(
          uuid: Value(_uuidV4()),
        ),
      );
    }
  }

  /// Group ordering is retired: the POS writes each voucher as an individual
  /// normal order, so nothing pushes this table any more. Rows left over from
  /// older builds are parked in the terminal state (4) rather than sitting at 0
  /// forever, which made the sync screen report a permanently unsynced queue
  /// that could never drain. The table itself is removed in a later cleanup.
  Future<void> _quarantineLegacyGroupOrders() async {
    await customStatement(
      'UPDATE group_orders SET sync_status = 4 WHERE sync_status != 2',
    );
  }

  static String _uuidV4() => const Uuid().v4();

  Future<void> _createPerformanceIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_orders_sync_status ON orders (sync_status)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders (created_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_orders_order_code ON orders (order_code)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_group_orders_sync_status ON group_orders (sync_status)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_group_orders_order_code ON group_orders (order_code)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_staff_department_id ON staff (department_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_bio_data_staff_id ON bio_data_entries (staff_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_bio_data_department_id ON bio_data_entries (department_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_bio_data_sync_status ON bio_data_entries (sync_status)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_cards_tag_id ON cards (tag_id)',
    );
  }

  Future<void> clearAll() async {
    await transaction(() async {
      await delete(sites).go();
      await delete(departments).go();
      await delete(shiftMealTypes).go();
      await delete(shifts).go();
      await delete(kitchens).go();
      await delete(menuTypes).go();
      await delete(mealTypes).go();
      await delete(staff).go();
      await delete(staffKitchens).go();
      await delete(contractorStaffKitchens).go();
      await delete(dependentKitchens).go();
      await delete(dependentVisits).go();
      await delete(visitorKitchens).go();
      await delete(dependents).go();
      await delete(cards).go();
      await delete(users).go();
      await delete(userKitchens).go();
      await delete(orders).go();
      await delete(posDevices).go();
      await delete(bioDataEntries).go();
      await delete(visitors).go();
      await delete(contractorStaffTable).go();
      await delete(contractors).go();
      await delete(activityLogs).go();
      });
  }

  Future<Map<String, int>> getSyncStats() async {
    return {
      'sites': await _countUnsyncedSites(),
      'contractors': await _countUnsyncedContractors(),
      'contractor_staff': await _countUnsyncedContractorStaff(),
      'visitors': await _countUnsyncedVisitors(),
      'departments': await _countUnsyncedDepartments(),
      'shifts': await _countUnsyncedShifts(),
      'kitchens': await _countUnsyncedKitchens(),
      'meal_types': await _countUnsyncedMealTypes(),
      'staff': await _countUnsyncedStaff(),
      'users': await _countUnsyncedUsers(),
      'orders': await _countUnsyncedOrders(),
      'function_orders': await _countUnsyncedFunctionOrders(),
      'pos_devices': await _countUnsyncedPosDevices(),
      'bio_data': await _countUnsyncedBioData(),
    };
  }

  Future<int> _countUnsyncedSites() async {
    final count = countAll();
    final query = selectOnly(sites)
      ..addColumns([count])
      ..where(sites.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedContractors() async {
    final count = countAll();
    final query = selectOnly(contractors)
      ..addColumns([count])
      ..where(contractors.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedContractorStaff() async {
    final count = countAll();
    final query = selectOnly(contractorStaffTable)
      ..addColumns([count])
      ..where(contractorStaffTable.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedVisitors() async {
    final count = countAll();
    final query = selectOnly(visitors)
      ..addColumns([count])
      ..where(visitors.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedDepartments() async {
    final count = countAll();
    final query = selectOnly(departments)
      ..addColumns([count])
      ..where(departments.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedShifts() async {
    final count = countAll();
    final query = selectOnly(shifts)
      ..addColumns([count])
      ..where(shifts.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedKitchens() async {
    final count = countAll();
    final query = selectOnly(kitchens)
      ..addColumns([count])
      ..where(kitchens.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedMealTypes() async {
    final count = countAll();
    final query = selectOnly(mealTypes)
      ..addColumns([count])
      ..where(mealTypes.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedStaff() async {
    final count = countAll();
    final query = selectOnly(staff)
      ..addColumns([count])
      ..where(staff.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedUsers() async {
    final count = countAll();
    final query = selectOnly(users)
      ..addColumns([count])
      ..where(users.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedOrders() async {
    final count = countAll();
    final query = selectOnly(orders)
      ..addColumns([count])
      ..where(orders.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedFunctionOrders() async {
    final count = countAll();
    final query = selectOnly(functionOrders)
      ..addColumns([count])
      ..where(functionOrders.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedPosDevices() async {
    final count = countAll();
    final query = selectOnly(posDevices)
      ..addColumns([count])
      ..where(posDevices.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> _countUnsyncedBioData() async {
    final count = countAll();
    final query = selectOnly(bioDataEntries)
      ..addColumns([count])
      ..where(bioDataEntries.syncStatus.isNotValue(2));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<int> countUnsyncedOrders() => _countUnsyncedOrders();

  Future<int> countUnsyncedFunctionOrders() => _countUnsyncedFunctionOrders();

  Future<int> countUnsyncedBioData() => _countUnsyncedBioData();

  Future<int> countStaff() => staff.count().getSingle();

  Future<int> countMealTypes() => mealTypes.count().getSingle();

  Future<int> countBioData() => bioDataEntries.count().getSingle();

  Future<int> countActiveBioData() async {
    final count = countAll();
    final query = selectOnly(bioDataEntries)
      ..addColumns([count])
      ..where(bioDataEntries.isActive.equals(true));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<List<BioDataFingerprintSummary>> getActiveBioDataSummaries() async {
    final query = selectOnly(bioDataEntries)
      ..addColumns([
        bioDataEntries.id,
        bioDataEntries.staffId,
        bioDataEntries.dependentId,
        bioDataEntries.contractorStaffId,
        bioDataEntries.visitorId,
        bioDataEntries.finger,
        bioDataEntries.createdAt,
      ])
      ..where(bioDataEntries.isActive.equals(true));
    final rows = await query.get();
    return rows
        .map(
          (row) => BioDataFingerprintSummary(
            id: row.read(bioDataEntries.id)!,
            staffId: row.read(bioDataEntries.staffId),
            dependentId: row.read(bioDataEntries.dependentId),
            contractorStaffId: row.read(bioDataEntries.contractorStaffId),
            visitorId: row.read(bioDataEntries.visitorId),
            finger: row.read(bioDataEntries.finger)!,
            createdAt: row.read(bioDataEntries.createdAt)!,
          ),
        )
        .toList();
  }

  Future<int> countVisitors() => visitors.count().getSingle();

  Future<int> countContractorStaff() => contractorStaffTable.count().getSingle();

  Future<int> countDependents() => dependents.count().getSingle();

  Future<int> countShifts() => shifts.count().getSingle();

  Future<int> countCards() => cards.count().getSingle();

  Future<int> countDepartments() => departments.count().getSingle();
  // ─── Sites ─────────────────────────────────────────────────

  Future<void> insertSite(
    SitesCompanion site, {
    InsertMode mode = InsertMode.insert,
  }) => into(sites).insert(site, mode: mode);

  Future<void> updateSite(int id, SitesCompanion site) =>
      (update(sites)..where((t) => t.id.equals(id))).write(site);

  Future<void> deleteSite(int id) =>
      (delete(sites)..where((t) => t.id.equals(id))).go();

  Future<List<Site>> getAllSites() => select(sites).get();
  Future<Site?> getSite(int id) =>
      (select(sites)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Site>> getUnsyncedSites() =>
      (select(sites)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markSiteSynced(int id) =>
      (update(sites)..where((t) => t.id.equals(id))).write(
        SitesCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markSiteFailed(int id) =>
      (update(sites)..where((t) => t.id.equals(id))).write(
        SitesCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<int> deleteSitesNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(sites)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(sites)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteSite(record.id);
    }
    return toDelete.length;
  }

  // ─── Departments ───────────────────────────────────────────

  Future<void> insertDepartment(
    DepartmentsCompanion department, {
    InsertMode mode = InsertMode.insert,
  }) => into(departments).insert(department, mode: mode);

  Future<void> updateDepartment(int id, DepartmentsCompanion department) =>
      (update(departments)..where((t) => t.id.equals(id))).write(department);

  Future<void> deleteDepartment(int id) =>
      (delete(departments)..where((t) => t.id.equals(id))).go();

  Future<List<Department>> getAllDepartments() => select(departments).get();

  Stream<List<Department>> watchAllDepartments() =>
      (select(departments)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<Department?> getDepartment(int id) =>
      (select(departments)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> markDepartmentSynced(int id) =>
      (update(departments)..where((t) => t.id.equals(id))).write(
        DepartmentsCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markDepartmentFailed(int id) =>
      (update(departments)..where((t) => t.id.equals(id))).write(
        DepartmentsCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<int> deleteDepartmentsNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(departments)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(departments)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteDepartment(record.id);
    }
    return toDelete.length;
  }

  // ─── Shifts ────────────────────────────────────────────────

  Future<void> insertShift(
    ShiftsCompanion shift, {
    List<int> mealTypeIds = const [],
    InsertMode mode = InsertMode.insert,
  }) async {
    await into(shifts).insert(shift, mode: mode);
    if (mealTypeIds.isNotEmpty && mode == InsertMode.insertOrReplace) {
      await deleteShiftMealTypesByShift(shift.id.value);
    }
    for (final mt in mealTypeIds) {
      await into(shiftMealTypes).insert(
        ShiftMealTypesCompanion(
          shiftId: Value(shift.id.value),
          mealTypeId: Value(mt),
        ),
      );
    }
  }

  Future<void> updateShift(int id, ShiftsCompanion shift,
      {List<int> mealTypeIds = const []}) async {
    await transaction(() async {
      await (update(shifts)..where((t) => t.id.equals(id))).write(shift);
      if (mealTypeIds.isNotEmpty) {
        await deleteShiftMealTypesByShift(id);
        for (final mt in mealTypeIds) {
          await into(shiftMealTypes).insert(
            ShiftMealTypesCompanion(shiftId: Value(id), mealTypeId: Value(mt)),
          );
        }
      }
    });
  }

  Future<void> deleteShift(int id) async {
    await transaction(() async {
      await deleteShiftMealTypesByShift(id);
      await (delete(shifts)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<Shift>> getAllShifts() => select(shifts).get();
  Future<Shift?> getShift(int id) =>
      (select(shifts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Shift>> getShiftsByCompany(int companyId) =>
      (select(shifts)..where((t) => t.companyId.equals(companyId))).get();

  Future<List<ShiftMealType>> getShiftMealTypes(int shiftId) =>
      (select(shiftMealTypes)..where((t) => t.shiftId.equals(shiftId))).get();

  Future<List<int>> getShiftMealTypeIds(int shiftId) async {
    final rows = await getShiftMealTypes(shiftId);
    return rows.map((r) => r.mealTypeId).toList();
  }

  Future<void> deleteShiftMealTypesByShift(int shiftId) =>
      (delete(shiftMealTypes)..where((t) => t.shiftId.equals(shiftId))).go();

  Future<List<Shift>> getUnsyncedShifts() =>
      (select(shifts)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markShiftSynced(int id) =>
      (update(shifts)..where((t) => t.id.equals(id))).write(
        ShiftsCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markShiftFailed(int id) =>
      (update(shifts)..where((t) => t.id.equals(id))).write(
        ShiftsCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<int> deleteShiftsNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(shifts)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(shifts)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteShift(record.id);
    }
    return toDelete.length;
  }

  // ─── Kitchens ──────────────────────────────────────────────

  Future<void> insertKitchen(
    KitchensCompanion kitchen, {
    InsertMode mode = InsertMode.insert,
  }) => into(kitchens).insert(kitchen, mode: mode);

  Future<void> updateKitchen(int id, KitchensCompanion kitchen) =>
      (update(kitchens)..where((t) => t.id.equals(id))).write(kitchen);

  Future<void> deleteKitchen(int id) =>
      (delete(kitchens)..where((t) => t.id.equals(id))).go();

  Future<List<Kitchen>> getAllKitchens() => select(kitchens).get();
  Future<Kitchen?> getKitchen(int id) =>
      (select(kitchens)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Kitchen>> getKitchensByCompany(int companyId) =>
      (select(kitchens)..where((t) => t.companyId.equals(companyId))).get();

  Future<List<Kitchen>> getUnsyncedKitchens() =>
      (select(kitchens)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markKitchenSynced(int id) =>
      (update(kitchens)..where((t) => t.id.equals(id))).write(
        KitchensCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markKitchenFailed(int id) =>
      (update(kitchens)..where((t) => t.id.equals(id))).write(
        KitchensCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<int> deleteKitchensNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(kitchens)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(kitchens)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteKitchen(record.id);
    }
    return toDelete.length;
  }

  // ─── MenuTypes ─────────────────────────────────────────────

  Future<void> insertMenuType(
    MenuTypesCompanion menuType, {
    InsertMode mode = InsertMode.insert,
  }) => into(menuTypes).insert(menuType, mode: mode);

  Future<void> updateMenuType(int id, MenuTypesCompanion menuType) =>
      (update(menuTypes)..where((t) => t.id.equals(id))).write(menuType);

  Future<void> deleteMenuType(int id) =>
      (delete(menuTypes)..where((t) => t.id.equals(id))).go();

  Future<List<MenuType>> getAllMenuTypes() => select(menuTypes).get();
  Future<MenuType?> getMenuType(int id) =>
      (select(menuTypes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> deleteMenuTypesNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(menuTypes)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(menuTypes)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteMenuType(record.id);
    }
    return toDelete.length;
  }

  // ─── MealTypes ─────────────────────────────────────────────

  Future<void> insertMealType(
    MealTypesCompanion mealType, {
    InsertMode mode = InsertMode.insert,
  }) => into(mealTypes).insert(mealType, mode: mode);

  Future<void> updateMealType(int id, MealTypesCompanion mealType) =>
      (update(mealTypes)..where((t) => t.id.equals(id))).write(mealType);

  Future<void> deleteMealType(int id) =>
      (delete(mealTypes)..where((t) => t.id.equals(id))).go();

  Future<List<MealType>> getAllMealTypes() => select(mealTypes).get();
  Future<MealType?> getMealType(int id) =>
      (select(mealTypes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<MealType>> getUnsyncedMealTypes() =>
      (select(mealTypes)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markMealTypeSynced(int id) =>
      (update(mealTypes)..where((t) => t.id.equals(id))).write(
        MealTypesCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markMealTypeFailed(int id) =>
      (update(mealTypes)..where((t) => t.id.equals(id))).write(
        MealTypesCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  /// Deletes synced MealType records whose IDs are not in [keepIds].
  Future<int> deleteMealTypesNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      final deleted = await (delete(mealTypes)
            ..where((t) => t.syncStatus.equals(2)))
          .go();
      return deleted;
    }
    final toDelete = await (select(mealTypes)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteMealType(record.id);
    }
    return toDelete.length;
  }

  // ─── Staff ─────────────────────────────────────────────────

  Future<void> insertStaff(
    StaffCompanion staff, {
    List<int> kitchenIds = const [],
    InsertMode mode = InsertMode.insert,
  }) async {
    await into(this.staff).insert(staff, mode: mode);
    if (kitchenIds.isNotEmpty) {
      for (final kid in kitchenIds) {
        await into(staffKitchens).insert(
          StaffKitchensCompanion(
            staffId: Value(staff.id.value),
            kitchenId: Value(kid),
          ),
        );
      }
    }
  }

  Future<void> updateStaff(int id, StaffCompanion staff,
      {List<int> kitchenIds = const []}) async {
    await transaction(() async {
      await (update(this.staff)..where((t) => t.id.equals(id))).write(staff);
      if (kitchenIds.isNotEmpty) {
        await deleteStaffKitchensByStaff(id);
        for (final kid in kitchenIds) {
          await into(staffKitchens).insert(
            StaffKitchensCompanion(staffId: Value(id), kitchenId: Value(kid)),
          );
        }
      }
    });
  }

  Future<void> deleteStaff(int id) async {
    await transaction(() async {
      await deleteStaffKitchensByStaff(id);
      await deleteDependentsByStaff(id);
      await deleteCardsByAssignedTo(id);
      await deleteBioDataByStaff(id);
      await (delete(staff)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<StaffData>> getAllStaff() => select(staff).get();

  Future<List<StaffData>> searchStaff(
    String query, {
    int limit = 20,
  }) async {
    final trimmed = query.trim();
    final queryBuilder = select(staff)
      ..orderBy([(t) => OrderingTerm(expression: t.firstName)])
      ..limit(limit);

    if (trimmed.isNotEmpty) {
      final pattern = '%${trimmed.replaceAll('%', '')}%';
      queryBuilder.where(
        (t) =>
            t.firstName.like(pattern) |
            t.lastName.like(pattern) |
            t.empId.like(pattern),
      );
    }

    return queryBuilder.get();
  }

  Future<StaffData?> getStaff(int id) =>
      (select(staff)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<StaffData>> getUnsyncedStaff() =>
      (select(staff)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markStaffSynced(int id) =>
      (update(staff)..where((t) => t.id.equals(id))).write(
        StaffCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markStaffFailed(int id) =>
      (update(staff)..where((t) => t.id.equals(id))).write(
        StaffCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<int> deleteStaffNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(staff)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(staff)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteStaff(record.id);
    }
    return toDelete.length;
  }

  // ─── StaffKitchens ─────────────────────────────────────────

  Future<void> insertStaffKitchen(StaffKitchensCompanion entry) =>
      into(staffKitchens).insert(entry);

  Future<void> deleteStaffKitchen(int staffId, int kitchenId) =>
      (delete(staffKitchens)
            ..where((t) =>
                t.staffId.equals(staffId) & t.kitchenId.equals(kitchenId)))
          .go();

  Future<void> deleteStaffKitchensByStaff(int staffId) =>
      (delete(staffKitchens)..where((t) => t.staffId.equals(staffId))).go();

  Future<List<StaffKitchen>> getStaffKitchens(int staffId) =>
      (select(staffKitchens)..where((t) => t.staffId.equals(staffId))).get();

  Future<List<int>> getStaffKitchenIds(int staffId) async {
    final rows = await getStaffKitchens(staffId);
    return rows.map((r) => r.kitchenId).toList();
  }

  Future<void> setStaffKitchens(int staffId, List<int> kitchenIds) async {
    await transaction(() async {
      await deleteStaffKitchensByStaff(staffId);
      for (final kid in kitchenIds) {
        await into(staffKitchens).insert(
          StaffKitchensCompanion(staffId: Value(staffId), kitchenId: Value(kid)),
        );
      }
    });
  }

  // ─── DependentKitchens ─────────────────────────────────────

  Future<void> insertDependentKitchen(DependentKitchensCompanion entry) =>
      into(dependentKitchens).insert(entry);

  Future<void> deleteDependentKitchen(int dependentId, int kitchenId) =>
      (delete(dependentKitchens)
            ..where((t) =>
                t.dependentId.equals(dependentId) & t.kitchenId.equals(kitchenId)))
          .go();

  Future<void> deleteDependentKitchensByDependent(int dependentId) =>
      (delete(dependentKitchens)..where((t) => t.dependentId.equals(dependentId))).go();

  Future<List<DependentKitchen>> getDependentKitchens(int dependentId) =>
      (select(dependentKitchens)..where((t) => t.dependentId.equals(dependentId))).get();

  Future<List<int>> getDependentKitchenIds(int dependentId) async {
    final rows = await getDependentKitchens(dependentId);
    return rows.map((r) => r.kitchenId).toList();
  }

  Future<void> setDependentKitchens(int dependentId, List<int> kitchenIds) async {
    await transaction(() async {
      await deleteDependentKitchensByDependent(dependentId);
      for (final kid in kitchenIds) {
        await into(dependentKitchens).insert(
          DependentKitchensCompanion(dependentId: Value(dependentId), kitchenId: Value(kid)),
        );
      }
    });
  }

  // ─── ContractorStaffKitchens ───────────────────────────────

  Future<void> insertContractorStaffKitchen(ContractorStaffKitchensCompanion entry) =>
      into(contractorStaffKitchens).insert(entry);

  Future<void> deleteContractorStaffKitchen(int contractorStaffId, int kitchenId) =>
      (delete(contractorStaffKitchens)
            ..where((t) =>
                t.contractorStaffId.equals(contractorStaffId) & t.kitchenId.equals(kitchenId)))
          .go();

  Future<void> deleteContractorStaffKitchensByContractorStaff(int contractorStaffId) =>
      (delete(contractorStaffKitchens)..where((t) => t.contractorStaffId.equals(contractorStaffId))).go();

  Future<List<ContractorStaffKitchen>> getContractorStaffKitchens(int contractorStaffId) =>
      (select(contractorStaffKitchens)..where((t) => t.contractorStaffId.equals(contractorStaffId))).get();

  Future<List<int>> getContractorStaffKitchenIds(int contractorStaffId) async {
    final rows = await getContractorStaffKitchens(contractorStaffId);
    return rows.map((r) => r.kitchenId).toList();
  }

  Future<void> setContractorStaffKitchens(int contractorStaffId, List<int> kitchenIds) async {
    await transaction(() async {
      await deleteContractorStaffKitchensByContractorStaff(contractorStaffId);
      for (final kid in kitchenIds) {
        await into(contractorStaffKitchens).insert(
          ContractorStaffKitchensCompanion(contractorStaffId: Value(contractorStaffId), kitchenId: Value(kid)),
        );
      }
    });
  }

  // ─── VisitorKitchens ───────────────────────────────────────

  Future<void> insertVisitorKitchen(VisitorKitchensCompanion entry) =>
      into(visitorKitchens).insert(entry);

  Future<void> deleteVisitorKitchen(int visitorId, int kitchenId) =>
      (delete(visitorKitchens)
            ..where((t) =>
                t.visitorId.equals(visitorId) & t.kitchenId.equals(kitchenId)))
          .go();

  Future<void> deleteVisitorKitchensByVisitor(int visitorId) =>
      (delete(visitorKitchens)..where((t) => t.visitorId.equals(visitorId))).go();

  Future<List<VisitorKitchen>> getVisitorKitchens(int visitorId) =>
      (select(visitorKitchens)..where((t) => t.visitorId.equals(visitorId))).get();

  Future<List<int>> getVisitorKitchenIds(int visitorId) async {
    final rows = await getVisitorKitchens(visitorId);
    return rows.map((r) => r.kitchenId).toList();
  }

  Future<void> setVisitorKitchens(int visitorId, List<int> kitchenIds) async {
    await transaction(() async {
      await deleteVisitorKitchensByVisitor(visitorId);
      for (final kid in kitchenIds) {
        await into(visitorKitchens).insert(
          VisitorKitchensCompanion(visitorId: Value(visitorId), kitchenId: Value(kid)),
        );
      }
    });
  }

  // ─── Dependents ────────────────────────────────────────────

  Future<void> insertDependent(
    DependentsCompanion dependent, {
    InsertMode mode = InsertMode.insert,
  }) => into(dependents).insert(dependent, mode: mode);

  Future<void> updateDependent(int id, DependentsCompanion dependent) =>
      (update(dependents)..where((t) => t.id.equals(id))).write(dependent);

  Future<void> deleteDependent(int id) async {
    await transaction(() async {
      await deleteDependentKitchensByDependent(id);
      await deleteDependentVisitsByDependent(id);
      await deleteBioDataByDependent(id);
      await (delete(dependents)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> deleteDependentsByStaff(int staffId) =>
      (delete(dependents)..where((t) => t.staffId.equals(staffId))).go();

  Future<List<Dependent>> getAllDependents() => select(dependents).get();
  Future<Dependent?> getDependent(int id) =>
      (select(dependents)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Dependent>> getDependentsByStaff(int staffId) =>
      (select(dependents)..where((t) => t.staffId.equals(staffId))).get();

  Future<List<Dependent>> getDependentsByContractorStaff(
    int contractorStaffId,
  ) =>
      (select(dependents)
            ..where((t) => t.contractorStaffId.equals(contractorStaffId)))
          .get();

  // ─── DependentVisits ───────────────────────────────────────

  Future<void> insertDependentVisit(
    DependentVisitsCompanion visit, {
    InsertMode mode = InsertMode.insert,
  }) => into(dependentVisits).insert(visit, mode: mode);

  Future<void> deleteDependentVisitsByDependent(int dependentId) =>
      (delete(dependentVisits)..where((t) => t.dependentId.equals(dependentId)))
          .go();

  Future<int> deleteDependentVisitsNotIn(
    int dependentId,
    Set<int> keepIds,
  ) async {
    if (keepIds.isEmpty) {
      return (delete(dependentVisits)
            ..where((t) =>
                t.dependentId.equals(dependentId) & t.syncStatus.equals(2)))
          .go();
    }
    final toDelete = await (select(dependentVisits)
          ..where((t) =>
              t.dependentId.equals(dependentId) &
              t.syncStatus.equals(2) &
              t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await (delete(dependentVisits)..where((t) => t.id.equals(record.id)))
          .go();
    }
    return toDelete.length;
  }

  Future<List<DependentVisit>> getVisitsByDependent(int dependentId) =>
      (select(dependentVisits)
            ..where((t) => t.dependentId.equals(dependentId))
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();

  /// Visit covering [day] (yyyy-MM-dd) that is not cancelled, if any.
  Future<DependentVisit?> getActiveVisitForDependent(
    int dependentId,
    String day,
  ) =>
      (select(dependentVisits)
            ..where((t) =>
                t.dependentId.equals(dependentId) &
                t.status.isNotValue('cancelled') &
                t.startDate.isSmallerOrEqualValue(day) &
                t.endDate.isBiggerOrEqualValue(day))
            ..orderBy([(t) => OrderingTerm.desc(t.endDate)])
            ..limit(1))
          .getSingleOrNull();

  Future<bool> hasAnyVisitForDependent(int dependentId) async {
    final count = countAll();
    final query = selectOnly(dependentVisits)
      ..addColumns([count])
      ..where(dependentVisits.dependentId.equals(dependentId));
    return ((await query.getSingle()).read(count) ?? 0) > 0;
  }

  Future<void> markDependentSynced(int id) =>
      (update(dependents)..where((t) => t.id.equals(id))).write(
        DependentsCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markDependentFailed(int id) =>
      (update(dependents)..where((t) => t.id.equals(id))).write(
        DependentsCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<int> deleteDependentsNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(dependents)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(dependents)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteDependent(record.id);
    }
    return toDelete.length;
  }

  // ─── Cards ─────────────────────────────────────────────────

  Future<void> insertCard(
    CardsCompanion card, {
    InsertMode mode = InsertMode.insert,
  }) => into(cards).insert(card, mode: mode);

  Future<void> updateCard(int id, CardsCompanion card) =>
      (update(cards)..where((t) => t.id.equals(id))).write(card);

  Future<void> deleteCard(int id) =>
      (delete(cards)..where((t) => t.id.equals(id))).go();

  Future<void> deleteCardsByAssignedTo(int assignedToId) =>
      (delete(cards)..where((t) => t.assignedToId.equals(assignedToId))).go();

  Future<int> deleteCardsNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(cards)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(cards)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteCard(record.id);
    }
    return toDelete.length;
  }

  Future<List<Card>> getAllCards() => select(cards).get();
  Future<Card?> getCard(int id) =>
      (select(cards)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<Card?> getCardByTagId(String tagId, {int? departmentId}) {
    final query = select(cards)..where((t) => t.tagId.equals(tagId));
    if (departmentId != null) {
      query.where((t) => t.departmentId.equals(departmentId));
    }
    return query.getSingleOrNull();
  }

  Future<List<Card>> getCardsByAssignedTo(int assignedToId) =>
      (select(cards)..where((t) => t.assignedToId.equals(assignedToId))).get();

  Future<void> markCardSynced(int id) =>
      (update(cards)..where((t) => t.id.equals(id))).write(
        CardsCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markCardFailed(int id) =>
      (update(cards)..where((t) => t.id.equals(id))).write(
        CardsCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  // ─── Contractors ──────────────────────────────────────────

  Future<void> insertContractor(
    ContractorsCompanion contractor, {
    InsertMode mode = InsertMode.insert,
  }) => into(contractors).insert(contractor, mode: mode);

  Future<void> updateContractor(int id, ContractorsCompanion contractor) =>
      (update(contractors)..where((t) => t.id.equals(id))).write(contractor);

  Future<void> deleteContractor(int id) =>
      (delete(contractors)..where((t) => t.id.equals(id))).go();

  Future<List<Contractor>> getAllContractors() => select(contractors).get();
  Future<Contractor?> getContractor(int id) =>
      (select(contractors)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Contractor>> getContractorsByCompany(int companyId) =>
      (select(contractors)..where((t) => t.companyId.equals(companyId))).get();

  Future<void> markContractorSynced(int id) =>
      (update(contractors)..where((t) => t.id.equals(id))).write(
        ContractorsCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markContractorFailed(int id) =>
      (update(contractors)..where((t) => t.id.equals(id))).write(
        ContractorsCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  // ─── ContractorStaff ──────────────────────────────────────

  Future<void> insertContractorStaff(
    ContractorStaffTableCompanion cStaff, {
    InsertMode mode = InsertMode.insert,
  }) => into(contractorStaffTable).insert(cStaff, mode: mode);

  Future<void> updateContractorStaff(
          int id, ContractorStaffTableCompanion cStaff) =>
      (update(contractorStaffTable)..where((t) => t.id.equals(id)))
          .write(cStaff);

  Future<void> deleteContractorStaff(int id) async {
    await transaction(() async {
      await deleteContractorStaffKitchensByContractorStaff(id);
      await deleteBioDataByContractorStaff(id);
      await (delete(contractorStaffTable)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> deleteContractorStaffByContractor(int contractorId) =>
      (delete(contractorStaffTable)
            ..where((t) => t.contractorId.equals(contractorId)))
          .go();

  Future<List<ContractorStaffTableData>> getAllContractorStaff() =>
      select(contractorStaffTable).get();
  Future<ContractorStaffTableData?> getContractorStaff(int id) =>
      (select(contractorStaffTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<ContractorStaffTableData>> getContractorStaffByContractor(
          int contractorId) =>
      (select(contractorStaffTable)
            ..where((t) => t.contractorId.equals(contractorId)))
          .get();

  Future<void> markContractorStaffSynced(int id) =>
      (update(contractorStaffTable)..where((t) => t.id.equals(id))).write(
        ContractorStaffTableCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markContractorStaffFailed(int id) =>
      (update(contractorStaffTable)..where((t) => t.id.equals(id))).write(
        ContractorStaffTableCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<int> deleteContractorStaffNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(contractorStaffTable)
            ..where((t) => t.syncStatus.equals(2)))
          .go();
    }
    final toDelete = await (select(contractorStaffTable)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteContractorStaff(record.id);
    }
    return toDelete.length;
  }

  // ─── Visitors ─────────────────────────────────────────────

  Future<void> insertVisitor(
    VisitorsCompanion visitor, {
    InsertMode mode = InsertMode.insert,
  }) => into(visitors).insert(visitor, mode: mode);

  Future<void> updateVisitor(int id, VisitorsCompanion visitor) =>
      (update(visitors)..where((t) => t.id.equals(id))).write(visitor);

  Future<void> deleteVisitor(int id) async {
    await transaction(() async {
      await deleteVisitorKitchensByVisitor(id);
      await deleteBioDataByVisitor(id);
      await (delete(visitors)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<Visitor>> getAllVisitors() => select(visitors).get();
  Future<Visitor?> getVisitor(int id) =>
      (select(visitors)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> markVisitorSynced(int id) =>
      (update(visitors)..where((t) => t.id.equals(id))).write(
        VisitorsCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markVisitorFailed(int id) =>
      (update(visitors)..where((t) => t.id.equals(id))).write(
        VisitorsCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<int> deleteVisitorsNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(visitors)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(visitors)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteVisitor(record.id);
    }
    return toDelete.length;
  }

  // ─── Users ─────────────────────────────────────────────────

  Future<void> insertUser(UsersCompanion user, List<int> kitchenIds) async {
    await transaction(() async {
      await into(users).insert(user);
      for (final kid in kitchenIds) {
        await into(userKitchens).insert(
          UserKitchensCompanion(
            userId: Value(user.id.value),
            kitchenId: Value(kid),
          ),
        );
      }
    });
  }

  Future<void> updateUser(UsersCompanion user, List<int> kitchenIds) async {
    final id = user.id.value;
    await transaction(() async {
      await (update(users)..where((t) => t.id.equals(id))).write(user);
      await (delete(userKitchens)..where((t) => t.userId.equals(id))).go();
      for (final kid in kitchenIds) {
        await into(userKitchens).insert(
          UserKitchensCompanion(userId: Value(id), kitchenId: Value(kid)),
        );
      }
    });
  }

  Future<void> deleteUser(int id) async {
    await transaction(() async {
      await (delete(userKitchens)..where((t) => t.userId.equals(id))).go();
      await (delete(users)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<User>> getAllUsers() => select(users).get();
  Future<User?> getUser(int id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<UserKitchen>> getUserKitchens(int userId) =>
      (select(userKitchens)..where((t) => t.userId.equals(userId))).get();

  Future<List<User>> getUnsyncedUsers() =>
      (select(users)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markUserSynced(int id) =>
      (update(users)..where((t) => t.id.equals(id))).write(
        UsersCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markUserFailed(int id) =>
      (update(users)..where((t) => t.id.equals(id))).write(
        UsersCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<int> deleteUsersNotIn(Set<int> keepIds) async {
    List<User> toDelete;
    if (keepIds.isEmpty) {
      toDelete = await (select(users)
            ..where((t) => t.syncStatus.equals(2)))
          .get();
    } else {
      toDelete = await (select(users)
            ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
          .get();
    }
    for (final user in toDelete) {
      await deleteUser(user.id);
    }
    return toDelete.length;
  }

  // ─── Orders ────────────────────────────────────────────────

  /// Allocates a local primary key that cannot collide.
  ///
  /// These ids used to be `DateTime.now().millisecondsSinceEpoch`, which repeats
  /// whenever two rows are written inside the same millisecond — rapid scans, a
  /// group batch written in a loop, or two unawaited syncs finishing together.
  /// The primary key conflict then threw and the row was silently lost, usually
  /// surfacing to the operator as "failed to print voucher".
  ///
  /// MAX(id) on an integer primary key is an O(1) lookup in SQLite, so this stays
  /// cheap enough to call on every insert, and it is immune to clock skew and
  /// to same-millisecond writes. Tables that also sync carry their own uuid
  /// column, which is what the server deduplicates on.
  Future<int> nextLocalId(String table) async {
    final row = await customSelect(
      'SELECT COALESCE(MAX(id), 0) + 1 AS next_id FROM $table',
    ).getSingle();

    return row.read<int>('next_id');
  }

  /// Allocates [count] consecutive ids in one round trip, for batch inserts.
  Future<List<int>> nextLocalIds(String table, int count) async {
    if (count <= 0) return const [];
    final first = await nextLocalId(table);
    return List<int>.generate(count, (index) => first + index);
  }

  Future<void> insertOrder(
    OrdersCompanion order, {
    InsertMode mode = InsertMode.insert,
  }) async {
    await into(orders).insert(order, mode: mode);
  }

  Future<void> updateOrder(int id, OrdersCompanion order) =>
      (update(orders)..where((t) => t.id.equals(id))).write(order);

  Future<void> deleteOrder(int id) =>
      (delete(orders)..where((t) => t.id.equals(id))).go();

  Future<List<Order>> getAllOrders() => select(orders).get();
  Future<Order?> getOrder(int id) =>
      (select(orders)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Orders placed by one person, optionally bounded to a day (yyyy-MM-dd
  /// prefix) and/or an ISO window. Local orders only (all rows count —
  /// synced or not — since the device is the source of truth offline).
  Future<int> countOrdersByPerson({
    required int personId,
    required String employeeType,
    String? dayPrefix,
    String? windowStartIso,
    String? windowEndIso,
  }) async {
    final count = countAll();
    final query = selectOnly(orders)
      ..addColumns([count])
      ..where(
        orders.orderedById.equals(personId) &
            orders.employeeType.equals(employeeType),
      );
    if (dayPrefix != null) {
      query.where(orders.createdAt.like('$dayPrefix%'));
    }
    if (windowStartIso != null) {
      query.where(orders.createdAt.isBiggerOrEqualValue(windowStartIso));
    }
    if (windowEndIso != null) {
      query.where(orders.createdAt.isSmallerOrEqualValue(windowEndIso));
    }
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<List<Order>> getUnsyncedOrders() => (select(orders)..where(
        (t) =>
            t.syncStatus.isIn([0, 3]) &
            t.syncAttempts.isSmallerThanValue(_maxOrderSyncAttempts),
      )).get();

  Future<({int count, double revenue})> aggregateOrders({
    String? createdAtFrom,
    String? createdAtToInclusive,
    String? createdAtToExclusive,
  }) async {
    final query = selectOnly(orders)
      ..addColumns([orders.id.count(), orders.total.sum()]);
    if (createdAtFrom != null) {
      query.where(orders.createdAt.isBiggerOrEqualValue(createdAtFrom));
    }
    if (createdAtToInclusive != null) {
      query.where(orders.createdAt.isSmallerOrEqualValue(createdAtToInclusive));
    }
    if (createdAtToExclusive != null) {
      query.where(orders.createdAt.isSmallerThanValue(createdAtToExclusive));
    }
    final row = await query.getSingle();
    return (
      count: row.read(orders.id.count()) ?? 0,
      revenue: row.read(orders.total.sum()) ?? 0.0,
    );
  }

  Future<int> countMealTypesInRange({
    String? createdAtFrom,
    String? createdAtToInclusive,
    String? createdAtToExclusive,
  }) async {
    final query = selectOnly(mealTypes)..addColumns([mealTypes.id.count()]);
    if (createdAtFrom != null) {
      query.where(mealTypes.createdAt.isBiggerOrEqualValue(createdAtFrom));
    }
    if (createdAtToInclusive != null) {
      query.where(mealTypes.createdAt.isSmallerOrEqualValue(createdAtToInclusive));
    }
    if (createdAtToExclusive != null) {
      query.where(mealTypes.createdAt.isSmallerThanValue(createdAtToExclusive));
    }
    final row = await query.getSingle();
    return row.read(mealTypes.id.count()) ?? 0;
  }

  List<String> _reportOrderFilterClauses({
    String? createdAtFrom,
    String? createdAtToInclusive,
    String? status,
    bool? synced,
    String? mealType,
    String? search,
    required List<Variable> variables,
  }) {
    final clauses = <String>[];
    if (createdAtFrom != null) {
      clauses.add('created_at >= ?');
      variables.add(Variable<String>(createdAtFrom));
    }
    if (createdAtToInclusive != null) {
      clauses.add('created_at <= ?');
      variables.add(Variable<String>(createdAtToInclusive));
    }
    if (status != null) {
      clauses.add('status = ?');
      variables.add(Variable<String>(status));
    }
    if (synced == true) {
      clauses.add('sync_status = 2');
    } else if (synced == false) {
      clauses.add('sync_status != 2');
    }
    if (mealType != null) {
      clauses.add('meal_type = ?');
      variables.add(Variable<String>(mealType));
    }
    // Search is applied here rather than in Dart: filtering the loaded page only
    // ever matched the newest 50 rows, so anything older was unsearchable.
    // Only columns carried by the unified projection are searchable; staff name
    // is resolved client-side from the name maps.
    if (search != null && search.trim().isNotEmpty) {
      final pattern = '%${search.trim().toLowerCase()}%';
      clauses.add(
        '(LOWER(order_code) LIKE ? OR LOWER(meal_type) LIKE ? OR LOWER(status) LIKE ?)',
      );
      variables
        ..add(Variable<String>(pattern))
        ..add(Variable<String>(pattern))
        ..add(Variable<String>(pattern));
    }
    return clauses;
  }

  String _whereSql(List<String> clauses) =>
      clauses.isEmpty ? '' : 'WHERE ${clauses.join(' AND ')}';

  Future<List<UnifiedReportOrderRow>> queryUnifiedOrdersPage({
    String? createdAtFrom,
    String? createdAtToInclusive,
    String? status,
    bool? synced,
    String? mealType,
    String? search,
    int? limit = 50,
    int offset = 0,
  }) async {
    final orderVars = <Variable>[];
    final orderClauses = _reportOrderFilterClauses(
      createdAtFrom: createdAtFrom,
      createdAtToInclusive: createdAtToInclusive,
      status: status,
      synced: synced,
      mealType: mealType,
      search: search,
      variables: orderVars,
    );

    final limitVars = <Variable>[
      if (limit != null) ...[
        Variable<int>(limit),
        Variable<int>(offset),
      ],
    ];

    final sql =
        '''
SELECT * FROM (
  SELECT id, order_code, status, order_type, meal_type, total, group_count,
         sync_status, description, created_at, ordered_by_id, employee_type, 0 AS is_group
  FROM orders ${_whereSql(orderClauses)}
)
ORDER BY created_at DESC
${limit != null ? 'LIMIT ? OFFSET ?' : ''}
''';

    final rows = await customSelect(
      sql,
      variables: [...orderVars, ...limitVars],
      readsFrom: {orders},
    ).get();

    return rows.map((row) => UnifiedReportOrderRow.fromData(row.data)).toList();
  }

  Future<int> countUnifiedOrders({
    String? createdAtFrom,
    String? createdAtToInclusive,
    String? status,
    bool? synced,
    String? mealType,
  }) async {
    final orderVars = <Variable>[];
    final orderClauses = _reportOrderFilterClauses(
      createdAtFrom: createdAtFrom,
      createdAtToInclusive: createdAtToInclusive,
      status: status,
      synced: synced,
      mealType: mealType,
      variables: orderVars,
    );

    final sql =
        '''
SELECT COUNT(*) AS c FROM (
  SELECT id FROM orders ${_whereSql(orderClauses)}
)
''';

    final row = await customSelect(
      sql,
      variables: [...orderVars],
      readsFrom: {orders},
    ).getSingle();
    return row.read<int>('c');
  }

  Future<double> sumUnifiedOrdersRevenue({
    String? createdAtFrom,
    String? createdAtToInclusive,
    String? status,
    bool? synced,
    String? mealType,
  }) async {
    final orderAgg = await aggregateOrders(
      createdAtFrom: createdAtFrom,
      createdAtToInclusive: createdAtToInclusive,
    );
    if (status == null && synced == null && mealType == null) {
      return orderAgg.revenue;
    }

    final orderVars = <Variable>[];
    final orderClauses = _reportOrderFilterClauses(
      createdAtFrom: createdAtFrom,
      createdAtToInclusive: createdAtToInclusive,
      status: status,
      synced: synced,
      mealType: mealType,
      variables: orderVars,
    );

    final sql =
        '''
SELECT COALESCE(SUM(total), 0) AS revenue FROM (
  SELECT total FROM orders ${_whereSql(orderClauses)}
)
''';

    final row = await customSelect(
      sql,
      variables: [...orderVars],
      readsFrom: {orders},
    ).getSingle();
    return row.read<double>('revenue');
  }

  Future<void> markOrderSynced(int id) =>
      (update(orders)..where((t) => t.id.equals(id))).write(
        OrdersCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  /// Records a failed push. Increments the attempt counter and parks the order
  /// in the terminal state ([syncStatus] == 4) once [_maxOrderSyncAttempts] is
  /// reached, so permanently-bad orders stop being retried forever.
  Future<void> markOrderFailed(int id, {String? error}) async {
    final order = await getOrder(id);
    if (order == null) return;
    final attempts = order.syncAttempts + 1;
    final terminal = attempts >= _maxOrderSyncAttempts;
    await (update(orders)..where((t) => t.id.equals(id))).write(
      OrdersCompanion(
        syncStatus: Value(terminal ? 4 : 3),
        syncAttempts: Value(attempts),
        lastSyncError: Value(error),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  // ─── Work Functions ───────────────────────────────────────

  /// Replaces the cached picker list. Called after a successful pull from
  /// /hr/work-functions/active, which already returns only orderable functions.
  Future<void> replaceWorkFunctions(List<WorkFunctionsCompanion> rows) async {
    await transaction(() async {
      await delete(workFunctions).go();
      if (rows.isNotEmpty) {
        await batch((b) => b.insertAll(workFunctions, rows));
      }
    });
  }

  Future<List<WorkFunction>> getAllWorkFunctions() =>
      (select(workFunctions)..orderBy([
          (t) => OrderingTerm(expression: t.functionStartTime),
        ]))
          .get();

  Future<WorkFunction?> getWorkFunction(int id) =>
      (select(workFunctions)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Orderable right now: dated today and inside the start/end window.
  ///
  /// The server already filters, but the POS re-checks locally so an offline or
  /// stale cache can never authorise an order outside the window.
  Future<List<WorkFunction>> getOrderableWorkFunctions([DateTime? now]) async {
    final at = now ?? DateTime.now();
    final all = await getAllWorkFunctions();

    // Delegates to the model so the cache filter, the picker and the order
    // guard all apply exactly the same window rule.
    return all
        .where(
          (fn) => WorkFunctionModel.isWindowOpenAt(
            fn.functionDate,
            fn.functionStartTime,
            fn.functionEndTime,
            at,
          ),
        )
        .toList();
  }

  // ─── Function Orders ──────────────────────────────────────

  Future<void> insertFunctionOrder(
    FunctionOrdersCompanion order, {
    InsertMode mode = InsertMode.insert,
  }) async {
    await into(functionOrders).insert(order, mode: mode);
  }

  Future<List<FunctionOrder>> getAllFunctionOrders() =>
      (select(functionOrders)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
          .get();

  Future<FunctionOrder?> getFunctionOrder(int id) =>
      (select(functionOrders)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<FunctionOrder>> getUnsyncedFunctionOrders() =>
      (select(functionOrders)
            ..where(
              (t) =>
                  t.syncStatus.isIn([0, 3]) &
                  t.syncAttempts.isSmallerThanValue(_maxOrderSyncAttempts),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
          .get();

  Future<void> markFunctionOrderSynced(int id) =>
      (update(functionOrders)..where((t) => t.id.equals(id))).write(
        FunctionOrdersCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
          lastSyncError: const Value(null),
        ),
      );

  /// Mirrors [markOrderFailed]: retries up to [_maxOrderSyncAttempts], then
  /// parks the row in the terminal state (4) so it stops being retried.
  Future<void> markFunctionOrderFailed(int id, {String? error}) async {
    final order = await getFunctionOrder(id);
    if (order == null) return;
    final attempts = order.syncAttempts + 1;
    final terminal = attempts >= _maxOrderSyncAttempts;
    await (update(functionOrders)..where((t) => t.id.equals(id))).write(
      FunctionOrdersCompanion(
        syncStatus: Value(terminal ? 4 : 3),
        syncAttempts: Value(attempts),
        lastSyncError: Value(error),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  /// Function orders taken by a person today. Used for reporting only — these
  /// deliberately do NOT feed the general meal quota pool.
  Future<int> countFunctionOrdersByPerson({
    required int personId,
    required String employeeType,
    required String dayPrefix,
  }) async {
    final count = functionOrders.id.count();
    final query = selectOnly(functionOrders)
      ..addColumns([count])
      ..where(
        functionOrders.orderedById.equals(personId) &
            functionOrders.employeeType.equals(employeeType) &
            functionOrders.createdAt.like('$dayPrefix%'),
      );
    return (await query.getSingle()).read(count) ?? 0;
  }

  // ─── Group Orders ───────────────────────────────────────────

  // ─── PosDevices ────────────────────────────────────────────
  // ─── Only one PosDevice is stored at a time ──────────────────

  Future<void> insertPosDevice(
    PosDevicesCompanion device, {
    InsertMode mode = InsertMode.insert,
  }) async {
    await delete(posDevices).go();
    await into(posDevices).insert(device, mode: mode);
  }

  Future<void> updatePosDevice(int id, PosDevicesCompanion device) =>
      (update(posDevices)..where((t) => t.id.equals(id))).write(device);

  Future<void> deletePosDevice() =>
      delete(posDevices).go();

  Future<List<PosDevice>> getAllPosDevices() => select(posDevices).get();
  Future<PosDevice?> getPosDevice(int id) =>
      (select(posDevices)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Kitchen/location name of the provisioned POS terminal, used as the receipt
  /// header. Falls back to the first cached kitchen when the device has no
  /// kitchen recorded, and null when nothing is known yet.
  Future<String?> getRegisteredKitchenName() async {
    final devices = await getAllPosDevices();
    final deviceKitchen =
        devices.isNotEmpty ? devices.first.kitchenName?.trim() : null;
    if (deviceKitchen != null && deviceKitchen.isNotEmpty) {
      return deviceKitchen;
    }
    final kitchens = await getAllKitchens();
    return kitchens.isNotEmpty ? kitchens.first.name : null;
  }

  Future<List<PosDevice>> getUnsyncedPosDevices() =>
      (select(posDevices)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markPosDeviceSynced() =>
      (update(posDevices)).write(
        PosDevicesCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markPosDeviceFailed() =>
      (update(posDevices)).write(
        PosDevicesCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );


  // ─── BioDataEntries ────────────────────────────────

  /// Inserts a locally captured fingerprint.
  ///
  /// A uuid is stamped here when the caller did not supply one, so no code path
  /// can create a row whose push is not idempotent.
  Future<void> insertBioData(
    BioDataEntriesCompanion entry, {
    InsertMode mode = InsertMode.insert,
  }) => into(bioDataEntries).insert(
        entry.uuid.present ? entry : entry.copyWith(uuid: Value(_uuidV4())),
        mode: mode,
      );

  Future<void> updateBioData(int id, BioDataEntriesCompanion entry) =>
      (update(bioDataEntries)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteBioData(int id) =>
      (delete(bioDataEntries)..where((t) => t.id.equals(id))).go();

  Future<void> deleteBioDataByStaff(int staffId) =>
      (delete(bioDataEntries)..where((t) => t.staffId.equals(staffId))).go();

  Future<void> deleteBioDataByDependent(int dependentId) =>
      (delete(bioDataEntries)..where((t) => t.dependentId.equals(dependentId))).go();

  Future<void> deleteBioDataByContractorStaff(int contractorStaffId) =>
      (delete(bioDataEntries)..where((t) => t.contractorStaffId.equals(contractorStaffId))).go();

  Future<void> deleteBioDataByVisitor(int visitorId) =>
      (delete(bioDataEntries)..where((t) => t.visitorId.equals(visitorId))).go();

  Future<List<BioDataEntry>> getAllBioData() => select(bioDataEntries).get();

  Future<BioDataEntry?> getBioData(int id) =>
      (select(bioDataEntries)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<BioDataEntry>> getBioDataByStaff(int staffId) =>
      (select(bioDataEntries)..where((t) => t.staffId.equals(staffId))).get();

  Future<List<BioDataEntry>> getActiveBioDataByStaff(int staffId) => (select(
    bioDataEntries,
  )..where((t) => t.staffId.equals(staffId) & t.isActive.equals(true))).get();

  Future<List<BioDataEntry>> getActiveBioData() => (select(
    bioDataEntries,
  )..where((t) => t.isActive.equals(true))).get();
  Future<List<BioDataEntry>> getActiveBioDataByDependent(int dependentId) =>
      (select(bioDataEntries)
            ..where((t) => t.dependentId.equals(dependentId) & t.isActive.equals(true)))
          .get();
  Future<List<BioDataEntry>> getActiveBioDataByContractorStaff(
          int contractorStaffId) =>
      (select(bioDataEntries)
            ..where(
                (t) => t.contractorStaffId.equals(contractorStaffId) & t.isActive.equals(true)))
          .get();
  Future<List<BioDataEntry>> getActiveBioDataByVisitor(int visitorId) =>
      (select(bioDataEntries)
            ..where((t) => t.visitorId.equals(visitorId) & t.isActive.equals(true)))
          .get();

  /// Rows still owed to the server: pending (0) or retryable (3), excluding
  /// anything that has exhausted [_maxBioDataSyncAttempts] (parked at 4).
  Future<List<BioDataEntry>> getUnsyncedBioData() =>
      (select(bioDataEntries)
            ..where(
              (t) =>
                  t.syncStatus.isIn([0, 3]) &
                  t.syncAttempts.isSmallerThanValue(_maxBioDataSyncAttempts),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
          .get();

  Future<void> markBioDataSynced(int id) =>
      (update(bioDataEntries)..where((t) => t.id.equals(id))).write(
        BioDataEntriesCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
          lastSyncError: const Value(null),
        ),
      );

  /// Mirrors [markOrderFailed]: counts the attempt and parks the row in the
  /// terminal state (4) once the cap is reached, so a permanently-bad payload
  /// stops being retried on every sync pass.
  Future<void> markBioDataFailed(int id, {String? error}) async {
    final entry = await getBioData(id);
    if (entry == null) return;
    final attempts = entry.syncAttempts + 1;
    final terminal = attempts >= _maxBioDataSyncAttempts;
    await (update(bioDataEntries)..where((t) => t.id.equals(id))).write(
      BioDataEntriesCompanion(
        syncStatus: Value(terminal ? 4 : 3),
        syncAttempts: Value(attempts),
        lastSyncError: Value(error),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  Future<void> upsertBioData(BioDataEntriesCompanion entry) =>
      into(bioDataEntries).insert(
        entry.uuid.present ? entry : entry.copyWith(uuid: Value(_uuidV4())),
        mode: InsertMode.insertOrReplace,
      );

  Future<int> deleteBioDataNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(bioDataEntries)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(bioDataEntries)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteBioData(record.id);
    }
    return toDelete.length;
  }

  Future<int> deleteStaffBioDataNotIn(Set<int> keepIds) async {
    final toDelete = await (select(bioDataEntries)
          ..where((t) => t.staffId.isNotNull() & t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteBioData(record.id);
    }
    return toDelete.length;
  }

  // ─── ActivityLogs ──────────────────────────────────

  Future<void> insertActivityLog(
    ActivityLogsCompanion log, {
    InsertMode mode = InsertMode.insert,
  }) => into(activityLogs).insert(log, mode: mode);

  Future<void> deleteActivityLog(int id) =>
      (delete(activityLogs)..where((t) => t.id.equals(id))).go();

  Future<void> clearActivityLogs() => delete(activityLogs).go();

  Future<List<ActivityLog>> getAllActivityLogs({int? limit, int? offset}) {
    final query = select(activityLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (limit != null) query.limit(limit, offset: offset);
    return query.get();
  }

  Future<List<ActivityLog>> getActivityLogsByType(String type) =>
      (select(activityLogs)
            ..where((t) => t.type.equals(type))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<ActivityLog>> getActivityLogsByActor(
    String actorType,
    int actorId,
  ) =>
      (select(activityLogs)
            ..where(
              (t) => t.actorType.equals(actorType) & t.actorId.equals(actorId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<int> getActivityLogCount() => activityLogs.count().getSingle();

  /// Returns the next order code in the format ASG{typeChar}{posId}-{kitchenId}-{seq}
  /// by scanning existing [orders] for the highest
  /// numeric suffix for the given POS and kitchen, and incrementing it.
  ///
  /// Group vouchers are rows in [orders] like any other order, so the retired
  /// `group_orders` table is not consulted here.
  Future<String> nextOrderCode(String typeChar, int posId, int kitchenId) async {
    return transaction(() async {
      final prefix = 'ASG$typeChar$posId-$kitchenId-';

      final row = await customSelect(
        'SELECT MAX(CAST(SUBSTR(order_code, ?) AS INTEGER)) AS max_seq '
        'FROM orders WHERE order_code LIKE ?',
        variables: [
          Variable<int>(prefix.length + 1),
          Variable<String>('$prefix%'),
        ],
      ).getSingleOrNull();

      final value = row?.data['max_seq'];
      final maxCode = value is num ? value.toInt() : 0;

      final next = maxCode + 1;
      return '$prefix${next.toString().padLeft(4, '0')}';
    });
  }

  /// Sequence for function order codes.
  ///
  /// Numbered per function so the printed voucher shows which event it belongs
  /// to, and counted independently of [nextOrderCode] so the two streams can
  /// never collide.
  Future<String> nextFunctionOrderCode({
    required int functionId,
    required int posId,
  }) async {
    return transaction(() async {
      final prefix = 'FNF$functionId-$posId-';
      final rows = await customSelect(
        'SELECT MAX(CAST(SUBSTR(order_code, ?) AS INTEGER)) FROM function_orders WHERE order_code LIKE ?',
        variables: [
          Variable<int>(prefix.length + 1),
          Variable<String>('$prefix%'),
        ],
        readsFrom: {functionOrders},
      ).get();

      final value = rows.isEmpty ? null : rows.first.data.values.firstOrNull;
      final maxCode = value is int
          ? value
          : (value is num ? value.toInt() : 0);

      return '$prefix${(maxCode + 1).toString().padLeft(4, '0')}';
    });
  }
}

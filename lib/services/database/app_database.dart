import 'package:drift/drift.dart';
import 'tables.dart';

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
    Dependants,
    DependantKitchens,
    Cards,
    Users,
    UserKitchens,
    Orders,
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

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      await m.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

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
      await delete(dependantKitchens).go();
      await delete(visitorKitchens).go();
      await delete(dependants).go();
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
      await delete(groupOrders).go();
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
      'pos_devices': await _countUnsyncedPosDevices(),
      'bio_data': await _countUnsyncedBioData(),
      'group_orders': await _countUnsyncedGroupOrders(),
    };
  }

  Future<int> _countUnsyncedSites() async => (await (select(
    sites,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedContractors() async => (await (select(
    contractors,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedContractorStaff() async => (await (select(
    contractorStaffTable,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedVisitors() async => (await (select(
    visitors,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedDepartments() async => (await (select(
    departments,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedShifts() async => (await (select(
    shifts,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedKitchens() async => (await (select(
    kitchens,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedMealTypes() async => (await (select(
    mealTypes,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedStaff() async => (await (select(
    staff,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedUsers() async => (await (select(
    users,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedOrders() async => (await (select(
    orders,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedPosDevices() async => (await (select(
    posDevices,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedGroupOrders() async => (await (select(
    groupOrders,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;
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
  Future<Department?> getDepartment(int id) =>
      (select(departments)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Department>> getDepartmentsByCompany(int companyId) =>
      (select(departments)..where((t) => t.companyId.equals(companyId))).get();

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
      await deleteDependantsByStaff(id);
      await deleteCardsByAssignedTo(id);
      await deleteBioDataByStaff(id);
      await (delete(staff)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<StaffData>> getAllStaff() => select(staff).get();
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

  // ─── DependantKitchens ─────────────────────────────────────

  Future<void> insertDependantKitchen(DependantKitchensCompanion entry) =>
      into(dependantKitchens).insert(entry);

  Future<void> deleteDependantKitchen(int dependantId, int kitchenId) =>
      (delete(dependantKitchens)
            ..where((t) =>
                t.dependantId.equals(dependantId) & t.kitchenId.equals(kitchenId)))
          .go();

  Future<void> deleteDependantKitchensByDependant(int dependantId) =>
      (delete(dependantKitchens)..where((t) => t.dependantId.equals(dependantId))).go();

  Future<List<DependantKitchen>> getDependantKitchens(int dependantId) =>
      (select(dependantKitchens)..where((t) => t.dependantId.equals(dependantId))).get();

  Future<List<int>> getDependantKitchenIds(int dependantId) async {
    final rows = await getDependantKitchens(dependantId);
    return rows.map((r) => r.kitchenId).toList();
  }

  Future<void> setDependantKitchens(int dependantId, List<int> kitchenIds) async {
    await transaction(() async {
      await deleteDependantKitchensByDependant(dependantId);
      for (final kid in kitchenIds) {
        await into(dependantKitchens).insert(
          DependantKitchensCompanion(dependantId: Value(dependantId), kitchenId: Value(kid)),
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

  // ─── Dependants ────────────────────────────────────────────

  Future<void> insertDependant(
    DependantsCompanion dependant, {
    InsertMode mode = InsertMode.insert,
  }) => into(dependants).insert(dependant, mode: mode);

  Future<void> updateDependant(int id, DependantsCompanion dependant) =>
      (update(dependants)..where((t) => t.id.equals(id))).write(dependant);

  Future<void> deleteDependant(int id) async {
    await transaction(() async {
      await deleteDependantKitchensByDependant(id);
      await deleteBioDataByDependant(id);
      await (delete(dependants)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> deleteDependantsByStaff(int staffId) =>
      (delete(dependants)..where((t) => t.staffId.equals(staffId))).go();

  Future<List<Dependant>> getAllDependants() => select(dependants).get();
  Future<Dependant?> getDependant(int id) =>
      (select(dependants)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Dependant>> getDependantsByStaff(int staffId) =>
      (select(dependants)..where((t) => t.staffId.equals(staffId))).get();

  Future<void> markDependantSynced(int id) =>
      (update(dependants)..where((t) => t.id.equals(id))).write(
        DependantsCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markDependantFailed(int id) =>
      (update(dependants)..where((t) => t.id.equals(id))).write(
        DependantsCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<int> deleteDependantsNotIn(Set<int> keepIds) async {
    if (keepIds.isEmpty) {
      return (delete(dependants)..where((t) => t.syncStatus.equals(2))).go();
    }
    final toDelete = await (select(dependants)
          ..where((t) => t.syncStatus.equals(2) & t.id.isNotIn(keepIds)))
        .get();
    for (final record in toDelete) {
      await deleteDependant(record.id);
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

  Future<List<Card>> getAllCards() => select(cards).get();
  Future<Card?> getCard(int id) =>
      (select(cards)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<Card?> getCardByTagId(String tagId) =>
      (select(cards)..where((t) => t.tagId.equals(tagId))).getSingleOrNull();

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

  Future<List<Order>> getUnsyncedOrders() =>
      (select(orders)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markOrderSynced(int id) =>
      (update(orders)..where((t) => t.id.equals(id))).write(
        OrdersCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markOrderFailed(int id) =>
      (update(orders)..where((t) => t.id.equals(id))).write(
        OrdersCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  // ─── Group Orders ───────────────────────────────────────────

  Future<void> insertGroupOrder(
    GroupOrdersCompanion order, {
    InsertMode mode = InsertMode.insert,
  }) async {
    await into(groupOrders).insert(order, mode: mode);
  }

  Future<void> deleteGroupOrder(int id) =>
      (delete(groupOrders)..where((t) => t.id.equals(id))).go();

  Future<List<GroupOrder>> getAllGroupOrders() => select(groupOrders).get();
  Future<GroupOrder?> getGroupOrder(int id) =>
      (select(groupOrders)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<GroupOrder>> getUnsyncedGroupOrders() =>
      (select(groupOrders)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markGroupOrderSynced(int id) =>
      (update(groupOrders)..where((t) => t.id.equals(id))).write(
        GroupOrdersCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markGroupOrderFailed(int id) =>
      (update(groupOrders)..where((t) => t.id.equals(id))).write(
        GroupOrdersCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

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


  Future<int> _countUnsyncedBioData() async => (await (select(
    bioDataEntries,
  )..where((t) => t.syncStatus.isNotValue(2))).get()).length;

  // ─── BioDataEntries ────────────────────────────────

  Future<void> insertBioData(
    BioDataEntriesCompanion entry, {
    InsertMode mode = InsertMode.insert,
  }) => into(bioDataEntries).insert(entry, mode: mode);

  Future<void> updateBioData(int id, BioDataEntriesCompanion entry) =>
      (update(bioDataEntries)..where((t) => t.id.equals(id))).write(entry);

  Future<void> deleteBioData(int id) =>
      (delete(bioDataEntries)..where((t) => t.id.equals(id))).go();

  Future<void> deleteBioDataByStaff(int staffId) =>
      (delete(bioDataEntries)..where((t) => t.staffId.equals(staffId))).go();

  Future<void> deleteBioDataByDependant(int dependantId) =>
      (delete(bioDataEntries)..where((t) => t.dependantId.equals(dependantId))).go();

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
  Future<List<BioDataEntry>> getActiveBioDataByDependant(int dependantId) =>
      (select(bioDataEntries)
            ..where((t) => t.dependantId.equals(dependantId) & t.isActive.equals(true)))
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

  Future<List<BioDataEntry>> getUnsyncedBioData() =>
      (select(bioDataEntries)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markBioDataSynced(int id) =>
      (update(bioDataEntries)..where((t) => t.id.equals(id))).write(
        BioDataEntriesCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> markBioDataFailed(int id) =>
      (update(bioDataEntries)..where((t) => t.id.equals(id))).write(
        BioDataEntriesCompanion(
          syncStatus: const Value(3),
          syncUpdatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

  Future<void> upsertBioData(BioDataEntriesCompanion entry) =>
      into(bioDataEntries).insert(entry, mode: InsertMode.insertOrReplace);

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
  /// by scanning existing [orders] and [group_orders] for the highest
  /// numeric suffix for the given POS and kitchen, and incrementing it.
  Future<String> nextOrderCode(String typeChar, int posId, int kitchenId) async {
    final prefix = 'ASG$typeChar$posId-$kitchenId-';
    int maxCode = 0;

    int? parseMax(List<QueryRow> rows) {
      if (rows.isEmpty) return null;
      final val = rows.first.data.values.firstOrNull;
      return val is int ? val : (val is num ? val.toInt() : null);
    }

    final orderRows = await customSelect(
      'SELECT MAX(CAST(SUBSTR(order_code, ?) AS INTEGER)) FROM orders WHERE order_code LIKE ?',
      variables: [Variable<int>(prefix.length + 1), Variable<String>('$prefix%')],
    ).get();
    final groupOrderRows = await customSelect(
      'SELECT MAX(CAST(SUBSTR(order_code, ?) AS INTEGER)) FROM group_orders WHERE order_code LIKE ?',
      variables: [Variable<int>(prefix.length + 1), Variable<String>('$prefix%')],
    ).get();

    final orderMax = parseMax(orderRows) ?? 0;
    final groupMax = parseMax(groupOrderRows) ?? 0;
    maxCode = orderMax > groupMax ? orderMax : groupMax;

    final next = maxCode + 1;
    return '$prefix${next.toString().padLeft(4, '0')}';
  }
}

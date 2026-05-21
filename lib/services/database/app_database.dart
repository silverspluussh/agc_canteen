import 'package:drift/drift.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Sites,
  Kitchens,
  MenuTypes,
  Meals,
  MealKitchens,
  Staff,
  Users,
  UserKitchens,
  Orders,
  OrderItems,
  Overcharges,
  PosDevices,
  Fingerprints,
  ActivityLogs,
  GroupOrders,
  GroupOrderItems,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 3) {
            await m.createTable(activityLogs);
          }
          if (from < 4) {
            await m.createTable(groupOrders);
            await m.createTable(groupOrderItems);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement(
            'CREATE TABLE IF NOT EXISTS activity_logs ('
            'id TEXT NOT NULL PRIMARY KEY, '
            'type TEXT NOT NULL, '
            'message TEXT NOT NULL, '
            'actor_type TEXT, '
            'actor_id TEXT, '
            'actor_name TEXT, '
            'source_table TEXT, '
            'record_id TEXT, '
            'metadata TEXT, '
            'created_at TEXT NOT NULL'
            ')',
          );
          await customStatement(
            'CREATE TABLE IF NOT EXISTS group_orders ('
            'id TEXT NOT NULL PRIMARY KEY, '
            'order_code TEXT NOT NULL, '
            'status TEXT NOT NULL, '
            'order_type TEXT NOT NULL, '
            'meal_type TEXT NOT NULL, '
            'total REAL NOT NULL, '
            'group_count INTEGER NOT NULL, '
            'description TEXT, '
            'created_at TEXT NOT NULL, '
            'updated_at TEXT NOT NULL, '
            'sync_status INTEGER NOT NULL DEFAULT 0, '
            'sync_updated_at TEXT'
            ')',
          );
          await customStatement(
            'CREATE TABLE IF NOT EXISTS group_order_items ('
            'id TEXT NOT NULL PRIMARY KEY, '
            'price REAL NOT NULL, '
            'qty INTEGER NOT NULL, '
            'meal_id TEXT NOT NULL REFERENCES meals(id), '
            'group_order_id TEXT NOT NULL REFERENCES group_orders(id), '
            'created_at TEXT NOT NULL, '
            'updated_at TEXT NOT NULL, '
            'sync_status INTEGER NOT NULL DEFAULT 0, '
            'sync_updated_at TEXT'
            ')',
          );
        },
      );

  Future<void> clearAll() async {
    await transaction(() async {
      await delete(sites).go();
      await delete(kitchens).go();
      await delete(menuTypes).go();
      await delete(meals).go();
      await delete(mealKitchens).go();
      await delete(staff).go();
      await delete(users).go();
      await delete(userKitchens).go();
      await delete(orders).go();
      await delete(orderItems).go();
      await delete(overcharges).go();
      await delete(posDevices).go();
      await delete(fingerprints).go();
      await delete(activityLogs).go();
      await delete(groupOrderItems).go();
      await delete(groupOrders).go();
    });
  }

  Future<Map<String, int>> getSyncStats() async {
    return {
      'sites': await _countUnsyncedSites(),
      'kitchens': await _countUnsyncedKitchens(),
      'menu_types': await _countUnsyncedMenuTypes(),
      'meals': await _countUnsyncedMeals(),
      'staff': await _countUnsyncedStaff(),
      'users': await _countUnsyncedUsers(),
      'orders': await _countUnsyncedOrders(),
      'order_items': await _countUnsyncedOrderItems(),
      'overcharges': await _countUnsyncedOvercharges(),
      'pos_devices': await _countUnsyncedPosDevices(),
      'fingerprints': await _countUnsyncedFingerprints(),
      'group_orders': await _countUnsyncedGroupOrders(),
      'group_order_items': await _countUnsyncedGroupOrderItems(),
    };
  }

  Future<int> _countUnsyncedSites() async =>
      (await (select(sites)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedKitchens() async =>
      (await (select(kitchens)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedMenuTypes() async =>
      (await (select(menuTypes)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedMeals() async =>
      (await (select(meals)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedStaff() async =>
      (await (select(staff)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedUsers() async =>
      (await (select(users)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedOrders() async =>
      (await (select(orders)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedOrderItems() async =>
      (await (select(orderItems)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedOvercharges() async =>
      (await (select(overcharges)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedPosDevices() async =>
      (await (select(posDevices)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedGroupOrders() async =>
      (await (select(groupOrders)..where((t) => t.syncStatus.isNotValue(2))).get()).length;
  Future<int> _countUnsyncedGroupOrderItems() async =>
      (await (select(groupOrderItems)..where((t) => t.syncStatus.isNotValue(2))).get()).length;

  // ─── Sites ─────────────────────────────────────────────────

  Future<void> insertSite(SitesCompanion site,
          {InsertMode mode = InsertMode.insert}) =>
      into(sites).insert(site, mode: mode);

  Future<void> updateSite(String id, SitesCompanion site) =>
      (update(sites)..where((t) => t.id.equals(id))).write(site);

  Future<void> deleteSite(String id) =>
      (delete(sites)..where((t) => t.id.equals(id))).go();

  Future<List<Site>> getAllSites() => select(sites).get();
  Future<Site?> getSite(String id) =>
      (select(sites)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Site>> getUnsyncedSites() =>
      (select(sites)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markSiteSynced(String id) =>
      (update(sites)..where((t) => t.id.equals(id))).write(SitesCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markSiteFailed(String id) =>
      (update(sites)..where((t) => t.id.equals(id))).write(SitesCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  // ─── Kitchens ──────────────────────────────────────────────

  Future<void> insertKitchen(KitchensCompanion kitchen,
          {InsertMode mode = InsertMode.insert}) =>
      into(kitchens).insert(kitchen, mode: mode);

  Future<void> updateKitchen(String id, KitchensCompanion kitchen) =>
      (update(kitchens)..where((t) => t.id.equals(id))).write(kitchen);

  Future<void> deleteKitchen(String id) =>
      (delete(kitchens)..where((t) => t.id.equals(id))).go();

  Future<List<Kitchen>> getAllKitchens() => select(kitchens).get();
  Future<Kitchen?> getKitchen(String id) =>
      (select(kitchens)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Kitchen>> getKitchensByCompany(String companyId) =>
      (select(kitchens)..where((t) => t.companyId.equals(companyId))).get();

  Future<List<Kitchen>> getUnsyncedKitchens() =>
      (select(kitchens)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markKitchenSynced(String id) =>
      (update(kitchens)..where((t) => t.id.equals(id)))
          .write(KitchensCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markKitchenFailed(String id) =>
      (update(kitchens)..where((t) => t.id.equals(id)))
          .write(KitchensCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  // ─── MenuTypes ─────────────────────────────────────────────

  Future<void> insertMenuType(MenuTypesCompanion menuType,
          {InsertMode mode = InsertMode.insert}) =>
      into(menuTypes).insert(menuType, mode: mode);

  Future<void> updateMenuType(String id, MenuTypesCompanion menuType) =>
      (update(menuTypes)..where((t) => t.id.equals(id))).write(menuType);

  Future<void> deleteMenuType(String id) =>
      (delete(menuTypes)..where((t) => t.id.equals(id))).go();

  Future<List<MenuType>> getAllMenuTypes() => select(menuTypes).get();
  Future<MenuType?> getMenuType(String id) =>
      (select(menuTypes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<MenuType>> getUnsyncedMenuTypes() =>
      (select(menuTypes)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markMenuTypeSynced(String id) =>
      (update(menuTypes)..where((t) => t.id.equals(id)))
          .write(MenuTypesCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markMenuTypeFailed(String id) =>
      (update(menuTypes)..where((t) => t.id.equals(id)))
          .write(MenuTypesCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  // ─── Meals ─────────────────────────────────────────────────

  Future<void> insertMeal(MealsCompanion meal, List<String> kitchenIds) async {
    await transaction(() async {
      await into(meals).insert(meal);
      for (final kid in kitchenIds) {
        await into(mealKitchens).insert(
          MealKitchensCompanion(
              mealId: Value(meal.id.value), kitchenId: Value(kid)),
        );
      }
    });
  }

  Future<void> updateMeal(MealsCompanion meal, List<String> kitchenIds) async {
    final id = meal.id.value;
    await transaction(() async {
      await (update(meals)..where((t) => t.id.equals(id))).write(meal);
      await (delete(mealKitchens)..where((t) => t.mealId.equals(id))).go();
      for (final kid in kitchenIds) {
        await into(mealKitchens).insert(
          MealKitchensCompanion(mealId: Value(id), kitchenId: Value(kid)),
        );
      }
    });
  }

  Future<void> deleteMeal(String id) async {
    await transaction(() async {
      await (delete(mealKitchens)..where((t) => t.mealId.equals(id))).go();
      await (delete(meals)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<Meal>> getAllMeals() => select(meals).get();
  Future<Meal?> getMeal(String id) =>
      (select(meals)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Meal>> getMealsByMenuType(String menuTypeId) =>
      (select(meals)..where((t) => t.menuTypeId.equals(menuTypeId))).get();

  Future<List<MealKitchen>> getMealKitchens(String mealId) =>
      (select(mealKitchens)..where((t) => t.mealId.equals(mealId))).get();

  Future<List<Meal>> getUnsyncedMeals() =>
      (select(meals)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markMealSynced(String id) =>
      (update(meals)..where((t) => t.id.equals(id))).write(MealsCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markMealFailed(String id) =>
      (update(meals)..where((t) => t.id.equals(id))).write(MealsCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  // ─── Staff ─────────────────────────────────────────────────

  Future<void> insertStaff(StaffCompanion staff,
          {InsertMode mode = InsertMode.insert}) =>
      into(this.staff).insert(staff, mode: mode);

  Future<void> updateStaff(String id, StaffCompanion staff) =>
      (update(this.staff)..where((t) => t.id.equals(id))).write(staff);

  Future<void> deleteStaff(String id) =>
      (delete(staff)..where((t) => t.id.equals(id))).go();

  Future<List<StaffData>> getAllStaff() => select(staff).get();
  Future<StaffData?> getStaff(String id) =>
      (select(staff)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<StaffData>> getUnsyncedStaff() =>
      (select(staff)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markStaffSynced(String id) =>
      (update(staff)..where((t) => t.id.equals(id))).write(StaffCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markStaffFailed(String id) =>
      (update(staff)..where((t) => t.id.equals(id))).write(StaffCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  // ─── Users ─────────────────────────────────────────────────

  Future<void> insertUser(UsersCompanion user, List<String> kitchenIds) async {
    await transaction(() async {
      await into(users).insert(user);
      for (final kid in kitchenIds) {
        await into(userKitchens).insert(
          UserKitchensCompanion(
              userId: Value(user.id.value), kitchenId: Value(kid)),
        );
      }
    });
  }

  Future<void> updateUser(UsersCompanion user, List<String> kitchenIds) async {
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

  Future<void> deleteUser(String id) async {
    await transaction(() async {
      await (delete(userKitchens)..where((t) => t.userId.equals(id))).go();
      await (delete(users)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<User>> getAllUsers() => select(users).get();
  Future<User?> getUser(String id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<UserKitchen>> getUserKitchens(String userId) =>
      (select(userKitchens)..where((t) => t.userId.equals(userId))).get();

  Future<List<User>> getUnsyncedUsers() =>
      (select(users)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markUserSynced(String id) =>
      (update(users)..where((t) => t.id.equals(id))).write(UsersCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markUserFailed(String id) =>
      (update(users)..where((t) => t.id.equals(id))).write(UsersCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  // ─── Orders ────────────────────────────────────────────────

  Future<void> insertOrder(
      OrdersCompanion order, List<OrderItemsCompanion> items) async {
    await transaction(() async {
      await into(orders).insert(order);
      for (final item in items) {
        await into(orderItems).insert(item);
      }
    });
  }

  Future<void> updateOrder(
      OrdersCompanion order, List<OrderItemsCompanion> items) async {
    final id = order.id.value;
    await transaction(() async {
      await (update(orders)..where((t) => t.id.equals(id))).write(order);
      await (delete(orderItems)..where((t) => t.orderId.equals(id))).go();
      for (final item in items) {
        await into(orderItems).insert(item);
      }
    });
  }

  Future<void> deleteOrder(String id) async {
    await transaction(() async {
      await (delete(orderItems)..where((t) => t.orderId.equals(id))).go();
      await (delete(orders)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<Order>> getAllOrders() => select(orders).get();
  Future<Order?> getOrder(String id) =>
      (select(orders)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<OrderItem>> getOrderItems(String orderId) =>
      (select(orderItems)..where((t) => t.orderId.equals(orderId))).get();

  Future<List<Order>> getUnsyncedOrders() =>
      (select(orders)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<List<OrderItem>> getUnsyncedOrderItems() =>
      (select(orderItems)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markOrderSynced(String id) =>
      (update(orders)..where((t) => t.id.equals(id))).write(OrdersCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markOrderFailed(String id) =>
      (update(orders)..where((t) => t.id.equals(id))).write(OrdersCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markOrderItemSynced(String id) =>
      (update(orderItems)..where((t) => t.id.equals(id)))
          .write(OrderItemsCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markOrderItemFailed(String id) =>
      (update(orderItems)..where((t) => t.id.equals(id)))
          .write(OrderItemsCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  // ─── Group Orders ───────────────────────────────────────────

  Future<void> insertGroupOrder(
      GroupOrdersCompanion order, List<GroupOrderItemsCompanion> items) async {
    await transaction(() async {
      await into(groupOrders).insert(order);
      for (final item in items) {
        await into(groupOrderItems).insert(item);
      }
    });
  }

  Future<void> deleteGroupOrder(String id) async {
    await transaction(() async {
      await (delete(groupOrderItems)..where((t) => t.groupOrderId.equals(id))).go();
      await (delete(groupOrders)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<GroupOrder>> getAllGroupOrders() => select(groupOrders).get();
  Future<GroupOrder?> getGroupOrder(String id) =>
      (select(groupOrders)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<GroupOrderItem>> getGroupOrderItems(String groupOrderId) =>
      (select(groupOrderItems)..where((t) => t.groupOrderId.equals(groupOrderId))).get();

  Future<List<GroupOrder>> getUnsyncedGroupOrders() =>
      (select(groupOrders)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<List<GroupOrderItem>> getUnsyncedGroupOrderItems() =>
      (select(groupOrderItems)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markGroupOrderSynced(String id) =>
      (update(groupOrders)..where((t) => t.id.equals(id)))
          .write(GroupOrdersCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markGroupOrderFailed(String id) =>
      (update(groupOrders)..where((t) => t.id.equals(id)))
          .write(GroupOrdersCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markGroupOrderItemSynced(String id) =>
      (update(groupOrderItems)..where((t) => t.id.equals(id)))
          .write(GroupOrderItemsCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markGroupOrderItemFailed(String id) =>
      (update(groupOrderItems)..where((t) => t.id.equals(id)))
          .write(GroupOrderItemsCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  // ─── Overcharges ───────────────────────────────────────────

  Future<void> insertOvercharge(OverchargesCompanion overcharge,
          {InsertMode mode = InsertMode.insert}) =>
      into(overcharges).insert(overcharge, mode: mode);

  Future<void> updateOvercharge(String id, OverchargesCompanion overcharge) =>
      (update(overcharges)..where((t) => t.id.equals(id))).write(overcharge);

  Future<void> deleteOvercharge(String id) =>
      (delete(overcharges)..where((t) => t.id.equals(id))).go();

  Future<List<Overcharge>> getAllOvercharges() => select(overcharges).get();
  Future<Overcharge?> getOvercharge(String id) =>
      (select(overcharges)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Overcharge>> getUnsyncedOvercharges() =>
      (select(overcharges)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markOverchargeSynced(String id) =>
      (update(overcharges)..where((t) => t.id.equals(id)))
          .write(OverchargesCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markOverchargeFailed(String id) =>
      (update(overcharges)..where((t) => t.id.equals(id)))
          .write(OverchargesCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  // ─── PosDevices ────────────────────────────────────────────

  Future<void> insertPosDevice(PosDevicesCompanion device,
          {InsertMode mode = InsertMode.insert}) =>
      into(posDevices).insert(device, mode: mode);

  Future<void> updatePosDevice(String id, PosDevicesCompanion device) =>
      (update(posDevices)..where((t) => t.id.equals(id))).write(device);

  Future<void> deletePosDevice(String id) =>
      (delete(posDevices)..where((t) => t.id.equals(id))).go();

  Future<List<PosDevice>> getAllPosDevices() => select(posDevices).get();
  Future<PosDevice?> getPosDevice(String id) =>
      (select(posDevices)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<PosDevice>> getUnsyncedPosDevices() =>
      (select(posDevices)..where((t) => t.syncStatus.isNotValue(2))).get();

  Future<void> markPosDeviceSynced(String id) =>
      (update(posDevices)..where((t) => t.id.equals(id)))
          .write(PosDevicesCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markPosDeviceFailed(String id) =>
      (update(posDevices)..where((t) => t.id.equals(id)))
          .write(PosDevicesCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  // ─── Fingerprints ──────────────────────────────────

  Future<void> insertFingerprint(FingerprintsCompanion tpl,
          {InsertMode mode = InsertMode.insert}) =>
      into(fingerprints).insert(tpl, mode: mode);

  Future<void> updateFingerprint(
          String id, FingerprintsCompanion tpl) =>
      (update(fingerprints)..where((t) => t.id.equals(id))).write(tpl);

  Future<void> deleteFingerprint(String id) =>
      (delete(fingerprints)..where((t) => t.id.equals(id))).go();

  Future<List<Fingerprint>> getAllFingerprints() =>
      select(fingerprints).get();

  Future<List<Fingerprint>> getFingerprintsByStaff(String staffId) =>
      (select(fingerprints)..where((t) => t.staffId.equals(staffId)))
          .get();

  Future<List<Fingerprint>> getActiveFingerprints() =>
      (select(fingerprints)..where((t) => t.isActive.equals(true)))
          .get();

  Future<Fingerprint?> getFingerprint(String id) =>
      (select(fingerprints)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<Fingerprint>> getUnsyncedFingerprints() =>
      (select(fingerprints)
            ..where((t) => t.syncStatus.isNotValue(2)))
          .get();

  Future<void> markFingerprintSynced(String id) =>
      (update(fingerprints)..where((t) => t.id.equals(id)))
          .write(FingerprintsCompanion(
        syncStatus: const Value(2),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<void> markFingerprintFailed(String id) =>
      (update(fingerprints)..where((t) => t.id.equals(id)))
          .write(FingerprintsCompanion(
        syncStatus: const Value(3),
        syncUpdatedAt: Value(DateTime.now().toIso8601String()),
      ));

  Future<int> _countUnsyncedFingerprints() async =>
      (await (select(fingerprints)
                ..where((t) => t.syncStatus.isNotValue(2)))
              .get())
          .length;

  // ─── ActivityLogs ──────────────────────────────────

  Future<void> insertActivityLog(ActivityLogsCompanion log,
          {InsertMode mode = InsertMode.insert}) =>
      into(activityLogs).insert(log, mode: mode);

  Future<void> deleteActivityLog(String id) =>
      (delete(activityLogs)..where((t) => t.id.equals(id))).go();

  Future<void> clearActivityLogs() => delete(activityLogs).go();

  Future<List<ActivityLog>> getAllActivityLogs({int? limit, int? offset}) {
    final query = select(activityLogs)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (limit != null) query.limit(limit, offset: offset);
    return query.get();
  }

  Future<List<ActivityLog>> getActivityLogsByType(String type) =>
      (select(activityLogs)
            ..where((t) => t.type.equals(type))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<ActivityLog>> getActivityLogsByActor(String actorType, String actorId) =>
      (select(activityLogs)
            ..where((t) => t.actorType.equals(actorType) & t.actorId.equals(actorId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<int> getActivityLogCount() =>
      activityLogs.count().getSingle();
}

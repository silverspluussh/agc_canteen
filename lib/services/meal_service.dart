import 'package:drift/drift.dart';
import 'package:logger/logger.dart';

import '../core/network/network_api_dio.dart';
import 'database/app_database.dart';

class MealService {
  final NetworkAPI _networkAPI;
  final AppDatabase _db;
  final Logger _logger;

  MealService({
    required NetworkAPI networkAPI,
    required AppDatabase db,
    Logger? logger,
  }) : _networkAPI = networkAPI,
       _db = db,
       _logger = logger ?? Logger();

  Future<List<Meal>> getMeals() async {
    try {
      _logger.i('Attempting to fetch meals from remote API...');
      final responseData = await _networkAPI.getData(
        '/caterer/meals',
        queryParameters: {
          'searchTerm': '',
          'limit': '100',
          'offset': 0,
          'status': 'available',
          // 'mealTypeId': '',
          // 'menuType': '',
          // 'startDate': '',
          // 'endDate': '',
        },
        builder: (data) => data,
      );

      if (responseData is Map && responseData['data'] is List) {
        final List<dynamic> mealsList = responseData['data'];
        _logger.i(
          'Successfully fetched ${mealsList.length} meals. Syncing with local database...',
        );

        for (final mealItem in mealsList) {
          if (mealItem is Map<String, dynamic>) {
            await _upsertMealData(mealItem);
          }
        }
        _logger.i('Local database sync completed for fetched meals.');
      } else {
        _logger.w('Remote response format was unexpected: $responseData');
      }
    } catch (e) {
      _logger.w(
        'Remote meal fetch failed ($e). Falling back to local database.',
      );
    }

    // Always return local database contents as the source of truth
    final localMeals = await _db.getAllMeals();
    _logger.i('Returning ${localMeals.length} meals from local database.');
    return localMeals;
  }

  /// Transaction-safe helper to upsert a meal and all of its nested relationships (menuType, kitchens)
  Future<void> _upsertMealData(Map<String, dynamic> mealMap) async {
    try {
      final mealId = mealMap['id']?.toString() ?? '';
      if (mealId.isEmpty) return;

      // 1. Upsert MenuType to satisfy foreign key constraints
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
              menuTypeMap['createdAt'] as String? ??
                  DateTime.now().toIso8601String(),
            ),
            updatedAt: Value(
              menuTypeMap['updatedAt'] as String? ??
                  DateTime.now().toIso8601String(),
            ),
            syncStatus: const Value(2),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 2. Ensure a default site exists to satisfy foreign key constraints for kitchens
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

      // 3. Upsert Kitchens and collect their IDs
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
                  int.tryParse(k['minTierRequired']?.toString() ?? '1') ?? 1;
              await _db.insertKitchen(
                KitchensCompanion(
                  id: Value(kitchenId),
                  name: Value(k['name'] as String? ?? 'Kitchen'),
                  minTierRequired: Value(minTier),
                  status: Value(k['status'] as String? ?? 'active'),
                  companyId: const Value(defaultSiteId),
                  createdAt: Value(
                    k['createdAt'] as String? ??
                        DateTime.now().toIso8601String(),
                  ),
                  updatedAt: Value(
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

      // 4. Upsert Meal entity using the proper AppDatabase transactional helpers
      final priceNum = mealMap['price'] as num? ?? 0.0;
      final existingMeal = await _db.getMeal(mealId);
      final mealCompanion = MealsCompanion(
        id: Value(mealId),
        name: Value(mealMap['name'] as String? ?? 'Meal'),
        status: Value(mealMap['status'] as String? ?? 'available'),
        mealType: Value(mealMap['mealType']['name'] as String? ?? 'breakfast'),
        remarks: Value.absentIfNull(mealMap['remarks'] as String?),
        price: Value(priceNum.toDouble()),
        photoUrl: Value.absentIfNull(mealMap['photoUrl'] as String?),
        menuTypeId: Value(menuTypeId),
        createdAt: Value(
          mealMap['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: Value(
          mealMap['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
        ),
        syncStatus: const Value(2),
      );

      if (existingMeal != null) {
        await _db.updateMeal(mealCompanion, kitchenIds);
      } else {
        await _db.insertMeal(mealCompanion, kitchenIds);
      }
    } catch (e, stack) {
      _logger.e('Failed to upsert meal details: $e', stackTrace: stack);
    }
  }

  //get menu
  Future<List<MenuType>> getMenuTypes() async {
    try {
      _logger.i('Attempting to fetch menu types from remote API...');
      final responseData = await _networkAPI.getData(
        '/caterer/menu-types',
        queryParameters: {
          'searchTerm': '',
          'limit': '100',
          'offset': 0,
          'status': '',
        },
        builder: (data) => data,
      );

      if (responseData is Map && responseData['data'] is List) {
        final List<dynamic> menuTypesList = responseData['data'];
        _logger.i(
          'Successfully fetched ${menuTypesList.length} menu types. Syncing with local database...',
        );

        for (final menuTypeItem in menuTypesList) {
          if (menuTypeItem is Map<String, dynamic>) {
            await _upsertMenuTypeData(menuTypeItem);
          }
        }
        _logger.i('Local database sync completed for fetched menu types.');
      } else {
        _logger.w('Remote response format was unexpected: $responseData');
      }
    } catch (e) {
      _logger.w(
        'Remote menu type fetch failed ($e). Falling back to local database.',
      );
    }

    // Always return local database contents as the source of truth
    final localMenuTypes = await _db.getAllMenuTypes();
    _logger.i(
      'Returning ${localMenuTypes.length} menu types from local database.',
    );
    return localMenuTypes;
  }

  /// Transaction-safe helper to upsert a menu type
  Future<void> _upsertMenuTypeData(Map<String, dynamic> menuTypeMap) async {
    try {
      final menuTypeId = menuTypeMap['id']?.toString() ?? '';
      if (menuTypeId.isEmpty) return;

      final menuTypeCompanion = MenuTypesCompanion(
        id: Value(menuTypeId),
        name: Value(menuTypeMap['name'] as String? ?? 'Menu Type'),
        remarks: Value.absentIfNull(menuTypeMap['remarks'] as String?),
        status: Value(menuTypeMap['status'] as String? ?? 'active'),
        createdAt: Value(
          menuTypeMap['createdAt'] as String? ??
              DateTime.now().toIso8601String(),
        ),
        updatedAt: Value(
          menuTypeMap['updatedAt'] as String? ??
              DateTime.now().toIso8601String(),
        ),
        syncStatus: const Value(2),
      );

      final existingMenuType = await _db.getMenuType(menuTypeId);
      if (existingMenuType != null) {
        await _db.updateMenuType(menuTypeId, menuTypeCompanion);
      } else {
        await _db.insertMenuType(
          menuTypeCompanion,
          mode: InsertMode.insertOrReplace,
        );
      }
    } catch (e, stack) {
      _logger.e('Failed to upsert menu type details: $e', stackTrace: stack);
    }
  }
}

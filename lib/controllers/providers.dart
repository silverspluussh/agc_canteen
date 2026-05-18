import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../services/database/database_service.dart';
import '../services/database/app_database.dart';
import '../services/meal_service.dart';
import '../services/pos/pos_fingerprint_service.dart';
import '../services/pos/pos_scanner_service.dart';
import '../services/pos/pos_print_service.dart';
import '../services/pos/pos_device_service.dart';
import '../services/auth/fingerprint_auth_service.dart';
import '../services/auth/pos_auth_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return DatabaseService.instance.db;
});

final mealServiceProvider = Provider<MealService>((ref) {
  return GetIt.instance<MealService>();
});

final mealsProvider = FutureProvider<List<Meal>>((ref) async {
  final mealService = ref.watch(mealServiceProvider);
  final dbMeals = await mealService.getMeals();
  if (dbMeals.isNotEmpty) {
    return dbMeals;
  }

  // Beautiful fallback mock meals for testing if DB is empty
  return [
    Meal(
      id: 'meal_1',
      name: 'Jollof Rice with Grilled Chicken',
      status: 'active',
      mealType: 'lunch',
      remarks: 'Served with salad and shito',
      price: 45.0,
      photoUrl: null,
      menuTypeId: 'menu_lunch',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      syncStatus: 1,
    ),
    Meal(
      id: 'meal_2',
      name: 'Waakye Special',
      status: 'active',
      mealType: 'lunch',
      remarks: 'With wele, egg, and fish',
      price: 50.0,
      photoUrl: null,
      menuTypeId: 'menu_lunch',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      syncStatus: 1,
    ),
    Meal(
      id: 'meal_3',
      name: 'Hausa Koko & Puff Puff (Buffrot)',
      status: 'active',
      mealType: 'breakfast',
      remarks: 'Spicy millet porridge with fritters',
      price: 15.0,
      photoUrl: null,
      menuTypeId: 'menu_breakfast',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      syncStatus: 1,
    ),
    Meal(
      id: 'meal_4',
      name: 'Egg & Avocado Sandwich',
      status: 'active',
      mealType: 'breakfast',
      remarks: 'Whole wheat toasted bread',
      price: 25.0,
      photoUrl: null,
      menuTypeId: 'menu_breakfast',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      syncStatus: 1,
    ),
    Meal(
      id: 'meal_5',
      name: 'Assorted Fried Rice',
      status: 'active',
      mealType: 'lunch',
      remarks: 'Chicken, beef, and shrimp',
      price: 55.0,
      photoUrl: null,
      menuTypeId: 'menu_lunch',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      syncStatus: 1,
    ),
    Meal(
      id: 'meal_6',
      name: 'Meat Pie (Beef)',
      status: 'active',
      mealType: 'snack',
      remarks: 'Golden baked flaky pastry',
      price: 12.0,
      photoUrl: null,
      menuTypeId: 'menu_snack',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      syncStatus: 1,
    ),
    Meal(
      id: 'meal_7',
      name: 'Fresh Pineapple Juice',
      status: 'active',
      mealType: 'beverage',
      remarks: '100% natural, no added sugar',
      price: 18.0,
      photoUrl: null,
      menuTypeId: 'menu_beverage',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      syncStatus: 1,
    ),
    Meal(
      id: 'meal_8',
      name: 'Hibiscus Tea (Sobolo)',
      status: 'active',
      mealType: 'beverage',
      remarks: 'Chilled local spiced drink',
      price: 10.0,
      photoUrl: null,
      menuTypeId: 'menu_beverage',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      syncStatus: 1,
    ),
  ];
});

final fingerprintDeviceProvider = Provider<PosFingerprintService>((ref) {
  return PosFingerprintService();
});

final scannerProvider = Provider<PosScannerService>((ref) {
  return PosScannerService();
});

final printProvider = Provider<PosPrintService>((ref) {
  return PosPrintService();
});

final deviceProvider = Provider<PosDeviceService>((ref) {
  return PosDeviceService();
});

final fingerprintAuthProvider = Provider<FingerprintAuthService>((ref) {
  final db = ref.watch(databaseProvider);
  final device = ref.watch(fingerprintDeviceProvider);
  return FingerprintAuthService(db: db, fingerprint: device);
});

final posAuthProvider = Provider<PosAuthService>((ref) {
  final db = ref.watch(databaseProvider);
  final fingerprint = ref.watch(fingerprintAuthProvider);
  return PosAuthService(db: db, fingerprintAuth: fingerprint);
});

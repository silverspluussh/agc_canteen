import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/meal_time_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'resolveActiveMealType uses configured windows instead of fixed hour buckets',
    () async {
      await seedMealType(
        db,
        id: 1,
        name: 'breakfast',
        price: 5,
        beginTime: '06:00',
        endTime: '10:00',
      );
      await seedMealType(
        db,
        id: 2,
        name: 'lunch',
        price: 12,
        beginTime: '10:00',
        endTime: '16:00',
      );
      await seedMealType(
        db,
        id: 3,
        name: 'dinner',
        price: 15,
        beginTime: '16:00',
        endTime: '21:00',
      );

      final mealTypes = await db.getAllMealTypes();
      // Hardcoded group-order logic treated hour >= 15 as dinner; configured
      // lunch runs until 16:00, so 15:30 must still resolve to lunch.
      final resolved = resolveActiveMealType(
        mealTypes,
        now: DateTime(2026, 8, 6, 15, 30),
      );

      expect(resolved, isNotNull);
      expect(resolved!.$1, 2);
      expect(resolved.$2, 'lunch');
      expect(resolved.$3, 12);
    },
  );
}

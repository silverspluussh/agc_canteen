import 'package:agc_canteen/services/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_database.dart';

/// Phase 4: local primary keys must not collide.
///
/// The ids used to be `DateTime.now().millisecondsSinceEpoch`, so two rows written
/// inside the same millisecond fought over the primary key: the insert threw and
/// the row was silently lost, which surfaced to the operator as a voucher that
/// failed to print.
void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertOrder(int id) async {
    final now = DateTime.now().toIso8601String();
    await db.insertOrder(
      OrdersCompanion.insert(
        id: Value(id),
        uuid: 'uuid-$id',
        orderCode: 'ORD-$id',
        status: 'completed',
        orderType: 'single',
        mealType: 'lunch',
        total: 10,
        groupCount: 1,
        orderedById: 1,
        employeeType: 'permanent',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  group('nextLocalId', () {
    test('starts at 1 on an empty table', () async {
      expect(await db.nextLocalId('orders'), 1);
    });

    test('allocation is a pure function of the current maximum', () async {
      // Nothing is inserted, so every allocation legitimately returns the same
      // value. Ids only advance once a row lands — which is why the callers
      // allocate and insert together.
      final ids = <int>{};
      for (var i = 0; i < 200; i++) {
        ids.add(await db.nextLocalId('orders'));
      }

      expect(ids, {1});

      // Allocate-then-insert is the real pattern, so simulate it.
      final allocated = <int>[];
      for (var i = 0; i < 50; i++) {
        allocated.add(await db.nextLocalId('orders'));
        await insertOrder(allocated.last);
      }

      expect(allocated.toSet().length, 50, reason: 'allocated ids must be unique');
    });

    test('continues past the highest existing row', () async {
      await insertOrder(7);
      await insertOrder(3);

      expect(await db.nextLocalId('orders'), 8);
    });

    test('is not fooled by a clock that jumps backwards', () async {
      // Epoch-millisecond ids would happily reissue a value here.
      await insertOrder(1000);

      expect(await db.nextLocalId('orders'), 1001);
    });
  });

  group('nextLocalIds', () {
    test('returns consecutive ids for a batch', () async {
      final ids = await db.nextLocalIds('orders', 3);

      expect(ids, [1, 2, 3]);
    });

    test('returns an empty list for a non-positive count', () async {
      expect(await db.nextLocalIds('orders', 0), isEmpty);
      expect(await db.nextLocalIds('orders', -2), isEmpty);
    });

    test('a batch insert succeeds without a primary key conflict', () async {
      final ids = await db.nextLocalIds('orders', 25);

      for (final id in ids) {
        await insertOrder(id);
      }

      final all = await db.getAllOrders();
      expect(all.length, 25);
    });

    test('a second batch continues after the first', () async {
      final first = await db.nextLocalIds('orders', 5);
      for (final id in first) {
        await insertOrder(id);
      }

      final second = await db.nextLocalIds('orders', 5);

      expect(second.first, greaterThan(first.last));
      expect(first.toSet().intersection(second.toSet()), isEmpty);
    });
  });
}

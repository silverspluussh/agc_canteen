import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/database/tables.dart';
import 'package:agc_canteen/services/sync_services/sync_from_local_to_remote.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/shared_prefs.dart';
import '../../../helpers/test_database.dart';

dynamic _identityBuilder(dynamic data) => data;

void main() {
  late MockNetworkAPI api;
  late MockConnectivity connectivity;
  late AppDatabase db;
  late LocalToRemoteSyncService sync;

  setUpAll(() {
    registerCommonFallbackValues();
    registerFallbackValue(_identityBuilder);
  });

  setUp(() async {
    initMockSharedPreferences();
    api = MockNetworkAPI();
    connectivity = MockConnectivity();
    db = createTestDatabase();
    sync = LocalToRemoteSyncService(
      db: db,
      networkAPI: api,
      connectivity: connectivity,
    );

    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedOrder({
    required int id,
    required String employeeType,
    required String mealType,
    required String createdAt,
    double total = 40,
  }) async {
    await db.insertOrder(
      OrdersCompanion.insert(
        id: Value(id),
        uuid: 'uuid-$id',
        orderCode: 'ASGS1-1-${id.toString().padLeft(6, '0')}',
        status: 'completed',
        orderType: 'single',
        mealType: mealType,
        total: total,
        groupCount: 1,
        orderedById: 1,
        employeeType: employeeType,
        createdAt: createdAt,
        updatedAt: createdAt,
        syncStatus: const Value(0),
      ),
    );
  }

  Map<String, dynamic>? captureOrdersPayload() {
    final captured = verify(
      () => api.postData<dynamic>(
        '/pos/order/create-bulk',
        data: captureAny(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        opts: any(named: 'opts'),
        builder: any(named: 'builder'),
      ),
    ).captured;
    if (captured.isEmpty) return null;
    return captured.first as Map<String, dynamic>;
  }

  void stubOrderUploadSuccess() {
    when(
      () => api.postData<dynamic>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        opts: any(named: 'opts'),
        builder: any(named: 'builder'),
      ),
    ).thenAnswer((_) async => {'ok': true});
  }

  test(
    'maps HR employeeType to POS API values and preserves createdAt',
    () async {
      await seedPosDevice(db);
      await seedMealType(db, name: 'lunch', price: 40);
      await seedOrder(
        id: 10,
        employeeType: 'permanent',
        mealType: 'lunch',
        createdAt: '2026-08-07T08:15:00.000',
      );
      await seedOrder(
        id: 11,
        employeeType: 'contractor',
        mealType: 'lunch',
        createdAt: '2026-08-07T08:16:00.000',
      );
      stubOrderUploadSuccess();

      final result = await sync.syncSingleOrders();

      expect(result.errors, isEmpty);
      expect(result.pushed['orders'], 2);

      final body = captureOrdersPayload()!;
      final orders = (body['orders'] as List).cast<Map<String, dynamic>>();
      expect(orders[0]['employeeType'], 'staff');
      expect(orders[0]['createdAt'], '2026-08-07T08:15:00.000');
      expect(orders[0]['mealTypeId'], 1);
      expect(orders[1]['employeeType'], 'contractorstaff');
      expect(orders[1]['createdAt'], '2026-08-07T08:16:00.000');

      expect((await db.getOrder(10))!.syncStatus, 2);
      expect((await db.getOrder(11))!.syncStatus, 2);
    },
  );

  test(
    'does not upload or mark synced when meal type cannot be resolved',
    () async {
      await seedPosDevice(db);
      // Local meal catalog no longer contains the name stored on the order.
      await seedMealType(db, name: 'dinner', price: 50);
      await seedOrder(
        id: 20,
        employeeType: 'permanent',
        mealType: 'lunch',
        createdAt: '2026-08-07T12:00:00.000',
      );

      final result = await sync.syncSingleOrders();

      expect(result.pushed['orders'], isNull);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first, contains('unknown meal type'));
      verifyNever(
        () => api.postData<dynamic>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          opts: any(named: 'opts'),
          builder: any(named: 'builder'),
        ),
      );
      expect((await db.getOrder(20))!.syncStatus, 0);
    },
  );

  test('uploads staff bio-data with entity class staff, not HR subtype', () async {
    await seedStaff(db, id: 5, employeeType: 'graduateTrainee');
    final now = DateTime.now().toIso8601String();
    await db.insertBioData(
      BioDataEntriesCompanion.insert(
        id: const Value(1),
        finger: 'index',
        dataBase64: 'abc',
        staffId: const Value(5),
        createdAt: now,
        updatedAt: now,
        syncStatus: const Value(0),
      ),
    );
    stubOrderUploadSuccess();

    final result = await sync.syncBioData();

    expect(result.errors, isEmpty);
    expect(result.pushed['bio_data'], 1);

    final captured = verify(
      () => api.postData<dynamic>(
        '/hr/bio-data/create-bulk',
        data: captureAny(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        opts: any(named: 'opts'),
        builder: any(named: 'builder'),
      ),
    ).captured.first as Map<String, dynamic>;
    expect(captured['employeeType'], 'staff');
    expect(captured['referenceId'], 5);
  });
}

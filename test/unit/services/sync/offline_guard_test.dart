import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/sync_services/sync_from_remote_to_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';

/// Regression for the offline gate added to `RemoteToLocalSyncService`.
///
/// `syncAll` used to fire every job even with no connection, producing a wall
/// of socket errors on each scheduler tick. It now short-circuits, and exposes
/// `isOnline` so the manual Download button can report the truth instead of a
/// false "All data synced".
void main() {
  late AppDatabase db;
  late MockNetworkAPI network;

  setUp(() {
    db = createTestDatabase();
    network = MockNetworkAPI();
  });

  tearDown(() async {
    await db.close();
  });

  test('offline syncAll does not touch the network', () async {
    final service = RemoteToLocalSyncService(
      networkAPI: network,
      db: db,
      isOnline: () async => false,
    );

    expect(await service.isOnline, isFalse);

    await service.syncAll(background: false);

    verifyZeroInteractions(network);
  });

  test('online syncAll proceeds to fetch', () async {
    when(() => network.getData<dynamic>(
          any(),
          builder: any(named: 'builder'),
        )).thenAnswer((_) async => {'data': <dynamic>[]});

    final service = RemoteToLocalSyncService(
      networkAPI: network,
      db: db,
      isOnline: () async => true,
    );

    expect(await service.isOnline, isTrue);

    await service.syncAll(background: false);

    verify(() => network.getData<dynamic>(
          any(),
          builder: any(named: 'builder'),
        )).called(greaterThan(0));
  });

  test('a throwing connectivity probe is treated as offline', () async {
    final service = RemoteToLocalSyncService(
      networkAPI: network,
      db: db,
      isOnline: () async => throw StateError('radio down'),
    );

    expect(await service.isOnline, isFalse);
    await service.syncAll(background: false);
    verifyZeroInteractions(network);
  });
}

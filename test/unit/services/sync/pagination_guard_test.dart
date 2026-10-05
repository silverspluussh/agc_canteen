import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/sync_services/sync_from_remote_to_local.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';

/// Phase 5: a partial pull must not delete rows it simply never saw.
///
/// The departments endpoint is read one page at a time (`limit: 100`,
/// `offset: 0`) and the result was then passed to `deleteDepartmentsNotIn`.
/// Anything past the page was absent from that set and so treated as deleted:
/// a server holding more than 100 departments silently wiped the rest of the
/// local cache on every sync.
void main() {
  late AppDatabase db;
  late MockNetworkAPI network;
  late RemoteToLocalSyncService service;

  setUp(() {
    db = createTestDatabase();
    network = MockNetworkAPI();
    service = RemoteToLocalSyncService(networkAPI: network, db: db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedDepartments(List<int> ids) async {
    for (final id in ids) {
      await db.insertDepartment(
        DepartmentsCompanion.insert(
          id: Value(id),
          name: 'Dept $id',
          syncStatus: const Value(2),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  /// Stubs the endpoint with [count] synthetic department rows.
  void stubPage(int count) {
    when(() => network.getData<dynamic>(
          any(),
          builder: any(named: 'builder'),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async {
      return {
        'data': [
          for (var i = 1; i <= count; i++)
            {'id': i, 'name': 'Remote $i', 'status': 'active'},
        ],
      };
    });
  }

  Future<Set<int>> localIds() async {
    final rows = await db.select(db.departments).get();
    return rows.map((r) => r.id).toSet();
  }

  test('a full page leaves rows beyond it untouched', () async {
    // #150 exists locally and would be on the second page.
    await seedDepartments([1, 2, 150]);
    stubPage(100);

    await service.syncDepartmentsOnly();

    final ids = await localIds();
    expect(
      ids,
      contains(150),
      reason: 'a row the server still has must not be deleted because this page '
          'did not include it',
    );
  });

  test('a short page still prunes rows the server dropped', () async {
    await seedDepartments([1, 2, 3]);
    stubPage(2); // fewer rows than the limit => complete dataset

    await service.syncDepartmentsOnly();

    expect(await localIds(), isNot(contains(3)));
  });
}

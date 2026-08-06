import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/sync_services/sync_from_remote_to_local.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';

dynamic _identityBuilder(dynamic data) => data;

void main() {
  late AppDatabase db;
  late MockNetworkAPI network;
  late RemoteToLocalSyncService sync;

  setUpAll(() {
    registerFallbackValue(_identityBuilder);
  });

  setUp(() {
    db = createTestDatabase();
    network = MockNetworkAPI();
    sync = RemoteToLocalSyncService(networkAPI: network, db: db);
  });

  tearDown(() async {
    await db.close();
  });

  Map<String, dynamic> department(int id) => {'id': id, 'name': 'Dept $id'};

  test(
    'department sync pages past the first limit before deleteNotIn',
    () async {
      // Seed a department that only appears on page 2. The old single-page
      // sync would omit it from remoteIds and delete it as "stale".
      await db.insertDepartment(
        DepartmentsCompanion.insert(id: const Value(150), name: 'Keep Me'),
      );
      // Mark as synced so deleteDepartmentsNotIn considers it.
      await db.markDepartmentSynced(150);

      when(
        () => network.getData<dynamic>(
          '/hr/departments',
          builder: any(named: 'builder'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((invocation) async {
        final query =
            invocation.namedArguments[#queryParameters] as Map<String, dynamic>;
        final offset = query['offset'] as int;
        final limit = query['limit'] as int;
        final builder =
            invocation.namedArguments[#builder] as dynamic Function(dynamic);
        final all = [for (var i = 1; i <= 150; i++) department(i)];
        final page = all.skip(offset).take(limit).toList();
        return builder(page);
      });

      await sync.syncDepartmentsOnly();

      expect(await db.getDepartment(150), isNotNull);
      expect(await db.getDepartment(1), isNotNull);
      expect((await db.getAllDepartments()).length, 150);
    },
  );
}

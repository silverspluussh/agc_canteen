import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/sync_services/sync_from_remote_to_local.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';

/// Regression coverage for the contractor-staff remote sync.
///
/// The endpoint used to be pulled in a single un-paginated request and every
/// per-record upsert failure was swallowed, so a schema/value mismatch looked
/// like a successful "0 rows" sync. It now pages through the endpoint and
/// counts/records failures.
void main() {
  late AppDatabase db;
  late MockNetworkAPI network;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    db = createTestDatabase();
    network = MockNetworkAPI();
  });

  tearDown(() async {
    await db.close();
  });

  Map<String, dynamic> contractorStaff(int id) => {
        'id': id,
        'name': 'Contractor Staff $id',
        'startDate': '2024-01-01T00:00:00.000000Z',
        'endDate': '2024-12-31T00:00:00.000000Z',
      };

  void stubPagedSync(Map<int, List<Map<String, dynamic>>> pagesByOffset) {
    when(() => network.getData<dynamic>(
          any(),
          builder: any(named: 'builder'),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((invocation) async {
      final query =
          invocation.namedArguments[#queryParameters] as Map<String, dynamic>?;
      final offset = (query?['offset'] as int?) ?? 0;
      final page = pagesByOffset[offset] ?? const <Map<String, dynamic>>[];
      return {'count': page.length, 'contractorStaffs': page};
    });
  }

  test('pages through the endpoint and persists every contractor staff',
      () async {
    final firstPage = List.generate(200, (i) => contractorStaff(i + 1));
    final secondPage = List.generate(5, (i) => contractorStaff(201 + i));
    stubPagedSync({0: firstPage, 200: secondPage});

    final service = RemoteToLocalSyncService(networkAPI: network, db: db);
    await service.syncContractorStaffOnly();

    final rows = await db.getAllContractorStaff();
    expect(rows.length, 205);
    expect(rows.map((r) => r.id), contains(205));

    verify(() => network.getData<dynamic>(
          any(),
          builder: any(named: 'builder'),
          queryParameters: any(named: 'queryParameters'),
        )).called(2);
  });

  test('purges stale contractor staff only after a complete sync', () async {
    await db.insertContractorStaff(
      ContractorStaffTableCompanion.insert(
        id: const Value(999),
        name: 'Stale Synced Staff',
        startDate: '2024-01-01',
        endDate: '2024-12-31',
        syncStatus: const Value(2),
      ),
    );

    stubPagedSync({
      0: [contractorStaff(1)],
    });

    final service = RemoteToLocalSyncService(networkAPI: network, db: db);
    await service.syncContractorStaffOnly();

    expect(await db.getContractorStaff(999), isNull);
    expect(await db.getContractorStaff(1), isNotNull);
  });

  test('a malformed record is skipped without failing the whole sync',
      () async {
    stubPagedSync({
      0: [
        {'id': 0, 'name': 'No id'},
        contractorStaff(7),
      ],
    });

    final service = RemoteToLocalSyncService(networkAPI: network, db: db);
    await service.syncContractorStaffOnly();

    expect(await db.getContractorStaff(7), isNotNull);
    expect(await db.getAllContractorStaff(), hasLength(1));
  });
}

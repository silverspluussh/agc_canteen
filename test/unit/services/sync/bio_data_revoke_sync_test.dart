import 'package:agc_canteen/core/network/api_exceptions_util.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/sync_services/sync_from_local_to_remote.dart';
import 'package:agc_canteen/services/sync_services/sync_from_remote_to_local.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/shared_prefs.dart';
import '../../../helpers/test_database.dart';

dynamic _identityBuilder(dynamic data) => data;

void main() {
  late MockNetworkAPI api;
  late MockConnectivity connectivity;
  late AppDatabase db;

  setUpAll(() {
    registerCommonFallbackValues();
    registerFallbackValue(_identityBuilder);
  });

  setUp(() async {
    initMockSharedPreferences();
    api = MockNetworkAPI();
    connectivity = MockConnectivity();
    db = createTestDatabase();

    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);
    await seedStaff(db, id: 10);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertBio({
    required int id,
    required int staffId,
    required bool isActive,
    required int syncStatus,
  }) {
    final now = DateTime.now().toIso8601String();
    return db.insertBioData(
      BioDataEntriesCompanion.insert(
        id: Value(id),
        staffId: Value(staffId),
        finger: 'thumb',
        dataBase64: 'template-$id',
        isActive: Value(isActive),
        createdAt: now,
        updatedAt: now,
        syncStatus: Value(syncStatus),
      ),
    );
  }

  group('LocalToRemoteSyncService bio revoke', () {
    late LocalToRemoteSyncService sync;

    setUp(() {
      sync = LocalToRemoteSyncService(
        db: db,
        networkAPI: api,
        connectivity: connectivity,
      );
    });

    test('DELETE inactive unsynced bio and removes local row', () async {
      await insertBio(id: 42, staffId: 10, isActive: false, syncStatus: 0);

      when(
        () => api.deleteData<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          opts: any(named: 'opts'),
          data: any(named: 'data'),
          builder: any(named: 'builder'),
        ),
      ).thenAnswer((_) async => {'ok': true});

      final result = await sync.syncBioData();

      expect(result.errors, isEmpty);
      expect(result.pushed['bio_data_deleted'], 1);
      expect(await db.getBioData(42), isNull);
      verify(
        () => api.deleteData<dynamic>(
          '/hr/bio-data/delete/42',
          queryParameters: any(named: 'queryParameters'),
          opts: any(named: 'opts'),
          data: any(named: 'data'),
          builder: any(named: 'builder'),
        ),
      ).called(1);
      verifyNever(
        () => api.postData<dynamic>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          opts: any(named: 'opts'),
          builder: any(named: 'builder'),
        ),
      );
    });

    test('404 on remote delete still clears local revocation', () async {
      await insertBio(id: 43, staffId: 10, isActive: false, syncStatus: 0);

      when(
        () => api.deleteData<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          opts: any(named: 'opts'),
          data: any(named: 'data'),
          builder: any(named: 'builder'),
        ),
      ).thenThrow(NotFoundException('gone'));

      final result = await sync.syncBioData();

      expect(result.errors, isEmpty);
      expect(result.pushed['bio_data_deleted'], 1);
      expect(await db.getBioData(43), isNull);
    });

    test('does not create-bulk deactivated fingerprints', () async {
      await insertBio(id: 44, staffId: 10, isActive: false, syncStatus: 0);
      await insertBio(id: 45, staffId: 10, isActive: true, syncStatus: 0);

      when(
        () => api.deleteData<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          opts: any(named: 'opts'),
          data: any(named: 'data'),
          builder: any(named: 'builder'),
        ),
      ).thenAnswer((_) async => {'ok': true});
      when(
        () => api.postData<dynamic>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          opts: any(named: 'opts'),
          builder: any(named: 'builder'),
        ),
      ).thenAnswer((_) async => {'ok': true});

      await sync.syncBioData();

      final createCalls = verify(
        () => api.postData<dynamic>(
          '/hr/bio-data/create-bulk',
          data: captureAny(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          opts: any(named: 'opts'),
          builder: any(named: 'builder'),
        ),
      ).captured;
      expect(createCalls.length, 1);
      final payload = createCalls.first as Map<String, dynamic>;
      final bios = payload['bioDatas'] as List<dynamic>;
      expect(bios.length, 1);
      expect(bios.single['data'], 'template-45');
    });
  });

  group('RemoteToLocalSyncService bio upsert preserve', () {
    late RemoteToLocalSyncService sync;

    setUp(() {
      sync = RemoteToLocalSyncService(
        networkAPI: api,
        db: db,
        logger: Logger(level: Level.nothing),
      );
    });

    test('pull does not re-activate a pending local soft-delete', () async {
      await insertBio(id: 42, staffId: 10, isActive: false, syncStatus: 0);

      when(
        () => api.getData<dynamic>(
          '/hr/bio-data/sync',
          queryParameters: any(named: 'queryParameters'),
          opts: any(named: 'opts'),
          data: any(named: 'data'),
          builder: any(named: 'builder'),
        ),
      ).thenAnswer(
        (_) async => [
          {
            'id': 42,
            'staffId': 10,
            'finger': 'thumb',
            'data': 'remote-template',
            'isActive': true,
          },
        ],
      );

      await sync.syncBioDataOnly();

      final row = await db.getBioData(42);
      expect(row, isNotNull);
      expect(row!.isActive, isFalse);
      expect(row.syncStatus, 0);
      expect(row.dataBase64, 'template-42');
    });
  });
}

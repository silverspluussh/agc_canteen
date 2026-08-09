import 'package:agc_canteen/models/sync.model.dart';
import 'package:agc_canteen/services/auth/fingerprint_auth_service.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/pos/pos_fingerprint_service.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';
import '../../../helpers/test_service_locator.dart';

class MockPosFingerprintService extends Mock implements PosFingerprintService {}

void main() {
  late AppDatabase db;
  late MockPosFingerprintService fingerprintHw;
  late MockLocalToRemoteSyncService sync;
  late FingerprintAuthService auth;

  setUp(() async {
    db = createTestDatabase();
    fingerprintHw = MockPosFingerprintService();
    sync = MockLocalToRemoteSyncService();
    auth = FingerprintAuthService(db: db, fingerprint: fingerprintHw);

    when(() => sync.syncBioData()).thenAnswer(
      (_) async => const SyncResult(pushed: {}, pulled: {}, errors: []),
    );
    await setupTestLocator(db: db, syncService: sync);
    await seedStaff(db, id: 10);
  });

  tearDown(() async {
    await resetTestLocator();
    await db.close();
  });

  Future<void> insertSyncedBio({required int id, required int staffId}) {
    final now = DateTime.now().toIso8601String();
    return db.insertBioData(
      BioDataEntriesCompanion.insert(
        id: Value(id),
        staffId: Value(staffId),
        finger: 'thumb',
        dataBase64: 'template-$id',
        isActive: const Value(true),
        createdAt: now,
        updatedAt: now,
        syncStatus: const Value(2),
      ),
    );
  }

  test(
    'deleteFingerprint soft-deactivates and queues remote sync (no hard delete)',
    () async {
      await insertSyncedBio(id: 42, staffId: 10);

      await auth.deleteFingerprint(42);

      final row = await db.getBioData(42);
      expect(row, isNotNull);
      expect(row!.isActive, isFalse);
      expect(row.syncStatus, 0);
      verify(() => sync.syncBioData()).called(1);

      final active = await db.getActiveBioDataByStaff(10);
      expect(active, isEmpty);
    },
  );
}

import 'package:agc_canteen/services/database/app_database.dart';
// drift exports isNull/isNotNull too, which collide with package:matcher.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_database.dart';

/// Phase 2: bio-data push idempotency.
///
/// Two problems are pinned here:
///  1. every retry used to send a fresh uuid, so the server inserted a duplicate
///     fingerprint each time a push was repeated;
///  2. bio-data rows had no attempt counter, so a permanently-bad payload was
///     re-pushed on every sync pass forever.
void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertEntry({
    required int id,
    String? uuid,
    int syncStatus = 0,
  }) async {
    final now = DateTime.now().toIso8601String();
    await db.insertBioData(
      BioDataEntriesCompanion.insert(
        id: Value(id),
        finger: 'thumb',
        dataBase64: 'template-$id',
        createdAt: now,
        updatedAt: now,
        uuid: Value.absentIfNull(uuid),
        syncStatus: Value(syncStatus),
      ),
    );
    return id;
  }

  group('stable uuid', () {
    test('insertBioData stamps a uuid when the caller omits one', () async {
      await insertEntry(id: 1);

      final entry = await db.getBioData(1);

      expect(entry, isNotNull);
      expect(entry!.uuid, isNotNull, reason: 'a row with no uuid is not idempotent');
      expect(entry.uuid, isNotEmpty);
    });

    test('a caller-supplied uuid is preserved', () async {
      await insertEntry(id: 1, uuid: 'fixed-uuid-1');

      final entry = await db.getBioData(1);

      expect(entry!.uuid, 'fixed-uuid-1');
    });

    test('distinct captures get distinct uuids', () async {
      await insertEntry(id: 1);
      await insertEntry(id: 2);

      final first = await db.getBioData(1);
      final second = await db.getBioData(2);

      expect(first!.uuid, isNot(second!.uuid));
    });
  });

  group('attempt cap', () {
    test('a freshly inserted row is immediately eligible for push', () async {
      await insertEntry(id: 1);

      final unsynced = await db.getUnsyncedBioData();

      expect(unsynced.map((e) => e.id), contains(1));
    });

    test('a synced row is not re-pushed', () async {
      await insertEntry(id: 1);
      await db.markBioDataSynced(1);

      final unsynced = await db.getUnsyncedBioData();

      expect(unsynced.map((e) => e.id), isNot(contains(1)));
    });

    test('a failed row is retried and counts its attempt', () async {
      await insertEntry(id: 1);

      await db.markBioDataFailed(1, error: 'boom');

      final entry = await db.getBioData(1);
      expect(entry!.syncStatus, 3, reason: 'retryable');
      expect(entry.syncAttempts, 1);
      expect(entry.lastSyncError, 'boom');
      expect((await db.getUnsyncedBioData()).map((e) => e.id), contains(1));
    });

    test('a row is parked in the terminal state once attempts are exhausted',
        () async {
      await insertEntry(id: 1);

      // The cap is private; drive it past the limit the same way production does.
      for (var i = 0; i < 5; i++) {
        await db.markBioDataFailed(1, error: 'boom $i');
      }

      final entry = await db.getBioData(1);
      expect(entry!.syncStatus, 4, reason: 'terminal');
      expect(
        (await db.getUnsyncedBioData()).map((e) => e.id),
        isNot(contains(1)),
        reason: 'an exhausted row must stop being retried forever',
      );
    });

    test('markBioDataSynced clears the recorded error', () async {
      await insertEntry(id: 1);
      await db.markBioDataFailed(1, error: 'boom');
      await db.markBioDataSynced(1);

      final entry = await db.getBioData(1);

      expect(entry!.syncStatus, 2);
      expect(entry.lastSyncError, isNull);
    });
  });
}

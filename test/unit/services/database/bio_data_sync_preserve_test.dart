import 'package:agc_canteen/services/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertBio({
    required int id,
    int? visitorId,
    int? dependentId,
    int? contractorStaffId,
    required int syncStatus,
  }) {
    final now = DateTime.now().toIso8601String();
    return db.insertBioData(
      BioDataEntriesCompanion.insert(
        id: Value(id),
        finger: 'index',
        dataBase64: 'template-$id',
        createdAt: now,
        updatedAt: now,
        visitorId: Value.absentIfNull(visitorId),
        dependentId: Value.absentIfNull(dependentId),
        contractorStaffId: Value.absentIfNull(contractorStaffId),
        syncStatus: Value(syncStatus),
      ),
    );
  }

  test('deleteSyncedBioDataByVisitor keeps unsynced local enrollments', () async {
    await seedVisitor(db, id: 10);
    await insertBio(id: 1, visitorId: 10, syncStatus: 2);
    await insertBio(id: 2, visitorId: 10, syncStatus: 0);

    await db.deleteSyncedBioDataByVisitor(10);

    final remaining = await db.getAllBioData();
    expect(remaining.map((e) => e.id), [2]);
    expect(remaining.single.syncStatus, 0);
  });

  test('deleteSyncedBioDataByDependent keeps unsynced local enrollments', () async {
    await seedDependent(db, id: 20);
    await insertBio(id: 3, dependentId: 20, syncStatus: 2);
    await insertBio(id: 4, dependentId: 20, syncStatus: 0);

    await db.deleteSyncedBioDataByDependent(20);

    final remaining = await db.getAllBioData();
    expect(remaining.map((e) => e.id), [4]);
  });

  test('deleteSyncedBioDataByContractorStaff keeps unsynced local enrollments',
      () async {
    await seedContractorStaff(db, id: 30);
    await insertBio(id: 5, contractorStaffId: 30, syncStatus: 2);
    await insertBio(id: 6, contractorStaffId: 30, syncStatus: 0);

    await db.deleteSyncedBioDataByContractorStaff(30);

    final remaining = await db.getAllBioData();
    expect(remaining.map((e) => e.id), [6]);
  });

  test('full entity delete still removes unsynced bios', () async {
    await seedVisitor(db, id: 11);
    await insertBio(id: 7, visitorId: 11, syncStatus: 0);

    await db.deleteBioDataByVisitor(11);

    expect(await db.getAllBioData(), isEmpty);
  });
}

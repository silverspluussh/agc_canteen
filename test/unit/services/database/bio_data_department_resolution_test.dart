import 'package:agc_canteen/services/database/app_database.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_database.dart';

/// Phase 2: department scoping resolves through the owner's **parent** record,
/// not `bio_data_entries.department_id`.
///
/// That column is only populated for staff-type enrolments, so locally-enrolled
/// contractor/visitor/dependent templates would be invisible to a
/// department-scoped scan without this join.
void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedBio({
    required int id,
    int? staffId,
    int? contractorStaffId,
    int? visitorId,
    int? dependentId,
    bool active = true,
    int? departmentId,
  }) async {
    await db.insertBioData(
      BioDataEntriesCompanion.insert(
        id: Value(id),
        finger: 'rightThumb',
        dataBase64: 'AAAA',
        createdAt: '2024-01-01T00:00:00.000',
        updatedAt: '2024-01-01T00:00:00.000',
        staffId: Value.absentIfNull(staffId),
        contractorStaffId: Value.absentIfNull(contractorStaffId),
        visitorId: Value.absentIfNull(visitorId),
        dependentId: Value.absentIfNull(dependentId),
        isActive: Value(active),
        departmentId: Value.absentIfNull(departmentId),
      ),
    );
  }

  test('staff template resolves to the staff department', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBio(id: 100, staffId: 1);

    final map = await db.activeBioDataDepartments();

    expect(map[100], 10);
  });

  test('contractor template resolves via the contractor record', () async {
    await seedContractorStaff(db, id: 2, departmentId: 20);
    // Stored department is null, exactly as local enrollment writes it.
    await seedBio(id: 101, contractorStaffId: 2);

    final map = await db.activeBioDataDepartments();

    expect(map[101], 20);
  });

  test('visitor template resolves via the visitor record', () async {
    await seedVisitor(db, id: 3, departmentId: 30);
    await seedBio(id: 102, visitorId: 3);

    expect((await db.activeBioDataDepartments())[102], 30);
  });

  test('dependent template inherits the staff parent department', () async {
    await seedStaff(db, id: 4, departmentId: 40);
    await seedDependent(db, id: 5, staffId: 4);
    await seedBio(id: 103, dependentId: 5);

    expect((await db.activeBioDataDepartments())[103], 40);
  });

  test('dependent template inherits the contractor parent department',
      () async {
    await seedContractorStaff(db, id: 6, departmentId: 60);
    await seedDependent(db, id: 7, contractorStaffId: 6);
    await seedBio(id: 104, dependentId: 7);

    expect((await db.activeBioDataDepartments())[104], 60);
  });

  test('a template whose owner has no department resolves to null', () async {
    await seedContractorStaff(db, id: 8); // no department
    await seedBio(id: 105, contractorStaffId: 8);

    expect((await db.activeBioDataDepartments())[105], isNull);
  });

  test('inactive templates are ignored', () async {
    await seedStaff(db, id: 9, departmentId: 90);
    await seedBio(id: 106, staffId: 9, active: false);

    expect(await db.activeBioDataDepartments(), isEmpty);
  });

  test('getActiveBioDataForDepartment returns only that department', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedContractorStaff(db, id: 2, departmentId: 20);
    await seedBio(id: 100, staffId: 1);
    await seedBio(id: 101, contractorStaffId: 2);

    final dept10 = await db.getActiveBioDataForDepartment(10);
    final dept20 = await db.getActiveBioDataForDepartment(20);

    expect(dept10.map((e) => e.id), [100]);
    expect(dept20.map((e) => e.id), [101]);
  });

  test('a department with no enrolled templates returns empty', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBio(id: 100, staffId: 1);

    expect(await db.getActiveBioDataForDepartment(999), isEmpty);
  });
}

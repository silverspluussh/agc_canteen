import 'package:agc_canteen/services/auth/fingerprint_template_cache.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_database.dart';

/// Phase 3: fingerprint templates are resolved once into an in-memory snapshot
/// and reused across scans, rebuilt only when invalidated.
void main() {
  late AppDatabase db;
  late FingerprintTemplateCache cache;

  setUp(() {
    db = createTestDatabase();
    cache = FingerprintTemplateCache(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('returns only the requested department templates', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedContractorStaff(db, id: 2, departmentId: 20);
    await seedBioData(db, id: 100, staffId: 1);
    await seedBioData(db, id: 101, contractorStaffId: 2);

    final dept10 = await cache.forDepartment(10);
    final dept20 = await cache.forDepartment(20);

    expect(dept10.map((e) => e.id), [100]);
    expect(dept20.map((e) => e.id), [101]);
  });

  test('returns empty for a department with no templates', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBioData(db, id: 100, staffId: 1);

    expect(await cache.forDepartment(999), isEmpty);
  });

  test('all() includes templates whose owner has no department', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedContractorStaff(db, id: 2); // no department
    await seedBioData(db, id: 100, staffId: 1);
    await seedBioData(db, id: 101, contractorStaffId: 2);

    final all = await cache.all();

    expect(all.map((e) => e.id).toSet(), {100, 101});
  });

  test('ignores inactive templates', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBioData(db, id: 100, staffId: 1, active: false);

    expect(await cache.forDepartment(10), isEmpty);
  });

  test('reuses the snapshot until invalidated', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBioData(db, id: 100, staffId: 1);

    expect((await cache.forDepartment(10)).map((e) => e.id), [100]);

    // A new template enrolled behind the cache's back is not seen yet...
    await seedBioData(db, id: 101, staffId: 1);
    expect((await cache.forDepartment(10)).map((e) => e.id), [100]);

    // ...until the cache is invalidated (as enrollment and sync do).
    cache.invalidate();
    expect((await cache.forDepartment(10)).map((e) => e.id).toSet(), {100, 101});
  });
}

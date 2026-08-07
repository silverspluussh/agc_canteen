import 'package:agc_canteen/services/auth/fingerprint_auth_service.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/pos/pos_fingerprint_service.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late MockPosFingerprintService fingerprint;
  late FingerprintAuthService auth;

  setUp(() {
    db = createTestDatabase();
    fingerprint = MockPosFingerprintService();
    auth = FingerprintAuthService(db: db, fingerprint: fingerprint);
    when(() => fingerprint.cancel()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertBio({
    required int id,
    int? staffId,
    int? visitorId,
    int? departmentId,
  }) {
    final now = DateTime.now().toIso8601String();
    return db.insertBioData(
      BioDataEntriesCompanion.insert(
        id: Value(id),
        finger: 'index',
        dataBase64: 'tpl-$id',
        createdAt: now,
        updatedAt: now,
        isActive: const Value(true),
        staffId: Value.absentIfNull(staffId),
        visitorId: Value.absentIfNull(visitorId),
        departmentId: Value.absentIfNull(departmentId),
      ),
    );
  }

  test('department filter still matches visitor bios with null departmentId',
      () async {
    await seedVisitor(db, id: 40);
    await seedStaff(db, id: 1, departmentId: 7);
    await insertBio(id: 1, staffId: 1, departmentId: 7);
    await insertBio(id: 2, visitorId: 40);

    when(() => fingerprint.capture()).thenAnswer(
      (_) async => const FingerprintResult(
        success: true,
        templateBase64: 'live',
      ),
    );
    // Only the visitor template should be verified when staff in another
    // department would also be present — here both are candidates, so return
    // a high score for the visitor template.
    when(() => fingerprint.verify(any())).thenAnswer((invocation) async {
      final template = invocation.positionalArguments.first as String;
      return template == 'tpl-2' ? 95 : 10;
    });

    final match = await auth.authenticate(departmentId: 7);

    expect(match, isNotNull);
    expect(match!.visitorId, 40);
    verify(() => fingerprint.verify('tpl-2')).called(1);
  });

  test('department filter excludes staff from other departments', () async {
    await seedStaff(db, id: 2, departmentId: 8);
    await insertBio(id: 3, staffId: 2, departmentId: 8);

    when(() => fingerprint.capture()).thenAnswer(
      (_) async => const FingerprintResult(
        success: true,
        templateBase64: 'live',
      ),
    );

    final match = await auth.authenticate(departmentId: 7);

    expect(match, isNull);
    verifyNever(() => fingerprint.verify(any()));
  });
}

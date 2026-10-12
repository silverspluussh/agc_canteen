import 'package:agc_canteen/services/auth/fingerprint_auth_service.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/pos/pos_fingerprint_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';

/// Phase 4: `authenticate` matches via a single native batch call instead of one
/// `verify` per template. Phase A: the accept threshold is configurable.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late MockPosFingerprintService fingerprint;

  setUpAll(() {
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = createTestDatabase();
    fingerprint = MockPosFingerprintService();
    when(() => fingerprint.cancel()).thenAnswer((_) async {});
    when(() => fingerprint.capture()).thenAnswer(
      (_) async =>
          const FingerprintResult(success: true, templateBase64: 'CAPTURED'),
    );
    when(() => fingerprint.verifyBatch(any())).thenAnswer((_) async => null);
  });

  tearDown(() async {
    await db.close();
  });

  FingerprintAuthService build() =>
      FingerprintAuthService(db: db, fingerprint: fingerprint);

  test('a batch match at or above the threshold is returned', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBioData(db, id: 100, staffId: 1);
    when(() => fingerprint.verifyBatch(any()))
        .thenAnswer((_) async => const FingerprintMatch(index: 0, score: 90));

    final match = await build().authenticate(departmentId: 10);

    expect(match?.id, 100);
    verify(() => fingerprint.verifyBatch(any())).called(1);
  });

  test('a batch score below the threshold is rejected', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBioData(db, id: 100, staffId: 1);
    when(() => fingerprint.verifyBatch(any()))
        .thenAnswer((_) async => const FingerprintMatch(index: 0, score: 70));

    expect(await build().authenticate(departmentId: 10), isNull);
  });

  test('an out-of-range index is ignored', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBioData(db, id: 100, staffId: 1);
    when(() => fingerprint.verifyBatch(any()))
        .thenAnswer((_) async => const FingerprintMatch(index: 5, score: 99));

    expect(await build().authenticate(departmentId: 10), isNull);
  });

  test('a null batch result returns null', () async {
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBioData(db, id: 100, staffId: 1);
    when(() => fingerprint.verifyBatch(any())).thenAnswer((_) async => null);

    expect(await build().authenticate(departmentId: 10), isNull);
  });

  test('an empty scope never calls the batch', () async {
    await seedStaff(db, id: 1, departmentId: 10); // no templates enrolled

    expect(await build().authenticate(departmentId: 10), isNull);
    verifyNever(() => fingerprint.verifyBatch(any()));
  });

  test('a configured higher threshold rejects a mid score', () async {
    SharedPreferences.setMockInitialValues({
      FingerprintAuthService.matchThresholdPrefsKey: 90,
    });
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBioData(db, id: 100, staffId: 1);
    when(() => fingerprint.verifyBatch(any()))
        .thenAnswer((_) async => const FingerprintMatch(index: 0, score: 85));

    expect(await build().authenticate(departmentId: 10), isNull);
  });

  test('a configured lower threshold accepts a mid score', () async {
    SharedPreferences.setMockInitialValues({
      FingerprintAuthService.matchThresholdPrefsKey: 70,
    });
    await seedStaff(db, id: 1, departmentId: 10);
    await seedBioData(db, id: 100, staffId: 1);
    when(() => fingerprint.verifyBatch(any()))
        .thenAnswer((_) async => const FingerprintMatch(index: 0, score: 75));

    expect((await build().authenticate(departmentId: 10))?.id, 100);
  });
}

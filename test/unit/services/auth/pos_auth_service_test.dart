import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/services/auth/pos_auth_service.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';
import '../../../helpers/test_service_locator.dart';

void main() {
  late AppDatabase db;
  late MockFingerprintAuthService fingerprintAuth;
  late MockNfcAuthService nfcAuth;
  late PosAuthService posAuth;

  setUpAll(() {
    registerFallbackValue(0);
  });

  setUp(() {
    db = createTestDatabase();
    fingerprintAuth = MockFingerprintAuthService();
    nfcAuth = MockNfcAuthService();
    posAuth = PosAuthService(
      fingerprintAuth: fingerprintAuth,
      nfcAuth: nfcAuth,
    );
  });

  tearDown(() async {
    await resetTestLocator();
    await db.close();
  });

  BioDataEntry bioDataEntry({
    int id = 1,
    int? staffId,
    int? dependentId,
    int? contractorStaffId,
    int? visitorId,
    String? personnelName,
  }) {
    return BioDataEntry(
      id: id,
      staffId: staffId,
      dependentId: dependentId,
      contractorStaffId: contractorStaffId,
      visitorId: visitorId,
      finger: 'thumb',
      dataBase64: 'template',
      isActive: true,
      personnelName: personnelName,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      syncStatus: 0,
    );
  }

  group('authenticateWithFingerprint', () {
    test('returns notEnrolled when no fingerprint match is found', () async {
      when(() => fingerprintAuth.authenticate(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => null);

      final result = await posAuth.authenticateWithFingerprint();

      expect(result.isAuthenticated, isFalse);
      expect(result.failureReason, AuthFailureReason.notEnrolled);
    });

    test('resolves matched staff via staffId FK', () async {
      await seedStaff(db, id: 10, firstName: 'Ada', lastName: 'Lovelace');
      await setupTestLocator(db: db);

      when(() => fingerprintAuth.authenticate(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => bioDataEntry(staffId: 10));

      final result = await posAuth.authenticateWithFingerprint();

      expect(result.isAuthenticated, isTrue);
      expect(result.entityId, 10);
      expect(result.entityType, EmployeeType.permanent);
      expect(result.displayName, 'Ada Lovelace');
    });

    test('resolves matched dependent via dependentId FK', () async {
      await seedDependent(db, id: 20, fullname: 'Baby Lovelace');
      await setupTestLocator(db: db);

      when(() => fingerprintAuth.authenticate(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => bioDataEntry(dependentId: 20));

      final result = await posAuth.authenticateWithFingerprint();

      expect(result.isAuthenticated, isTrue);
      expect(result.entityId, 20);
      expect(result.entityType, EmployeeType.dependent);
      expect(result.displayName, 'Baby Lovelace');
    });

    test('resolves matched contractor staff via contractorStaffId FK', () async {
      await seedContractorStaff(db, id: 30, name: 'Contract Bob');
      await setupTestLocator(db: db);

      when(() => fingerprintAuth.authenticate(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => bioDataEntry(contractorStaffId: 30));

      final result = await posAuth.authenticateWithFingerprint();

      expect(result.isAuthenticated, isTrue);
      expect(result.entityId, 30);
      expect(result.entityType, EmployeeType.contractor);
      expect(result.displayName, 'Contract Bob');
    });

    test('resolves matched visitor via visitorId FK', () async {
      await seedVisitor(db, id: 40, name: 'Visiting Carol');
      await setupTestLocator(db: db);

      when(() => fingerprintAuth.authenticate(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => bioDataEntry(visitorId: 40));

      final result = await posAuth.authenticateWithFingerprint();

      expect(result.isAuthenticated, isTrue);
      expect(result.entityId, 40);
      expect(result.entityType, EmployeeType.visitor);
      expect(result.displayName, 'Visiting Carol');
    });

    test('returns entityNotFound when bio match has no FK set', () async {
      await setupTestLocator(db: db);

      when(() => fingerprintAuth.authenticate(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => bioDataEntry());

      final result = await posAuth.authenticateWithFingerprint();

      expect(result.isAuthenticated, isFalse);
      expect(result.failureReason, AuthFailureReason.entityNotFound);
    });

    test('returns entityNotFound when staff FK points to a deleted staff row', () async {
      await setupTestLocator(db: db);

      when(() => fingerprintAuth.authenticate(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => bioDataEntry(staffId: 999));

      final result = await posAuth.authenticateWithFingerprint();

      expect(result.isAuthenticated, isFalse);
      expect(result.failureReason, AuthFailureReason.entityNotFound);
    });
  });

  group('authenticateWithNfc', () {
    test('returns notEnrolled when no card is read', () async {
      when(() => nfcAuth.readCard(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => null);

      final result = await posAuth.authenticateWithNfc();

      expect(result.isAuthenticated, isFalse);
      expect(result.failureReason, AuthFailureReason.notEnrolled);
    });

    test('returns notEnrolled when card has no assignedToId/assignedToType', () async {
      await setupTestLocator(db: db);
      await seedNfcCard(db, id: 1, tagId: 'TAG1');
      final card = await db.getCardByTagId('TAG1');

      when(() => nfcAuth.readCard(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => card);

      final result = await posAuth.authenticateWithNfc();

      expect(result.isAuthenticated, isFalse);
      expect(result.failureReason, AuthFailureReason.notEnrolled);
    });

    test('resolves a dependent when assignedToType is dependent', () async {
      await seedDependent(db, id: 50, fullname: 'Card Dependent');
      await setupTestLocator(db: db);
      await seedNfcCard(
        db,
        id: 2,
        tagId: 'TAG2',
        assignedToId: 50,
        assignedToType: 'dependent',
      );
      final card = await db.getCardByTagId('TAG2');

      when(() => nfcAuth.readCard(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => card);

      final result = await posAuth.authenticateWithNfc();

      expect(result.isAuthenticated, isTrue);
      expect(result.entityId, 50);
      expect(result.entityType, EmployeeType.dependent);
      expect(result.displayName, 'Card Dependent');
    });

    test('resolves staff when assignedToType is a staff-type alias', () async {
      await seedStaff(db, id: 60, firstName: 'Grace', lastName: 'Hopper');
      await setupTestLocator(db: db);
      await seedNfcCard(
        db,
        id: 3,
        tagId: 'TAG3',
        assignedToId: 60,
        assignedToType: 'Staff',
      );
      final card = await db.getCardByTagId('TAG3');

      when(() => nfcAuth.readCard(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => card);

      final result = await posAuth.authenticateWithNfc();

      expect(result.isAuthenticated, isTrue);
      expect(result.entityId, 60);
      expect(result.entityType, EmployeeType.permanent);
      expect(result.displayName, 'Grace Hopper');
    });

    test('returns entityNotFound when assignedToType is a known type but the entity row is missing', () async {
      await setupTestLocator(db: db);
      await seedNfcCard(
        db,
        id: 4,
        tagId: 'TAG4',
        assignedToId: 999,
        assignedToType: 'visitor',
      );
      final card = await db.getCardByTagId('TAG4');

      when(() => nfcAuth.readCard(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => card);

      final result = await posAuth.authenticateWithNfc();

      expect(result.isAuthenticated, isFalse);
      expect(result.failureReason, AuthFailureReason.entityNotFound);
    });

    test(
      'refuses auth when assignedToType cannot be parsed (no cross-table probe)',
      () async {
        // Staff id=70 exists; card claims id=70 with an unknown type.
        // Old behavior probed staff first and would mis-auth as that staff.
        await seedStaff(db, id: 70, firstName: 'Wrong', lastName: 'Person');
        await seedVisitor(db, id: 70, name: 'Real Visitor');
        await setupTestLocator(db: db);
        await seedNfcCard(
          db,
          id: 5,
          tagId: 'TAG5',
          assignedToId: 70,
          assignedToType: 'some_unknown_type',
        );
        final card = await db.getCardByTagId('TAG5');

        when(() => nfcAuth.readCard(departmentId: any(named: 'departmentId')))
            .thenAnswer((_) async => card);

        final result = await posAuth.authenticateWithNfc();

        expect(result.isAuthenticated, isFalse);
        expect(result.failureReason, AuthFailureReason.entityNotFound);
      },
    );
  });

  group('cancelAuth', () {
    test('cancels both fingerprint capture and NFC read', () async {
      when(() => fingerprintAuth.cancel()).thenAnswer((_) async {});
      when(() => nfcAuth.cancel()).thenReturn(null);

      await posAuth.cancelAuth();

      verify(() => fingerprintAuth.cancel()).called(1);
      verify(() => nfcAuth.cancel()).called(1);
    });
  });
}

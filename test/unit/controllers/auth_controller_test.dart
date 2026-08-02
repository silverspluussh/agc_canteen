import 'dart:async';

import 'package:agc_canteen/controllers/auth_controller.dart';
import 'package:agc_canteen/controllers/providers.dart';
import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/services/auth/pos_auth_service.dart';
import 'package:agc_canteen/models/sync.model.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_database.dart';
import '../../helpers/test_service_locator.dart';

void main() {
  late AppDatabase db;
  late MockPosAuthService posAuth;
  late MockPrintServiceManager printer;
  late MockLocalToRemoteSyncService sync;
  late ProviderContainer container;

  AuthController controller() => container.read(authProvider.notifier);
  AuthState state() => container.read(authProvider);

  setUpAll(() {
    registerCommonFallbackValues();
    registerFallbackValue(
      const SyncResult(pushed: {}, pulled: {}, errors: []),
    );
  });

  setUp(() async {
    db = createTestDatabase();
    posAuth = MockPosAuthService();
    printer = MockPrintServiceManager();
    sync = MockLocalToRemoteSyncService();

    await setupTestLocator(db: db, printer: printer, syncService: sync);

    when(() => sync.syncSingleOrders())
        .thenAnswer((_) async => const SyncResult(pushed: {}, pulled: {}, errors: []));
    when(() => printer.printRawBytes(any())).thenAnswer((_) async => true);
    when(() => printer.cutPaper()).thenAnswer((_) async => true);

    container = ProviderContainer(
      overrides: [posAuthProvider.overrideWithValue(posAuth)],
    );
  });

  tearDown(() async {
    container.dispose();
    await resetTestLocator();
    await db.close();
  });

  AuthResult authenticatedStaff({
    int entityId = 1,
    String displayName = 'Ada Lovelace',
    EmployeeType entityType = EmployeeType.permanent,
  }) {
    return AuthResult.authenticated(
      entityId: entityId,
      entityType: entityType,
      displayName: displayName,
      staffId: entityId,
    );
  }

  group('authenticate (fingerprint + place order)', () {
    test('places a voucher order and completes on successful match', () async {
      await seedPosDevice(db, kitchenId: 1);
      await seedMealType(db, id: 1, name: 'lunch', price: 12.5);
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff());

      await controller().authenticate();

      expect(state().step, AuthStep.completed);
      expect(state().orderCode, isNotNull);
      expect(state().mealType, 'lunch');
      verify(() => printer.printRawBytes(any())).called(1);
      verify(() => printer.cutPaper()).called(1);

      final orders = await db.getAllOrders();
      expect(orders, hasLength(1));
      expect(orders.first.mealType, 'lunch');
      expect(orders.first.orderedById, 1);
    });

    test('sets an error state when fingerprint is not enrolled', () async {
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => const AuthResult.failed(
                failureReason: AuthFailureReason.notEnrolled,
              ));

      await controller().authenticate();

      expect(state().step, AuthStep.error);
      expect(state().error, contains('enroll'));
      verifyNever(() => printer.printRawBytes(any()));
    });

    test('sets an error state when the matched entity is not found locally', () async {
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => const AuthResult.failed(
                failureReason: AuthFailureReason.entityNotFound,
              ));

      await controller().authenticate();

      expect(state().step, AuthStep.error);
      expect(state().error, contains('sync staff data'));
    });

    test('surfaces an error if authentication throws', () async {
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenThrow(Exception('device disconnected'));

      await controller().authenticate();

      expect(state().step, AuthStep.error);
      expect(state().error, contains('device disconnected'));
    });

    test('errors when no meal type is active for the current time', () async {
      await seedPosDevice(db, kitchenId: 1);
      // No meal types seeded at all -> none active.
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff());

      await controller().authenticate();

      expect(state().step, AuthStep.error);
      expect(state().error, contains('No meals available'));
    });

    test('errors when no POS device is registered', () async {
      await seedMealType(db, id: 1, name: 'lunch');
      // No POS device seeded.
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff());

      await controller().authenticate();

      expect(state().step, AuthStep.error);
      expect(state().error, contains('POS device is not registered'));
    });

    test('blocks the order when the meal is not allowed for the staff shift', () async {
      final shiftId = await seedShift(db, id: 1, mealTypeIds: [2]);
      await seedStaff(db, id: 5, shiftId: shiftId);
      await seedPosDevice(db, kitchenId: 1);
      await seedMealType(db, id: 1, name: 'lunch'); // not in allowed list [2]

      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff(entityId: 5));

      await controller().authenticate();

      expect(state().step, AuthStep.error);
      expect(state().error, contains('not allowed'));
      verifyNever(() => printer.printRawBytes(any()));
    });

    test('allows the order when the meal is in the staff shift allow-list', () async {
      final shiftId = await seedShift(db, id: 1, mealTypeIds: [1]);
      await seedStaff(db, id: 5, shiftId: shiftId);
      await seedPosDevice(db, kitchenId: 1);
      await seedMealType(db, id: 1, name: 'lunch');

      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff(entityId: 5));

      await controller().authenticate();

      expect(state().step, AuthStep.completed);
    });
  });

  group('authenticateWithNfc (place order)', () {
    test('places a voucher order and completes on successful match', () async {
      await seedPosDevice(db, kitchenId: 1);
      await seedMealType(db, id: 1, name: 'breakfast', price: 5);
      when(() => posAuth.authenticateWithNfc(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff());

      await controller().authenticateWithNfc();

      expect(state().step, AuthStep.completed);
      expect(state().mealType, 'breakfast');
    });

    test('sets an error state when the card is not recognized', () async {
      when(() => posAuth.authenticateWithNfc(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => const AuthResult.failed(
                failureReason: AuthFailureReason.notEnrolled,
              ));

      await controller().authenticateWithNfc();

      expect(state().step, AuthStep.error);
      expect(state().error, contains('register your NFC card'));
    });
  });

  group('authenticateOnly / authenticateWithNfcOnly', () {
    test('authenticateOnly stops at authenticated without placing an order', () async {
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff());

      await controller().authenticateOnly();

      expect(state().step, AuthStep.authenticated);
      expect(state().staff?.displayName, 'Ada Lovelace');
      verifyNever(() => printer.printRawBytes(any()));
      expect(await db.getAllOrders(), isEmpty);
    });

    test('authenticateWithNfcOnly stops at authenticated without placing an order', () async {
      when(() => posAuth.authenticateWithNfc(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff());

      await controller().authenticateWithNfcOnly();

      expect(state().step, AuthStep.authenticated);
      verifyNever(() => printer.printRawBytes(any()));
    });

    test('authenticateOnly surfaces failure reasons without the voucher wording', () async {
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => const AuthResult.failed(
                failureReason: AuthFailureReason.notEnrolled,
              ));

      await controller().authenticateOnly();

      expect(state().step, AuthStep.error);
      expect(state().error, 'Fingerprint not recognized.');
    });
  });

  group('cancel', () {
    test('cancels pos auth and resets to unauthenticated', () async {
      when(() => posAuth.cancelAuth()).thenAnswer((_) async {});
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff());
      await controller().authenticateOnly();
      expect(state().step, AuthStep.authenticated);

      await controller().cancel();

      expect(state().step, AuthStep.unauthenticated);
      verify(() => posAuth.cancelAuth()).called(1);
    });

    test('cancel while auth is in flight does not place an order', () async {
      await seedPosDevice(db, kitchenId: 1);
      await seedMealType(db, id: 1, name: 'lunch', price: 12.5);
      when(() => posAuth.cancelAuth()).thenAnswer((_) async {});

      final releaseAuth = Completer<AuthResult>();
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) => releaseAuth.future);

      final authFuture = controller().authenticate();
      await controller().cancel();
      releaseAuth.complete(authenticatedStaff());
      await authFuture;

      expect(state().step, AuthStep.unauthenticated);
      expect(await db.getAllOrders(), isEmpty);
      verifyNever(() => printer.printRawBytes(any()));
    });

    test('cancel after match during order placement does not write an order', () async {
      await seedPosDevice(db, kitchenId: 1);
      await seedMealType(db, id: 1, name: 'lunch', price: 12.5);
      when(() => posAuth.cancelAuth()).thenAnswer((_) async {});
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async {
        // Race cancel after auth returns but while voucher placement awaits DB/meal lookup.
        unawaited(Future<void>.microtask(() => controller().cancel()));
        return authenticatedStaff();
      });

      await controller().authenticate();

      expect(state().step, AuthStep.unauthenticated);
      expect(await db.getAllOrders(), isEmpty);
      verifyNever(() => printer.printRawBytes(any()));
    });
  });

  group('reset', () {
    test('clears state back to unauthenticated', () async {
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff());
      await controller().authenticateOnly();
      expect(state().staff, isNotNull);

      // ActivityLogService ids are `DateTime.now().millisecondsSinceEpoch`;
      // wait a tick so the sign-out log's id doesn't collide with the
      // auth-success log written a moment ago in the same test.
      await Future<void>.delayed(const Duration(milliseconds: 2));
      controller().reset();

      expect(state().step, AuthStep.unauthenticated);
      expect(state().staff, isNull);
    });

    test('is a no-op safe to call with no active staff session', () {
      controller().reset();
      expect(state().step, AuthStep.unauthenticated);
    });
  });

  group('clearError', () {
    test('resets the step back to unauthenticated', () async {
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => const AuthResult.failed(
                failureReason: AuthFailureReason.notEnrolled,
              ));
      await controller().authenticate();
      expect(state().step, AuthStep.error);

      controller().clearError();

      expect(state().step, AuthStep.unauthenticated);
      expect(state().error, isNull);
    });
  });

  group('error clearing across attempts', () {
    test('a new authenticate() call clears a stale error from a prior attempt', () async {
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => const AuthResult.failed(
                failureReason: AuthFailureReason.notEnrolled,
              ));
      await controller().authenticate();
      expect(state().error, isNotNull);

      await seedPosDevice(db, kitchenId: 1);
      await seedMealType(db, id: 1, name: 'lunch');
      when(() => posAuth.authenticateWithFingerprint(departmentId: any(named: 'departmentId')))
          .thenAnswer((_) async => authenticatedStaff());

      await controller().authenticate();

      expect(state().step, AuthStep.completed);
      expect(state().error, isNull);
    });
  });

  group('setOrderDetails', () {
    test('directly sets completed order fields', () {
      controller().setOrderDetails(
        orderCode: 'ASG1-1-0001',
        mealType: 'lunch',
        orderTime: '12:00 2026-01-01',
      );

      expect(state().step, AuthStep.completed);
      expect(state().orderCode, 'ASG1-1-0001');
      expect(state().mealType, 'lunch');
      expect(state().orderTime, '12:00 2026-01-01');
    });
  });
}

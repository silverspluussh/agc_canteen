import 'package:agc_canteen/models/work_function.model.dart';
import 'package:agc_canteen/repositories/function_order.repo.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';

/// The work-function revamp: the POS owns the voucher identity (unique
/// uuid-derived code), guests are anonymous with a soft allowance, and
/// one-per-person is enforced locally via the synced issued-person set.
void main() {
  late AppDatabase db;
  late MockNetworkAPI network;
  late FunctionOrderRepository repo;

  setUp(() {
    db = createTestDatabase();
    network = MockNetworkAPI();
    repo = FunctionOrderRepository(db: db, networkAPI: network);
  });

  tearDown(() async {
    await db.close();
  });

  WorkFunctionModel fn({int allowance = 2, int issued = 0}) => WorkFunctionModel(
    id: 1,
    functionName: 'Annual Gala',
    functionDate: '2026-10-07',
    functionStartTime: '12:00:00',
    functionEndTime: '15:00:00',
    status: 'scheduled',
    guestAllowance: allowance,
    guestIssued: issued,
    state: 'open',
  );

  test('fromMap parses the revamp fields', () {
    final m = WorkFunctionModel.fromMap({
      'id': 1,
      'functionName': 'Annual Gala',
      'functionDate': '2026-10-07',
      'functionStartTime': '12:00:00',
      'functionEndTime': '15:00:00',
      'status': 'scheduled',
      'guestAllowance': 5,
      'guestIssued': 2,
      'state': 'open',
    });

    expect(m.guestAllowance, 5);
    expect(m.guestIssued, 2);
    expect(m.state, 'open');
  });

  test('a guest voucher stores a unique uuid-derived code and its flags', () async {
    final id = await repo.createFunctionOrder(
      function: fn(),
      orderedById: 0,
      employeeType: 'guest',
      mealType: 'function',
      isGuest: true,
      guestName: 'Walk-in guest',
    );

    final row = await db.getFunctionOrder(id);
    expect(row, isNotNull);
    expect(row!.isGuest, isTrue);
    expect(row.guestName, 'Walk-in guest');
    expect(row.orderCode.startsWith('FN-'), isTrue);
    expect(row.orderCode.length, greaterThan(6));
  });

  test('two vouchers get distinct codes', () async {
    final a = await repo.createFunctionOrder(
      function: fn(),
      orderedById: 0,
      employeeType: 'guest',
      mealType: 'function',
      isGuest: true,
    );
    final b = await repo.createFunctionOrder(
      function: fn(),
      orderedById: 0,
      employeeType: 'guest',
      mealType: 'function',
      isGuest: true,
    );

    final codeA = (await db.getFunctionOrder(a))!.orderCode;
    final codeB = (await db.getFunctionOrder(b))!.orderCode;
    expect(codeA, isNot(codeB));
  });

  test('one-per-person holds once a person is recorded as issued', () async {
    expect(
      await repo.hasIssuedVoucher(
        functionId: 1,
        employeeType: 'permanent',
        personId: 42,
      ),
      isFalse,
    );

    await repo.recordIssuedPerson(
      functionId: 1,
      employeeType: 'permanent',
      personId: 42,
    );

    expect(
      await repo.hasIssuedVoucher(
        functionId: 1,
        employeeType: 'permanent',
        personId: 42,
      ),
      isTrue,
    );
  });

  test('guestRemaining subtracts synced and locally pending guests', () async {
    expect(await repo.guestRemaining(fn(allowance: 3, issued: 1)), 2);

    await repo.createFunctionOrder(
      function: fn(allowance: 3, issued: 1),
      orderedById: 0,
      employeeType: 'guest',
      mealType: 'function',
      isGuest: true,
    );

    // The freshly-created local guest is pending until synced, so it reduces
    // the remaining count immediately.
    expect(await repo.guestRemaining(fn(allowance: 3, issued: 1)), 1);
  });
}

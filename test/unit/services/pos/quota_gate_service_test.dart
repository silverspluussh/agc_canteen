import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/pos/quota_gate_service.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_database.dart';

String _nowIso() => DateTime.now().toIso8601String();
String _today() => DateTime.now().toIso8601String().substring(0, 10);

Future<void> _seedShift(
  AppDatabase db, {
  int id = 1,
  int dailyMealQuota = 2,
  int workingDaysPerMonth = 21,
}) =>
    db.insertShift(
      ShiftsCompanion.insert(
        id: Value(id),
        name: 'Day',
        hours: 8,
        dailyMealQuota: Value(dailyMealQuota),
        workingDaysPerMonth: Value(workingDaysPerMonth),
        syncStatus: const Value(2),
        syncUpdatedAt: Value(_nowIso()),
      ),
    );

Future<void> _refreshSync(AppDatabase db, String table, int id) async {
  // Touch syncUpdatedAt via companion updates per table.
  final now = _nowIso();
  switch (table) {
    case 'staff':
      await db.updateStaff(
        id,
        StaffCompanion(syncStatus: const Value(2), syncUpdatedAt: Value(now)),
      );
    case 'contractor':
      await db.updateContractorStaff(
        id,
        ContractorStaffTableCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(now),
        ),
      );
    case 'visitor':
      await db.updateVisitor(
        id,
        VisitorsCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(now),
        ),
      );
    case 'dependent':
      await db.updateDependent(
        id,
        DependentsCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(now),
        ),
      );
    case 'shift':
      await db.updateShift(
        id,
        ShiftsCompanion(
          syncStatus: const Value(2),
          syncUpdatedAt: Value(now),
        ),
      );
  }
}

Future<void> _seedOrder(
  AppDatabase db, {
  required int id,
  required int personId,
  required String employeeType,
}) =>
    db.insertOrder(
      OrdersCompanion.insert(
        id: Value(id),
        uuid: 'uuid-$id',
        orderCode: 'ORD-$id',
        status: 'completed',
        orderType: 'single',
        mealType: 'lunch',
        total: 5.0,
        groupCount: 1,
        orderedById: personId,
        employeeType: employeeType,
        createdAt: _nowIso(),
        updatedAt: _nowIso(),
      ),
    );

/// A function order lives in its own table and must never consume the general
/// meal pool, so these are seeded separately from [_seedOrder].
Future<void> _seedFunctionOrder(
  AppDatabase db, {
  required int id,
  required int personId,
  required String employeeType,
  int functionId = 7,
}) =>
    db.insertFunctionOrder(
      FunctionOrdersCompanion.insert(
        id: Value(id),
        uuid: 'fnuuid-$id',
        orderCode: 'FNF$functionId-1-0001',
        functionId: functionId,
        functionName: 'Annual Gala',
        status: 'completed',
        mealType: 'lunch',
        quantity: const Value(1),
        rate: const Value(25.0),
        total: const Value(25.0),
        orderedById: personId,
        employeeType: employeeType,
        createdAt: _nowIso(),
        updatedAt: _nowIso(),
      ),
    );

void main() {
  late AppDatabase db;
  late QuotaGateService gate;

  setUp(() {
    db = createTestDatabase();
    gate = QuotaGateService(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('staff with shift', () {
    test('allows within daily quota, blocks when exhausted', () async {
      await _seedShift(db, dailyMealQuota: 2, workingDaysPerMonth: 21);
      await seedStaff(db, id: 1, shiftId: 1);
      await _refreshSync(db, 'staff', 1);

      var decision = await gate.checkCanOrder(
        type: EmployeeType.permanent,
        personId: 1,
      );
      expect(decision.allowed, isTrue);
      expect(decision.dailyQuota, 2);
      expect(decision.periodTotal, 42);

      await _seedOrder(db, id: 11, personId: 1, employeeType: 'permanent');
      await _seedOrder(db, id: 12, personId: 1, employeeType: 'permanent');

      decision = await gate.checkCanOrder(
        type: EmployeeType.permanent,
        personId: 1,
      );
      expect(decision.allowed, isFalse);
      expect(decision.reason, contains('Daily'));
    });

    test('allows when staff has no shift and no manual quota (legacy)', () async {
      await seedStaff(db, id: 2);
      await _refreshSync(db, 'staff', 2);

      final decision = await gate.checkCanOrder(
        type: EmployeeType.permanent,
        personId: 2,
      );
      expect(decision.allowed, isTrue);
      expect(decision.stale, isTrue);
    });

    test('no-shift staff is enforced against their manual daily quota', () async {
      await seedStaff(
        db,
        id: 20,
        manualDailyQuota: 1,
        manualMonthlyQuota: 21,
        quotaPeriodStart: _today(),
        quotaPeriodEnd: _today(),
      );
      await _refreshSync(db, 'staff', 20);
      await _seedOrder(
        db,
        id: 900,
        personId: 20,
        employeeType: 'permanent',
      );

      final decision = await gate.checkCanOrder(
        type: EmployeeType.permanent,
        personId: 20,
      );

      expect(decision.stale, isFalse);
      expect(decision.allowed, isFalse);
      expect(decision.dailyQuota, 1);
      expect(decision.dailyUsed, 1);
    });

    test('no-shift staff within manual quota is allowed', () async {
      await seedStaff(
        db,
        id: 21,
        manualDailyQuota: 2,
        manualMonthlyQuota: 21,
        quotaPeriodStart: _today(),
        quotaPeriodEnd: _today(),
      );
      await _refreshSync(db, 'staff', 21);

      final decision = await gate.checkCanOrder(
        type: EmployeeType.permanent,
        personId: 21,
      );

      expect(decision.stale, isFalse);
      expect(decision.allowed, isTrue);
      expect(decision.dailyQuota, 2);
      expect(decision.periodTotal, 21);
    });

    test('no-shift staff is blocked once the manual period is exhausted', () async {
      final monthStart = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      ).toIso8601String().substring(0, 10);
      final monthEnd = DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
        0,
      ).toIso8601String().substring(0, 10);

      await seedStaff(
        db,
        id: 22,
        manualDailyQuota: 5,
        manualMonthlyQuota: 1,
        quotaPeriodStart: monthStart,
        quotaPeriodEnd: monthEnd,
      );
      await _refreshSync(db, 'staff', 22);
      await _seedOrder(
        db,
        id: 901,
        personId: 22,
        employeeType: 'permanent',
      );

      final decision = await gate.checkCanOrder(
        type: EmployeeType.permanent,
        personId: 22,
      );

      expect(decision.stale, isFalse);
      expect(decision.allowed, isFalse);
      expect(decision.periodTotal, 1);
    });

    test('function mode still enforces the staff daily quota', () async {
      await _seedShift(db, dailyMealQuota: 2, workingDaysPerMonth: 21);
      await seedStaff(db, id: 30, shiftId: 1);
      await _refreshSync(db, 'staff', 30);
      await _seedOrder(db, id: 800, personId: 30, employeeType: 'permanent');
      await _seedOrder(db, id: 801, personId: 30, employeeType: 'permanent');

      final decision = await gate.checkCanOrder(
        type: EmployeeType.permanent,
        personId: 30,
        inFunctionMode: true,
      );

      expect(decision.stale, isFalse);
      expect(decision.allowed, isFalse);
      expect(decision.dailyUsed, 2);
    });

    test('function orders do NOT consume the staff quota pool', () async {
      await _seedShift(db, dailyMealQuota: 2, workingDaysPerMonth: 21);
      await seedStaff(db, id: 31, shiftId: 1);
      await _refreshSync(db, 'staff', 31);

      // Two function orders, plus one general order.
      await _seedFunctionOrder(
        db,
        id: 810,
        personId: 31,
        employeeType: 'permanent',
      );
      await _seedFunctionOrder(
        db,
        id: 811,
        personId: 31,
        employeeType: 'permanent',
      );
      await _seedOrder(db, id: 812, personId: 31, employeeType: 'permanent');

      final decision = await gate.checkCanOrder(
        type: EmployeeType.permanent,
        personId: 31,
        inFunctionMode: true,
      );

      // Only the single general order counts against the pool.
      expect(decision.dailyUsed, 1);
      expect(decision.allowed, isTrue);
    });

    test('general mode is unaffected by function orders', () async {
      await _seedShift(db, dailyMealQuota: 2, workingDaysPerMonth: 21);
      await seedStaff(db, id: 32, shiftId: 1);
      await _refreshSync(db, 'staff', 32);
      await _seedFunctionOrder(
        db,
        id: 820,
        personId: 32,
        employeeType: 'permanent',
      );

      final decision = await gate.checkCanOrder(
        type: EmployeeType.permanent,
        personId: 32,
      );

      expect(decision.dailyUsed, 0);
      expect(decision.allowed, isTrue);
    });

    test('allows when data is stale', () async {
      await _seedShift(db, dailyMealQuota: 2, workingDaysPerMonth: 21);
      await seedStaff(db, id: 3, shiftId: 1);
      // syncStatus stays 0 -> stale
      final decision = await gate.checkCanOrder(
        type: EmployeeType.permanent,
        personId: 3,
      );
      expect(decision.allowed, isTrue);
      expect(decision.stale, isTrue);
    });
  });

  group('contractor', () {
    test('blocks after daily quota exhausted within stay', () async {
      await db.insertContractorStaff(
        ContractorStaffTableCompanion.insert(
          id: const Value(10),
          name: 'Worker',
          startDate: '2000-01-01',
          endDate: '2100-01-01',
          dailyQuota: const Value(1),
          syncStatus: const Value(2),
          syncUpdatedAt: Value(_nowIso()),
        ),
      );

      var decision = await gate.checkCanOrder(
        type: EmployeeType.contractor,
        personId: 10,
      );
      expect(decision.allowed, isTrue);

      await _seedOrder(db, id: 21, personId: 10, employeeType: 'contractor');
      decision = await gate.checkCanOrder(
        type: EmployeeType.contractor,
        personId: 10,
      );
      expect(decision.allowed, isFalse);
    });

    test('blocks outside the stay window', () async {
      await db.insertContractorStaff(
        ContractorStaffTableCompanion.insert(
          id: const Value(11),
          name: 'Past Worker',
          startDate: '2000-01-01',
          endDate: '2000-02-01',
          dailyQuota: const Value(3),
          syncStatus: const Value(2),
          syncUpdatedAt: Value(_nowIso()),
        ),
      );

      final decision = await gate.checkCanOrder(
        type: EmployeeType.contractor,
        personId: 11,
      );
      expect(decision.allowed, isFalse);
      expect(decision.reason, contains('ended'));
    });
  });

  group('visitor', () {
    test('allows within stay quota', () async {
      await db.insertVisitor(
        VisitorsCompanion.insert(
          id: const Value(20),
          name: 'Guest',
          dailyQuota: const Value(3),
          syncStatus: const Value(2),
          syncUpdatedAt: Value(_nowIso()),
        ),
      );

      final decision = await gate.checkCanOrder(
        type: EmployeeType.visitor,
        personId: 20,
      );
      expect(decision.allowed, isTrue);
      expect(decision.dailyQuota, 3);
    });
  });

  group('dependent', () {
    test('allows legacy dependent without visits', () async {
      await seedStaff(db, id: 1);
      await _refreshSync(db, 'staff', 1);
      await seedDependent(db, id: 30, staffId: 1);
      await _refreshSync(db, 'dependent', 30);

      final decision = await gate.checkCanOrder(
        type: EmployeeType.dependent,
        personId: 30,
      );
      expect(decision.allowed, isTrue);
      expect(decision.stale, isTrue);
    });

    test('blocks when visits exist but none active', () async {
      await _seedShift(db, dailyMealQuota: 2, workingDaysPerMonth: 21);
      await seedStaff(db, id: 31, shiftId: 1);
      await _refreshSync(db, 'staff', 31);
      await seedDependent(db, id: 32, staffId: 31);
      await _refreshSync(db, 'dependent', 32);
      await db.insertDependentVisit(
        DependentVisitsCompanion.insert(
          id: const Value(100),
          dependentId: 32,
          startDate: '2000-01-01',
          endDate: '2000-01-10',
          status: const Value('ended'),
          syncStatus: const Value(2),
          syncUpdatedAt: Value(_nowIso()),
        ),
      );

      final decision = await gate.checkCanOrder(
        type: EmployeeType.dependent,
        personId: 32,
      );
      expect(decision.allowed, isFalse);
      expect(decision.reason, contains('No active visit'));
    });

    test('enforces inherited daily within active visit', () async {
      await _seedShift(db, id: 7, dailyMealQuota: 1, workingDaysPerMonth: 21);
      await _refreshSync(db, 'shift', 7);
      await seedStaff(db, id: 33, shiftId: 7);
      await _refreshSync(db, 'staff', 33);
      await seedDependent(db, id: 34, staffId: 33);
      await _refreshSync(db, 'dependent', 34);
      final today = _today();
      await db.insertDependentVisit(
        DependentVisitsCompanion.insert(
          id: const Value(101),
          dependentId: 34,
          startDate: today,
          endDate: today,
          status: const Value('active'),
          syncStatus: const Value(2),
          syncUpdatedAt: Value(_nowIso()),
        ),
      );

      var decision = await gate.checkCanOrder(
        type: EmployeeType.dependent,
        personId: 34,
      );
      expect(decision.allowed, isTrue);
      expect(decision.dailyQuota, 1);
      expect(decision.periodTotal, 1);

      await _seedOrder(db, id: 41, personId: 34, employeeType: 'dependent');
      decision = await gate.checkCanOrder(
        type: EmployeeType.dependent,
        personId: 34,
      );
      expect(decision.allowed, isFalse);
    });
  });
}

import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/database/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Creates a fresh in-memory [AppDatabase] for tests.
///
/// Each call returns an isolated database instance; callers are
/// responsible for closing it in `tearDown` (`await db.close()`).
AppDatabase createTestDatabase() => AppDatabase(NativeDatabase.memory());

/// Seeds a minimal staff record and returns its id.
Future<int> seedStaff(
  AppDatabase db, {
  int id = 1,
  String empId = 'EMP001',
  String firstName = 'Jane',
  String lastName = 'Doe',
  String employeeType = 'permanent',
  String? empStatus,
  int? shiftId,
  int? departmentId,
}) async {
  await db.insertStaff(
    StaffCompanion.insert(
      id: Value(id),
      empId: empId,
      firstName: firstName,
      lastName: lastName,
      employeeType: employeeType,
      empStatus: Value.absentIfNull(empStatus),
      shiftId: Value.absentIfNull(shiftId),
      departmentId: Value.absentIfNull(departmentId),
    ),
  );
  return id;
}

Future<int> seedDependent(
  AppDatabase db, {
  int id = 1,
  String fullname = 'Baby Doe',
  String status = 'active',
  int? staffId,
}) async {
  await db.insertDependent(
    DependentsCompanion.insert(
      id: Value(id),
      fullname: fullname,
      status: status,
      staffId: Value.absentIfNull(staffId),
    ),
  );
  return id;
}

Future<int> seedContractorStaff(
  AppDatabase db, {
  int id = 1,
  String name = 'Contract Worker',
  String startDate = '2024-01-01',
  String endDate = '2099-12-31',
}) async {
  await db.insertContractorStaff(
    ContractorStaffTableCompanion.insert(
      id: Value(id),
      name: name,
      startDate: startDate,
      endDate: endDate,
    ),
  );
  return id;
}

Future<int> seedVisitor(
  AppDatabase db, {
  int id = 1,
  String name = 'Visitor Person',
  String? startDate,
  String? endTime,
}) async {
  await db.insertVisitor(
    VisitorsCompanion.insert(
      id: Value(id),
      name: name,
      startDate: Value.absentIfNull(startDate),
      endTime: Value.absentIfNull(endTime),
    ),
  );
  return id;
}

Future<int> seedNfcCard(
  AppDatabase db, {
  int id = 1,
  required String tagId,
  int? assignedToId,
  String? assignedToType,
  int? departmentId,
  String? personnelName,
}) async {
  await db.insertCard(
    CardsCompanion.insert(
      id: Value(id),
      code: 0,
      status: 'active',
      tagId: Value(tagId),
      assignedToId: Value.absentIfNull(assignedToId),
      assignedToType: Value.absentIfNull(assignedToType),
      departmentId: Value.absentIfNull(departmentId),
      personnelName: Value.absentIfNull(personnelName),
    ),
  );
  return id;
}

Future<int> seedPosDevice(
  AppDatabase db, {
  int id = 1,
  String name = 'POS 1',
  String serialNumber = 'SN-001',
  int? kitchenId = 1,
}) async {
  await db.insertPosDevice(
    PosDevicesCompanion.insert(
      id: Value(id),
      name: name,
      serialNumber: serialNumber,
      status: 'active',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      kitchenId: Value.absentIfNull(kitchenId),
    ),
  );
  return id;
}

Future<int> seedMealType(
  AppDatabase db, {
  int id = 1,
  String name = 'breakfast',
  double price = 5.0,
  String? beginTime,
  String? endTime,
}) async {
  final now = DateTime.now();
  // Stored as plain "HH:MM" (not ISO8601) — matches the format
  // `AuthController._resolveCurrentMealType` expects when parsing.
  final begin = beginTime ?? '00:00';
  final end = endTime ?? '23:59';
  await db.insertMealType(
    MealTypesCompanion.insert(
      id: Value(id),
      name: name,
      status: 'active',
      beginTime: begin,
      endTime: end,
      createdAt: now.toIso8601String(),
      updatedAt: now.toIso8601String(),
      price: Value(price),
    ),
  );
  return id;
}

Future<int> seedShift(
  AppDatabase db, {
  int id = 1,
  String name = 'Day Shift',
  int hours = 8,
  List<int> mealTypeIds = const [],
}) async {
  await db.insertShift(
    ShiftsCompanion.insert(id: Value(id), name: name, hours: hours),
    mealTypeIds: mealTypeIds,
  );
  return id;
}

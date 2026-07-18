import 'package:drift/drift.dart';

class Sites extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get location => text().nullable()();
  IntColumn get noOfEmployees => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get startDate => text().nullable()();
  TextColumn get endDate => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Departments extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Shifts extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get hours => integer()();
  IntColumn get companyId => integer().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ShiftMealTypes extends Table {
  IntColumn get shiftId => integer()();
  IntColumn get mealTypeId => integer()();

  @override
  Set<Column> get primaryKey => {shiftId, mealTypeId};
}

class Kitchens extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get minTierRequired => integer()();
  TextColumn get status => text()();
  IntColumn get companyId => integer().nullable().references(Sites, #id)();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MenuTypes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get remarks => text().nullable()();
  TextColumn get status => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MealTypes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get status => text()();
  TextColumn get beginTime => text()();
  TextColumn get endTime => text()();
  RealColumn get price => real().withDefault(const Constant(0))();
  TextColumn get remarks => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Staff extends Table {
  IntColumn get id => integer()();
  TextColumn get empId => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  IntColumn get companyId => integer().nullable()();
  TextColumn get jobTitle => text().nullable()();
  TextColumn get empStatus => text().nullable()();
  TextColumn get employeeType => text()();
  TextColumn get startDate => text().nullable()();
  TextColumn get endDate => text().nullable()();
  BoolColumn get allowGroupOrder => boolean().nullable()();
  IntColumn get maxOrderCount => integer().nullable()();
  IntColumn get shiftId => integer().nullable()();
  IntColumn get totalDependent => integer().nullable()();
  IntColumn get noOfDependentAssigned => integer().nullable()();
  IntColumn get departmentId => integer().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class StaffKitchens extends Table {
  IntColumn get staffId => integer()();
  IntColumn get kitchenId => integer()();

  @override
  Set<Column> get primaryKey => {staffId, kitchenId};
}

class Dependents extends Table {
  IntColumn get id => integer()();
  TextColumn get fullname => text()();
  TextColumn get status => text()();
  TextColumn get gender => text().nullable()();
  IntColumn get staffId => integer().nullable().references(Staff, #id)();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Cards extends Table {
  IntColumn get id => integer()();
  TextColumn get tagId => text().nullable()();
  RealColumn get code => real()();
  RealColumn get reversedCode => real().nullable()();
  TextColumn get status => text()();
  BoolColumn get isAssigned => boolean().nullable()();
  IntColumn get assignedToId => integer().nullable()();
  TextColumn get assignedToType => text().nullable()();
  IntColumn get departmentId => integer().nullable()();
  TextColumn get departmentName => text().nullable()();
  TextColumn get personnelName => text().nullable()();
  TextColumn get issuedDate => text().nullable()();
  TextColumn get createdAt => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Users extends Table {
  IntColumn get id => integer()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get role => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get lastLoginAt => text().nullable()();
  TextColumn get actStartDate => text().nullable()();
  TextColumn get actEndDate => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserKitchens extends Table {
  IntColumn get userId => integer()();
  IntColumn get kitchenId => integer()();

  @override
  Set<Column> get primaryKey => {userId, kitchenId};
}

class Orders extends Table {
  IntColumn get id => integer()();
  TextColumn get uuid => text()();
  TextColumn get orderCode => text()();
  TextColumn get status => text()();
  TextColumn get orderType => text()();
  TextColumn get mealType => text()();
  RealColumn get total => real()();
  IntColumn get groupCount => integer()();
  TextColumn get description => text().nullable()();
  IntColumn get orderedById => integer()();
  TextColumn get employeeType => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PosDevices extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get serialNumber => text()();
  TextColumn get model => text().nullable()();
  TextColumn get status => text()();
  TextColumn get macAddress => text().nullable()();
  IntColumn get kitchenId => integer().nullable()();
  TextColumn get kitchenName => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ActivityLogs extends Table {
  IntColumn get id => integer()();
  TextColumn get type => text()();
  TextColumn get message => text()();
  TextColumn get actorType => text().nullable()();
  IntColumn get actorId => integer().nullable()();
  TextColumn get actorName => text().nullable()();
  TextColumn get sourceTable => text().nullable()();
  TextColumn get recordId => text().nullable()();
  TextColumn get metadata => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class GroupOrders extends Table {
  IntColumn get id => integer()();
  TextColumn get uuid => text()();
  TextColumn get orderCode => text()();
  TextColumn get status => text()();
  TextColumn get orderType => text()();
  TextColumn get mealType => text()();
  RealColumn get total => real()();
  IntColumn get groupCount => integer()();
  TextColumn get description => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Contractors extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get status => text()();
  IntColumn get noOfStaffs => integer().withDefault(const Constant(0))();
  IntColumn get companyId => integer().nullable()();
  IntColumn get departmentId => integer().nullable()();
  TextColumn get company => text().nullable()();
  TextColumn get department => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ContractorStaffTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get gender => text().nullable()();
  IntColumn get contractorId => integer().nullable()();
  TextColumn get contractorName => text().nullable()();
  IntColumn get companyId => integer().nullable()();
  TextColumn get company => text().nullable()();
  IntColumn get departmentId => integer().nullable()();
  TextColumn get department => text().nullable()();
  TextColumn get startDate => text()();
  TextColumn get endDate => text()();
  BoolColumn get isCharged => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Visitors extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get gender => text().nullable()();
  TextColumn get startDate => text().nullable()();
  TextColumn get endTime => text().nullable()();
  IntColumn get companyId => integer().nullable()();
  TextColumn get company => text().nullable()();
  IntColumn get departmentId => integer().nullable()();
  TextColumn get department => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class BioDataEntries extends Table {
  IntColumn get id => integer()();
  IntColumn get staffId => integer().nullable()();
  IntColumn get dependentId => integer().nullable()();
  IntColumn get contractorStaffId => integer().nullable()();
  IntColumn get visitorId => integer().nullable()();
  TextColumn get finger => text()();
  TextColumn get dataBase64 => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get departmentId => integer().nullable()();
  TextColumn get departmentName => text().nullable()();
  TextColumn get personnelName => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ContractorStaffKitchens extends Table {
  IntColumn get contractorStaffId => integer()();
  IntColumn get kitchenId => integer()();

  @override
  Set<Column> get primaryKey => {contractorStaffId, kitchenId};
}

class DependentKitchens extends Table {
  IntColumn get dependentId => integer()();
  IntColumn get kitchenId => integer()();

  @override
  Set<Column> get primaryKey => {dependentId, kitchenId};
}

class VisitorKitchens extends Table {
  IntColumn get visitorId => integer()();
  IntColumn get kitchenId => integer()();

  @override
  Set<Column> get primaryKey => {visitorId, kitchenId};
}

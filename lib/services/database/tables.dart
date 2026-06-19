import 'package:drift/drift.dart';

class Sites extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get location => text().nullable()();
  IntColumn get noOfEmployees => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get startDate => text().nullable()();
  TextColumn get endDate => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Kitchens extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get minTierRequired => integer()();
  TextColumn get status => text()();
  TextColumn get companyId => text().nullable().references(Sites, #id)();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MenuTypes extends Table {
  TextColumn get id => text()();
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

class Meals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get status => text()();
  TextColumn get mealType => text()();
  TextColumn get mealTypeId => text()();
  TextColumn get remarks => text().nullable()();
  RealColumn get price => real()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get menuTypeId => text().references(MenuTypes, #id)();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MealKitchens extends Table {
  TextColumn get mealId => text().references(Meals, #id)();
  TextColumn get kitchenId => text().references(Kitchens, #id)();

  @override
  Set<Column> get primaryKey => {mealId, kitchenId};
}

class Staff extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Users extends Table {
  TextColumn get id => text()();
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
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get kitchenId => text().references(Kitchens, #id)();

  @override
  Set<Column> get primaryKey => {userId, kitchenId};
}

class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get uuid => text()();
  TextColumn get orderCode => text()();
  TextColumn get status => text()();
  TextColumn get orderType => text()();
  TextColumn get mealType => text()();
  RealColumn get total => real()();
  IntColumn get groupCount => integer()();
  TextColumn get description => text().nullable()();
  TextColumn get orderedById => text().references(Staff, #id)();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class OrderItems extends Table {
  TextColumn get id => text()();
  RealColumn get price => real()();
  IntColumn get qty => integer()();
  TextColumn get mealId => text().references(Meals, #id)();
  TextColumn get orderId => text().references(Orders, #id)();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Overcharges extends Table {
  TextColumn get id => text()();
  TextColumn get mealType => text()();
  TextColumn get orderCode => text()();
  RealColumn get price => real()();
  TextColumn get staffId => text().references(Staff, #id)();
  TextColumn get mealId => text().references(Meals, #id)();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PosDevices extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get serialNumber => text()();
  TextColumn get model => text().nullable()();
  TextColumn get status => text()();
  TextColumn get macAddress => text().nullable()();
  TextColumn get kitchenId => text().nullable()();
  TextColumn get kitchenName => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ActivityLogs extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get message => text()();
  TextColumn get actorType => text().nullable()();
  TextColumn get actorId => text().nullable()();
  TextColumn get actorName => text().nullable()();
  TextColumn get sourceTable => text().nullable()();
  TextColumn get recordId => text().nullable()();
  TextColumn get metadata => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class GroupOrders extends Table {
  TextColumn get id => text()();
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

class GroupOrderItems extends Table {
  TextColumn get id => text()();
  RealColumn get price => real()();
  IntColumn get qty => integer()();
  TextColumn get mealId => text().references(Meals, #id)();
  TextColumn get groupOrderId => text().references(GroupOrders, #id)();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class BioDataEntries extends Table {
  /// Remote API integer ID.
  IntColumn get id => integer()();
  TextColumn get staffId => text().references(Staff, #id)();
  /// Which finger this template belongs to (e.g. 'left_thumb', 'right_index').
  TextColumn get finger => text()();
  /// Raw biometric template stored as a Base64 string.
  TextColumn get dataBase64 => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get syncUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/services/auth/pos_auth_service.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/views/auth/group_order_auth_pos.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  Future<StaffData> staffWithGroupOrder({
    int id = 5,
    bool allow = true,
  }) async {
    await seedStaff(db, id: id);
    await db.updateStaff(
      id,
      StaffCompanion(allowGroupOrder: Value(allow)),
    );
    return (await db.getStaff(id))!;
  }

  AuthResult auth({
    required int entityId,
    required EmployeeType entityType,
  }) {
    return AuthResult.authenticated(
      entityId: entityId,
      entityType: entityType,
      displayName: 'Tester',
      staffId: entityType.isStaffType ? entityId : null,
    );
  }

  test('allows staff with allowGroupOrder enabled', () async {
    final staffData = await staffWithGroupOrder(id: 5, allow: true);
    expect(
      isAllowedGroupOrderAuth(
        auth(entityId: 5, entityType: EmployeeType.permanent),
        staffData,
      ),
      isTrue,
    );
  });

  test('denies staff when allowGroupOrder is false', () async {
    final staffData = await staffWithGroupOrder(id: 5, allow: false);
    expect(
      isAllowedGroupOrderAuth(
        auth(entityId: 5, entityType: EmployeeType.permanent),
        staffData,
      ),
      isFalse,
    );
  });

  test('denies visitor even when entityId matches staff with group order', () async {
    final staffData = await staffWithGroupOrder(id: 5, allow: true);
    expect(
      isAllowedGroupOrderAuth(
        auth(entityId: 5, entityType: EmployeeType.visitor),
        staffData,
      ),
      isFalse,
    );
  });

  test('denies dependent / contractor on colliding staff ids', () async {
    final staffData = await staffWithGroupOrder(id: 9, allow: true);
    expect(
      isAllowedGroupOrderAuth(
        auth(entityId: 9, entityType: EmployeeType.dependent),
        staffData,
      ),
      isFalse,
    );
    expect(
      isAllowedGroupOrderAuth(
        auth(entityId: 9, entityType: EmployeeType.contractor),
        staffData,
      ),
      isFalse,
    );
  });
}

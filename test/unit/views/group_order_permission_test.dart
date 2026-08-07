import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/services/auth/pos_auth_service.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/views/auth/group_order_auth_pos.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  StaffData staffWithGroupOrder({
    int id = 5,
    bool allow = true,
  }) {
    return StaffData(
      id: id,
      empId: 'EMP$id',
      firstName: 'Group',
      lastName: 'Allowed',
      employeeType: 'permanent',
      allowGroupOrder: allow,
      syncStatus: 2,
    );
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

  test('allows staff with allowGroupOrder enabled', () {
    expect(
      isAllowedGroupOrderAuth(
        auth(entityId: 5, entityType: EmployeeType.permanent),
        staffWithGroupOrder(id: 5, allow: true),
      ),
      isTrue,
    );
  });

  test('denies staff when allowGroupOrder is false', () {
    expect(
      isAllowedGroupOrderAuth(
        auth(entityId: 5, entityType: EmployeeType.permanent),
        staffWithGroupOrder(id: 5, allow: false),
      ),
      isFalse,
    );
  });

  test('denies visitor even when entityId matches staff with group order', () {
    expect(
      isAllowedGroupOrderAuth(
        auth(entityId: 5, entityType: EmployeeType.visitor),
        staffWithGroupOrder(id: 5, allow: true),
      ),
      isFalse,
    );
  });

  test('denies dependent / contractor on colliding staff ids', () {
    final staffData = staffWithGroupOrder(id: 9, allow: true);
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

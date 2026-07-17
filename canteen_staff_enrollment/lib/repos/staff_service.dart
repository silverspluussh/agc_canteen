import 'dart:developer';

import 'package:canteen_staff_enrollment/core/network/network_api_dio.dart';
import 'package:canteen_staff_enrollment/models/staff.model.dart';

class StaffService extends StaffCtrller {
  final NetworkAPI networkAPI;
  StaffService({required this.networkAPI});

  @override
  Future<List<Staff>> getAllStaffs({
    String? staffId,
    String? status,
    String? company,
    String? department,
    String? kitchenId,
    String? searchTerm,
    int limit = 2500,
  }) async {
    try {
      return await networkAPI.getData<List<Staff>>(
        '/hr/staffs',
        queryParameters: {
          "limit": limit,
          if (staffId != null) "staffId": staffId,
          if (status != null) "status": status,
          if (company != null) "companyId": company,
          if (department != null) "departmentId": department,
          if (kitchenId != null) "kitchenId": kitchenId,
          if (searchTerm != null && searchTerm.isNotEmpty) "searchTerm": searchTerm,
        },
        builder: (data) {
          if (data['data'] is List) {
            return (data['data'] as List)
                .map((e) => Staff.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e, stack) {
      log("Error in getAllStaffs: $e", error: e, stackTrace: stack);
      return [];
    }
  }

  @override
  Future<List<Staff>> getStaffById(String staffId) async {
    try {
      return await networkAPI.getData<List<Staff>>(
        '/hr/staff',
        queryParameters: {"id": staffId},
        builder: (data) {
          if (data['data'] is List) {
            return (data['data'] as List)
                .map<Staff>((e) => Staff.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e) {
      return [];
    }
  }
}

abstract class StaffCtrller {
  Future<List<Staff>> getAllStaffs({
    String? staffId,
    String? status,
    String? company,
    String? department,
    String? kitchenId,
    String? searchTerm,
    int limit = 2500,
  });

  Future<List<Staff>> getStaffById(String staffId);
}

import 'dart:developer';
import 'package:canteen_staff_enrollment/core/network/network_api_dio.dart';
import 'package:canteen_staff_enrollment/models/company.model.dart';

class DepartmentService {
  final NetworkAPI networkAPI;
  DepartmentService({required this.networkAPI});

  Future<List<Department>> getAllDepartments({int limit = 200}) async {
    try {
      return await networkAPI.getData<List<Department>>(
        '/hr/departments',
        queryParameters: {"limit": limit},
        builder: (data) {
         
          if (data['data'] is List) {
            return (data['data'] as List)
                .map((e) => Department.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e, stack) {
      log('Error in getAllDepartments: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAnalytics() async {
    try {
      return await networkAPI.getData<Map<String, dynamic>>(
        '/hr/analytics/overview',
        builder: (data) => data as Map<String, dynamic>,
      );
    } catch (e, stack) {
      log('Error in getAnalytics: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

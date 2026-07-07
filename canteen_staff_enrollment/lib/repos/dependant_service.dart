import 'dart:developer';

import 'package:canteen_staff_enrollment/core/network/network_api_dio.dart';
import 'package:canteen_staff_enrollment/models/dependant.model.dart';

class DependantService {
  final NetworkAPI networkAPI;
  DependantService({required this.networkAPI});

  Future<List<Dependant>> getAllDependants(
    {String? kitchenId, String? departmentId}
  ) async {
    try {
      return await networkAPI.getData<List<Dependant>>(
        '/hr/dependants',
        queryParameters: {
      
          if (kitchenId != null) 'kitchenId': kitchenId,
          if (departmentId != null) 'departmentId': departmentId,
        },
        builder: (data) {
          log('Raw data received for dependants: $data'); // Debugging line to check the structure of the data
          final list = data is List
              ? data
              : (data['dependants'] is List ? data['dependants'] : null);
          if (list != null) {
            return (list as List)
                .map((e) => Dependant.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e, stack) {
      log('Error in getAllDependants: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<Dependant>> getDependantsByStaffId(
    int staffId) async {
    try {
      return await networkAPI.getData<List<Dependant>>(
        '/hr/dependant/$staffId/all',
        queryParameters: {
          'staffId': staffId,
        },
        builder: (data) {
          final list = data is List
              ? data
              : (data['dependants'] is List ? data['dependants'] : null);
          if (list != null) {
            return (list as List)
                .map((e) => Dependant.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e, stack) {
      log('Error in getDependantsByStaffId: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

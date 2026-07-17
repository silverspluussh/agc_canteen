import 'dart:developer';

import 'package:canteen_staff_enrollment/core/network/network_api_dio.dart';
import 'package:canteen_staff_enrollment/models/dependent.model.dart';

class DependentService {
  final NetworkAPI networkAPI;
  DependentService({required this.networkAPI});

  Future<List<Dependent>> getAllDependents({
    String? kitchenId,
    String? departmentId,
    String? searchTerm,
    int limit = 2500,
  }) async {
    try {
      return await networkAPI.getData<List<Dependent>>(
        '/hr/dependents',
        queryParameters: {
          'limit': limit,
          if (kitchenId != null) 'kitchenId': kitchenId,
          if (departmentId != null) 'departmentId': departmentId,
          if (searchTerm != null && searchTerm.isNotEmpty) 'searchTerm': searchTerm,
        },
        builder: (data) {
          log('Raw data received for dependents: $data');
          final list = data is List
              ? data
              : (data['data'] is List ? data['data'] : null);
          if (list != null) {
            return (list as List)
                .map((e) => Dependent.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e, stack) {
      log('Error in getAllDependents: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<Dependent>> getDependentsByStaffId(int staffId) async {
    try {
      return await networkAPI.getData<List<Dependent>>(
        '/hr/dependent/$staffId/all',
        queryParameters: {'staffId': staffId},
        builder: (data) {
          final list = data is List
              ? data
              : (data['data'] is List ? data['data'] : null);
          if (list != null) {
            return (list as List)
                .map((e) => Dependent.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e, stack) {
      log('Error in getDependentsByStaffId: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

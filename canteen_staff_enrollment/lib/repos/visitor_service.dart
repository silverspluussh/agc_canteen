import 'dart:developer';

import 'package:canteen_staff_enrollment/core/network/network_api_dio.dart';
import 'package:canteen_staff_enrollment/models/visitor.model.dart';

class VisitorService {
  final NetworkAPI networkAPI;
  VisitorService({required this.networkAPI});

  Future<List<Visitor>> getAllVisitors({
    String? status,
    String? departmentId,
    String? kitchenId,
    String? searchTerm,
    int limit = 2500,
  }) async {
    try {
      return await networkAPI.getData<List<Visitor>>(
        '/hr/visitors',
        queryParameters: {
          "limit": limit,
          if (departmentId != null) 'departmentId': departmentId,
          if (kitchenId != null) 'kitchenId': kitchenId,
          if (status != null) 'status': status,
          if (searchTerm != null && searchTerm.isNotEmpty) 'searchTerm': searchTerm,
        },
        builder: (data) {
          final list = data is List
              ? data
              : (data['visitors'] is List ? data['visitors'] : null);
          if (list != null) {
            return (list as List)
                .map((e) => Visitor.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e, stack) {
      log('Error in getAllVisitors: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

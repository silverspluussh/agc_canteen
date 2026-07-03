import 'dart:developer';

import 'package:canteen_staff_enrollment/core/network/network_api_dio.dart';
import 'package:canteen_staff_enrollment/models/contractor.model.dart';

class ContractorService {
  final NetworkAPI networkAPI;
  ContractorService({required this.networkAPI});

  Future<List<Contractor>> getAllContractors(
    {String? departmentId, String? kitchenId}
    
  ) async {
    try {
      return await networkAPI.getData<List<Contractor>>(
        '/hr/contractors',
        queryParameters: {
        
          if (departmentId != null) 'departmentId': departmentId,
          if (kitchenId != null) 'kitchenId': kitchenId,
        },
        builder: (data) {
          
          if (data['contractors'] is List ) {
            return (data['contractors'] as List)
                .map((e) => Contractor.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e, stack) {
      log('Error in getAllContractors: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<ContractorStaff>> getAllContractorStaff() async {
    try {
      return await networkAPI.getData<List<ContractorStaff>>(
        '/hr/contractor-staffs',
  
        builder: (data) {
          final list = data is List
              ? data
              : (data['contractorStaffs'] is List ? data['contractorStaffs'] : null);
          if (list != null) {
            return (list as List)
                .map((e) =>
                    ContractorStaff.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e, stack) {
      log('Error in getAllContractorStaff: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<ContractorStaff>> getContractorStaff(
    int contractorId,
    {
      String? departmentId,
      String? kitchenId
    }
   
  ) async {
    try {
      return await networkAPI.getData<List<ContractorStaff>>(
        '/hr/contractor-staffs',
        queryParameters: {
          'contractorId': contractorId,
          if (departmentId != null) 'departmentId': departmentId,
          if (kitchenId != null) 'kitchenId': kitchenId,
        },
        builder: (data) {
          final list = data is List
              ? data
              : (data['data']['contractorStaffs'] is List ? data['data']['contractorStaffs'] : null);
          if (list != null) {
            return (list as List)
                .map((e) =>
                    ContractorStaff.fromMap(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
    } catch (e, stack) {
      log('Error in getContractorStaff: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

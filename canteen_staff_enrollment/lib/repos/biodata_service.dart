import 'dart:developer';

import 'package:canteen_staff_enrollment/core/network/api_exceptions_util.dart';

import '../core/network/network_api_dio.dart';
import '../models/staff.model.dart';

class StaffBioDataService {
  final NetworkAPI networkAPI;
  StaffBioDataService({required this.networkAPI});

  Future<List<BioData>> getAllBioDatas() async {
    return await networkAPI.getData<List<BioData>>(
      '/hr/bio-data',
      builder: (data) {
        if (data is List) {
          return data
              .map((e) => BioData.fromMap(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  Future<List<BioData>> getBioDatasByStaffId(String staffId) async {
    return await networkAPI.getData<List<BioData>>(
      '/hr/bio-data',
      queryParameters: {"staffId": staffId},
      builder: (data) {
        if (data is List) {
          return data
              .map((e) => BioData.fromMap(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  Future<bool> createBioData(String staffId, List<BioData> bioDatas) async {
    final payload = {
      "staffId": staffId,
      "bioDatas": bioDatas.map((b) {
        return {"finger": b.finger.name, "data": b.data};
      }).toList(),
    };
    return await networkAPI.postData<bool>(
      '/hr/bio-data/create-bulk',
      data: payload,
      builder: (data) {
        if (data != null) {
          return true;
        }
        return false;
      },
    );
  }

  Future<bool> deleteBioData(int bioDataId) async {
    try {
      return await networkAPI.deleteData<bool>(
        '/hr/bio-data/delete/$bioDataId',
        builder: (data) => true,
      );
    } on APIException catch (e) {
      rethrow;
    }
  }

  Future<bool> activateBioData(int id) async {
    return await networkAPI.patchData<bool>(
      '/hr/bio-data/update/$id/status',
      data: {'id': id, 'isActive': true},
      builder: (data) {
        return true;
      },
    );
  }

  Future<bool> deactivateBioData(int id) async {
    return await networkAPI.patchData<bool>(
      '/hr/bio-data/update/$id/status',
      data: {'id': id, 'isActive': false},
      builder: (data) {
        return true;
      },
    );
  }

  Future<BioData> updateBioData(BioData bioData) async {
    final payload = {
      "id": bioData.id,
      "finger": bioData.finger,
      "data": bioData.data,
    };

    return await networkAPI.putData<BioData>(
      '/hr/bio-data/update',
      data: payload,
      queryParameters: {"id": bioData.id},
      builder: (data) {
        return BioData.fromMap(data as Map<String, dynamic>);
      },
    );
  }
}

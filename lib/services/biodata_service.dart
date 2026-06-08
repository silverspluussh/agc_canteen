import 'dart:developer';

import '../core/network/network_api_dio.dart';
import '../models/staff.model.dart';

class BioDataService {
  final NetworkAPI networkAPI;

  BioDataService({required this.networkAPI});

  Future<List<BioData>> getAllBioDatas() async {
    return await networkAPI.getData<List<BioData>>(
      'hr/bio-data',
      builder: (data) {
        if (data is List) {
          print(data.first);
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
      'hr/bio-data',
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

  Future<bool> createBioData(
    String staffId,
    List<BioData> bioDatas,
  ) async {
    final payload = {
      "staffId": int.tryParse(staffId) ?? staffId,
      "bioDatas": bioDatas
          .map((b) => {"finger": b.finger.name, "data": b.data})
          .toList(),
    };

    log(payload.toString());
    return await networkAPI.postData<bool>(
      'hr/bio-data/create-bulk',
      data: payload,
      builder: (data) {
        if(data != null){
          return true;
        }
        return false;
       
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
      'hr/bio-data/update',
      data: payload,
      queryParameters: {"id": bioData.id},
      builder: (data) {
        return BioData.fromMap(data as Map<String, dynamic>);
      },
    );
  }
}

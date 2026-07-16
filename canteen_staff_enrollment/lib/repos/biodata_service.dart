import 'package:canteen_staff_enrollment/core/network/api_exceptions_util.dart';
import 'package:canteen_staff_enrollment/models/biodata.model.dart';
import 'package:uuid/uuid.dart';
import '../core/network/network_api_dio.dart';
import '../models/employee_type.enum.dart';

class StaffBioDataService {
  final NetworkAPI networkAPI;
  StaffBioDataService({required this.networkAPI});

  List<BioData> _parseBioDataList(dynamic data) {
    final List<dynamic> rawList;
    if (data is List) {
      rawList = data;
    } else if (data is Map && data['data'] is List) {
      rawList = data['data'] as List<dynamic>;
    } else {
      return [];
    }
    return rawList
        .map((e) => BioData.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<BioData>> getAllBioDatas() async {
    return await networkAPI.getData<List<BioData>>(
      '/hr/bio-data',
     
      builder: (data) => _parseBioDataList(data),
    );
  }

  Future<List<BioData>> getBioDatasByStaffId(
    int staffId,
    EmployeeType type,
  ) async {
    return await networkAPI.getData<List<BioData>>(
      '/hr/bio-data',
      queryParameters: {"referenceId": staffId, "employeeType": type.name},
      builder: (data) => _parseBioDataList(data),
    );
  }

  Future<bool> createBioData(
    int referenceId,
    EmployeeType type,
    List<BioData> bioDatas,
  ) async {
    final payload = {
      "uuid": Uuid().v4(),
      "referenceId": referenceId,
      "employeeType": type.name,
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
    } on APIException {
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

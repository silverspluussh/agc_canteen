import 'package:uuid/uuid.dart';
import '../core/network/network_api_dio.dart';
import '../models/staff.model.dart';
import '../services/database/app_database.dart';

class BioDataService {
  final NetworkAPI networkAPI;
  final AppDatabase _db;

  BioDataService({required this.networkAPI, required AppDatabase db}) : _db = db;

  Future<List<BioData>> getAllBioDatas() async {

      final posDevices = await _db.getAllPosDevices();
      final posKitchenId =
          posDevices.isNotEmpty ? posDevices.first.kitchenId : null;

      return await networkAPI.getData(
        '/hr/bio-data',
        queryParameters: {
          if (posKitchenId != null && posKitchenId != 0)
            'kitchenId': posKitchenId,
        },
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

  Future<List<BioData>> getBioDatasByStaffId(int staffId) async {
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
    int referenceId,
    String employeeType,
    List<BioData> bioDatas,
  ) async {

    final payload = {
      'uuid': const Uuid().v4(),
      'referenceId': referenceId,
      'employeeType': employeeType,
      'bioDatas': bioDatas
          .map((b) {
            return {'finger': b.finger.name, 'data': b.data};
          })
          .toList(),
    };
    return await networkAPI.postData<bool>(
      '/hr/bio-data/create-bulk',
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
      '/hr/bio-data/update',
      data: payload,
      queryParameters: {"id": bioData.id},
      builder: (data) {
        return BioData.fromMap(data as Map<String, dynamic>);
      },
    );
  }
}

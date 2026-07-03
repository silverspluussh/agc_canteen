import 'package:agc_canteen/core/network/network_api_dio.dart';
import 'package:agc_canteen/models/contractor.model.dart' as contractor;
import 'package:agc_canteen/services/database/app_database.dart';

class ContractorsApi{

    final NetworkAPI networkAPI;
  final AppDatabase _db;

  ContractorsApi({required this.networkAPI, required AppDatabase db}) : _db = db;


  //get Contractors by kitchen id
  Future<List<contractor.Contractor>> getContractors() async {
      final posDevices = await _db.getAllPosDevices();
      final posKitchenId =
          posDevices.isNotEmpty ? posDevices.first.kitchenId : null;

      return await networkAPI.getData(
        '/hr/contractors',
        queryParameters: {
          if (posKitchenId != null && posKitchenId != 0)
            'kitchenId': posKitchenId
        },
        builder: (data) {
           if (data is List) {
          return data
              .map((e) => contractor.Contractor.fromMap(e as Map<String, dynamic>))
              .toList();
        }
        return [];
        },
      );  
  }

  //get contractor staff
   Future<List<contractor.ContractorStaff>> getContractorStaff() async {
      final posDevices = await _db.getAllPosDevices();
      final posKitchenId =
          posDevices.isNotEmpty ? posDevices.first.kitchenId : null;

      return await networkAPI.getData(
        '/hr/contractor-staff',
        queryParameters: {
          if (posKitchenId != null && posKitchenId != 0)
            'kitchenId': posKitchenId
        },
        builder: (data) {
           if (data is List) {
          return data
              .map((e) => contractor.ContractorStaff.fromMap(e as Map<String, dynamic>))
              .toList();
        }
        return [];
        },
      );  
  }


}
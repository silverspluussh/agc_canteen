import '../core/network/network_api_dio.dart';
import '../models/staff.model.dart';

class BioDataService {
  final NetworkAPI networkAPI;

  BioDataService({required this.networkAPI});

  Future<List<BioData>> createBioData(
    String staffId,
    List<BioData> bioDatas,
  ) async {
    final payload = {
      "staffId": int.tryParse(staffId) ?? staffId,
      "bioDatas": bioDatas
          .map((b) => {"finger": b.finger, "data": b.data})
          .toList(),
    };

    return await networkAPI.postData<List<BioData>>(
      'hr/bio-data/create-bulk',
      data: payload,
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

  Future<BioData> updateBioData(BioData bioData) async {
    final payload = {
      "id": bioData.id,
      "finger": bioData.finger,
      "data": bioData.data,
    };

    return await networkAPI.putData<BioData>(
      'hr/bio-data/update/${bioData.id}',
      data: payload,
      builder: (data) {
        return BioData.fromMap(data as Map<String, dynamic>);
      },
    );
  }
}

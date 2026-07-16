import 'dart:developer';
import 'package:canteen_staff_enrollment/core/network/network_api_dio.dart';
import 'package:canteen_staff_enrollment/models/nfc_card.model.dart';

class NfcCardService {
  final NetworkAPI networkAPI;

  NfcCardService({required this.networkAPI});

  Future<List<NfcCard>> getAllCards({
    String? assignedToType,
    int? referenceId,
    String? searchTerm,
    String? status,
    String? kitchenId,
    String? startDate,
    String? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      return await networkAPI.getData<List<NfcCard>>(
        '/hr/nfc-cards',
        queryParameters: {
          "limit":"100",
          "offset":"0",
        
       
        },
        builder: (data) {
          log('getAllCards data: $data');
          final List<dynamic> rawList;
          if (data is List) {
            rawList = data;
          } else if (data is Map && data['data'] is List) {
            rawList = data['data'] as List<dynamic>;
          } else {
            return [];
          }
          return rawList
              .map((e) => NfcCard.fromMap(e as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e, stack) {
      log('Error in getAllCards: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<NfcCard> getCardById(int id) async {
    try {
      return await networkAPI.getData<NfcCard>(
        '/hr/nfc-cards/$id/single',
        builder: (data) =>
            NfcCard.fromMap(data as Map<String, dynamic>),
      );
    } catch (e, stack) {
      log('Error in getCardById: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<NfcCard>> getCardsByReference(
    int referenceId, {
    String assignedToType = 'staff',
  }) async {
    try {
      return await networkAPI.getData<List<NfcCard>>(
        '/hr/nfc-cards/$referenceId/by-reference',
        queryParameters: {'assignedToType': assignedToType},
        builder: (data) {
          final List<dynamic> rawList;
          if (data is List) {
            rawList = data;
          } else if (data is Map && data['data'] is List) {
            rawList = data['data'] as List<dynamic>;
          } else {
            return [];
          }
          return rawList
              .map((e) => NfcCard.fromMap(e as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e, stack) {
      log('Error in getCardsByReference: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<NfcCard> createCard({
    String? code,
    String? tagId,
    String? reversedCode,
    String? assignedToType,
    int? referenceId,
    String? issuedDate,
  }) async {
    try {
      return await networkAPI.postData<NfcCard>(
        '/hr/nfc-cards/create',
        data: {
          if (code != null) 'code': code,
          if (tagId != null) 'tagId': tagId,
          if (reversedCode != null) 'reversedCode': reversedCode,
          if (assignedToType != null) 'assignedToType': assignedToType,
          if (referenceId != null) 'referenceId': referenceId,
          if (issuedDate != null) 'issuedDate': issuedDate,
        },
        builder: (data) =>
            NfcCard.fromMap(data['data'] as Map<String, dynamic>),
      );
    } catch (e, stack) {
      log('Error in createCard: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<NfcCard>> createCardsBulk({
    String? assignedToType,
    int? referenceId,
    required List<Map<String, dynamic>> cards,
  }) async {
    try {
      return await networkAPI.postData<List<NfcCard>>(
        '/hr/nfc-cards/create-bulk',
        data: {
          if (assignedToType != null) 'assignedToType': assignedToType,
          if (referenceId != null) 'referenceId': referenceId,
          'cards': cards,
        },
        builder: (data) {
          final List<dynamic> rawList;
          if (data['data'] is List) {
            rawList = data['data'] as List<dynamic>;
          } else {
            return [];
          }
          return rawList
              .map((e) => NfcCard.fromMap(e as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e, stack) {
      log('Error in createCardsBulk: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<NfcCard> updateCard(
    int id, {
    String? code,
    String? tagId,
    String? reversedCode,
    String? assignedToType,
    int? referenceId,
    String? issuedDate,
  }) async {
    try {
      return await networkAPI.putData<NfcCard>(
        '/hr/nfc-cards/update/$id',
        data: {
          if (code != null) 'code': code,
          if (tagId != null) 'tagId': tagId,
          if (reversedCode != null) 'reversedCode': reversedCode,
          if (assignedToType != null) 'assignedToType': assignedToType,
          if (referenceId != null) 'referenceId': referenceId,
          if (issuedDate != null) 'issuedDate': issuedDate,
        },
        builder: (data) =>
            NfcCard.fromMap(data['data'] as Map<String, dynamic>),
      );
    } catch (e, stack) {
      log('Error in updateCard: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<NfcCard> updateCardStatus(int id, String status) async {
    try {
      return await networkAPI.patchData<NfcCard>(
        '/hr/nfc-cards/update/$id/status',
        data: {'status': status},
        builder: (data) =>
            NfcCard.fromMap(data['data'] as Map<String, dynamic>),
      );
    } catch (e, stack) {
      log('Error in updateCardStatus: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<NfcCard> unassignCard(int id) async {
    try {
      return await networkAPI.patchData<NfcCard>(
        '/hr/nfc-cards/$id/unassign',
        builder: (data) =>
            NfcCard.fromMap(data['data'] as Map<String, dynamic>),
      );
    } catch (e, stack) {
      log('Error in unassignCard: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<NfcCard>> unassignCardsBulk(List<int> ids) async {
    try {
      return await networkAPI.postData<List<NfcCard>>(
        '/hr/nfc-cards/unassign-bulk',
        data: {'ids': ids},
        builder: (data) {
          final List<dynamic> rawList;
          if (data['data'] is List) {
            rawList = data['data'] as List<dynamic>;
          } else {
            return [];
          }
          return rawList
              .map((e) => NfcCard.fromMap(e as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e, stack) {
      log('Error in unassignCardsBulk: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<NfcCard> deleteCard(int id) async {
    try {
      return await networkAPI.deleteData<NfcCard>(
        '/hr/nfc-cards/delete/$id',
        builder: (data) =>
            NfcCard.fromMap(data['data'] as Map<String, dynamic>),
      );
    } catch (e, stack) {
      log('Error in deleteCard: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<NfcCard>> deleteCardsBulk(List<int> ids) async {
    try {
      return await networkAPI.postData<List<NfcCard>>(
        '/hr/nfc-cards/delete-bulk',
        data: {'ids': ids},
        builder: (data) {
          final List<dynamic> rawList;
          if (data['data'] is List) {
            rawList = data['data'] as List<dynamic>;
          } else {
            return [];
          }
          return rawList
              .map((e) => NfcCard.fromMap(e as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e, stack) {
      log('Error in deleteCardsBulk: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

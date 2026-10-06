import 'package:logger/logger.dart';
import '../core/network/network_api_dio.dart';
import '../core/utils/app_log.dart';

class OrderService {
  final NetworkAPI _networkAPI;
  final Logger _logger;

  OrderService({
    required NetworkAPI networkAPI,
    Logger? logger,
  })  : _networkAPI = networkAPI,
        _logger = logger ?? createAppLogger();


  Future<Map<String, dynamic>> fetchOrders({
    String? searchTerm,
    String? status,
    String? mealType,
    String? orderType,
    String? startDate,
    String? endDate,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final result = await _networkAPI.getData(
        '/caterer/orders',
        builder: (data) => data as Map<String, dynamic>,
        queryParameters: {
          'searchTerm': searchTerm ?? '',
          'status': status ?? '',
          'mealType': mealType ?? '',
          'orderType': orderType ?? '',
          'startDate': startDate ?? '',
          'endDate': endDate ?? '',
          'limit': limit.toString(),
          'offset': offset.toString(),
        },
      );
      _logger.i('Fetched orders: $result');
      return result;
    } catch (e) {
      _logger.e('Failed to fetch orders: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchOrderById(String id) async {
    try {
      final result = await _networkAPI.getData(
        '/caterer/order/$id',
        builder: (data) => data as Map<String, dynamic>,
      );
      _logger.i('Fetched order $id: $result');
      return result;
    } catch (e) {
      _logger.e('Failed to fetch order $id: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await _networkAPI.deleteData(
        '/caterer/order/delete/$id',
        builder: (_) => null,
      );
      _logger.i('Order $id deleted');
    } catch (e) {
      _logger.e('Failed to delete order $id: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatus({
    required String status,
    required String orderIds,
  }) async {
    try {
      await _networkAPI.patchData(
        '/caterer/order/status',
        builder: (_) => null,
        data: {
          'status': status,
          'orderIds': orderIds,
        },
      );
      _logger.i('Order status updated: status=$status ids=$orderIds');
    } catch (e) {
      _logger.e('Failed to update order status: $e');
      rethrow;
    }
  }

  
  /// Online single-order push.
  ///
  /// The payload must match CreateOrderWithOneItemRequest: mealTypeId, kitchenId,
  /// employeeType and posProfileId are all required, and `total` is ignored by the
  /// server (it reprices from the meal type). The previous shape sent a mealType
  /// *name*, an items[] array and no ids, so every call 422'd.
  ///
  /// Orders are normally written locally and pushed by the sync service; this
  /// path exists for callers that already hold a live server connection.
  Future<Map<String, dynamic>> createOrder({
    required String orderType,
    required int mealTypeId,
    required int kitchenId,
    required String employeeType,
    required int orderedBy,
    required int posProfileId,
    String? description,
    bool isAlaCarte = false,
    String? uuid,
    String? createdAt,
  }) async {
    try {
      final result = await _networkAPI.postData(
        '/pos/order/create',
        builder: (data) => data as Map<String, dynamic>,
        data: {
          'orderType': orderType,
          'mealTypeId': mealTypeId,
          'kitchenId': kitchenId,
          'employeeType': employeeType,
          'orderedBy': orderedBy,
          'posProfileId': posProfileId,
          'description': description ?? '',
          'isAlaCarte': isAlaCarte,
          'uuid': ?uuid,
          'createdAt': ?createdAt,
        },
      );
      _logger.i('POS order created: $result');
      return result;
    } catch (e) {
      _logger.e('Failed to create POS order: $e');
      rethrow;
    }
  }

 
}

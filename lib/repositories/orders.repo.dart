import 'package:logger/logger.dart';
import '../core/network/network_api_dio.dart';

class OrderItemRequest {
  final String mealName;
  final int mealId;
  final double unitPrice;
  final int quantity;

  const OrderItemRequest({
    required this.mealName,
    required this.mealId,
    required this.unitPrice,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'mealName': mealName,
        'mealId': mealId,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };
}

class CreateGroupOrderRequest {
  final String orderType;
  final String mealType;
  final double total;
  final int orderedBy;
  final int groupCount;
  final String? description;
  final List<OrderItemRequest> items;

  const CreateGroupOrderRequest({
    required this.orderType,
    required this.mealType,
    required this.total,
    required this.orderedBy,
    required this.groupCount,
    this.description,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'orderType': orderType,
        'mealType': mealType,
        'total': total,
        'orderedBy': orderedBy,
        'groupCount': groupCount,
        'description': description ?? '',
        'items': items.map((i) => i.toJson()).toList(),
      };
}

class OrderService {
  final NetworkAPI _networkAPI;
  final Logger _logger;

  OrderService({
    required NetworkAPI networkAPI,
    Logger? logger,
  })  : _networkAPI = networkAPI,
        _logger = logger ?? Logger();


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

  
  Future<Map<String, dynamic>> createOrder({
    required String orderType,
    required String mealType,
    required double total,
    required int orderedBy,
    String? description,
    bool isAlaCarte = false,
    required List<OrderItemRequest> items,
  }) async {
    try {
      final result = await _networkAPI.postData(
        '/pos/order/create',
        builder: (data) => data as Map<String, dynamic>,
        data: {
          'orderType': orderType,
          'mealType': mealType,
          'total': total,
          'orderedBy': orderedBy,
          'description': description ?? '',
          'isAlaCarte': isAlaCarte,
          'items': items.map((i) => i.toJson()).toList(),
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

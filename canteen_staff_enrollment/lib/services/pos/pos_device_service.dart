import 'package:canteen_staff_enrollment/core/network/network_api_dio.dart';
import 'package:flutter/services.dart';


class PosDeviceService {
  static const _channel = MethodChannel('com.silverware.canteen_staff_enrollment/pos');
    final NetworkAPI networkAPI = NetworkAPI();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<bool> init() async {
    try {
      final result = await _channel.invokeMethod<bool>('init');
      _isInitialized = result ?? false;
   
      return _isInitialized;
    } on PlatformException {
      _isInitialized = false;
     
      return false;
    }
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('getDeviceInfo');
      return Map<String, dynamic>.from(result ?? {});
    } on PlatformException {
      return {};
    }
  }

  Future<bool> checkInit() async {
    try {
      final result = await _channel.invokeMethod<bool>('isInit');
      _isInitialized = result ?? false;
      return _isInitialized;
    } on PlatformException {
      return false;
    }
  }

  //remote api



 




  //update
}

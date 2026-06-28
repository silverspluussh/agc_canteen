import 'package:agc_canteen/core/network/network_api_dio.dart';
import 'package:agc_canteen/models/pos_device.model.dart';
import 'package:flutter/services.dart';
import '../database/activity_log_service.dart';
import '../../core/di/injection_container.dart';

class PosDeviceService {
  static const _channel = MethodChannel('com.silverware.agc_canteen/pos');
    final NetworkAPI networkAPI = NetworkAPI();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<bool> init() async {
    try {
      final result = await _channel.invokeMethod<bool>('init');
      _isInitialized = result ?? false;
      getIt<ActivityLogService>().log(
        type: 'pos_device_init',
        message: 'POS device ${_isInitialized ? "activated" : "activation failed"}',
        metadata: {'success': _isInitialized},
      );
      return _isInitialized;
    } on PlatformException {
      _isInitialized = false;
      getIt<ActivityLogService>().log(
        type: 'pos_device_init',
        message: 'POS device init failed (PlatformException)',
        metadata: {'success': false, 'error': 'platform_exception'},
      );
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



  //fetch
   Future<List<PosDevice>> getAllBioDatas() async {
    return await networkAPI.getData<List<PosDevice>>(
      'hr/bio-data',
      builder: (data) {
        if (data is List) {
          return data
              .map((e) => PosDevice.fromMap(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }




  //update
}

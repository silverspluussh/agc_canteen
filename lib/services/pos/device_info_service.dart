import 'dart:io';
import 'package:agc_canteen/core/network/network_api_dio.dart';
import 'package:agc_canteen/models/pos_device.model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../models/device_info.model.dart';

class DeviceInfoService {
  final NetworkAPI networkAPI = NetworkAPI();
  DeviceInfoService();

  final _logger = Logger();

  Future<DeviceInfo> gatherDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    String? mac;
    String? wifiInterface;

    try {
      final macResult = await _getMacAddress();
      mac = macResult.mac;
      wifiInterface = macResult.interfaceName;
    } catch (e, stack) {
      _logger.w('Failed to retrieve MAC address', error: e, stackTrace: stack);
    }

    try {
      final androidInfo = await deviceInfo.androidInfo;

      _logger.i(
        'Device info gathered: model=${androidInfo.model}, '
        'manufacturer=${androidInfo.manufacturer}, '
        'sdk=${androidInfo.version.sdkInt}, '
        'physical=${androidInfo.isPhysicalDevice}',
      );

      return DeviceInfo(
        deviceName: androidInfo.device,
        model: androidInfo.model,
        manufacturer: androidInfo.manufacturer,
        brand: androidInfo.brand,
        product: androidInfo.product,
        board: androidInfo.board,
        hardware: androidInfo.hardware,
        buildFingerprint: androidInfo.fingerprint,
        buildId: androidInfo.id,
        display: androidInfo.display,
        bootloader: androidInfo.bootloader,
        host: androidInfo.host,
        buildTags: androidInfo.tags,
        buildType: androidInfo.type,
        deviceNameGlobal: androidInfo.name,
        freeDiskSize: androidInfo.freeDiskSize,
        totalDiskSize: androidInfo.totalDiskSize,
        physicalRamMb: androidInfo.physicalRamSize,
        availableRamMb: androidInfo.availableRamSize,
        isLowRamDevice: androidInfo.isLowRamDevice,
        supported32BitAbis: androidInfo.supported32BitAbis,
        supported64BitAbis: androidInfo.supported64BitAbis,
        androidSdkInt: androidInfo.version.sdkInt,
        androidRelease: androidInfo.version.release,
        androidCodename: androidInfo.version.codename,
        androidIncremental: androidInfo.version.incremental,
        androidBaseOS: androidInfo.version.baseOS,
        androidSecurityPatch: androidInfo.version.securityPatch,
        macAddress: mac,
        wifiInterface: wifiInterface,
        isPhysicalDevice: androidInfo.isPhysicalDevice,
        supportedAbis: androidInfo.supportedAbis,
        systemFeatures: androidInfo.systemFeatures,
        appName: packageInfo.appName,
        packageName: packageInfo.packageName,
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        installerStore: packageInfo.installerStore,
        timestamp: DateTime.now(),
      );
    } catch (e, stack) {
      _logger.e('Failed to gather device info', error: e, stackTrace: stack);

      return DeviceInfo(
        deviceName: 'unknown',
        isPhysicalDevice: false,
        supportedAbis: [],
        systemFeatures: [],
        supported32BitAbis: [],
        supported64BitAbis: [],
        appName: packageInfo.appName,
        packageName: packageInfo.packageName,
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        installerStore: packageInfo.installerStore,
        timestamp: DateTime.now(),
      );
    }
  }

  Future<({String? mac, String? interfaceName})> _getMacAddress() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );
      for (final interface in interfaces) {
        if (interface.name.contains('wlan') || interface.name.contains('eth')) {
          return (
            mac: interface.addresses.first.address,
            interfaceName: interface.name,
          );
        }
      }
      if (interfaces.isNotEmpty) {
        final first = interfaces.first;
        return (mac: first.addresses.first.address, interfaceName: first.name);
      }
    } catch (_) {}
    return (mac: null, interfaceName: null);
  }

  Future<PosDevice?> getPOSDevice() async {
    final deviceModel = await gatherDeviceInfo().then((d) => d.model ?? "");
    return await networkAPI.getData<PosDevice?>(
      'pos/profiles',
      queryParameters: {"model": deviceModel},
      builder: (data) {
        print("POS Device Data: $data");
        if (data is List && data.isNotEmpty) {
          //log(data.first.toString());
          return PosDevice.fromMap(data.first as Map<String, dynamic>);
        }
        return null;
      },
    );
  }
}

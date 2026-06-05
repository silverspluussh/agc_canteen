class DeviceInfo {
  final String deviceName;
  final String? model;
  final String? manufacturer;
  final String? brand;
  final String? product;
  final String? board;
  final String? hardware;
  final String? buildFingerprint;
  final String? buildId;
  final String? display;
  final String? bootloader;
  final String? host;
  final String? buildTags;
  final String? buildType;
  final String? deviceNameGlobal;
  final int? freeDiskSize;
  final int? totalDiskSize;
  final int? physicalRamMb;
  final int? availableRamMb;
  final bool? isLowRamDevice;
  final List<String> supported32BitAbis;
  final List<String> supported64BitAbis;
  final int? androidSdkInt;
  final String? androidRelease;
  final String? androidCodename;
  final String? androidIncremental;
  final String? androidBaseOS;
  final String? androidSecurityPatch;
  final String? macAddress;
  final String? wifiInterface;
  final bool isPhysicalDevice;
  final List<String> supportedAbis;
  final List<String> systemFeatures;
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
  final String? installerStore;
  final DateTime timestamp;

  const DeviceInfo({
    required this.deviceName,
    this.model,
    this.manufacturer,
    this.brand,
    this.product,
    this.board,
    this.hardware,
    this.buildFingerprint,
    this.buildId,
    this.display,
    this.bootloader,
    this.host,
    this.buildTags,
    this.buildType,
    this.deviceNameGlobal,
    this.freeDiskSize,
    this.totalDiskSize,
    this.physicalRamMb,
    this.availableRamMb,
    this.isLowRamDevice,
    required this.supported32BitAbis,
    required this.supported64BitAbis,
    this.androidSdkInt,
    this.androidRelease,
    this.androidCodename,
    this.androidIncremental,
    this.androidBaseOS,
    this.androidSecurityPatch,
    this.macAddress,
    this.wifiInterface,
    required this.isPhysicalDevice,
    required this.supportedAbis,
    required this.systemFeatures,
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    this.installerStore,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'device_name': deviceName,
      'model': model,
      'manufacturer': manufacturer,
      'brand': brand,
      'product': product,
      'board': board,
      'hardware': hardware,
      'build_fingerprint': buildFingerprint,
      'build_id': buildId,
      'display': display,
      'bootloader': bootloader,
      'host': host,
      'build_tags': buildTags,
      'build_type': buildType,
      'device_name_global': deviceNameGlobal,
      'free_disk_size': freeDiskSize,
      'total_disk_size': totalDiskSize,
      'physical_ram_mb': physicalRamMb,
      'available_ram_mb': availableRamMb,
      'is_low_ram_device': isLowRamDevice,
      'supported_32_bit_abis': supported32BitAbis.join(','),
      'supported_64_bit_abis': supported64BitAbis.join(','),
      'android_sdk_int': androidSdkInt,
      'android_release': androidRelease,
      'android_codename': androidCodename,
      'android_incremental': androidIncremental,
      'android_base_os': androidBaseOS,
      'android_security_patch': androidSecurityPatch,
      'mac_address': macAddress,
      'wifi_interface': wifiInterface,
      'is_physical_device': isPhysicalDevice,
      'supported_abis': supportedAbis.join(','),
      'system_features_count': systemFeatures.length,
      'app_name': appName,
      'package_name': packageName,
      'version': version,
      'build_number': buildNumber,
      'installer_store': installerStore,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'DeviceInfo(deviceName: $deviceName, model: $model, '
        'manufacturer: $manufacturer, macAddress: $macAddress, '
        'androidRelease: $androidRelease, version: $version)';
  }
}

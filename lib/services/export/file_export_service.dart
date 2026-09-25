import 'package:flutter/services.dart';

class FileExportService {
  static const _methodChannel =
      MethodChannel('com.silverware.agc_canteen/file_export');

  /// Saves [bytes] as [fileName] in the device's public Downloads folder
  /// (inside an "AGC Canteen" subfolder) and returns the saved path.
  Future<String> saveToDownloads({
    required String fileName,
    required List<int> bytes,
  }) async {
    final path = await _methodChannel.invokeMethod<String>('saveToDownloads', {
      'fileName': fileName,
      'bytes': bytes,
    });
    if (path == null) {
      throw PlatformException(
        code: 'EXPORT_FAILED',
        message: 'File was not saved',
      );
    }
    return path;
  }
}

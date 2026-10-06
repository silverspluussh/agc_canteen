/// A work function the POS may currently offer.
///
/// Mirrors the server's ordering window so the POS can decide locally whether a
/// function is still orderable, without a round trip.
class WorkFunctionModel {
  final int id;
  final String functionName;
  final String? functionLocation;
  final int? catererId;

  /// Price per voucher/coupon, applied to every order in this function.
  final double ratePerVoucher;
  final int totalQuantity;

  /// yyyy-MM-dd, normalised on construction.
  final String functionDate;

  /// HH:mm:ss, normalised on construction.
  final String functionStartTime;
  final String functionEndTime;

  final String status;

  WorkFunctionModel({
    required this.id,
    required this.functionName,
    required String functionDate,
    required String functionStartTime,
    required String functionEndTime,
    required this.status,
    this.functionLocation,
    this.catererId,
    this.ratePerVoucher = 0,
    this.totalQuantity = 0,
  }) : functionDate = normalizeDate(functionDate),
       functionStartTime = normalizeTime(functionStartTime),
       functionEndTime = normalizeTime(functionEndTime);

  factory WorkFunctionModel.fromMap(Map<String, dynamic> map) {
    return WorkFunctionModel(
      id: (map['id'] as num).toInt(),
      functionName: (map['functionName'] ?? '') as String,
      functionLocation: map['functionLocation'] as String?,
      catererId: (map['catererId'] as num?)?.toInt(),
      ratePerVoucher: (map['ratePerVoucher'] as num?)?.toDouble() ?? 0,
      totalQuantity: (map['totalQuantity'] as num?)?.toInt() ?? 0,
      functionDate: map['functionDate']?.toString() ?? '',
      functionStartTime: map['functionStartTime']?.toString() ?? '',
      functionEndTime: map['functionEndTime']?.toString() ?? '',
      status: (map['status'] ?? 'scheduled') as String,
    );
  }

  /// Seconds since midnight for the start/end of the window.
  ///
  /// Times are compared as numbers, never as strings: lexicographic comparison
  /// gets single-digit hours wrong ('9:00:00' > '12:00:00') and cannot handle
  /// differing precision. Seconds are kept so the POS matches the server's
  /// second-accurate boundary exactly.
  int get startSeconds => secondsOfDay(functionStartTime);

  int get endSeconds => secondsOfDay(functionEndTime);

  bool get hasWindow =>
      functionDate.isNotEmpty &&
      functionStartTime.isNotEmpty &&
      functionEndTime.isNotEmpty;

  /// True when [now] falls on the function's date and inside its window.
  /// Inclusive at both ends, matching the server rule exactly.
  bool isOrderableAt(DateTime now) =>
      isWindowOpenAt(functionDate, functionStartTime, functionEndTime, now);

  /// Shared window rule, so the picker, the order guard and the cache filter
  /// cannot disagree about when a function is orderable.
  static bool isWindowOpenAt(
    String functionDate,
    String startTime,
    String endTime,
    DateTime now,
  ) {
    if (functionDate.isEmpty || startTime.isEmpty || endTime.isEmpty) {
      return false;
    }

    if (normalizeDate(functionDate) != isoDate(now)) return false;

    final clock =
        now.hour * 3600 + now.minute * 60 + now.second;
    return clock >= secondsOfDay(startTime) && clock <= secondsOfDay(endTime);
  }

  String get windowLabel =>
      '$functionDate ${_hhmm(functionStartTime)}-${_hhmm(functionEndTime)}';

  static String isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static String _hhmm(String value) =>
      value.length >= 5 ? value.substring(0, 5) : value;

  /// Accepts a date-only string or a full ISO timestamp; returns yyyy-MM-dd.
  static String normalizeDate(dynamic value) {
    if (value == null) return '';
    final text = value.toString();
    if (text.isEmpty) return '';
    return text.length >= 10 ? text.substring(0, 10) : text;
  }

  /// Accepts H:i, H:i:s or a full ISO timestamp; returns HH:mm:ss.
  static String normalizeTime(dynamic value) {
    if (value == null) return '';
    final text = value.toString();
    if (text.isEmpty) return '';
    if (text.contains('T')) {
      final time = text.substring(text.indexOf('T') + 1);
      if (time.length >= 8) return time.substring(0, 8);
      return time.padRight(8, ':0');
    }
    if (text.length == 5) return '$text:00';
    if (text.length < 5) return text.padRight(5, '0');
    return text;
  }

  /// Seconds since midnight from an H:i / H:i:s / ISO time string.
  static int secondsOfDay(String value) {
    var text = value;
    if (text.contains('T')) {
      text = text.substring(text.indexOf('T') + 1);
    }
    final parts = text.split(':');
    if (parts.length < 2) return 0;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    final second = parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;
    return hour * 3600 + minute * 60 + second;
  }
}

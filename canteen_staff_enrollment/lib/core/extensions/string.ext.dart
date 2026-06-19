import 'package:intl/intl.dart';

extension StringExtensions on String {
  bool get isNullOrEmpty => isEmpty;

  bool get isNotNullOrEmpty => isNotEmpty;

  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(this);
  }

  bool get isValidUrl {
    return RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    ).hasMatch(this);
  }

  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  String toDecimalPlaces(int decimals) {
    final number = num.tryParse(this);
    if (number == null) return this;
    return number.toStringAsFixed(decimals);
  }

  String addCommas() {
    final number = num.tryParse(this);
    if (number == null) return this;
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  String get initials {
    if (isEmpty) return '';
    final words = trim().split(' ').where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  String mask({int start = 4, int end = 4, String maskChar = '*'}) {
    if (length <= start + end) return maskChar * length;
    return '${substring(0, start)}${maskChar * (length - start - end)}${substring(length - end)}';
  }

  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  bool get isAlpha {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  String get extractNumbers {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  bool? get toBool {
    final lower = toLowerCase().trim();
    if (lower == 'true' || lower == '1' || lower == 'yes') return true;
    if (lower == 'false' || lower == '0' || lower == 'no') return false;
    return null;
  }
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  String get orEmpty => this ?? '';

  String or(String defaultValue) => this ?? defaultValue;
}

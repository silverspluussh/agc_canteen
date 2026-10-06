import '../database/app_database.dart';

/// The header line printed at the top of every POS receipt.
///
/// Returns the operating kitchen/location name, falling back to the legacy app
/// label when the terminal has no provisioned kitchen yet. Centralised so every
/// receipt builder shows the same header.
Future<String> receiptHeaderName(
  AppDatabase db, {
  String fallback = 'AGCL CANTEEN',
}) async {
  final name = (await db.getRegisteredKitchenName())?.trim();
  return (name != null && name.isNotEmpty) ? name : fallback;
}

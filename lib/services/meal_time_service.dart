import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import 'database/app_database.dart';

class MealTimeWindow {
  final String mealType;
  final TimeOfDay start;
  final TimeOfDay end;

  const MealTimeWindow({
    required this.mealType,
    required this.start,
    required this.end,
  });

  bool isActiveAt(DateTime dateTime) {
    final current = TimeOfDay.fromDateTime(dateTime);
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (startMinutes <= endMinutes) {
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    } else {
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    }
  }
}

TimeOfDay parseMealTimeOfDay(String time) {
  final parts = time.trim().split(':');
  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
  return TimeOfDay(hour: hour, minute: minute);
}

/// Returns the first active meal type whose configured window contains [now].
///
/// Used by single-voucher and group-order paths so pricing/meal names stay
/// consistent with kitchen-configured begin/end times.
(int id, String name, double price)? resolveActiveMealType(
  Iterable<MealType> mealTypes, {
  DateTime? now,
}) {
  final moment = now ?? DateTime.now();
  final currentMinutes = moment.hour * 60 + moment.minute;

  for (final mt in mealTypes) {
    if (mt.status != 'active') continue;

    final start = parseMealTimeOfDay(mt.beginTime);
    final end = parseMealTimeOfDay(mt.endTime);
    final startMins = start.hour * 60 + start.minute;
    final endMins = end.hour * 60 + end.minute;

    final active = startMins <= endMins
        ? currentMinutes >= startMins && currentMinutes < endMins
        : currentMinutes >= startMins || currentMinutes < endMins;

    if (active) {
      return (mt.id, mt.name.toLowerCase(), mt.price);
    }
  }
  return null;
}

final mealTimeWindowsProvider = FutureProvider<List<MealTimeWindow>>((ref) async {
  final db = ref.watch(databaseProvider);
  final mealTypes = await db.getAllMealTypes();

  final activeTypes = mealTypes.where((mt) => mt.status == 'active').toList();
  return activeTypes.map((mt) {
    final start = parseMealTimeOfDay(mt.beginTime);
    final end = parseMealTimeOfDay(mt.endTime);
    return MealTimeWindow(
      mealType: mt.name.toLowerCase(),
      start: start,
      end: end,
    );
  }).toList();
});

final availableMealTypesProvider = FutureProvider<List<String>>((ref) async {
  final windows = await ref.watch(mealTimeWindowsProvider.future);
  final now = DateTime.now();
  return windows
      .where((window) => window.isActiveAt(now))
      .map((window) => window.mealType)
      .toList();
});

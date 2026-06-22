import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';

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

TimeOfDay _parseTimeOfDay(String time) {
  final parts = time.trim().split(':');
  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
  return TimeOfDay(hour: hour, minute: minute);
}

final mealTimeWindowsProvider = FutureProvider<List<MealTimeWindow>>((ref) async {
  final db = ref.watch(databaseProvider);
  final mealTypes = await db.getAllMealTypes();

  final activeTypes = mealTypes.where((mt) => mt.status == 'active').toList();
  return activeTypes.map((mt) {
    final start = _parseTimeOfDay(mt.beginTime);
    final end = _parseTimeOfDay(mt.endTime);
    return MealTimeWindow(
      mealType: mt.name.toLowerCase(),
      start: start,
      end: end,
    );
  }).toList();
});

final availableMealTypesProvider = FutureProvider<List<String>>((ref) async {
  final timer = Timer.periodic(const Duration(seconds: 30), (_) {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  final windows = await ref.watch(mealTimeWindowsProvider.future);
  final now = DateTime.now();
  final active = windows.where((window) {
    final active = window.isActiveAt(now);
    return active;
  }).map((window) => window.mealType).toList();
  return active;
});

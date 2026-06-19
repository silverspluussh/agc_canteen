import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

const List<MealTimeWindow> mealTimeWindows = [
  MealTimeWindow(
    mealType: 'breakfast',
    start: TimeOfDay(hour: 5, minute: 0),
    end: TimeOfDay(hour: 10, minute: 30),
  ),
  MealTimeWindow(
    mealType: 'lunch',
    start: TimeOfDay(hour: 11, minute: 0),
    end: TimeOfDay(hour: 14, minute: 0),
  ),
  MealTimeWindow(
    mealType: 'dinner',
    start: TimeOfDay(hour: 16, minute: 0),
    end: TimeOfDay(hour: 12, minute: 0),
  ),
  MealTimeWindow(
    mealType: 'midnight',
    start: TimeOfDay(hour: 0, minute: 0),
    end: TimeOfDay(hour: 3, minute: 0),
  ),
];

List<String> getAvailableMealTypes(DateTime now) {
  return mealTimeWindows
      .where((window) => window.isActiveAt(now))
      .map((window) => window.mealType)
      .toList();
}

final availableMealTypesProvider = Provider<List<String>>((ref) {
  return getAvailableMealTypes(DateTime.now());
});

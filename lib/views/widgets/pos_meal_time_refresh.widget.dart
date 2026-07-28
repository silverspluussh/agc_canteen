import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/meal_time_service.dart';

/// Refreshes meal-time providers every 30s while a POS screen is active.
class PosMealTimeRefresh extends ConsumerStatefulWidget {
  const PosMealTimeRefresh({
    super.key,
    required this.child,
    this.onRefresh,
  });

  final Widget child;
  final VoidCallback? onRefresh;

  @override
  ConsumerState<PosMealTimeRefresh> createState() => _PosMealTimeRefreshState();
}

class _PosMealTimeRefreshState extends ConsumerState<PosMealTimeRefresh> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _refresh());
  }

  void _refresh() {
    ref.invalidate(mealTimeWindowsProvider);
    ref.invalidate(availableMealTypesProvider);
    widget.onRefresh?.call();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

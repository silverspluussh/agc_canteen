import 'dart:developer';

import 'package:agc_canteen/models/work_function.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Which order flow the till is currently running.
enum PosOrderMode {
  /// Normal orders — the default.
  general,

  /// Orders are routed to the function order flow for one selected work function.
  function,
}

/// Durable POS session state for the function order mode.
///
/// The mode and the selected function are persisted so an operator does not
/// re-pick after every restart. Persistence is NOT a licence to keep ordering:
/// [isSelectionUsable] re-checks the stored function against the current clock,
/// so a function that has ended (or whose date has passed) is rejected before
/// any order can be written.
class PosModeStore {
  static const _modeKey = 'pos.orderMode';
  static const _functionIdKey = 'pos.selectedFunctionId';

  Future<PosOrderMode> readMode() async {
    final raw = await _readString(_modeKey);
    return PosOrderMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => PosOrderMode.general,
    );
  }

  /// SharedPreferences is unavailable in some contexts (unit tests, a corrupted
  /// store). The mode store must never be able to take the order flow down, so
  /// every read degrades to a safe default and every write is best-effort.
  Future<SharedPreferences?> _prefs() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (e) {
      log('PosModeStore: preferences unavailable ($e) — using defaults');
      return null;
    }
  }

  Future<String?> _readString(String key) async {
    try {
      return (await _prefs())?.getString(key);
    } catch (e) {
      log('PosModeStore: read $key failed ($e)');
      return null;
    }
  }

  Future<int?> _readInt(String key) async {
    try {
      return (await _prefs())?.getInt(key);
    } catch (e) {
      log('PosModeStore: read $key failed ($e)');
      return null;
    }
  }

  Future<void> writeMode(PosOrderMode mode) async {
    try {
      await (await _prefs())?.setString(_modeKey, mode.name);
    } catch (e) {
      log('PosModeStore: write mode failed ($e)');
    }
  }

  Future<int?> readFunctionId() => _readInt(_functionIdKey);

  Future<void> writeFunctionId(int? id) async {
    try {
      final prefs = await _prefs();
      if (prefs == null) return;
      if (id == null) {
        await prefs.remove(_functionIdKey);
      } else {
        await prefs.setInt(_functionIdKey, id);
      }
    } catch (e) {
      log('PosModeStore: write function id failed ($e)');
    }
  }

  Future<void> clearFunction() => writeFunctionId(null);

  /// Switching back to general drops the selection so returning to function mode
  /// always requires an explicit, deliberate pick.
  Future<void> setMode(PosOrderMode mode) async {
    await writeMode(mode);
    if (mode == PosOrderMode.general) {
      await clearFunction();
    }
  }
}

/// Why a stored function selection cannot be used for an order right now.
enum FunctionSelectionProblem {
  none,

  /// Function mode is on but no function has been chosen yet.
  notSelected,

  /// The chosen function is not in the local cache (never synced, or deleted).
  unknownFunction,

  /// The function is not scheduled for today.
  wrongDay,

  /// Today, but the clock is outside the function's start/end window.
  outsideWindow,
}

class FunctionSelectionCheck {
  const FunctionSelectionCheck(this.problem, {this.message});

  final FunctionSelectionProblem problem;
  final String? message;

  bool get isUsable => problem == FunctionSelectionProblem.none;

  static const ok = FunctionSelectionCheck(FunctionSelectionProblem.none);
}

/// Pure, testable re-validation of a persisted function selection.
class FunctionSelectionValidator {
  static FunctionSelectionCheck validate({
    required PosOrderMode mode,
    required int? selectedFunctionId,
    required String? functionDate,
    required String? startTime,
    required String? endTime,
    required DateTime now,
  }) {
    if (mode != PosOrderMode.function) {
      return FunctionSelectionCheck.ok;
    }

    if (selectedFunctionId == null) {
      return const FunctionSelectionCheck(
        FunctionSelectionProblem.notSelected,
        message: 'Select a work function before taking orders.',
      );
    }

    if (functionDate == null || startTime == null || endTime == null) {
      return const FunctionSelectionCheck(
        FunctionSelectionProblem.unknownFunction,
        message: 'The selected work function is no longer available.',
      );
    }

    final today = WorkFunctionModel.normalizeDate(functionDate);

    if (today != WorkFunctionModel.isoDate(now)) {
      return const FunctionSelectionCheck(
        FunctionSelectionProblem.wrongDay,
        message: 'The selected work function is not scheduled for today.',
      );
    }

    final clock = now.hour * 3600 + now.minute * 60 + now.second;
    final start = WorkFunctionModel.secondsOfDay(startTime);
    final end = WorkFunctionModel.secondsOfDay(endTime);

    if (clock < start || clock > end) {
      return FunctionSelectionCheck(
        FunctionSelectionProblem.outsideWindow,
        message:
            'The selected work function can only be ordered between '
            '${startTime.substring(0, 5)} and ${endTime.substring(0, 5)}.',
      );
    }

    return FunctionSelectionCheck.ok;
  }
}

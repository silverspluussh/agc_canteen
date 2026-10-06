import 'package:agc_canteen/models/work_function.model.dart';
import 'package:agc_canteen/services/pos/pos_mode_store.dart';
import 'package:flutter_test/flutter_test.dart';

WorkFunctionModel fn({
  int id = 7,
  String date = '2026-10-03',
  String start = '12:00:00',
  String end = '15:00:00',
  double rate = 25,
}) {
  return WorkFunctionModel(
    id: id,
    functionName: 'Annual Gala',
    functionDate: date,
    functionStartTime: start,
    functionEndTime: end,
    status: 'scheduled',
    ratePerVoucher: rate,
  );
}

FunctionSelectionCheck validate({
  PosOrderMode mode = PosOrderMode.function,
  WorkFunctionModel? function,
  DateTime? now,
}) {
  return FunctionSelectionValidator.validate(
    mode: mode,
    selectedFunctionId: function?.id,
    functionDate: function?.functionDate,
    startTime: function?.functionStartTime,
    endTime: function?.functionEndTime,
    now: now ?? DateTime(2026, 10, 3, 13),
  );
}

void main() {
  // ─── Model: local window re-validation ────────────────────────────────

  group('WorkFunctionModel.isOrderableAt', () {
    test('open inside the window', () {
      expect(fn().isOrderableAt(DateTime(2026, 10, 3, 13)), isTrue);
    });

    test('inclusive at the start', () {
      expect(fn().isOrderableAt(DateTime(2026, 10, 3, 12, 0, 0)), isTrue);
    });

    test('inclusive at the end', () {
      expect(fn().isOrderableAt(DateTime(2026, 10, 3, 15, 0, 0)), isTrue);
    });

    test('closed one second before the start', () {
      expect(
        fn().isOrderableAt(DateTime(2026, 10, 3, 11, 59, 59)),
        isFalse,
      );
    });

    test('closed one second after the end', () {
      expect(
        fn().isOrderableAt(DateTime(2026, 10, 3, 15, 0, 1)),
        isFalse,
      );
    });

    test('closed on another day at the same clock time', () {
      expect(fn().isOrderableAt(DateTime(2026, 10, 4, 13)), isFalse);
    });

    test('normalises an H:i start from the API', () {
      final function = fn(start: '12:00');
      expect(function.functionStartTime, '12:00:00');
      expect(function.isOrderableAt(DateTime(2026, 10, 3, 12)), isTrue);
    });

    test('normalises a full ISO timestamp', () {
      final function = fn(start: '2026-10-03T12:00:00.000000Z');
      expect(function.functionDate, '2026-10-03');
      expect(function.functionStartTime, '12:00:00');
    });

    test('a single-digit hour is not treated as later than a double-digit one', () {
      // Lexicographic comparison would wrongly place 9:00 after 12:00.
      final morning = fn(start: '09:00:00', end: '10:30:00');
      expect(morning.startSeconds, 540 * 60);
      expect(morning.isOrderableAt(DateTime(2026, 10, 3, 9, 30)), isTrue);
      expect(morning.isOrderableAt(DateTime(2026, 10, 3, 12)), isFalse);
    });

    test('renders a readable window label', () {
      expect(fn().windowLabel, '2026-10-03 12:00-15:00');
    });
  });

  // ─── Persisted selection re-validation ────────────────────────────────

  group('FunctionSelectionValidator', () {
    test('general mode never blocks', () {
      final check = validate(mode: PosOrderMode.general);
      expect(check.isUsable, isTrue);
    });

    test('function mode with a live selection is usable', () {
      expect(validate(function: fn()).isUsable, isTrue);
    });

    test('function mode with nothing selected is blocked', () {
      final check = validate(function: null);
      expect(check.isUsable, isFalse);
      expect(check.problem, FunctionSelectionProblem.notSelected);
    });

    test('a selection for another day is rejected', () {
      final check = validate(
        function: fn(),
        now: DateTime(2026, 10, 4, 13),
      );
      expect(check.isUsable, isFalse);
      expect(check.problem, FunctionSelectionProblem.wrongDay);
    });

    test('a selection whose window has closed is rejected', () {
      final check = validate(
        function: fn(),
        now: DateTime(2026, 10, 3, 16),
      );
      expect(check.isUsable, isFalse);
      expect(check.problem, FunctionSelectionProblem.outsideWindow);
      expect(check.message, contains('12:00'));
      expect(check.message, contains('15:00'));
    });

    test('a selection whose window has not opened is rejected', () {
      final check = validate(
        function: fn(),
        now: DateTime(2026, 10, 3, 9),
      );
      expect(check.isUsable, isFalse);
      expect(check.problem, FunctionSelectionProblem.outsideWindow);
    });

    test('a malformed cached function is treated as unknown', () {
      final check = FunctionSelectionValidator.validate(
        mode: PosOrderMode.function,
        selectedFunctionId: 7,
        functionDate: null,
        startTime: null,
        endTime: null,
        now: DateTime(2026, 10, 3, 13),
      );
      expect(check.isUsable, isFalse);
      expect(check.problem, FunctionSelectionProblem.unknownFunction);
    });

    test('exactly on the boundary second is still usable', () {
      expect(
        validate(function: fn(), now: DateTime(2026, 10, 3, 12, 0, 0))
            .isUsable,
        isTrue,
      );
      expect(
        validate(function: fn(), now: DateTime(2026, 10, 3, 15, 0, 0))
            .isUsable,
        isTrue,
      );
    });
  });
}

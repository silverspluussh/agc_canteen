import 'package:agc_canteen/core/utils/search_debouncer.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchDebouncer', () {
    test('runs the action once after the delay elapses', () {
      fakeAsync((async) {
        final debouncer = SearchDebouncer(
          delay: const Duration(milliseconds: 300),
        );
        var callCount = 0;

        debouncer.call(() => callCount++);
        expect(callCount, 0);

        async.elapse(const Duration(milliseconds: 300));
        expect(callCount, 1);

        debouncer.dispose();
      });
    });

    test('only the last call within the delay window fires', () {
      fakeAsync((async) {
        final debouncer = SearchDebouncer(
          delay: const Duration(milliseconds: 300),
        );
        final calls = <int>[];

        debouncer.call(() => calls.add(1));
        async.elapse(const Duration(milliseconds: 100));
        debouncer.call(() => calls.add(2));
        async.elapse(const Duration(milliseconds: 100));
        debouncer.call(() => calls.add(3));

        // Not enough time has elapsed yet for call 3's timer to fire.
        expect(calls, isEmpty);

        async.elapse(const Duration(milliseconds: 300));
        expect(calls, [3]);

        debouncer.dispose();
      });
    });

    test('dispose cancels a pending timer so the action never runs', () {
      fakeAsync((async) {
        final debouncer = SearchDebouncer(
          delay: const Duration(milliseconds: 300),
        );
        var callCount = 0;

        debouncer.call(() => callCount++);
        debouncer.dispose();

        async.elapse(const Duration(seconds: 1));
        expect(callCount, 0);
      });
    });
  });
}

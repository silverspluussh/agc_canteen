import 'package:agc_canteen/controllers/pos_mode_controller.dart';
import 'package:agc_canteen/models/work_function.model.dart';
import 'package:agc_canteen/services/pos/pos_mode_store.dart';
import 'package:agc_canteen/views/settings/order_mode_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Layout regression cover for the Settings > Order Mode page.
///
/// These cards used to be ListTiles with a wide action button as `trailing`.
/// ListTile reserves the trailing widget's full intrinsic width before laying out
/// the title and subtitle, so on a narrow screen the text had nowhere to go and
/// the render library threw "Trailing widget consumes the entire tile width".
///
/// A widget test is the only thing here that can catch that class of bug — the
/// analyzer cannot see layout, and the source-level placement test does not pump
/// a frame.
/// Stands in for the real controller so the page can be pumped without
/// SharedPreferences or a repository behind [posModeControllerProvider].
class FakePosModeController extends PosModeController {
  FakePosModeController(this.initial);

  final PosModeState initial;

  @override
  PosModeState build() => initial;

  @override
  Future<void> setMode(PosOrderMode mode) async {}

  @override
  Future<void> refreshAvailable() async {}

  @override
  Future<void> selectFunction(WorkFunctionModel function) async {}

  @override
  Future<void> clearSelection() async {}
}

void main() {
  WorkFunctionModel function({String name = 'End of Year Party'}) {
    return WorkFunctionModel(
      id: 7,
      functionName: name,
      functionDate: '2026-10-04',
      functionStartTime: '09:00:00',
      functionEndTime: '17:00:00',
      status: 'scheduled',
      ratePerVoucher: 12.5,
    );
  }

  Future<void> pumpPage(
    WidgetTester tester,
    PosModeState state, {
    Size size = const Size(400, 800),
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          posModeControllerProvider.overrideWith(
            () => FakePosModeController(state),
          ),
        ],
        child: MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: const OrderModeSettingsPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('general mode renders without layout errors', (tester) async {
    await pumpPage(tester, const PosModeState());

    expect(find.text('Order Mode'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('function mode with no selection renders the action', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const PosModeState(
        mode: PosOrderMode.function,
        problem: FunctionSelectionProblem.notSelected,
        message: 'Select a work function before taking orders.',
      ),
    );

    // problem != none renders the "blocked" wording, which is the same card the
    // not-yet-selected case uses.
    expect(find.text('Function mode blocked'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Select'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('function mode with a selection renders the function', (
    tester,
  ) async {
    await pumpPage(
      tester,
      PosModeState(
        mode: PosOrderMode.function,
        selectedFunction: function(),
      ),
    );

    expect(find.text('End of Year Party'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Change'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('blocked state renders the reason', (tester) async {
    await pumpPage(
      tester,
      const PosModeState(
        mode: PosOrderMode.function,
        problem: FunctionSelectionProblem.outsideWindow,
        message: 'The selected work function can only be ordered between '
            '09:00 and 17:00.',
      ),
    );

    expect(find.text('Function mode blocked'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // The widths and text scales that actually produced the assertion. The old
  // ListTile shape threw at 220dp and below, where the action button's loose
  // measurement clamps to exactly the tile width; 320 is a common POS terminal
  // size and the upper bound for ordinary phones.
  for (final size in const [
    Size(200, 640),
    Size(220, 640),
    Size(320, 640),
    Size(360, 640),
    Size(400, 800),
  ]) {
    for (final scale in const [1.0, 1.5, 2.0]) {
      testWidgets('no overflow at ${size.width}x${size.height} scale $scale', (
        tester,
      ) async {
        await pumpPage(
          tester,
          const PosModeState(
            mode: PosOrderMode.function,
            problem: FunctionSelectionProblem.notSelected,
            message:
                'Choose a function before taking orders. '
                'Only functions running right now are listed.',
          ),
          size: size,
          textScale: scale,
        );

        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('no overflow with a long function name at large text scale', (
    tester,
  ) async {
    await pumpPage(
      tester,
      PosModeState(
        mode: PosOrderMode.function,
        selectedFunction: function(
          name:
              'Annual End of Year Celebration and Awards Night '
              'for All Departments',
        ),
      ),
      // Tall viewport so the card is inside ListView's built region at 2.0 scale;
      // width is what is under test here, not height.
      size: const Size(320, 1400),
      textScale: 2.0,
    );

    expect(find.textContaining('Annual End of Year'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
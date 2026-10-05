import 'package:agc_canteen/views/widgets/fingerprint_init_recovery.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Coverage for the fingerprint init recovery controls.
///
/// The page these plug into gates its auth buttons on the reader being ready, so a
/// failed init previously left it blank: no buttons, no spinner, and
/// _fingerprintInitFailed set but never rendered. These tests pin the two pieces
/// that make the failure recoverable.
void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('FingerprintReloadAction', () {
    testWidgets('is tappable when idle', (tester) async {
      var taps = 0;
      await tester.pumpWidget(wrap(
        FingerprintReloadAction(busy: false, onPressed: () => taps++),
      ));

      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(tester.widget<IconButton>(find.byType(IconButton)).onPressed,
          isNotNull);

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(taps, 1);
    });

    // A retry runs up to four attempts with backoff (~20s). Re-enabling the
    // button invites stacked init attempts against a native SDK that reports
    // "already in progress".
    testWidgets('is disabled and shows progress while busy', (tester) async {
      var taps = 0;
      await tester.pumpWidget(wrap(
        FingerprintReloadAction(busy: true, onPressed: () => taps++),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsNothing);
      expect(
        tester.widget<IconButton>(find.byType(IconButton)).onPressed,
        isNull,
        reason: 'Must not accept taps while a retry is in flight.',
      );

      await tester.tap(find.byType(IconButton), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
    });
  });

  group('FingerprintInitFailureCard', () {
    testWidgets('explains the failure and offers a retry', (tester) async {
      var taps = 0;
      await tester.pumpWidget(wrap(
        FingerprintInitFailureCard(onRetry: () => taps++),
      ));

      expect(find.text('Fingerprint reader unavailable'), findsOneWidget);
      expect(find.textContaining('The scanner did not start'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('shows progress and blocks retry while busy', (tester) async {
      var taps = 0;
      await tester.pumpWidget(wrap(
        FingerprintInitFailureCard(busy: true, onRetry: () => taps++),
      ));

      expect(find.text('Retrying…'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      await tester.tap(find.byType(FilledButton), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('lays out on a narrow terminal without overflow', (tester) async {
      // POS terminals report widths at or below this; a fixed-width child here
      // would be the same class of bug as the Order Mode ListTile overflow.
      for (final width in [200.0, 320.0, 400.0]) {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(wrap(
          FingerprintInitFailureCard(onRetry: () {}),
        ));
        await tester.pumpAndSettle();

        expect(
          tester.takeException(),
          isNull,
          reason: 'overflowed at width $width',
        );
      }
    });
  });
}
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards where the order-mode control lives.
///
/// The General/Function switch was moved off the POS order screen to
/// Settings > Order Mode so a stray tap cannot change the flow mid-queue. The POS
/// page keeps a read-only indicator because the mode is persisted and an operator
/// still needs to see which flow is active.
///
/// This asserts the wiring rather than the rendering: the repo has no widget
/// tests, and a source-level guard is what actually protects the requirement —
/// it fails if the segmented control is reintroduced onto the order screen or the
/// settings route is unregistered.
void main() {
  String read(String path) => File(path).readAsStringSync();

  group('order mode control placement', () {
    test('POS page shows the read-only indicator, not the switcher', () {
      final pos = read('lib/views/auth/single_auth_pos.dart');

      expect(pos, contains('PosModeIndicator'));
      expect(
        pos,
        isNot(contains('PosModeSwitcher')),
        reason: 'The switcher must not return to the POS order screen.',
      );
      expect(
        pos,
        isNot(contains('SegmentedButton')),
        reason: 'The POS page must offer no way to change the order mode.',
      );
    });

    test('the switcher widget file is gone', () {
      expect(
        File('lib/views/widgets/pos_mode_switcher.widget.dart').existsSync(),
        isFalse,
        reason: 'Superseded by pos_mode_indicator.widget.dart.',
      );
      expect(File('lib/views/widgets/pos_mode_indicator.widget.dart').existsSync(), isTrue);
    });

    test('the indicator cannot change the mode', () {
      final indicator = read('lib/views/widgets/pos_mode_indicator.widget.dart');

      expect(indicator, isNot(contains('SegmentedButton')));
      expect(
        indicator,
        isNot(contains('setMode')),
        reason: 'Read-only: mode changes belong to Settings.',
      );
      expect(indicator, isNot(contains('InkWell')));
      expect(indicator, isNot(contains('TextButton')));
    });

    test('the control and picker live on the settings page', () {
      final page = read('lib/views/settings/order_mode_settings_page.dart');

      expect(page, contains('SegmentedButton<PosOrderMode>'));
      expect(page, contains('Select work function'));
      expect(page, contains('setMode'));
      expect(page, contains('selectFunction'));
    });

    test('settings page exposes the tile and navigates to the route', () {
      final settings = read('lib/views/settings/settings_page.dart');

      expect(settings, contains('Order Mode'));
      expect(settings, contains("pushNamed('/order-mode')"));
    });

    test('the order-mode tile is not behind the admin PIN gate', () {
      final settings = read('lib/views/settings/settings_page.dart');

      // Mode switching is a daily operational action; gating it behind the admin
      // code would be a regression from the POS page, where anyone could switch.
      final tile = settings.substring(settings.indexOf('title: "Order Mode"'));
      final onTap = tile.substring(0, tile.indexOf('),'));
      expect(onTap, isNot(contains('_requireAdminAccessFor')));
    });

    test('the route is registered', () {
      final main = read('lib/main.dart');

      expect(main, contains("case '/order-mode':"));
      expect(main, contains('OrderModeSettingsPage'));
    });

    test('stale guidance points at Settings', () {
      final manual = read('lib/views/pos/manual_order_page.dart');

      expect(
        manual,
        contains('in Settings > Order Mode'),
        reason: 'The blocked manual-order screen must not send operators to a '
            'control that is no longer on the POS page.',
      );
    });
  });
}
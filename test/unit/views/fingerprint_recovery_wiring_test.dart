import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the fingerprint-init recovery wiring on both POS auth pages.
///
/// The scanner is initialised once when either page opens. Because the auth
/// buttons are gated on the reader being ready, a failed init previously left the
/// page blank — _fingerprintInitFailed was set but never rendered, and the
/// "Initializing biometrics..." spinner was suppressed by that same flag, so there
/// were no buttons, no spinner and no explanation. This asserts the wiring that
/// makes the failure recoverable; the retry's actual behaviour is covered by
/// fingerprint_init_recovery_test.dart.
void main() {
  String read(String path) => File(path).readAsStringSync();

  const pages = {
    'single_auth_pos': 'lib/views/auth/single_auth_pos.dart',
    'group_order_auth_pos': 'lib/views/auth/group_order_auth_pos.dart',
  };

  for (final entry in pages.entries) {
    final name = entry.key;
    final path = entry.value;

    group('$name fingerprint recovery', () {
      test('offers a reload action in the app bar', () {
        final source = read(path);

        expect(
          source,
          contains('FingerprintReloadAction'),
          reason: '$name must expose a way to retry fingerprint init.',
        );
        expect(
          RegExp(
            r'actions:\s*\[\s*FingerprintReloadAction',
            multiLine: true,
          ).hasMatch(source),
          isTrue,
          reason: 'The reload action belongs in the app bar actions.',
        );
      });

      test('renders the failure card when init has failed', () {
        final source = read(path);

        expect(
          RegExp(
            r'if \(_fingerprintInitFailed\)\s*\n?\s*FingerprintInitFailureCard',
            multiLine: true,
          ).hasMatch(source),
          isTrue,
          reason:
              '_fingerprintInitFailed must be rendered. Gating the buttons on '
              '_fingerprintReady otherwise leaves the page blank.',
        );
      });

      test('retry re-runs init and clears the failure state', () {
        final source = read(path);

        expect(source, contains('Future<void> _retryFingerprint()'));
        expect(
          RegExp(
            r'Future<void> _retryFingerprint\(\) async \{\s*\n\s*if '
            r'\(_fingerprintInitInProgress\) return;',
          ).hasMatch(source),
          isTrue,
          reason: 'Retry must be re-entrancy guarded.',
        );

        final retry = source.substring(source.indexOf('Future<void> _retryFingerprint()'));
        expect(
          retry,
          contains('await _initFingerprint()'),
          reason: 'Retry must re-run the initialisation, not just reset flags.',
        );
        expect(
          retry,
          contains('_fingerprintInitFailed = false'),
          reason: 'Retry must clear the failure so the spinner shows progress.',
        );
      });

      test('the reload action is wired to the busy flag', () {
        final source = read(path);

        expect(
          RegExp(
            r'FingerprintReloadAction\(\s*busy: _fingerprintInitInProgress,\s*'
            r'onPressed: _retryFingerprint',
          ).hasMatch(source),
          isTrue,
          reason: 'A ~20s retry must disable the button while in flight.',
        );
      });

      test('init state is still cleared on a failed attempt', () {
        // The failure path must keep the reader marked not-ready, or the auth
        // buttons would render against a dead scanner.
        expect(
          read(path),
          contains('_fingerprintReady = false'),
          reason: '$name must not mark the reader ready after a failure.',
        );
      });
    });
  }
}
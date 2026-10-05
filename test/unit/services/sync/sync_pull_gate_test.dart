import 'package:agc_canteen/services/sync_services/sync_pull_gate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

/// The gate is the only thing standing between the terminal and an expensive
/// full pull, so its fallback behaviour matters: when in doubt it must pull.
void main() {
  late MockSyncVersionService versions;
  final now = DateTime(2026, 1, 1, 12);

  setUp(() {
    versions = MockSyncVersionService();
    registerFallbackValue(DateTime(2026));
  });

  VersionPullGate build({
    Duration reconcile = const Duration(minutes: 30),
  }) =>
      VersionPullGate(
        versions: versions,
        now: () => now,
        fullReconcileInterval: reconcile,
      );

  void recentFullPull() {
    when(() => versions.lastFullPullAt)
        .thenAnswer((_) async => now.subtract(const Duration(minutes: 1)));
  }

  test('unchanged version with a recent full pull skips the pull', () async {
    recentFullPull();
    when(() => versions.fetchVersion()).thenAnswer((_) async => 'v1');
    when(() => versions.storedVersion).thenAnswer((_) async => 'v1');

    expect(await build().shouldPull(), isFalse);
  });

  test('a changed version pulls', () async {
    recentFullPull();
    when(() => versions.fetchVersion()).thenAnswer((_) async => 'v2');
    when(() => versions.storedVersion).thenAnswer((_) async => 'v1');

    expect(await build().shouldPull(), isTrue);
  });

  test('a version fetch error falls back to a full pull', () async {
    recentFullPull();
    when(() => versions.fetchVersion()).thenThrow(StateError('offline'));

    expect(await build().shouldPull(), isTrue);
  });

  test('a stale full pull forces reconciliation even when unchanged', () async {
    when(() => versions.lastFullPullAt)
        .thenAnswer((_) async => now.subtract(const Duration(minutes: 31)));
    when(() => versions.fetchVersion()).thenAnswer((_) async => 'v1');
    when(() => versions.storedVersion).thenAnswer((_) async => 'v1');

    expect(await build().shouldPull(), isTrue);
  });

  test('onPullSucceeded persists the fetched version and stamps the pull',
      () async {
    recentFullPull();
    when(() => versions.fetchVersion()).thenAnswer((_) async => 'v9');
    when(() => versions.storedVersion).thenAnswer((_) async => 'v1');
    when(() => versions.saveVersion(any())).thenAnswer((_) async {});
    when(() => versions.markFullPull(any())).thenAnswer((_) async {});

    final gate = build();
    await gate.shouldPull();
    await gate.onPullSucceeded();

    verify(() => versions.saveVersion('v9')).called(1);
    verify(() => versions.markFullPull(any())).called(1);
  });

  test('without a fetched version onPullSucceeded still stamps the pull',
      () async {
    recentFullPull();
    when(() => versions.fetchVersion()).thenThrow(StateError('offline'));
    when(() => versions.markFullPull(any())).thenAnswer((_) async {});

    final gate = build();
    await gate.shouldPull();
    await gate.onPullSucceeded();

    verifyNever(() => versions.saveVersion(any()));
    verify(() => versions.markFullPull(any())).called(1);
  });
}

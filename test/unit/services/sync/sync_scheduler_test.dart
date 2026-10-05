import 'dart:async';

import 'package:agc_canteen/models/sync.model.dart';
import 'package:agc_canteen/services/sync_services/sync_scheduler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/mocks.dart';

/// Phase 1/2/5: the scheduler decides *when* a sync runs. These tests pin the
/// trigger/coalescing/backoff behaviour without touching a real network or DB.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockRemoteToLocalSyncService remote;
  late MockLocalToRemoteSyncService local;
  late MockConnectivity connectivity;
  late StreamController<List<ConnectivityResult>> connectivityCtrl;
  late bool online;
  late DateTime now;
  late List<SyncScheduler> schedulers;

  const emptyResult = SyncResult(pushed: {}, pulled: {}, errors: []);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    remote = MockRemoteToLocalSyncService();
    local = MockLocalToRemoteSyncService();
    connectivity = MockConnectivity();
    connectivityCtrl = StreamController<List<ConnectivityResult>>.broadcast();
    online = true;
    now = DateTime(2026, 1, 1, 12);
    schedulers = [];

    when(() => connectivity.onConnectivityChanged)
        .thenAnswer((_) => connectivityCtrl.stream);
    when(() => remote.syncAll(background: false)).thenAnswer((_) async {});
    when(() => local.syncAll()).thenAnswer((_) async => emptyResult);
  });

  tearDown(() async {
    for (final s in schedulers) {
      await s.dispose();
    }
    await connectivityCtrl.close();
  });

  SyncScheduler build({
    Duration interval = const Duration(minutes: 3),
  }) {
    final scheduler = SyncScheduler(
      remoteToLocal: remote,
      localToRemote: local,
      connectivity: connectivity,
      isOnline: () async => online,
      now: () => now,
      interval: interval,
      observeLifecycle: false,
      logger: Logger(level: Level.off),
    );
    schedulers.add(scheduler);
    return scheduler;
  }

  /// Starts the scheduler and lets its immediate cycle settle.
  Future<SyncScheduler> started({Duration? interval}) async {
    final scheduler = build(interval: interval ?? const Duration(minutes: 3));
    await scheduler.start();
    await pumpEventQueue();
    clearInteractions(remote);
    clearInteractions(local);
    return scheduler;
  }

  test('start runs an immediate cycle in both directions', () async {
    final scheduler = build();
    await scheduler.start();
    await pumpEventQueue();

    expect(scheduler.isRunning, isTrue);
    verify(() => remote.syncAll(background: false)).called(1);
    verify(() => local.syncAll()).called(1);
    expect(scheduler.snapshot.value.lastSyncedAt, now);
    expect(scheduler.snapshot.value.lastError, isNull);
  });

  test('offline cycles call neither direction', () async {
    final scheduler = await started();
    online = false;

    await scheduler.runCycle();

    verifyNever(() => remote.syncAll(background: false));
    verifyNever(() => local.syncAll());
  });

  test('overlapping triggers do not run a second cycle concurrently', () async {
    final scheduler = await started();
    final gate = Completer<void>();
    var remoteCalls = 0;
    var concurrent = 0;
    var maxConcurrent = 0;

    when(() => remote.syncAll(background: false)).thenAnswer((_) async {
      remoteCalls++;
      concurrent++;
      if (concurrent > maxConcurrent) maxConcurrent = concurrent;
      await gate.future;
      concurrent--;
    });

    final first = scheduler.runCycle();
    final second = scheduler.runCycle();
    await pumpEventQueue();

    // While the first is still gated, no second cycle may have started.
    expect(maxConcurrent, 1);
    expect(remoteCalls, 1);

    gate.complete();
    await Future.wait([first, second]);
    // The coalesced follow-up is fire-and-forget; let it drain before asserting.
    await pumpEventQueue();

    expect(maxConcurrent, 1, reason: 'cycles must never overlap');
    expect(remoteCalls, 2, reason: 'the second trigger runs once after the first');
  });

  test('a failure backs off non-forced ticks until the window passes', () async {
    when(() => remote.syncAll(background: false))
        .thenThrow(StateError('boom'));

    final scheduler = await started();
    expect(scheduler.snapshot.value.lastError, isNotNull);
    expect(scheduler.snapshot.value.consecutiveFailures, 1);

    // Same instant: inside the backoff window, a plain tick is suppressed.
    await scheduler.tick();
    verifyNever(() => remote.syncAll(background: false));

    // Past the window (interval is 3m): the tick is allowed again.
    now = now.add(const Duration(minutes: 4));
    await scheduler.tick();
    verify(() => remote.syncAll(background: false)).called(1);
  });

  test('reconnecting forces a catch-up even while backing off', () async {
    when(() => remote.syncAll(background: false))
        .thenThrow(StateError('boom'));

    await started();
    clearInteractions(remote);

    connectivityCtrl.add([ConnectivityResult.wifi]);
    await pumpEventQueue();

    verify(() => remote.syncAll(background: false)).called(1);
  });

  test('a successful cycle resets the failure count', () async {
    var shouldFail = true;
    when(() => remote.syncAll(background: false)).thenAnswer((_) async {
      if (shouldFail) throw StateError('boom');
    });

    final scheduler = await started();
    expect(scheduler.snapshot.value.consecutiveFailures, 1);

    shouldFail = false;
    now = now.add(const Duration(minutes: 5));
    await scheduler.tick();

    expect(scheduler.snapshot.value.consecutiveFailures, 0);
    expect(scheduler.snapshot.value.lastError, isNull);
  });

  test('stop cancels triggers and further runs are ignored', () async {
    final scheduler = await started();
    await scheduler.stop();

    expect(scheduler.isRunning, isFalse);
    await scheduler.runCycle();
    verifyNever(() => remote.syncAll(background: false));
  });

  test('a stop and start issued together settle deterministically', () async {
    final scheduler = await started();

    // Fire both without awaiting: _serialize runs them in order, so the stop
    // cannot clobber the subscription/timer the start just created.
    final stopFuture = scheduler.stop();
    final startFuture = scheduler.start();
    await Future.wait([stopFuture, startFuture]);

    expect(scheduler.isRunning, isTrue);

    // The scheduler is healthy: a cycle still runs after the churn.
    clearInteractions(remote);
    await scheduler.runCycle();
    verify(() => remote.syncAll(background: false)).called(1);
  });
}

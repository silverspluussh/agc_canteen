import 'dart:async';

import 'package:agc_canteen/models/sync.model.dart';
import 'package:agc_canteen/services/sync_services/push_scheduler.dart';
import 'package:agc_canteen/services/sync_services/sync_loop.dart';
import 'package:agc_canteen/services/sync_services/sync_pull_gate.dart';
import 'package:agc_canteen/services/sync_services/sync_scheduler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/mocks.dart';

/// The scheduler is now two independent loops. These tests pin the shared
/// trigger/coalescing/backoff behaviour on the push loop, and the light/full
/// split plus version gating on the pull loop.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockRemoteToLocalSyncService remote;
  late MockLocalToRemoteSyncService local;
  late MockConnectivity connectivity;
  late StreamController<List<ConnectivityResult>> connectivityCtrl;
  late bool online;
  late DateTime now;
  late List<SyncLoop> loops;

  const emptyResult = SyncResult(pushed: {}, pulled: {}, errors: []);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    remote = MockRemoteToLocalSyncService();
    local = MockLocalToRemoteSyncService();
    connectivity = MockConnectivity();
    connectivityCtrl = StreamController<List<ConnectivityResult>>.broadcast();
    online = true;
    now = DateTime(2026, 1, 1, 12);
    loops = [];

    when(() => connectivity.onConnectivityChanged)
        .thenAnswer((_) => connectivityCtrl.stream);
    when(() => remote.syncAll(background: any(named: 'background')))
        .thenAnswer((_) async => true);
    when(() => remote.syncLight(background: any(named: 'background')))
        .thenAnswer((_) async => true);
    when(() => remote.syncHeavy(background: any(named: 'background')))
        .thenAnswer((_) async => true);
    when(() => local.syncAll()).thenAnswer((_) async => emptyResult);
  });

  tearDown(() async {
    for (final l in loops) {
      await l.dispose();
    }
    await connectivityCtrl.close();
  });

  PushScheduler buildPush({Duration interval = const Duration(minutes: 4)}) {
    final loop = PushScheduler(
      localToRemote: local,
      connectivity: connectivity,
      isOnline: () async => online,
      now: () => now,
      interval: interval,
      observeLifecycle: false,
      logger: Logger(level: Level.off),
    );
    loops.add(loop);
    return loop;
  }

  SyncScheduler buildPull({
    Duration interval = const Duration(minutes: 3),
    RemotePullGate? pullGate,
  }) {
    final loop = SyncScheduler(
      remoteToLocal: remote,
      connectivity: connectivity,
      isOnline: () async => online,
      now: () => now,
      interval: interval,
      observeLifecycle: false,
      pullGate: pullGate,
      logger: Logger(level: Level.off),
    );
    loops.add(loop);
    return loop;
  }

  group('push loop', () {
    test('start runs an immediate upload cycle', () async {
      final push = buildPush();
      await push.start();
      await pumpEventQueue();

      expect(push.isRunning, isTrue);
      verify(() => local.syncAll()).called(1);
      expect(push.snapshot.value.lastSyncedAt, now);
      expect(push.snapshot.value.lastError, isNull);
    });

    test('offline cycles do not upload', () async {
      final push = buildPush();
      await push.start();
      await pumpEventQueue();
      clearInteractions(local);
      online = false;

      await push.runNow();

      verifyNever(() => local.syncAll());
    });

    test('overlapping triggers do not run concurrently', () async {
      final push = buildPush();
      await push.start();
      await pumpEventQueue();
      clearInteractions(local);

      final gate = Completer<void>();
      var calls = 0;
      var concurrent = 0;
      var maxConcurrent = 0;
      when(() => local.syncAll()).thenAnswer((_) async {
        calls++;
        concurrent++;
        if (concurrent > maxConcurrent) maxConcurrent = concurrent;
        await gate.future;
        concurrent--;
        return emptyResult;
      });

      final first = push.runNow();
      final second = push.runNow();
      await pumpEventQueue();

      expect(maxConcurrent, 1);
      expect(calls, 1);

      gate.complete();
      await Future.wait([first, second]);
      await pumpEventQueue();

      expect(maxConcurrent, 1, reason: 'cycles must never overlap');
      expect(calls, 2, reason: 'the second trigger runs once after the first');
    });

    test('a failure backs off non-forced ticks until the window passes',
        () async {
      when(() => local.syncAll()).thenThrow(StateError('boom'));

      final push = buildPush();
      await push.start();
      await pumpEventQueue();
      expect(push.snapshot.value.lastError, isNotNull);
      expect(push.snapshot.value.consecutiveFailures, 1);
      clearInteractions(local);

      await push.tick();
      verifyNever(() => local.syncAll());

      now = now.add(const Duration(minutes: 5));
      await push.tick();
      verify(() => local.syncAll()).called(1);
    });

    test('reconnecting forces a catch-up even while backing off', () async {
      when(() => local.syncAll()).thenThrow(StateError('boom'));

      final push = buildPush();
      await push.start();
      await pumpEventQueue();
      clearInteractions(local);

      connectivityCtrl.add([ConnectivityResult.wifi]);
      await pumpEventQueue();

      verify(() => local.syncAll()).called(1);
    });

    test('a successful cycle resets the failure count', () async {
      var shouldFail = true;
      when(() => local.syncAll()).thenAnswer((_) async {
        if (shouldFail) throw StateError('boom');
        return emptyResult;
      });

      final push = buildPush();
      await push.start();
      await pumpEventQueue();
      expect(push.snapshot.value.consecutiveFailures, 1);

      shouldFail = false;
      now = now.add(const Duration(minutes: 5));
      await push.tick();

      expect(push.snapshot.value.consecutiveFailures, 0);
      expect(push.snapshot.value.lastError, isNull);
    });

    test('stop cancels triggers and further runs are ignored', () async {
      final push = buildPush();
      await push.start();
      await pumpEventQueue();
      await push.stop();

      expect(push.isRunning, isFalse);
      clearInteractions(local);
      await push.runNow();
      verifyNever(() => local.syncAll());
    });

    test('default push interval is four minutes', () {
      expect(kDefaultPushInterval, const Duration(minutes: 4));
    });
  });

  group('pull loop', () {
    test('start performs a full reconcile on the first cycle of the day',
        () async {
      final pull = buildPull();
      await pull.start();
      await pumpEventQueue();

      verify(() => remote.syncAll(background: false)).called(1);
      verifyNever(() => remote.syncLight(background: any(named: 'background')));
      expect(pull.snapshot.value.lastSyncedAt, now);
    });

    test('a later timer tick pulls only the light set', () async {
      final pull = buildPull();
      await pull.start();
      await pumpEventQueue();
      clearInteractions(remote);

      now = now.add(const Duration(minutes: 61));
      await pull.tick();

      verify(() => remote.syncLight(background: false)).called(1);
      verifyNever(() => remote.syncAll(background: any(named: 'background')));
    });

    test('the full reconcile repeats on the next day', () async {
      final pull = buildPull();
      await pull.start();
      await pumpEventQueue();
      clearInteractions(remote);

      now = now.add(const Duration(days: 1));
      await pull.tick();

      verify(() => remote.syncAll(background: false)).called(1);
    });

    test('coalesced triggers never run concurrently', () async {
      final pull = buildPull();
      await pull.start();
      await pumpEventQueue();
      clearInteractions(remote);

      final gate = Completer<void>();
      var calls = 0;
      var concurrent = 0;
      var maxConcurrent = 0;
      when(() => remote.syncAll(background: false)).thenAnswer((_) async {
        calls++;
        concurrent++;
        if (concurrent > maxConcurrent) maxConcurrent = concurrent;
        await gate.future;
        concurrent--;
        return true;
      });

      final first = pull.runCycle();
      final second = pull.runCycle();
      await pumpEventQueue();

      expect(maxConcurrent, 1);
      expect(calls, 1);

      gate.complete();
      await Future.wait([first, second]);
      await pumpEventQueue();

      expect(maxConcurrent, 1);
      expect(calls, 2);
    });

    test('an unchanged gate skips the pull', () async {
      final gate = _FakeGate(false);
      final pull = buildPull(pullGate: gate);
      await pull.start();
      await pumpEventQueue();
      clearInteractions(remote);

      now = now.add(const Duration(minutes: 61));
      await pull.tick();

      verifyNever(() => remote.syncLight(background: any(named: 'background')));
      expect(gate.shouldPullCalls, greaterThan(0));
      expect(gate.succeededCalls, 0);
      expect(pull.snapshot.value.pullSkipped, isTrue);
    });

    test('a changed gate pulls the light set and records success', () async {
      final gate = _FakeGate(true);
      final pull = buildPull(pullGate: gate);
      await pull.start();
      await pumpEventQueue();
      clearInteractions(remote);

      now = now.add(const Duration(minutes: 61));
      await pull.tick();

      verify(() => remote.syncLight(background: false)).called(1);
      expect(gate.succeededCalls, greaterThanOrEqualTo(1));
      expect(pull.snapshot.value.pullSkipped, isFalse);
    });

    test('manual runNow bypasses the gate and always pulls', () async {
      final gate = _FakeGate(false);
      final pull = buildPull(pullGate: gate);
      await pull.start();
      await pumpEventQueue();
      clearInteractions(remote);
      final baseGateCalls = gate.shouldPullCalls;

      await pull.runNow();

      verify(() => remote.syncLight(background: false)).called(1);
      expect(gate.shouldPullCalls, baseGateCalls,
          reason: 'a manual pull must not consult the gate');
    });

    test('runNow(full: true) pulls everything', () async {
      final pull = buildPull();
      await pull.start();
      await pumpEventQueue();
      clearInteractions(remote);

      await pull.runNow(full: true);

      verify(() => remote.syncAll(background: false)).called(1);
    });

    test('a dropped connection during a full pull is not marked done',
        () async {
      var onlineRuns = 0;
      when(() => remote.syncAll(background: false)).thenAnswer((_) async {
        onlineRuns++;
        return onlineRuns > 1; // first attempt reports the link dropped
      });

      final pull = buildPull();
      await pull.start();
      await pumpEventQueue();

      // The failed full pull must not have been recorded as today's reconcile.
      expect(pull.snapshot.value.lastError, isNotNull);

      // Next online cycle must retry the full pull (day still not marked).
      now = now.add(const Duration(minutes: 4));
      await pull.tick();

      verify(() => remote.syncAll(background: false)).called(2);
    });

    test('a dropped connection during a light pull skips gate success',
        () async {
      final gate = _FakeGate(true);
      final pull = buildPull(pullGate: gate);
      await pull.start();
      await pumpEventQueue();
      clearInteractions(remote);
      final baseGateCalls = gate.shouldPullCalls;

      when(() => remote.syncLight(background: false)).thenAnswer((_) async => false);

      now = now.add(const Duration(minutes: 61));
      await pull.tick();

      verify(() => remote.syncLight(background: false)).called(1);
      expect(gate.shouldPullCalls, baseGateCalls + 1);
      expect(gate.succeededCalls, 0,
          reason: 'the version must not advance when nothing was pulled');
      expect(pull.snapshot.value.lastError, isNotNull);
    });

    test('default pull interval is sixty minutes', () {
      expect(kDefaultPullInterval, const Duration(minutes: 60));
    });
  });
}

/// Minimal [RemotePullGate] stub with call counters.
class _FakeGate implements RemotePullGate {
  _FakeGate(this.result);

  final bool result;
  int shouldPullCalls = 0;
  int succeededCalls = 0;

  @override
  Future<bool> shouldPull() async {
    shouldPullCalls++;
    return result;
  }

  @override
  Future<void> onPullSucceeded() async {
    succeededCalls++;
  }
}

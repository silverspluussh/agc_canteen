import 'dart:async';

import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/sync_services/sync_from_remote_to_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';

/// The manual Sync screen exposes one download button per category. These tests
/// pin two guarantees the screen relies on:
///
///  1. Each `syncXOnly()` reports success/failure (returns `bool`) instead of
///     swallowing errors — otherwise a failed "only BioData" pull still looked
///     like a green "synced".
///  2. A single-category pull serializes behind an in-flight full run, so it can
///     never race the background sync over the same tables (visitors, dependents
///     and shifts used to bypass that guard).
void main() {
  late AppDatabase db;
  late MockNetworkAPI network;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    db = createTestDatabase();
    network = MockNetworkAPI();
  });

  tearDown(() async {
    await db.close();
  });

  RemoteToLocalSyncService buildService({bool online = true}) =>
      RemoteToLocalSyncService(
        networkAPI: network,
        db: db,
        isOnline: () async => online,
      );

  void stubSync(String path, Map<String, dynamic> body) {
    when(() => network.getData<dynamic>(
          path,
          builder: any(named: 'builder'),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => body);
  }

  group('single-category download reports success/failure', () {
    test('staff returns true when the endpoint returns data', () async {
      stubSync('/hr/staff/sync', {
        'data': [
          {'id': 1, 'fullName': 'Jane Doe', 'employeeType': 'permanent'},
        ],
      });

      expect(await buildService().syncStaffOnly(), isTrue);
    });

    test('staff returns false when the network throws', () async {
      when(() => network.getData<dynamic>(
            any(),
            builder: any(named: 'builder'),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(Exception('boom'));

      expect(await buildService().syncStaffOnly(), isFalse);
    });

    test('visitors returns true when the endpoint returns data', () async {
      stubSync('/hr/visitor/sync', {
        'visitors': [
          {'id': 1, 'name': 'Visitor One'},
        ],
      });

      expect(await buildService().syncVisitorsOnly(), isTrue);
    });

    test('dependents returns true when the endpoint returns data', () async {
      stubSync('/hr/dependent/sync', {
        'data': [
          {'id': 1, 'fullName': 'Dep One', 'status': 'active'},
        ],
      });

      expect(await buildService().syncDependentsOnly(), isTrue);
    });

    test('shifts returns true when the endpoint returns data', () async {
      stubSync('/hr/shifts', {
        'shifts': [
          {'id': 1, 'name': 'Day Shift', 'hours': 8},
        ],
      });

      expect(await buildService().syncShiftsOnly(), isTrue);
    });
  });

  test('a single-category pull waits for an in-flight full run', () async {
    final gate = Completer<void>();
    Future<dynamic> gated() async {
      await gate.future;
      return {'data': <dynamic>[]};
    }

    when(() => network.getData<dynamic>(
          any(),
          builder: any(named: 'builder'),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) => gated());
    when(() => network.getData<dynamic>(
          any(),
          builder: any(named: 'builder'),
        )).thenAnswer((_) => gated());

    final service = buildService();

    // Background full run starts and blocks on the first network call.
    unawaited(service.syncAll(background: true));
    await pumpEventQueue();

    var visitorsDone = false;
    final visitors = service.syncVisitorsOnly().then((result) {
      visitorsDone = true;
      return result;
    });

    await pumpEventQueue();
    expect(
      visitorsDone,
      isFalse,
      reason: 'the single pull must wait for the in-flight full run',
    );

    gate.complete();
    await visitors;
    expect(visitorsDone, isTrue);
  });
}

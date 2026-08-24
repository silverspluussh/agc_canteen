import 'dart:async';

import 'package:agc_canteen/services/auth/nfc_auth_service.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';

/// `readCard()` is async and only subscribes to the tag stream after its
/// first internal `await`. Since [tagController] is a broadcast stream,
/// events emitted before that subscription exists are dropped silently.
/// Tests must yield back to the event loop once before emitting a tag (or
/// calling `cancel()`) so `readCard()` has reached `stream.listen(...)`.
Future<void> pumpEventLoop() => Future<void>.delayed(Duration.zero);

void main() {
  late AppDatabase db;
  late MockNfcService nfcService;
  late StreamController<Map<String, dynamic>> tagController;
  late NfcAuthService nfcAuth;

  setUp(() {
    db = createTestDatabase();
    nfcService = MockNfcService();
    tagController = StreamController<Map<String, dynamic>>.broadcast();
    when(() => nfcService.tagStream).thenAnswer((_) => tagController.stream);
    nfcAuth = NfcAuthService(db: db, nfc: nfcService);
  });

  tearDown(() async {
    await tagController.close();
    await db.close();
  });

  test('resolves the card matching a tapped tag id', () async {
    await seedNfcCard(
      db,
      id: 1,
      tagId: 'ABC123',
      assignedToId: 5,
      assignedToType: 'permanent',
    );

    final future = nfcAuth.readCard();
    await pumpEventLoop();
    tagController.add({'tagId': 'ABC123'});
    final result = await future;

    expect(result, isNotNull);
    expect(result!.assignedToId, 5);
    expect(result.assignedToType, 'permanent');
  });

  test('returns null when the tapped tag has no matching card', () async {
    final future = nfcAuth.readCard();
    await pumpEventLoop();
    tagController.add({'tagId': 'UNKNOWN'});
    final result = await future;

    expect(result, isNull);
  });

  test('filters by departmentId when provided', () async {
    await seedNfcCard(
      db,
      id: 1,
      tagId: 'DEPT1',
      assignedToId: 1,
      assignedToType: 'permanent',
      departmentId: 99,
    );

    final future = nfcAuth.readCard(departmentId: 1);
    await pumpEventLoop();
    tagController.add({'tagId': 'DEPT1'});
    final result = await future;

    // Card exists for a different department, so it should not match.
    expect(result, isNull);
  });

  test('cancel() completes a pending read with null', () async {
    final future = nfcAuth.readCard();
    await pumpEventLoop();
    nfcAuth.cancel();

    final result = await future;
    expect(result, isNull);
  });

  test('cancel() after a matched tag does not throw StateError', () async {
    await seedNfcCard(
      db,
      id: 1,
      tagId: 'RACE',
      assignedToId: 1,
      assignedToType: 'permanent',
    );

    final future = nfcAuth.readCard();
    await pumpEventLoop();
    tagController.add({'tagId': 'RACE'});
    // Cancel in the window after match while the listen callback may still
    // hold _pendingCompleter — must not double-complete.
    await pumpEventLoop();
    expect(() => nfcAuth.cancel(), returnsNormally);

    final result = await future;
    // Either the match or the cancel may win; both are non-throwing outcomes.
    expect(result == null || result.tagId == 'RACE', isTrue);
  });

  test('starting a new readCard cancels the previous pending read', () async {
    await seedNfcCard(
      db,
      id: 1,
      tagId: 'SECOND',
      assignedToId: 2,
      assignedToType: 'visitor',
    );

    final firstRead = nfcAuth.readCard();
    await pumpEventLoop();
    final secondRead = nfcAuth.readCard();
    await pumpEventLoop();
    tagController.add({'tagId': 'SECOND'});

    final firstResult = await firstRead;
    final secondResult = await secondRead;

    expect(firstResult, isNull);
    expect(secondResult, isNotNull);
    expect(secondResult!.assignedToId, 2);
  });
}

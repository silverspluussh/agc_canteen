import 'package:agc_canteen/services/auth/fingerprint_template_cache.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/sync_services/sync_from_remote_to_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_database.dart';

/// Phase 3 wiring: a completed pull must drop the cached fingerprint templates,
/// because synced bio-data (and the entities its department scoping resolves
/// through) may have changed.
class _SpyCache extends FingerprintTemplateCache {
  _SpyCache(AppDatabase db) : super(db: db);

  int invalidations = 0;

  @override
  void invalidate() {
    invalidations++;
    super.invalidate();
  }
}

void main() {
  late AppDatabase db;
  late MockNetworkAPI network;
  late _SpyCache cache;

  setUp(() {
    db = createTestDatabase();
    network = MockNetworkAPI();
    cache = _SpyCache(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('a light pull invalidates the fingerprint template cache', () async {
    when(() => network.getData<dynamic>(
          any(),
          builder: any(named: 'builder'),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => {'data': <dynamic>[]});
    when(() => network.getData<dynamic>(
          any(),
          builder: any(named: 'builder'),
        )).thenAnswer((_) async => {'data': <dynamic>[]});

    final service = RemoteToLocalSyncService(
      networkAPI: network,
      db: db,
      isOnline: () async => true,
      templateCache: cache,
    );

    await service.syncLight(background: false);

    expect(cache.invalidations, greaterThan(0));
  });
}

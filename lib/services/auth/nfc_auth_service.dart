import 'dart:async';
import 'dart:developer' as dev;
import 'dart:developer';
import 'package:agc_canteen/services/nfc/nfc_service.dart';
import 'package:logger/logger.dart';
import '../database/app_database.dart';

class NfcAuthService {
  final AppDatabase _db;
  final NfcService _nfc;
  final Logger _logger;
  Completer<Card?>? _pendingCompleter;

  NfcAuthService({
    required AppDatabase db,
    required NfcService nfc,
    Logger? logger,
  }) : _db = db,
       _nfc = nfc,
       _logger = logger ?? Logger();

  /// Waits for one NFC tag, looks up the card in the local DB,
  /// and returns the matching [Card] record (with assignedToId + assignedToType).
  /// Optionally filters by [departmentId] to narrow the lookup.
  Future<Card?> readCard({int? departmentId}) async {
    _pendingCompleter?.complete(null);
    dev.log('[NfcAuth] Waiting for NFC tap...', name: 'NFC_AUTH');

    final stream = _nfc.tagStream;
    final completer = Completer<Card?>();
    _pendingCompleter = completer;

    StreamSubscription<Map<String, dynamic>>? sub;
    sub = stream.listen(
      (tag) async {
        final code = tag['tagId'] as String;

        final match = await _db.getCardByTagId(code, departmentId: departmentId);

        if (match != null) {
          dev.log(
            '[NfcAuth] Card matched: id=${match.id}, assignedToId=${match.assignedToId}, type=${match.assignedToType}',
            name: 'NFC_AUTH',
          );
        } else {
          dev.log('[NfcAuth] No card found for code=$code', name: 'NFC_AUTH');
        }

        await sub?.cancel();
        if (!completer.isCompleted) completer.complete(match);
        if (_pendingCompleter == completer) _pendingCompleter = null;
      },
      onError: (error) {
        dev.log('[NfcAuth] Stream error: $error', name: 'NFC_AUTH');
        if (!completer.isCompleted) completer.complete(null);
        if (_pendingCompleter == completer) _pendingCompleter = null;
      },
    );

    return completer.future;
  }
}

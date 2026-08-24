import 'dart:async';
import 'package:agc_canteen/core/utils/app_log.dart';
import 'package:agc_canteen/services/nfc/nfc_service.dart';
import '../database/app_database.dart';

class NfcAuthService {
  final AppDatabase _db;
  final NfcService _nfc;
  Completer<Card?>? _pendingCompleter;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  NfcAuthService({
    required AppDatabase db,
    required NfcService nfc,
  }) : _db = db,
       _nfc = nfc;

  /// Waits for one NFC tag, looks up the card in the local DB,
  /// and returns the matching [Card] record (with assignedToId + assignedToType).
  /// Optionally filters by [departmentId] to narrow the lookup.
  Future<Card?> readCard({int? departmentId}) async {
    _completePending(null);
    await _subscription?.cancel();
    appLog('[NfcAuth] Waiting for NFC tap...', name: 'NFC_AUTH');

    final stream = _nfc.tagStream;
    final completer = Completer<Card?>();
    _pendingCompleter = completer;

    _subscription = stream.listen(
      (tag) async {
        final code = tag['tagId'] as String;

        final match = await _db.getCardByTagId(code, departmentId: departmentId);

        if (match != null) {
          appLog(
            '[NfcAuth] Card matched: id=${match.id}, assignedToId=${match.assignedToId}, type=${match.assignedToType}',
            name: 'NFC_AUTH',
          );
        } else {
          appLog('[NfcAuth] No card found for code=$code', name: 'NFC_AUTH');
        }

        await _subscription?.cancel();
        if (_pendingCompleter == completer) _pendingCompleter = null;
        if (!completer.isCompleted) completer.complete(match);
      },
      onError: (error) {
        appLog('[NfcAuth] Stream error: $error', name: 'NFC_AUTH');
        if (_pendingCompleter == completer) _pendingCompleter = null;
        if (!completer.isCompleted) completer.complete(null);
      },
    );

    return completer.future;
  }

  /// Cancels an in-progress NFC read.
  void cancel() {
    _subscription?.cancel();
    _subscription = null;
    _completePending(null);
  }

  /// Completes and clears [_pendingCompleter] without double-completing.
  void _completePending(Card? value) {
    final pending = _pendingCompleter;
    _pendingCompleter = null;
    if (pending != null && !pending.isCompleted) {
      pending.complete(value);
    }
  }
}

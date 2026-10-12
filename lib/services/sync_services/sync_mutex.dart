import 'dart:async';

/// A minimal async mutex used to serialise operations that must not overlap.
///
/// The push loop and the pull loop now run on independent timers. Most of their
/// work touches disjoint tables, but bio-data is written by both: the pull
/// upserts/deletes bio-data rows while the push marks locally-captured rows as
/// synced. Sharing one [SyncMutex] around just those sections keeps them from
/// interleaving without serialising the whole (expensive) pull behind the push.
class SyncMutex {
  Future<void> _tail = Future.value();

  /// Runs [action] after every previously enqueued action has finished.
  ///
  /// A failure in [action] is propagated to its caller but never wedges the
  /// queue: the next waiter runs regardless.
  Future<T> synchronized<T>(Future<T> Function() action) {
    final completer = Completer<void>();
    final previous = _tail;
    _tail = completer.future;
    return previous.then((_) => action()).whenComplete(completer.complete);
  }
}

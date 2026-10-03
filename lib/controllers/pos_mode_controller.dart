import 'dart:developer';

import 'package:agc_canteen/core/di/injection_container.dart';
import 'package:agc_canteen/core/network/network_api_dio.dart';
import 'package:agc_canteen/models/work_function.model.dart';
import 'package:agc_canteen/repositories/function_order.repo.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/pos/pos_mode_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current order mode + selected function, persisted across restarts.
class PosModeState {
  final PosOrderMode mode;
  final WorkFunctionModel? selectedFunction;
  final List<WorkFunctionModel> available;
  final bool loading;
  final FunctionSelectionProblem problem;
  final String? message;

  const PosModeState({
    this.mode = PosOrderMode.general,
    this.selectedFunction,
    this.available = const [],
    this.loading = false,
    this.problem = FunctionSelectionProblem.none,
    this.message,
  });

  bool get isFunctionMode => mode == PosOrderMode.function;

  PosModeState copyWith({
    PosOrderMode? mode,
    WorkFunctionModel? selectedFunction,
    bool clearSelection = false,
    List<WorkFunctionModel>? available,
    bool? loading,
    FunctionSelectionProblem? problem,
    String? message,
  }) {
    return PosModeState(
      mode: mode ?? this.mode,
      selectedFunction: clearSelection
          ? null
          : (selectedFunction ?? this.selectedFunction),
      available: available ?? this.available,
      loading: loading ?? this.loading,
      problem: problem ?? this.problem,
      message: message,
    );
  }
}

class PosModeController extends Notifier<PosModeState> {
  /// Resolved once in [build]: reading `ref` lazily would touch a disposed ref
  /// when the provider is torn down mid-load.
  late final PosModeStore _store;

  /// Null when function mode cannot be wired; the POS then simply stays in
  /// general mode.
  FunctionOrderRepository? _repo;

  @override
  PosModeState build() {
    _store = ref.read(posModeStoreProvider);
    _repo = ref.read(functionOrderRepositoryProvider);

    // Kick off the persisted-state load; the UI renders general mode until it
    // resolves, and revalidates before any order can be written.
    Future.microtask(restore);
    return const PosModeState(loading: true);
  }

  /// Reloads the persisted mode and re-validates any stored selection.
  Future<void> restore() async {
    final mode = await _store.readMode();
    final functionId = await _store.readFunctionId();
    final available = await _repo?.orderableFunctions() ?? const [];

    // The provider may have been disposed while the loads were in flight.
    if (!ref.mounted) return;

    final selected = functionId == null
        ? null
        : available.where((fn) => fn.id == functionId).firstOrNull;

    state = state.copyWith(
      mode: mode,
      available: available,
      loading: false,
      selectedFunction: selected,
      clearSelection: selected == null,
    );
    revalidate();
  }

  /// Refreshes the cached picker list from the server.
  Future<void> refreshAvailable() async {
    state = state.copyWith(loading: true);
    try {
      await _repo?.syncActiveWorkFunctions();
    } catch (e) {
      // Offline: keep whatever is cached and let the local window check stand.
      log('PosModeController: function refresh failed ($e)');
    }
    final available = await _repo?.orderableFunctions() ?? const [];
    if (!ref.mounted) return;
    state = state.copyWith(available: available, loading: false);
    revalidate();
  }

  Future<void> setMode(PosOrderMode mode) async {
    await _store.setMode(mode);
    if (!ref.mounted) return;
    state = state.copyWith(
      mode: mode,
      clearSelection: mode == PosOrderMode.general,
      problem: FunctionSelectionProblem.none,
    );
    revalidate();
  }

  Future<void> selectFunction(WorkFunctionModel function) async {
    await _store.writeFunctionId(function.id);
    if (!ref.mounted) return;
    state = state.copyWith(selectedFunction: function);
    revalidate();
  }

  Future<void> clearSelection() async {
    await _store.clearFunction();
    if (!ref.mounted) return;
    state = state.copyWith(clearSelection: true);
    revalidate();
  }

  /// Re-checks the selection against the current clock.
  ///
  /// This is the guard that stops a stale persisted selection from silently
  /// continuing to take orders after the window closes.
  void revalidate({DateTime? now}) {
    if (!ref.mounted) return;

    if (state.mode != PosOrderMode.function) {
      state = state.copyWith(problem: FunctionSelectionProblem.none);
      return;
    }

    final selected = state.selectedFunction;
    final check = FunctionSelectionValidator.validate(
      mode: state.mode,
      selectedFunctionId: selected?.id,
      functionDate: selected?.functionDate,
      startTime: selected?.functionStartTime,
      endTime: selected?.functionEndTime,
      now: now ?? DateTime.now(),
    );

    state = state.copyWith(problem: check.problem, message: check.message);
  }
}

final posModeStoreProvider = Provider<PosModeStore>((ref) => PosModeStore());

/// Null when the container is not fully wired (unit tests, early bootstrap).
///
/// Function mode is strictly additive, so a missing repository must never take
/// the general order flow down with it.
final functionOrderRepositoryProvider = Provider<FunctionOrderRepository?>(
  (ref) {
    try {
      return FunctionOrderRepository(
        db: getIt<AppDatabase>(),
        networkAPI: getIt<NetworkAPI>(),
      );
    } catch (e) {
      log('functionOrderRepository unavailable ($e) — function mode disabled');
      return null;
    }
  },
);

final posModeControllerProvider =
    NotifierProvider<PosModeController, PosModeState>(PosModeController.new);

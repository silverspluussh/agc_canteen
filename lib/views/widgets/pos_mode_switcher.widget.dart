import 'package:agc_canteen/controllers/pos_mode_controller.dart';
import 'package:agc_canteen/services/pos/pos_mode_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// General / Function switch plus the active-function banner.
///
/// Sits above the POS order area so the operator always knows which flow they
/// are in before scanning a card or finger.
class PosModeSwitcher extends ConsumerWidget {
  const PosModeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posModeControllerProvider);
    final controller = ref.read(posModeControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<PosOrderMode>(
          segments: const [
            ButtonSegment(
              value: PosOrderMode.general,
              label: Text('General'),
              icon: Icon(Icons.storefront, size: 18),
            ),
            ButtonSegment(
              value: PosOrderMode.function,
              label: Text('Function'),
              icon: Icon(Icons.celebration, size: 18),
            ),
          ],
          selected: {state.mode},
          onSelectionChanged: (selection) =>
              controller.setMode(selection.first),
        ),
        if (state.isFunctionMode) ...[
          const SizedBox(height: 8),
          _FunctionBanner(state: state, controller: controller),
        ],
      ],
    );
  }
}

class _FunctionBanner extends StatelessWidget {
  const _FunctionBanner({required this.state, required this.controller});

  final PosModeState state;
  final PosModeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = state.selectedFunction;

    if (selected != null && state.problem == FunctionSelectionProblem.none) {
      return Card(
        margin: EdgeInsets.zero,
        color: theme.colorScheme.primaryContainer,
        child: ListTile(
          dense: true,
          leading: const Icon(Icons.event_available),
          title: Text(
            selected.functionName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${selected.windowLabel} • ${selected.ratePerVoucher.toStringAsFixed(2)} per voucher',
          ),
          trailing: TextButton.icon(
            onPressed: () => _openPicker(context, controller, state),
            icon: const Icon(Icons.swap_horiz, size: 18),
            label: const Text('Change'),
          ),
        ),
      );
    }

    final blocked = state.problem != FunctionSelectionProblem.none;

    return Card(
      margin: EdgeInsets.zero,
      color: blocked
          ? theme.colorScheme.errorContainer
          : theme.colorScheme.surfaceContainerHighest,
      child: ListTile(
        dense: true,
        leading: Icon(
          blocked ? Icons.error_outline : Icons.event_busy,
          color: blocked ? theme.colorScheme.error : null,
        ),
        title: Text(
          blocked
              ? 'Function mode blocked'
              : 'No work function selected',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          state.message ??
              'Choose a function before taking orders. Only functions running right now are listed.',
        ),
        trailing: FilledButton.icon(
          onPressed: state.loading
              ? null
              : () => _openPicker(context, controller, state),
          icon: state.loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.playlist_add_check, size: 18),
          label: const Text('Select'),
        ),
      ),
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    PosModeController controller,
    PosModeState state,
  ) async {
    // Pull fresh first so a function that closed in the last few minutes is
    // gone from the list before the operator picks it.
    await controller.refreshAvailable();
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => const _FunctionPickerSheet(),
    );
  }
}

class _FunctionPickerSheet extends ConsumerWidget {
  const _FunctionPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posModeControllerProvider);
    final controller = ref.read(posModeControllerProvider.notifier);
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select work function',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Only functions running at this moment can be selected.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (state.available.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    const Icon(Icons.event_busy, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'No work functions are running right now.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.available.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final fn = state.available[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(fn.functionName),
                      subtitle: Text(
                        '${fn.windowLabel} • ${fn.ratePerVoucher.toStringAsFixed(2)} per voucher',
                      ),
                      trailing: state.selectedFunction?.id == fn.id
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.chevron_right),
                      onTap: () async {
                        await controller.selectFunction(fn);
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Convenience helper for widgets that need to react to function mode.
extension PosModeStateX on PosModeState {
  bool get canOrder => !isFunctionMode || selectedFunction != null;
}

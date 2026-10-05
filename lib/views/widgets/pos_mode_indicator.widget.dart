import 'package:agc_canteen/controllers/pos_mode_controller.dart';
import 'package:agc_canteen/services/pos/pos_mode_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Read-only display of the active order mode on the POS page.
///
/// Switching mode deliberately lives in Settings > Order Mode, not on the order
/// screen: a mode change mid-queue is easy to fat-finger and hard to notice
/// happening. This widget therefore shows *what* the till is set to and nothing
/// that can be tapped.
///
/// The indicator still earns its place. The mode is persisted across restarts, so
/// a till left in function mode keeps routing every order into the function flow
/// with no other on-screen cue — an operator needs to see that before scanning a
/// card or finger.
class PosModeIndicator extends ConsumerWidget {
  const PosModeIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posModeControllerProvider);

    // General mode is the default and needs no banner; only function mode changes
    // where orders go, so that is the only case worth interrupting the screen for.
    if (!state.isFunctionMode) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final selected = state.selectedFunction;
    final blocked = state.problem != FunctionSelectionProblem.none;

    final Color background = blocked
        ? theme.colorScheme.errorContainer
        : theme.colorScheme.primaryContainer;
    final Color foreground = blocked
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onPrimaryContainer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            blocked ? Icons.error_outline : Icons.event_available,
            color: foreground,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selected?.functionName ?? 'Function mode blocked',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: foreground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  state.message ??
                      '${selected?.windowLabel ?? ''} • '
                          '${selected?.ratePerVoucher.toStringAsFixed(2) ?? '0.00'} per voucher',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foreground.withValues(alpha: 0.85),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Function',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

/// Convenience helper for widgets that need to react to function mode.
extension PosModeStateX on PosModeState {
  bool get canOrder => !isFunctionMode || selectedFunction != null;
}
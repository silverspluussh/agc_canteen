import 'package:agc_canteen/controllers/pos_mode_controller.dart';
import 'package:agc_canteen/services/pos/pos_mode_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class OrderModeSettingsPage extends ConsumerWidget {
  const OrderModeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(posModeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text('Order Mode'),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        physics: const ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Choose how this terminal issues meal vouchers. '
              'The setting is remembered when the app restarts.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<PosOrderMode>(
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
                  ref.read(posModeControllerProvider.notifier).setMode(
                    selection.first,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          if (state.isFunctionMode)
            _FunctionSelection(
              state: state,
              controller: ref.read(posModeControllerProvider.notifier),
            ),
        ],
      ),
    );
  }
}

class _FunctionSelection extends ConsumerWidget {
  const _FunctionSelection({required this.state, required this.controller});

  final PosModeState state;
  final PosModeController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = state.selectedFunction;
    final blocked = state.problem != FunctionSelectionProblem.none;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'function Settings',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        if (selected != null && !blocked)
          _FunctionStatusCard(
            icon: Icons.event_available,
            title: selected.functionName,
            subtitle:
                '${selected.windowLabel} • '
                '${selected.ratePerVoucher.toStringAsFixed(2)} per voucher',
            background: theme.colorScheme.primaryContainer,
            action: TextButton.icon(
              onPressed: state.loading ? null : () => _openPicker(context),
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('Change'),
            ),
          )
        else
          _FunctionStatusCard(
            fontColor:Colors.white,
            icon: blocked ? Icons.error_outline : Icons.event_busy,
            iconColor: blocked ? theme.colorScheme.surfaceBright : null,
            title: blocked
                ? 'Function mode blocked'
                : 'No work function selected',
            subtitle:
                state.message ??
                'Choose a function before taking orders. '
                    'Only functions running right now are listed.',
            background: blocked
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.surfaceContainerHighest,
            action: FilledButton.icon(
              onPressed: state.loading ? null : () => _openPicker(context),
              icon: state.loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.playlist_add_check, size: 18),
              label: const Text('Select', style: TextStyle(fontSize: 16,color: Colors.white)),
            ),
          ),
        if (selected != null && !blocked)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: controller.clearSelection,
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Clear selection', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openPicker(BuildContext context) async {
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


class _FunctionStatusCard extends StatelessWidget {
  const _FunctionStatusCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.background,
    required this.action,
    this.iconColor,
    this.fontColor
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final Color? fontColor;
  final Color background;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: fontColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(subtitle, style: theme.textTheme.bodyLarge!.copyWith(
                        color: fontColor,
                      ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(alignment: Alignment.centerRight, child: action),
            ),
          ],
        ),
      ),
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
                        '${fn.windowLabel} • '
                        '${fn.ratePerVoucher.toStringAsFixed(2)} per voucher',
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
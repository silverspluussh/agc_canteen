import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../core/di/injection_container.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/staff.model.dart';
import '../../services/activity_log_service.dart';

class StaffManagementPage extends ConsumerStatefulWidget {
  const StaffManagementPage({super.key});

  @override
  ConsumerState<StaffManagementPage> createState() =>
      _StaffManagementPageState();
}

class _StaffManagementPageState extends ConsumerState<StaffManagementPage> {
  final List<_StaffWithFingerprint> _staffList = [
    _StaffWithFingerprint(
      staff: const Staff(
        id: 'staff_1',
        firstName: 'Kwame',
        lastName: 'Asante',
        phone: '0244123456',
        email: 'kwame@agc.com',
      ),
      hasFingerprint: true,
      fingerprintId: 'fp_001',
    ),
    _StaffWithFingerprint(
      staff: const Staff(
        id: 'staff_2',
        firstName: 'Ama',
        lastName: 'Mensah',
        phone: '0244987654',
        email: 'ama@agc.com',
      ),
      hasFingerprint: false,
    ),
    _StaffWithFingerprint(
      staff: const Staff(
        id: 'staff_3',
        firstName: 'Yaw',
        lastName: 'Boateng',
        phone: '0208123456',
        email: 'yaw@agc.com',
      ),
      hasFingerprint: true,
      fingerprintId: 'fp_002',
    ),
    _StaffWithFingerprint(
      staff: const Staff(
        id: 'staff_4',
        firstName: 'Akosua',
        lastName: 'Darko',
        phone: '0276234567',
        email: 'akosua@agc.com',
      ),
      hasFingerprint: false,
    ),
    _StaffWithFingerprint(
      staff: const Staff(
        id: 'staff_5',
        firstName: 'Kofi',
        lastName: 'Agyeman',
        phone: '0501234567',
        email: 'kofi@agc.com',
      ),
      hasFingerprint: true,
      fingerprintId: 'fp_003',
    ),
  ];

  final _searchCtrl = TextEditingController();
  String _query = '';
  bool? _fingerprintFilter;
  bool _isEnrolling = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(
      () => setState(() => _query = _searchCtrl.text.trim().toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_StaffWithFingerprint> get _filtered => _staffList.where((s) {
        final q = _query;
        final name = '${s.staff.firstName} ${s.staff.lastName}'.toLowerCase();
        final matchQ = q.isEmpty ||
            name.contains(q) ||
            s.staff.id.toLowerCase().contains(q);
        final matchF =
            _fingerprintFilter == null || s.hasFingerprint == _fingerprintFilter;
        return matchQ && matchF;
      }).toList();

  void _showFilterModal() {
    bool? tempFilter = _fingerprintFilter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final l10n = AppLocalizations.of(context);
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.filter,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    l10n.status,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterChip(
                        label: l10n.all,
                        selected: tempFilter == null,
                        onSelected: (_) =>
                            setModalState(() => tempFilter = null),
                      ),
                      _FilterChip(
                        label: l10n.fingerprintRegistered,
                        selected: tempFilter == true,
                        onSelected: (_) =>
                            setModalState(() => tempFilter = true),
                      ),
                      _FilterChip(
                        label: l10n.noFingerprintRegistered,
                        selected: tempFilter == false,
                        onSelected: (_) =>
                            setModalState(() => tempFilter = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        setState(() => _fingerprintFilter = tempFilter);
                        Navigator.pop(context);
                      },
                      child: Text(l10n.applyFilters),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final items = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.staffManagement),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _SearchBar(
                  controller: _searchCtrl,
                  hint: l10n.searchOrderHint,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.tune, color: colorScheme.primary),
                    onPressed: _showFilterModal,
                  ),
                ),
              ),
            ],
          ),
          if (items.isNotEmpty)
            _SummaryStrip(
              '${items.length} ${l10n.staffManagement}',
              '${_staffList.where((s) => s.hasFingerprint).length} ${l10n.fingerprintRegistered}',
            ),
          Expanded(
            child: items.isEmpty
                ? _EmptyView(Icons.group_outlined, l10n.noResults)
                : ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 10),
                    itemBuilder: (context, index) {
                      final entry = items[index];
                      return _StaffCard(
                        entry: entry,
                        onAddFingerprint: () => _showEnrollmentDialog(entry),
                        onDeleteFingerprint: () =>
                            _showDeleteConfirmation(entry),
                        isEnrolling: _isEnrolling,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showEnrollmentDialog(_StaffWithFingerprint entry) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.fingerprint, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.enrollFingerprint),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.fingerprint,
                  size: 80,
                  color: colorScheme.primary.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.placeFingerToEnroll,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '${entry.staff.firstName} ${entry.staff.lastName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              FilledButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await _enrollFingerprint(entry, setDialogState);
                },
                icon: const Icon(Icons.fingerprint),
                label: Text(l10n.enrollFingerprint),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(_StaffWithFingerprint entry) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(l10n.deleteFingerprint),
        content: Text(l10n.deleteFingerprintConfirm),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              setState(() {
                entry.hasFingerprint = false;
                entry.fingerprintId = null;
              });
              getIt<ActivityLogService>().log(
                type: 'fingerprint_deleted',
                message: 'Fingerprint deleted for staff: ${entry.staff.firstName} ${entry.staff.lastName}',
                actorType: 'admin',
                actorId: entry.staff.id,
                actorName: '${entry.staff.firstName} ${entry.staff.lastName}',
                sourceTable: 'fingerprints',
                recordId: entry.fingerprintId,
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.deleteFingerprint)),
              );
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _enrollFingerprint(
    _StaffWithFingerprint entry,
    void Function(VoidCallback) setDialogState,
  ) async {
    setState(() => _isEnrolling = true);

    try {
      final authService = ref.read(fingerprintAuthProvider);

      final isAvailable = await authService.isAvailable;
      if (!isAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint scanner not available'),
            ),
          );
        }
        return;
      }

      final fingerprintId = await authService.enroll(entry.staff.id);

      if (fingerprintId != null) {
        setState(() {
          entry.hasFingerprint = true;
          entry.fingerprintId = fingerprintId;
        });
        getIt<ActivityLogService>().log(
          type: 'fingerprint_enrolled',
          message: 'Fingerprint enrolled for staff: ${entry.staff.firstName} ${entry.staff.lastName}',
          actorType: 'admin',
          actorId: entry.staff.id,
          actorName: '${entry.staff.firstName} ${entry.staff.lastName}',
          sourceTable: 'fingerprints',
          recordId: fingerprintId,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fingerprint enrolled successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint enrollment failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enrollment error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isEnrolling = false);
      }
    }
  }
}

class _StaffWithFingerprint {
  final Staff staff;
  bool hasFingerprint;
  String? fingerprintId;

  _StaffWithFingerprint({
    required this.staff,
    required this.hasFingerprint,
    this.fingerprintId,
  });
}

class _StaffCard extends StatelessWidget {
  final _StaffWithFingerprint entry;
  final VoidCallback onAddFingerprint;
  final VoidCallback onDeleteFingerprint;
  final bool isEnrolling;

  const _StaffCard({
    required this.entry,
    required this.onAddFingerprint,
    required this.onDeleteFingerprint,
    required this.isEnrolling,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return  Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                '${entry.staff.firstName[0]}${entry.staff.lastName[0]}',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.staff.firstName} ${entry.staff.lastName}',
                    style: Theme.of(  context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        entry.staff.id,
                        style: Theme.of(  context).textTheme.bodyMedium!.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                      ),
                      SizedBox(width: 12),
                      Row(
                    children: [
                      Icon(
                        entry.hasFingerprint
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 15,
                        color: entry.hasFingerprint
                            ? Colors.green
                            : Colors.red.shade300,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        entry.hasFingerprint
                            ? l10n.fingerprintRegistered
                            : l10n.noFingerprintRegistered,
                        style: TextStyle(
                          fontSize: 12,
                          color: entry.hasFingerprint
                              ? Colors.green.shade700
                              : Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                    ],
                  ),
                  
                ],
              ),
            ),
          
          SizedBox(width: 10,),
            if (entry.hasFingerprint)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: colorScheme.error,
                tooltip: l10n.deleteFingerprint,
                onPressed: isEnrolling ? null : onDeleteFingerprint,
              ),
            IconButton.filled(
              icon: Icon(entry.hasFingerprint ? Icons.fingerprint : Icons.add,color: Colors.white,),
              tooltip: l10n.addFingerprint,
              onPressed: isEnrolling ? null : onAddFingerprint,
            ),
          ],
        ),
      
    );
  }
}

// ── Shared widgets ──────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13),
          prefixIcon: const Icon(Icons.search, size: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip(this.left, this.right);
  final String left, right;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(102),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            right,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 56,
            color: Theme.of(context).colorScheme.outline.withAlpha(102),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

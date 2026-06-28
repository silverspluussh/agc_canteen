import 'package:agc_canteen/models/staff.model.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/database/app_database.dart';
import 'fingerprint_enrollment_sheet.dart';

class StaffManagementPage extends ConsumerStatefulWidget {
  const StaffManagementPage({super.key});

  @override
  ConsumerState<StaffManagementPage> createState() =>
      _StaffManagementPageState();
}

class _StaffManagementPageState extends ConsumerState<StaffManagementPage> {
  List<_StaffWithFingerprint> _staffList = [];
  bool _isLoading = true;

  final _searchCtrl = TextEditingController();
  String _query = '';
  bool? _fingerprintFilter;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(
      () => setState(() => _query = _searchCtrl.text.trim().toLowerCase()),
    );
    _loadStaffData();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadStaffData() async {
    final db = ref.read(databaseProvider);
    final staffList = await db.getAllStaff();
    final allFingerprints = await db.getActiveBioData();

    final items = staffList.map((s) {
      final staffFps = allFingerprints.where((f) => f.staffId == s.id).toList();
      return _StaffWithFingerprint(
        staff: s,
        hasFingerprint: staffFps.isNotEmpty,
        fingerprints: staffFps,
      );
    }).toList();

    if (mounted) {
      setState(() {
        _staffList = items;
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshStaffData() async {
    setState(() => _isLoading = true);
    await _loadStaffData();
  }

  List<_StaffWithFingerprint> get _filtered => _staffList.where((s) {
    final q = _query;
    final name = '${s.staff.firstName} ${s.staff.lastName}'.toLowerCase();
    final matchQ =
        q.isEmpty || name.contains(q) || s.staff.id.toString().contains(q);
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
                  PrimaryButton(
                    onPressed: () {
                      setState(() => _fingerprintFilter = tempFilter);
                      Navigator.pop(context);
                    },
                    label: Text(
                      l10n.applyFilters,
                      style: TextStyle(color: Colors.white),
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
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        title: Text(l10n.staffManagement),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                      : RefreshIndicator(
                          onRefresh: () async {
                            _loadStaffData();
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.all(10),
                            itemCount: items.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 10),
                            itemBuilder: (context, index) {
                              final entry = items[index];
                              return _StaffCard(
                                entry: entry,
                                onAddFingerprint: () async {
                                  final result =
                                      await FingerprintEnrollmentSheet.show(
                                        context,
                                        entry.staff,
                                      );
                                  if (result == true) {
                                    _refreshStaffData();
                                  }
                                },
                                onViewFingerprints: () =>
                                    _showFingerprintsSheet(entry),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  void _showFingerprintsSheet(_StaffWithFingerprint entry) {
    final colorScheme = Theme.of(context).colorScheme;
    final fingerprints = entry.fingerprints;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.25,
          maxChildSize: 0.75,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${entry.staff.firstName} ${entry.staff.lastName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.fingerprint,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${fingerprints.length} fingerprint${fingerprints.length == 1 ? '' : 's'} stored',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  if (fingerprints.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: Text('No fingerprints stored')),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        itemCount: fingerprints.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final fp = fingerprints[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.primaryContainer,
                              child: Icon(
                                Icons.fingerprint,
                                color: colorScheme.primary,
                              ),
                            ),
                            title: Text(_fingerLabelFromString(fp.finger)),
                            subtitle: Text(
                              'ID: ${fp.id}  •  ${_formatDate(fp.createdAt)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                Navigator.pop(ctx);
                                await _deleteSingleFingerprint(fp);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  const Divider(),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final result = await FingerprintEnrollmentSheet.show(
                        context,
                        entry.staff,
                      );
                      if (result == true) {
                        _refreshStaffData();
                      }
                    },
                    prefixChild: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add Fingerprint',
                      style: TextStyle(color: Colors.white),
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

  Future<void> _deleteSingleFingerprint(BioDataEntry fp) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.deleteFingerprint),
        content: Text(
          'Delete ${_fingerLabelFromString(fp.finger)} fingerprint (ID: ${fp.id})?',
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          DestructiveButton(
            width: 120,
            onPressed: () => Navigator.pop(ctx, true),
            label: Text(l10n.delete, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final authService = ref.read(fingerprintAuthProvider);
    await authService.deleteFingerprint(fp.id);
    await _refreshStaffData();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.deleteFingerprint)));
    }
  }

  String _fingerLabelFromString(String finger) {
    switch (finger) {
      case 'thumb':
        return 'Thumb';
      case 'indexFinger':
        return 'Index Finger';
      case 'middle':
        return 'Middle Finger';
      case 'ring':
        return 'Ring Finger';
      case 'little':
        return 'Pinky';
      default:
        return finger;
    }
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }
}

class _StaffWithFingerprint {
  final StaffData staff;
  bool hasFingerprint;
  List<BioDataEntry> fingerprints;

  _StaffWithFingerprint({
    required this.staff,
    required this.hasFingerprint,
    required this.fingerprints,
  });
}

class _StaffCard extends StatelessWidget {
  final _StaffWithFingerprint entry;
  final VoidCallback onAddFingerprint;
  final VoidCallback onViewFingerprints;

  const _StaffCard({
    required this.entry,
    required this.onAddFingerprint,
    required this.onViewFingerprints,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
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
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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

          SizedBox(width: 10),
          if (entry.hasFingerprint)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: colorScheme.error,
              tooltip: l10n.deleteFingerprint,
              onPressed: onViewFingerprints,
            ),
          IconButton.filled(
            icon: Icon(
              entry.hasFingerprint ? Icons.fingerprint : Icons.add,
              color: Colors.white,
            ),
            tooltip: entry.hasFingerprint
                ? l10n.fingerprintRegistered
                : l10n.addFingerprint,
            onPressed: entry.hasFingerprint
                ? onViewFingerprints
                : onAddFingerprint,
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
          Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

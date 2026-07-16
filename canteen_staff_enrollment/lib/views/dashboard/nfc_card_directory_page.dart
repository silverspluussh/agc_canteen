import 'package:canteen_staff_enrollment/controllers/injection_container.dart';
import 'package:canteen_staff_enrollment/controllers/nfc_card_controller.dart';
import 'package:canteen_staff_enrollment/core/theme/app_colors.dart';
import 'package:canteen_staff_enrollment/models/employee_type.enum.dart';
import 'package:canteen_staff_enrollment/models/nfc_card.model.dart';
import 'package:canteen_staff_enrollment/repos/nfc_card_service.dart';
import 'package:canteen_staff_enrollment/views/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NfcCardDirectoryPage extends ConsumerStatefulWidget {
  const NfcCardDirectoryPage({super.key});

  @override
  ConsumerState<NfcCardDirectoryPage> createState() =>
      _NfcCardDirectoryPageState();
}

class _NfcCardDirectoryPageState
    extends ConsumerState<NfcCardDirectoryPage> {
  bool _hasFilters = false;
  String? _statusFilter;
  String? _typeFilter;

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(filteredNfcCardListProvider);
    final searchQuery = ref.watch(nfcCardSearchQueryProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) =>
                        ref.read(nfcCardSearchQueryProvider.notifier).state =
                            val,
                    decoration: InputDecoration(
                      hintText: 'Search by code...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => ref
                                  .read(nfcCardSearchQueryProvider.notifier)
                                  .state = '',
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Badge(
                  isLabelVisible: _hasFilters,
                  label: Text(
                    '${(_statusFilter != null ? 1 : 0) + (_typeFilter != null ? 1 : 0)}',
                    style:
                        const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => _NfcFilterSheet(
                          statusFilter: _statusFilter,
                          typeFilter: _typeFilter,
                          onApply: (status, type) {
                            setState(() {
                              _statusFilter = status;
                              _typeFilter = type;
                              _hasFilters =
                                  status != null || type != null;
                            });
                            ref
                                .read(nfcCardStatusFilterProvider.notifier)
                                .state = status;
                            ref
                                .read(nfcCardTypeFilterProvider.notifier)
                                .state = type;
                          },
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.filter_list,
                      color: _hasFilters
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    tooltip: 'Filter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_hasFilters)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildActiveFilterChips(),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(nfcCardListProvider);
                  await ref.read(nfcCardListProvider.future);
                },
                child: cardsAsync.when(
                  data: (cards) {
                    if (cards.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.credit_card_outlined,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No NFC cards found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () => _showCreateCardSheet(),
                              icon: const Icon(Icons.add),
                              label: const Text('Create a card'),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: cards.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 5),
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return Card(
                          margin: EdgeInsets.zero,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (_) => _NfcCardActionSheet(
                                  card: card,
                                  onChanged: () {
                                    ref.invalidate(nfcCardListProvider);
                                  },
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 17,
                                    backgroundColor: card.status == 'active'
                                        ? AppColors.success
                                            .withValues(alpha: 0.1)
                                        : AppColors.error
                                            .withValues(alpha: 0.1),
                                    child: Icon(
                                      Icons.credit_card,
                                      
                                      color: card.status == 'active'
                                          ? AppColors.success
                                          : AppColors.error,
                                      size: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                           card.tagId ??card.code ?? '---',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      
                                        if (card.assignedTo != null)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              '${card.assignedTo!.name} (${card.assignedTo!.type})',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                          ), 
                                          if (card.assignedTo == null)
                                          Text("Not assigned",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:Colors.red,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),

                                      ],
                                    ),
                                  ),
                                
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: card.status == 'active'
                                              ? const Color(0xFF2E7D32)
                                                  .withValues(alpha: 0.1)
                                              : const Color(0xFFD32F2F)
                                                  .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          card.status == 'active'
                                              ? 'Active'
                                              : 'Inactive',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: card.status == 'active'
                                                ? const Color(0xFF2E7D32)
                                                : const Color(0xFFD32F2F),
                                          ),
                                        ),
                                      ),
                                     
                                   
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.35),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                      child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text('Failed to load NFC cards: $err'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              ref.refresh(nfcCardListProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateCardSheet(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (_statusFilter != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InputChip(
                label: Text(
                  'Status: $_statusFilter',
                  style: const TextStyle(fontSize: 12),
                ),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () {
                  setState(() {
                    _statusFilter = null;
                    _hasFilters = _typeFilter != null;
                  });
                  ref
                      .read(nfcCardStatusFilterProvider.notifier)
                      .state = null;
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          if (_typeFilter != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InputChip(
                label: Text(
                  'Type: $_typeFilter',
                  style: const TextStyle(fontSize: 12),
                ),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () {
                  setState(() {
                    _typeFilter = null;
                    _hasFilters = _statusFilter != null;
                  });
                  ref
                      .read(nfcCardTypeFilterProvider.notifier)
                      .state = null;
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          if (_hasFilters)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _statusFilter = null;
                    _typeFilter = null;
                    _hasFilters = false;
                  });
                  ref
                      .read(nfcCardStatusFilterProvider.notifier)
                      .state = null;
                  ref
                      .read(nfcCardTypeFilterProvider.notifier)
                      .state = null;
                },
                child: const Text('Clear all',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }

  void _showCreateCardSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CreateCardSheet(
        onCreated: () => ref.invalidate(nfcCardListProvider),
      ),
    );
  }
}

// ─── Filter Sheet ─────────────────────────────────────────────────────────────

class _NfcFilterSheet extends StatefulWidget {
  final String? statusFilter;
  final String? typeFilter;
  final void Function(String? status, String? type) onApply;

  const _NfcFilterSheet({
    required this.statusFilter,
    required this.typeFilter,
    required this.onApply,
  });

  @override
  State<_NfcFilterSheet> createState() => _NfcFilterSheetState();
}

class _NfcFilterSheetState extends State<_NfcFilterSheet> {
  String? _status;
  String? _type;

  @override
  void initState() {
    super.initState();
    _status = widget.statusFilter;
    _type = widget.typeFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Filter NFC Cards',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String?>(
            value: _status,
            decoration: InputDecoration(
              labelText: 'Status',
              prefixIcon: const Icon(Icons.radio_button_checked, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
            items: const [
              DropdownMenuItem<String?>(
                value: null,
                child: Text('All', style: TextStyle(color: Colors.grey)),
              ),
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
            ],
            onChanged: (val) => setState(() => _status = val),
            isExpanded: true,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String?>(
            value: _type,
            decoration: InputDecoration(
              labelText: 'Assigned Type',
              prefixIcon: const Icon(Icons.person_outline, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('All', style: TextStyle(color: Colors.grey)),
              ),
              ...EmployeeType.values.map((e) => DropdownMenuItem(
                    value: e.name,
                    child: Text(e.entityName),
                  )),
            ],
            onChanged: (val) => setState(() => _type = val),
            isExpanded: true,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _status = null;
                      _type = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.onApply(_status, _type);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Create Card Sheet ────────────────────────────────────────────────────────

class _CreateCardSheet extends StatefulWidget {
  final VoidCallback onCreated;

  const _CreateCardSheet({required this.onCreated});

  @override
  State<_CreateCardSheet> createState() => _CreateCardSheetState();
}

class _CreateCardSheetState extends State<_CreateCardSheet> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _tagIdCtrl = TextEditingController();
  final _reversedCodeCtrl = TextEditingController();
  final _referenceIdCtrl = TextEditingController();
  final _issuedDateCtrl = TextEditingController();

  String? _assignedToType;
  bool _isCreating = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _tagIdCtrl.dispose();
    _reversedCodeCtrl.dispose();
    _referenceIdCtrl.dispose();
    _issuedDateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Create NFC Card',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _codeCtrl,
              decoration: InputDecoration(
                labelText: 'Code',
                hintText: 'e.g. 14157161536',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tagIdCtrl,
              decoration: InputDecoration(
                labelText: 'Tag ID',
                hintText: 'e.g. TAG001',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reversedCodeCtrl,
              decoration: InputDecoration(
                labelText: 'Reversed Code',
                hintText: 'e.g. 63516175141',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _issuedDateCtrl,
              decoration: InputDecoration(
                labelText: 'Issued Date (optional)',
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today, size: 20),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      _issuedDateCtrl.text =
                          '${date.toIso8601String().split('T').first}T00:00:00.000Z';
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              value: _assignedToType,
              decoration: InputDecoration(
                labelText: 'Assign To (optional)',
                prefixIcon:
                    const Icon(Icons.person_outline, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Not assigned',
                      style: TextStyle(color: Colors.grey)),
                ),
                ...EmployeeType.values.map((e) => DropdownMenuItem(
                      value: e.name,
                      child: Text(e.entityName),
                    )),
              ],
              onChanged: (val) =>
                  setState(() => _assignedToType = val),
              isExpanded: true,
            ),
            if (_assignedToType != null) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _referenceIdCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Reference ID',
                  hintText: 'Enter entity ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) {
                  if (_assignedToType != null &&
                      (val == null || val.isEmpty)) {
                    return 'Reference ID is required when assigning';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: _isCreating ? null : _createCard,
                label: Text(
                  _isCreating ? 'Creating...' : 'Create Card',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                prefixChild: const Icon(Icons.add,
                    size: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createCard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);
    try {
      final service = getIt<NfcCardService>();
      await service.createCard(
        code: _codeCtrl.text.isNotEmpty ? _codeCtrl.text : null,
        tagId: _tagIdCtrl.text.isNotEmpty ? _tagIdCtrl.text : null,
        reversedCode: _reversedCodeCtrl.text.isNotEmpty
            ? _reversedCodeCtrl.text
            : null,
        assignedToType: _assignedToType,
        referenceId: _referenceIdCtrl.text.isNotEmpty
            ? int.tryParse(_referenceIdCtrl.text)
            : null,
        issuedDate: _issuedDateCtrl.text.isNotEmpty
            ? _issuedDateCtrl.text
            : null,
      );
      if (mounted) {
        Navigator.pop(context);
        widget.onCreated();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('NFC card created successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create card: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }
}

// ─── Card Action Sheet ────────────────────────────────────────────────────────

class _NfcCardActionSheet extends StatelessWidget {
  final NfcCard card;
  final VoidCallback onChanged;

  const _NfcCardActionSheet({
    required this.card,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                card.code ?? card.tagId ?? 'Card #${card.id}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: card.status == 'active'
                      ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
                      : const Color(0xFFD32F2F).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      card.status == 'active'
                          ? Icons.check_circle
                          : Icons.cancel,
                      size: 16,
                      color: card.status == 'active'
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFD32F2F),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      card.status == 'active' ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: card.status == 'active'
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (card.tagId != null)
            Text(
              'Tag: ${card.tagId}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          if (card.assignedTo != null) ...[
            const SizedBox(height: 4),
            Text(
              'Assigned to: ${card.assignedTo!.name} (${card.assignedTo!.type})',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ] else
            Text(
              'Not assigned',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlineButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditCardSheet(context);
              },
              prefixChild: const Icon(Icons.edit_outlined,
                  size: 18, color: AppColors.gold600),
              label: const Text(
                'Edit Card',
                style: TextStyle(
                  color: AppColors.gold600,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
             if (!card.isAssigned)
          SizedBox(
            width: double.infinity,
            child: OutlineButton(
              onPressed: () {
                Navigator.pop(context);
                _showAssignSheet(context);
              },
              prefixChild: const Icon(Icons.person_add_outlined,
                  size: 18, color: AppColors.gold600),
              label: const Text(
                'Assign Card',
                style: TextStyle(
                  color: AppColors.gold600,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (card.isAssigned) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlineButton(
                onPressed: () {
                  Navigator.pop(context);
                  _confirmUnassign(context);
                },
                prefixChild: const Icon(Icons.person_remove_outlined,
                    size: 18, color: AppColors.warning),
                label: const Text(
                  'Unassign Card',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        
         
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: DestructiveButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmDelete(context);
              },
              label: const Text(
                'Delete Card',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              prefixChild: const Icon(Icons.delete_outline,
                  size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditCardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EditCardSheet(
        card: card,
        onUpdated: onChanged,
      ),
    );
  }

  void _showAssignSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AssignCardSheet(
        card: card,
        onAssigned: onChanged,
      ),
    );
  }



  void _confirmUnassign(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unassign Card'),
        content: Text(
          'Remove assignment from card ${card.code ?? card.tagId ?? '#${card.id}'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final service = getIt<NfcCardService>();
                await service.unassignCard(card.id);
                onChanged();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Card unassigned successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to unassign: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Unassign', style: TextStyle(color: AppColors.warning)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Card'),
        content: Text(
            'Are you sure you want to delete card ${card.code ?? card.tagId ?? '#${card.id}'}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          DestructiveButton(
            width: 120,
           
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final service = getIt<NfcCardService>();
                await service.deleteCard(card.id);
                onChanged();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Card deleted successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            label: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Edit Card Sheet ──────────────────────────────────────────────────────────

class _EditCardSheet extends StatefulWidget {
  final NfcCard card;
  final VoidCallback onUpdated;

  const _EditCardSheet({required this.card, required this.onUpdated});

  @override
  State<_EditCardSheet> createState() => _EditCardSheetState();
}

class _EditCardSheetState extends State<_EditCardSheet> {
  late final TextEditingController _codeCtrl;
  late final TextEditingController _tagIdCtrl;
  late final TextEditingController _reversedCodeCtrl;
  late final TextEditingController _issuedDateCtrl;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _codeCtrl = TextEditingController(text: widget.card.code);
    _tagIdCtrl = TextEditingController(text: widget.card.tagId);
    _reversedCodeCtrl =
        TextEditingController(text: widget.card.reversedCode);
    _issuedDateCtrl = TextEditingController(
      text: widget.card.issuedDate?.toIso8601String(),
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _tagIdCtrl.dispose();
    _reversedCodeCtrl.dispose();
    _issuedDateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Edit Card',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _codeCtrl,
            decoration: InputDecoration(
              labelText: 'Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tagIdCtrl,
            decoration: InputDecoration(
              labelText: 'Tag ID',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _reversedCodeCtrl,
            decoration: InputDecoration(
              labelText: 'Reversed Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _issuedDateCtrl,
            decoration: InputDecoration(
              labelText: 'Issued Date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, size: 20),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        widget.card.issuedDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    _issuedDateCtrl.text =
                        '${date.toIso8601String().split('T').first}T00:00:00.000Z';
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: _isUpdating ? null : _updateCard,
              label: Text(
                _isUpdating ? 'Updating...' : 'Update Card',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              prefixChild: const Icon(Icons.save,
                  size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateCard() async {
    setState(() => _isUpdating = true);
    try {
      final service = getIt<NfcCardService>();
      await service.updateCard(
        widget.card.id,
        code: _codeCtrl.text.isNotEmpty ? _codeCtrl.text : null,
        tagId: _tagIdCtrl.text.isNotEmpty ? _tagIdCtrl.text : null,
        reversedCode: _reversedCodeCtrl.text.isNotEmpty
            ? _reversedCodeCtrl.text
            : null,
        issuedDate: _issuedDateCtrl.text.isNotEmpty
            ? _issuedDateCtrl.text
            : null,
      );
      if (mounted) {
        Navigator.pop(context);
        widget.onUpdated();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }
}

// ─── Assign Card Sheet ────────────────────────────────────────────────────────

class _AssignCardSheet extends StatefulWidget {
  final NfcCard card;
  final VoidCallback onAssigned;

  const _AssignCardSheet({required this.card, required this.onAssigned});

  @override
  State<_AssignCardSheet> createState() => _AssignCardSheetState();
}

class _AssignCardSheetState extends State<_AssignCardSheet> {
  String? _selectedType;
  final _refIdCtrl = TextEditingController();
  bool _isAssigning = false;

  @override
  void dispose() {
    _refIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Assign Card',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Assigning: ${widget.card.code ?? widget.card.tagId}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: InputDecoration(
              labelText: 'Employee Type',
              prefixIcon:
                  const Icon(Icons.person_outline, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
            items: EmployeeType.values
                .map((e) => DropdownMenuItem(
                      value: e.name,
                      child: Text(e.entityName),
                    ))
                .toList(),
            onChanged: (val) => setState(() => _selectedType = val),
            isExpanded: true,
            validator: (val) =>
                val == null ? 'Please select a type' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _refIdCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Reference ID',
              hintText: 'Enter the entity ID',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: _isAssigning ? null : _assignCard,
              label: Text(
                _isAssigning ? 'Assigning...' : 'Assign Card',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              prefixChild: const Icon(Icons.person_add,
                  size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _assignCard() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an employee type'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    final refId = int.tryParse(_refIdCtrl.text);
    if (refId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Reference ID'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isAssigning = true);
    try {
      final service = getIt<NfcCardService>();
      await service.updateCard(
        widget.card.id,
        code: widget.card.code,
        tagId: widget.card.tagId,
        assignedToType: _selectedType,
        referenceId: refId,
      );
      if (mounted) {
        Navigator.pop(context);
        widget.onAssigned();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card assigned successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to assign: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAssigning = false);
    }
  }
}

// ─── Status Toggle Sheet ──────────────────────────────────────────────────────

class _StatusSheet extends StatelessWidget {
  final NfcCard card;
  final VoidCallback onChanged;

  const _StatusSheet({required this.card, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currentStatus = card.status;
    final newStatus =
        currentStatus == 'active' ? 'inactive' : 'active';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            currentStatus == 'active'
                ? Icons.toggle_off_outlined
                : Icons.toggle_on_outlined,
            size: 64,
            color: currentStatus == 'active'
                ? AppColors.success
                : AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Change status to "$newStatus"?',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Card: ${card.code ?? card.tagId ?? '#${card.id}'}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    try {
                      final service = getIt<NfcCardService>();
                      await service.updateCardStatus(
                          card.id, newStatus);
                      onChanged();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Status changed to $newStatus'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Failed to update status: $e'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Set as $newStatus'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

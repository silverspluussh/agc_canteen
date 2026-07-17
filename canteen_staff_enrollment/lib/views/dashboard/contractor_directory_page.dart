import 'package:canteen_staff_enrollment/models/company.model.dart';
import 'package:canteen_staff_enrollment/models/contractor.model.dart';
import 'package:canteen_staff_enrollment/views/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/contractor_controller.dart';
import '../../controllers/providers.dart';
import '../../core/theme/app_colors.dart';
import 'contractor_biodata_page.dart';

class ContractorDirectoryPage extends ConsumerStatefulWidget {
  const ContractorDirectoryPage({super.key});

  @override
  ConsumerState<ContractorDirectoryPage> createState() => _ContractorDirectoryPageState();
}

class _ContractorDirectoryPageState extends ConsumerState<ContractorDirectoryPage> {
  final _searchController = TextEditingController();
  int? _selectedDepartmentId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildDepartmentFilter(AsyncValue<List<Department>> departmentsAsync) {
    final departments = departmentsAsync.value ?? [];
    return PopupMenuButton<int?>(
      tooltip: 'Filter by department',
      icon: Icon(
        Icons.business_center,
        color: _selectedDepartmentId != null
            ? Theme.of(context).colorScheme.primary
            : null,
      ),
      onSelected: (id) {
        setState(() => _selectedDepartmentId = id);
        ref.read(contractorStaffDeptFilterProvider.notifier).state = id?.toString();
      },
      itemBuilder: (context) => [
        PopupMenuItem<int?>(
          value: null,
          child: Text('All Departments',
              style: TextStyle(fontWeight: _selectedDepartmentId == null ? FontWeight.bold : null)),
        ),
        ...departments.map((d) => PopupMenuItem<int?>(
              value: d.id,
              child: Text(d.name,
                  style: TextStyle(fontWeight: _selectedDepartmentId == d.id ? FontWeight.bold : null)),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(filteredContractorStaffListProvider);
    final searchQuery = ref.watch(contractorStaffQueryProvider);
    final departmentsAsync = ref.watch(departmentListProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) =>
                        ref.read(contractorStaffQueryProvider.notifier).state = val,
                    decoration: InputDecoration(
                      hintText: 'Search contractor staff by name...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                ref.read(contractorStaffQueryProvider.notifier).state = '';
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildDepartmentFilter(departmentsAsync),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(contractorStaffListProvider);
                  await ref.read(contractorStaffListProvider.future);
                },
                child: staffAsync.when(
                  data: (staffList) {
                    if (staffList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No contractor staff found',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: staffList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final staff = staffList[index];
                        final biodata = staff.bioData ?? [];
                        final isEnrolled = biodata.isNotEmpty;

                        return Card(
                          margin: EdgeInsets.zero,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (_) => _ContractorStaffActionSheet(
                                  contractorStaff: staff,
                                  isEnrolled: isEnrolled,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1),
                                    child: Text(
                                      staff.name.isNotEmpty ? staff.name[0].toUpperCase() : '?',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          staff.name,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        if (staff.contractorName != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            staff.contractorName!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isEnrolled
                                              ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
                                              : const Color(0xFFE65100).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isEnrolled ? Icons.check_circle : Icons.pending,
                                              size: 14,
                                              color: isEnrolled
                                                  ? const Color(0xFF2E7D32)
                                                  : const Color(0xFFE65100),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isEnrolled ? 'Enrolled' : 'Pending',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isEnrolled
                                                    ? const Color(0xFF2E7D32)
                                                    : const Color(0xFFE65100),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isEnrolled) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          '${biodata.length} Finger(s)',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ],
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
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text('Failed to load contractor staff: $err'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.refresh(contractorStaffListProvider),
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
    );
  }
}

class _ContractorStaffActionSheet extends StatelessWidget {
  final ContractorStaff contractorStaff;
  final bool isEnrolled;

  const _ContractorStaffActionSheet({
    required this.contractorStaff,
    required this.isEnrolled,
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
                contractorStaff.name,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isEnrolled
                      ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
                      : const Color(0xFFE65100).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isEnrolled ? Icons.check_circle : Icons.pending,
                      size: 16,
                      color: isEnrolled
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFE65100),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isEnrolled ? 'Enrolled' : 'Not Enrolled',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isEnrolled
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFE65100),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlineButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContractorBiodataPage(contractorStaff: contractorStaff),
                  ),
                );
              },
              prefixChild: const Icon(Icons.person_outline, size: 18, color: AppColors.gold600),
              label: const Text(
                'View Contractor Biodata',
                style: TextStyle(color: AppColors.gold600, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:canteen_staff_enrollment/models/employee_type.enum.dart';
import 'package:canteen_staff_enrollment/models/staff.model.dart';
import 'package:canteen_staff_enrollment/models/staff_filter.model.dart';
import 'package:canteen_staff_enrollment/views/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/staff_controller.dart';
import '../../core/theme/app_colors.dart';
import 'biometric_enrollment_page.dart';
import 'staff_biodata_page.dart';

class StaffDirectoryPage extends ConsumerWidget {
  const StaffDirectoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(filteredStaffListProvider);
    final searchQuery = ref.watch(staffQueryProvider);
    final filter = ref.watch(staffFilterProvider);
    final biodataCounts = ref.watch(allBiodataProvider).value ?? {};

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           

            // Search + Filter Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) =>
                        ref.read(staffQueryProvider.notifier).state = val,
                    decoration: InputDecoration(
                      hintText: 'Search by name or Employee ID...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => ref
                                  .read(staffQueryProvider.notifier)
                                  .state = '',
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Badge(
                  isLabelVisible: filter.isActive,
                  label: Text(
                    '${filter.activeFilterCount}',
                    style: const TextStyle(
                        fontSize: 10, color: Colors.white),
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
                        builder: (_) => const _FilterSheet(),
                      );
                    },
                    icon: Icon(
                      Icons.filter_list,
                      color: filter.isActive
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    tooltip: 'Filter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Active filter chips
            if (filter.isActive)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ActiveFilterChips(filter: filter),
              ),

            // Staff List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(staffListProvider);
                  ref.invalidate(allBiodataProvider);
                  await Future.wait([
                    ref.read(staffListProvider.future),
                    ref.read(allBiodataProvider.future),
                  ]);
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
                              'No staff members found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: staffList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final staff = staffList[index];
                        final fingerprintCount =
                            biodataCounts[staff.id] ?? 0;
                        final isEnrolled = fingerprintCount > 0;
;                        return Card(
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
                                builder: (_) => _StaffActionSheet(
                                  staff: staff,
                                  isEnrolled: isEnrolled,
                                  onNavigateBack: () {
                                      ref.invalidate(staffListProvider);
                                      ref.invalidate(allBiodataProvider);
                                    },
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Left Initial Circle
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1),
                                    child: Text(
                                      '${staff.fullname.isNotEmpty ? staff.fullname[0] : ''}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Middle Name & ID
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          staff.fullname,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),  
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'ID: ${staff.empId}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Right: enrollment badge + chevron
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isEnrolled
                                              ? const Color(0xFF2E7D32)
                                                  .withValues(alpha: 0.1)
                                              : const Color(0xFFE65100)
                                                  .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isEnrolled
                                                  ? Icons.check_circle
                                                  : Icons.pending,
                                              size: 14,
                                              color: isEnrolled
                                                  ? const Color(0xFF2E7D32)
                                                  : const Color(0xFFE65100),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isEnrolled
                                                  ? 'Enrolled'
                                                  : 'Pending',
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
                                          '$fingerprintCount Finger(s)',
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
                        Text('Failed to load staff list: $err'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              ref.refresh(staffListProvider),
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

// ─── Active Filter Chips ────────────────────────────────────────────────────────

class _ActiveFilterChips extends ConsumerWidget {
  final StaffFilter filter;

  const _ActiveFilterChips({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kitchens = ref.watch(availableKitchensProvider);
    final departments = ref.watch(availableDepartmentsProvider);
    final companies = ref.watch(availableCompaniesProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (filter.kitchenId != null)
            _buildChip(
              context,
              label: kitchens
                  .firstWhere((e) => e.key == filter.kitchenId,
                      orElse: () => const MapEntry(-1, ''))
                  .value,
              onDeleted: () {
                ref.read(staffFilterProvider.notifier).state =
                    filter.copyWith(clearKitchen: true);
              },
            ),
          if (filter.departmentId != null)
            _buildChip(
              context,
              label: departments
                  .firstWhere((e) => e.key == filter.departmentId,
                      orElse: () => const MapEntry(-1, ''))
                  .value,
              onDeleted: () {
                ref.read(staffFilterProvider.notifier).state =
                    filter.copyWith(clearDepartment: true);
              },
            ),
          if (filter.companyId != null)
            _buildChip(
              context,
              label: companies
                  .firstWhere((e) => e.key == filter.companyId,
                      orElse: () => const MapEntry(-1, ''))
                  .value,
              onDeleted: () {
                ref.read(staffFilterProvider.notifier).state =
                    filter.copyWith(clearCompany: true);
              },
            ),
          if (filter.enrolled != null)
            _buildChip(
              context,
              label: filter.enrolled! ? 'Enrolled' : 'Not Enrolled',
              onDeleted: () {
                ref.read(staffFilterProvider.notifier).state =
                    filter.copyWith(clearEnrolled: true);
              },
            ),
          if (filter.isActive)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: TextButton(
                onPressed: () {
                  ref.read(staffFilterProvider.notifier).state =
                      filter.clearAll();
                },
                child: const Text('Clear all',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context,
      {required String label, required VoidCallback onDeleted}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InputChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 14),
        onDeleted: onDeleted,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

// ─── Filter Bottom Sheet ────────────────────────────────────────────────────────

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(staffFilterProvider);
    final kitchens = ref.watch(availableKitchensProvider);
    final departments = ref.watch(availableDepartmentsProvider);
    final companies = ref.watch(availableCompaniesProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Drag handle
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
            'Filter Staff',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),

          // Kitchen dropdown
          _buildDropdown(
            context: context,
            label: 'Kitchen',
            icon: Icons.kitchen,
            value: filter.kitchenId,
            items: kitchens,
            onChanged: (val) {
              ref.read(staffFilterProvider.notifier).state =
                  filter.copyWith(kitchenId: val);
            },
          ),
          const SizedBox(height: 16),

          // Department dropdown
          _buildDropdown(
            context: context,
            label: 'Department',
            icon: Icons.business,
            value: filter.departmentId,
            items: departments,
            onChanged: (val) {
              ref.read(staffFilterProvider.notifier).state =
                  filter.copyWith(departmentId: val);
            },
          ),
          const SizedBox(height: 16),

          // Company dropdown
          _buildDropdown(
            context: context,
            label: 'Company',
            icon: Icons.corporate_fare,
            value: filter.companyId,
            items: companies,
            onChanged: (val) {
              ref.read(staffFilterProvider.notifier).state =
                  filter.copyWith(companyId: val);
            },
          ),
          const SizedBox(height: 16),

          // Enrollment status dropdown
          DropdownButtonFormField<bool?>(
            value: filter.enrolled,
            decoration: InputDecoration(
              labelText: 'Enrollment Status',
              prefixIcon: const Icon(Icons.fingerprint, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            items: const [
              DropdownMenuItem<bool?>(
                value: null,
                child: Text('All', style: TextStyle(color: Colors.grey)),
              ),
              DropdownMenuItem<bool?>(
                value: true,
                child: Text('Enrolled'),
              ),
              DropdownMenuItem<bool?>(
                value: false,
                child: Text('Not Enrolled'),
              ),
            ],
            onChanged: (val) {
              ref.read(staffFilterProvider.notifier).state =
                  filter.copyWith(enrolled: val);
            },
            isExpanded: true,
          ),
          const SizedBox(height: 24),

          // Clear + Apply row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: filter.isActive
                      ? () {
                          ref.read(staffFilterProvider.notifier).state =
                              filter.clearAll();
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Clear Filters'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
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
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required IconData icon,
    required int? value,
    required List<MapEntry<int, String>> items,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: [
        const DropdownMenuItem<int>(
          value: null,
          child: Text('All', style: TextStyle(color: Colors.grey)),
        ),
        ...items.map(
          (e) => DropdownMenuItem<int>(
            value: e.key,
            child: Text(e.value),
          ),
        ),
      ],
      onChanged: onChanged,
      isExpanded: true,
      menuMaxHeight: 300,
    );
  }
}

// ─── Staff Action Sheet ─────────────────────────────────────────────────────────

class _StaffActionSheet extends StatelessWidget {
  final Staff staff;
  final bool isEnrolled;
  final VoidCallback onNavigateBack;

  const _StaffActionSheet({
    required this.staff,
    required this.isEnrolled,
    required this.onNavigateBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Staff name & ID
          Row(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                staff.fullname,
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
          const SizedBox(height: 4),
          Text(
            'Employee ID: ${staff.empId}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),

          const SizedBox(height: 24),

          // View Staff Biodata button
          SizedBox(
            width: double.infinity,
            child: OutlineButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StaffBiodataPage(staff: staff),
                  ),
                ).then((_) => onNavigateBack());
              },
              prefixChild: const Icon(Icons.person_outline,
                  size: 18, color: AppColors.gold600),
              label: const Text(
                'View Staff Biodata',
                style: TextStyle(
                  color: AppColors.gold600,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Enroll Staff / Add Fingerprint button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: () {
                final employeeType = EmployeeType.values.firstWhere(
                  (e) => e.name == staff.employeeType,
                  orElse: () => EmployeeType.permanent,
                );
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BiometricEnrollmentPage(
                      referenceId: staff.id,
                      employeeType: employeeType,
                      displayName: staff.fullname,
                      subtitle: 'Employee ID: ${staff.empId}',
                      existingBioData: staff.bioData,
                      onEnrolled: onNavigateBack,
                    ),
                  ),
                );
              },
              label: Text(
                isEnrolled ? 'Add Fingerprint' : 'Enroll Staff',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              prefixChild: Icon(
                isEnrolled ? Icons.add : Icons.fingerprint,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

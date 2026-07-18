import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';

class DepartmentDropdown extends ConsumerWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const DepartmentDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departmentsAsync = ref.watch(departmentsProvider);
    final departments = departmentsAsync.asData?.value ?? [];
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: cs.primary, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          isExpanded: true,
          value: value,
          hint: Text(
            'Select Department (required)',
            style: TextStyle(color: cs.primary.withOpacity(0.7)),
          ),
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text('All Departments'),
            ),
            ...departments.map(
              (dep) => DropdownMenuItem<int?>(
                value: dep.id,
                child: Text(dep.name),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

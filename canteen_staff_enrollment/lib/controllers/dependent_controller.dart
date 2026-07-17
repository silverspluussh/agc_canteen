import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/dependent.model.dart';
import '../repos/dependent_service.dart';
import 'injection_container.dart';

final dependentDeptFilterProvider = StateProvider<String?>((ref) => null);

final dependentListProvider = FutureProvider<List<Dependent>>((ref) async {
  final deptId = ref.watch(dependentDeptFilterProvider);
  final service = getIt<DependentService>();
  return await service.getAllDependents(limit: 2500, departmentId: deptId);
});

final dependentQueryProvider = StateProvider<String>((ref) => '');

final filteredDependentListProvider =
    Provider.autoDispose<AsyncValue<List<Dependent>>>((ref) {
  final dependentAsync = ref.watch(dependentListProvider);
  final query = ref.watch(dependentQueryProvider).trim().toLowerCase();

  return dependentAsync.whenData((list) {
    if (query.isEmpty) return list;
    return list
        .where((d) => d.fullname.toLowerCase().contains(query))
        .toList();
  });
});

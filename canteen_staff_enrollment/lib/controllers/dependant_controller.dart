import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/dependant.model.dart';
import '../repos/dependant_service.dart';
import 'injection_container.dart';

final dependantListProvider = FutureProvider<List<Dependant>>((ref) async {
  final service = getIt<DependantService>();
  return await service.getAllDependants();
});

final dependantQueryProvider = StateProvider<String>((ref) => '');

final filteredDependantListProvider =
    Provider.autoDispose<AsyncValue<List<Dependant>>>((ref) {
  final dependantAsync = ref.watch(dependantListProvider);
  final query = ref.watch(dependantQueryProvider).trim().toLowerCase();

  return dependantAsync.whenData((list) {
    if (query.isEmpty) return list;
    return list
        .where((d) => d.fullname.toLowerCase().contains(query))
        .toList();
  });
});

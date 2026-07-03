import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/contractor.model.dart';
import '../repos/contractor_service.dart';
import 'injection_container.dart';

final contractorListProvider = FutureProvider<List<Contractor>>((ref) async {
  final service = getIt<ContractorService>();
  return await service.getAllContractors();
});

final contractorQueryProvider = StateProvider<String>((ref) => '');

final filteredContractorListProvider =
    Provider.autoDispose<AsyncValue<List<Contractor>>>((ref) {
  final contractorAsync = ref.watch(contractorListProvider);
  final query = ref.watch(contractorQueryProvider).trim().toLowerCase();

  return contractorAsync.whenData((list) {
    if (query.isEmpty) return list;
    return list
        .where((c) => c.name.toLowerCase().contains(query))
        .toList();
  });
});

final contractorStaffListProvider =
    FutureProvider<List<ContractorStaff>>((ref) async {
  final service = getIt<ContractorService>();
  return await service.getAllContractorStaff();
});

final contractorStaffQueryProvider = StateProvider<String>((ref) => '');

final filteredContractorStaffListProvider =
    Provider.autoDispose<AsyncValue<List<ContractorStaff>>>((ref) {
  final staffAsync = ref.watch(contractorStaffListProvider);
  final query = ref.watch(contractorStaffQueryProvider).trim().toLowerCase();

  return staffAsync.whenData((list) {
    if (query.isEmpty) return list;
    return list
        .where((s) => s.name.toLowerCase().contains(query))
        .toList();
  });
});

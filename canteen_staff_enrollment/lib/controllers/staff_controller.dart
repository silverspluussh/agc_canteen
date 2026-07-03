import 'package:canteen_staff_enrollment/models/employee_type.enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/staff.model.dart';
import '../models/staff_filter.model.dart';
import '../repos/biodata_service.dart';
import '../repos/staff_service.dart';
import 'injection_container.dart';
import 'package:canteen_staff_enrollment/models/biodata.model.dart';


final staffListProvider = FutureProvider<List<Staff>>((ref) async {
  final staffService = getIt<StaffService>();
  return await staffService.getAllStaffs();
});

final staffQueryProvider = StateProvider<String>((ref) => '');

final staffBiodataProvider = FutureProvider.family<List<BioData>, ({int id, EmployeeType type})>(
  (ref, args) async {
    final service = getIt<StaffBioDataService>();
    return service.getBioDatasByStaffId(args.id, args.type);
  },
);

final allBiodataProvider = FutureProvider<Map<int, int>>((ref) async {
  final service = getIt<StaffBioDataService>();
  final all = await service.getAllBioDatas();
  final map = <int, int>{};
  for (final b in all) {
    final id = b.staffId;
    if (id != null) {
      map[id] = (map[id] ?? 0) + 1;
    }
  }
  return map;
});

final staffFilterProvider = StateProvider<StaffFilter>((ref) => const StaffFilter());

final availableKitchensProvider = Provider.autoDispose<List<MapEntry<int, String>>>((ref) {
  final staffAsync = ref.watch(staffListProvider);
  return staffAsync.whenData((list) {
    final seen = <int>{};
    final result = <MapEntry<int, String>>[];
    for (final staff in list) {
      if (staff.kitchens != null) {
        for (final kitchen in staff.kitchens!) {
          if (seen.add(kitchen.id)) {
            result.add(MapEntry(kitchen.id, kitchen.name));
          }
        }
      }
    }
    result.sort((a, b) => a.value.compareTo(b.value));
    return result;
  }).value ?? [];
});

final availableDepartmentsProvider = Provider.autoDispose<List<MapEntry<int, String>>>((ref) {
  final staffAsync = ref.watch(staffListProvider);
  return staffAsync.whenData((list) {
    final seen = <int>{};
    final result = <MapEntry<int, String>>[];
    for (final staff in list) {
      final dept = staff.department;
      if (dept != null && seen.add(dept.id)) {
        result.add(MapEntry(dept.id, dept.name));
      }
    }
    result.sort((a, b) => a.value.compareTo(b.value));
    return result;
  }).value ?? [];
});

final availableCompaniesProvider = Provider.autoDispose<List<MapEntry<int, String>>>((ref) {
  final staffAsync = ref.watch(staffListProvider);
  return staffAsync.whenData((list) {
    final seen = <int>{};
    final result = <MapEntry<int, String>>[];
    for (final staff in list) {
      final company = staff.department?.company;
      if (company != null && seen.add(company.id)) {
        result.add(MapEntry(company.id, company.name));
      }
    }
    result.sort((a, b) => a.value.compareTo(b.value));
    return result;
  }).value ?? [];
});

final filteredStaffListProvider =
    Provider.autoDispose<AsyncValue<List<Staff>>>((ref) {
  final staffAsync = ref.watch(staffListProvider);
  final query = ref.watch(staffQueryProvider).trim().toLowerCase();
  final filter = ref.watch(staffFilterProvider);
  final biodataCounts = ref.watch(allBiodataProvider).value ?? {};

  return staffAsync.whenData((list) {
    var result = list;
    if (query.isNotEmpty) {
      result = result.where((staff) {
        final name = staff.fullname.toLowerCase();
        final empId = staff.empId.toLowerCase();
        return name.contains(query) || empId.contains(query);
      }).toList();
    }

    if (filter.kitchenId != null) {
      result = result.where((staff) {
        return staff.kitchens?.any((k) => k.id == filter.kitchenId) ?? false;
      }).toList();
    }

    if (filter.departmentId != null) {
      result = result.where((staff) {
        return staff.department?.id == filter.departmentId;
      }).toList();
    }

    if (filter.companyId != null) {
      result = result.where((staff) {
        return staff.department?.company.id == filter.companyId;
      }).toList();
    }

    if (filter.enrolled != null) {
      if (filter.enrolled!) {
        result = result.where((staff) {
          return (biodataCounts[staff.id] ?? 0) > 0;
        }).toList();
      } else {
        result = result.where((staff) {
          return (biodataCounts[staff.id] ?? 0) == 0;
        }).toList();
      }
    }

    return result;
  });
});

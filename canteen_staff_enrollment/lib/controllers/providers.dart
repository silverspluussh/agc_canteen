import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/company.model.dart';
import '../repos/department_service.dart';
import '../services/pos/pos_fingerprint_service.dart';
import '../services/pos/pos_device_service.dart';
import '../services/auth/fingerprint_auth_service.dart';
import '../services/auth/pos_auth_service.dart';
import 'injection_container.dart';

final fingerprintDeviceProvider = Provider<PosFingerprintService>((ref) {
  return PosFingerprintService();
});

final scannerProvider = Provider<PosScannerService>((ref) {
  return PosScannerService();
});

class PosScannerService {
}

final deviceProvider = Provider<PosDeviceService>((ref) {
  return PosDeviceService();
});

final fingerprintAuthProvider = Provider<FingerprintAuthService>((ref) {
  final device = ref.watch(fingerprintDeviceProvider);
  return FingerprintAuthService( fingerprint: device);
});

final posAuthProvider = Provider<PosAuthService>((ref) {
  final fingerprint = ref.watch(fingerprintAuthProvider);
  return PosAuthService( fingerprintAuth: fingerprint);
});

final departmentListProvider = FutureProvider<List<Department>>((ref) async {
  final service = getIt<DepartmentService>();
  return await service.getAllDepartments(limit: 200);
});

final overviewStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final service = getIt<DepartmentService>();
  final data = await service.getAnalytics();
  final stats = data['stats'] as Map? ?? {};

  final activeStaff = stats['activeStaff'] as Map? ?? {};
  final visitors = stats['visitors'] as Map? ?? {};
  final assignedDependents = stats['assignedDependents'] as Map? ?? {};
  final contractorStaff = stats['contractorStaff'] as Map? ?? {};

  return {
    'totalStaff': _intVal(activeStaff['total']),
    'enrolledStaff': _intVal(activeStaff['count']),
    'totalVisitors': _intVal(visitors['total']),
    'totalDependents': _intVal(assignedDependents['declared']),
    'enrolledDependents': _intVal(assignedDependents['count']),
    'totalContractorStaff': _intVal(contractorStaff['total']),
  };
});

int _intVal(dynamic v) {
  if (v is int) return v;
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

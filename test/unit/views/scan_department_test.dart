import 'package:agc_canteen/views/auth/scan_department.dart';
import 'package:flutter_test/flutter_test.dart';

/// Phase 1: a scan must always run against a department.
///
/// A single-department terminal auto-resolves so the operator never picks; a
/// multi-department terminal must select one, because scanning without a
/// department searches every enrolled fingerprint (slow and ambiguous).
void main() {
  group('resolveScanDepartmentId', () {
    test('uses the selected department when one is chosen', () {
      expect(
        resolveScanDepartmentId(
          selectedDepartmentId: 7,
          departmentIds: [1, 7, 9],
        ),
        7,
      );
    });

    test('auto-resolves a single-department terminal', () {
      expect(
        resolveScanDepartmentId(selectedDepartmentId: null, departmentIds: [42]),
        42,
      );
    });

    test('requires a selection on a multi-department terminal', () {
      expect(
        resolveScanDepartmentId(
          selectedDepartmentId: null,
          departmentIds: [1, 2, 3],
        ),
        isNull,
      );
    });

    test('returns null when no departments are synced', () {
      expect(
        resolveScanDepartmentId(selectedDepartmentId: null, departmentIds: const []),
        isNull,
      );
    });

    test('a selected department wins over the single-department shortcut', () {
      expect(
        resolveScanDepartmentId(selectedDepartmentId: 5, departmentIds: [5]),
        5,
      );
    });
  });
}

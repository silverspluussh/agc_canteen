/// Resolves the department a POS scan should run against.
///
/// A terminal that serves a single department auto-resolves to it, so the
/// operator never has to choose. On a multi-department terminal a department
/// must be selected first: scanning without one searches every enrolled
/// fingerprint, which is both slow and ambiguous.
///
/// Returns the department id to scan with, or null when the operator still
/// needs to pick one.
int? resolveScanDepartmentId({
  required int? selectedDepartmentId,
  required List<int> departmentIds,
}) {
  if (selectedDepartmentId != null) return selectedDepartmentId;
  if (departmentIds.length == 1) return departmentIds.first;
  return null;
}

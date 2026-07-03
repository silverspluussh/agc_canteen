class StaffFilter {
  final int? kitchenId;
  final int? departmentId;
  final int? companyId;
  final bool? enrolled;

  const StaffFilter({
    this.kitchenId,
    this.departmentId,
    this.companyId,
    this.enrolled,
  });

  bool get isActive =>
      kitchenId != null ||
      departmentId != null ||
      companyId != null ||
      enrolled != null;

  int get activeFilterCount {
    int count = 0;
    if (kitchenId != null) count++;
    if (departmentId != null) count++;
    if (companyId != null) count++;
    if (enrolled != null) count++;
    return count;
  }

  StaffFilter copyWith({
    int? kitchenId,
    int? departmentId,
    int? companyId,
    bool? enrolled,
    bool clearKitchen = false,
    bool clearDepartment = false,
    bool clearCompany = false,
    bool clearEnrolled = false,
  }) {
    return StaffFilter(
      kitchenId: clearKitchen ? null : (kitchenId ?? this.kitchenId),
      departmentId:
          clearDepartment ? null : (departmentId ?? this.departmentId),
      companyId: clearCompany ? null : (companyId ?? this.companyId),
      enrolled: clearEnrolled ? null : (enrolled ?? this.enrolled),
    );
  }

  StaffFilter clearAll() => const StaffFilter();
}
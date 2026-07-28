/// Unified row for reports list (single + group orders).
class UnifiedReportOrderRow {
  final int id;
  final String orderCode;
  final String status;
  final String orderType;
  final String mealType;
  final double total;
  final int groupCount;
  final int syncStatus;
  final String? description;
  final String createdAt;
  final int? orderedById;
  final String? employeeType;
  final bool isGroup;

  const UnifiedReportOrderRow({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.orderType,
    required this.mealType,
    required this.total,
    required this.groupCount,
    required this.syncStatus,
    this.description,
    required this.createdAt,
    this.orderedById,
    this.employeeType,
    required this.isGroup,
  });

  factory UnifiedReportOrderRow.fromData(Map<String, dynamic> data) {
    return UnifiedReportOrderRow(
      id: data['id'] as int,
      orderCode: data['order_code'] as String,
      status: data['status'] as String,
      orderType: data['order_type'] as String,
      mealType: data['meal_type'] as String,
      total: (data['total'] as num).toDouble(),
      groupCount: data['group_count'] as int,
      syncStatus: data['sync_status'] as int,
      description: data['description'] as String?,
      createdAt: data['created_at'] as String,
      orderedById: data['ordered_by_id'] as int?,
      employeeType: data['employee_type'] as String?,
      isGroup: (data['is_group'] as int) == 1,
    );
  }
}

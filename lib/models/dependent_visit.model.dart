/// One stay of a dependent. The dependent PERSON (Dependents row) is created
/// once; each visit window can be renewed/extended while identity data stays.
class DependentVisit {
  final int id;
  final int dependentId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  const DependentVisit({
    required this.id,
    required this.dependentId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory DependentVisit.fromMap(Map<String, dynamic> map) {
    return DependentVisit(
      id: map['id'] as int,
      dependentId: map['dependentId'] as int,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      status: map['status'] as String? ?? 'scheduled',
    );
  }

  bool covers(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final s = DateTime(startDate.year, startDate.month, startDate.day);
    final e = DateTime(endDate.year, endDate.month, endDate.day);
    return !d.isBefore(s) && !d.isAfter(e);
  }

  bool get isCancelled => status == 'cancelled';

  DependentVisit copyWith({
    int? id,
    int? dependentId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) {
    return DependentVisit(
      id: id ?? this.id,
      dependentId: dependentId ?? this.dependentId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }
}

import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/core/utils/app_log.dart';
import 'package:agc_canteen/services/database/app_database.dart';

/// Result of the offline quota check.
class QuotaDecision {
  /// Whether the order may proceed.
  final bool allowed;

  /// True when quota data is missing or stale: allowed, but the order will
  /// reconcile as a potential overcharge once synced.
  final bool stale;

  /// Human-readable reason when blocked (or why stale).
  final String? reason;

  final int dailyUsed;
  final int dailyQuota;
  final int periodUsed;
  final int periodTotal;

  int get dailyRemaining => (dailyQuota - dailyUsed).clamp(0, dailyQuota);
  int get periodRemaining => (periodTotal - periodUsed).clamp(0, periodTotal);

  const QuotaDecision({
    required this.allowed,
    this.stale = false,
    this.reason,
    this.dailyUsed = 0,
    this.dailyQuota = 0,
    this.periodUsed = 0,
    this.periodTotal = 0,
  });

  const QuotaDecision.allowLegacy({String? reason})
    : this(allowed: true, stale: true, reason: reason);

  const QuotaDecision.block({
    required this.reason,
    required this.dailyUsed,
    required this.dailyQuota,
    required this.periodUsed,
    required this.periodTotal,
  }) : allowed = false,
       stale = false;
}

/// Offline-first quota gate. Mirrors the server rules using synced data:
///
/// * staff with shift: daily = shift.dailyMealQuota,
///   pool = daily x workingDaysPerMonth for the calendar month.
/// * contractor / visitor: daily x stay days.
/// * dependent: inherited daily x active-visit days (staff parent: shift
///   daily; contractor parent: contractor dailyQuota).
///
/// Anything over the pool is an overcharge. When quota data is missing or
/// stale the order is ALLOWED and reconciles server-side after sync.
class QuotaGateService {
  final AppDatabase _db;

  /// Quota data older than this is treated as stale (allowed, flagged).
  static const Duration maxDataAge = Duration(hours: 24);

  QuotaGateService({required AppDatabase db}) : _db = db;

  bool _isFresh(int syncStatus, String? syncUpdatedAt) {
    if (syncStatus != 2) return false;
    if (syncUpdatedAt == null) return false;
    final syncedAt = DateTime.tryParse(syncUpdatedAt);
    if (syncedAt == null) return false;
    return DateTime.now().difference(syncedAt) <= maxDataAge;
  }

  String _dayPrefix(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';

  Future<QuotaDecision> checkCanOrder({
    required EmployeeType type,
    required int personId,
    int quantity = 1,

    /// True when ordering inside a work function.
    ///
    /// Entitlement is still enforced, but the "used" counts deliberately read
    /// only the general [Orders] table: function orders live in their own table
    /// and must NOT consume the person's normal meal pool.
    ///
    /// Also suppresses the dependent-specific reason copy so the UI can stay
    /// terse in function mode — enforcement is unchanged.
    bool inFunctionMode = false,
  }) async {
    final now = DateTime.now();
    try {
      if (type == EmployeeType.dependent) {
        return await _checkDependent(
          personId,
          now,
          quantity,
          suppressWarning: inFunctionMode,
        );
      }
      if (type == EmployeeType.contractor) {
        return await _checkContractorOrVisitor(
          isContractor: true,
          personId: personId,
          now: now,
          quantity: quantity,
        );
      }
      if (type == EmployeeType.visitor) {
        return await _checkContractorOrVisitor(
          isContractor: false,
          personId: personId,
          now: now,
          quantity: quantity,
        );
      }
      return await _checkStaff(type, personId, now, quantity);
    } catch (e) {
      appLog('[QuotaGate] check failed ($e) — allowing (stale).',
          name: 'QUOTA_GATE');
      return const QuotaDecision.allowLegacy(
        reason: 'Quota check unavailable offline.',
      );
    }
  }

  Future<QuotaDecision> _checkStaff(
    EmployeeType type,
    int staffId,
    DateTime now,
    int quantity,
  ) async {
    final staff = await _db.getStaff(staffId);
    if (staff == null) {
      return const QuotaDecision.allowLegacy(reason: 'Staff not synced yet.');
    }
    if (!_isFresh(staff.syncStatus, staff.syncUpdatedAt)) {
      return const QuotaDecision.allowLegacy(reason: 'Staff data is stale.');
    }
    final employeeType = staff.employeeType.isNotEmpty
        ? staff.employeeType
        : type.name;

    // No shift means the allowance is configured directly on the person.
    if (staff.shiftId == null) {
      return _evaluate(
        staffId: staffId,
        daily: staff.manualDailyQuota,
        periodTotal: staff.manualMonthlyQuota,
        employeeType: employeeType,
        now: now,
        quantity: quantity,
        periodStart: staff.quotaPeriodStart,
        periodEnd: staff.quotaPeriodEnd,
        periodLabel: 'quota period',
      );
    }

    final shift = await _db.getShift(staff.shiftId!);
    if (shift == null) {
      return const QuotaDecision.allowLegacy(reason: 'Shift not synced yet.');
    }
    if (!_isFresh(shift.syncStatus, shift.syncUpdatedAt)) {
      return const QuotaDecision.allowLegacy(reason: 'Shift data is stale.');
    }

    return _evaluate(
      staffId: staffId,
      daily: shift.dailyMealQuota,
      periodTotal: shift.dailyMealQuota * shift.workingDaysPerMonth,
      employeeType: employeeType,
      now: now,
      quantity: quantity,
      periodLabel: 'monthly',
    );
  }

  /// Shared daily + period exhaustion check for a shift-derived or manually
  /// configured allowance.
  ///
  /// When the server supplied an explicit period window it is honoured;
  /// otherwise the calendar month is used.
  Future<QuotaDecision> _evaluate({
    required int staffId,
    required int daily,
    required int periodTotal,
    required String employeeType,
    required DateTime now,
    required int quantity,
    required String periodLabel,
    String? periodStart,
    String? periodEnd,
  }) async {
    if (daily <= 0) {
      return const QuotaDecision.allowLegacy(
        reason: 'No daily quota configured.',
      );
    }

    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final total = periodTotal;

    final dailyUsed = await _db.countOrdersByPerson(
      personId: staffId,
      employeeType: employeeType,
      dayPrefix: _dayPrefix(now),
    );

    final int periodUsed;
    if (periodStart != null && periodEnd != null) {
      periodUsed = await _db.countOrdersByPerson(
        personId: staffId,
        employeeType: employeeType,
        windowStartIso: '${periodStart}T00:00:00.000',
        windowEndIso: '${periodEnd}T23:59:59.999',
      );
    } else {
      periodUsed = await _db.countOrdersByPerson(
        personId: staffId,
        employeeType: employeeType,
        windowStartIso: '${_dayPrefix(monthStart)}T00:00:00.000',
        windowEndIso: '${_dayPrefix(monthEnd)}T23:59:59.999',
      );
    }

    if (dailyUsed + quantity > daily) {
      return QuotaDecision.block(
        reason: 'Daily meal quota exhausted ($dailyUsed/$daily used today).',
        dailyUsed: dailyUsed,
        dailyQuota: daily,
        periodUsed: periodUsed,
        periodTotal: total,
      );
    }
    if (periodUsed + quantity > total) {
      return QuotaDecision.block(
        reason:
            'Meal quota exhausted for this $periodLabel ($periodUsed/$total used).',
        dailyUsed: dailyUsed,
        dailyQuota: daily,
        periodUsed: periodUsed,
        periodTotal: total,
      );
    }
    return QuotaDecision(
      allowed: true,
      dailyUsed: dailyUsed,
      dailyQuota: daily,
      periodUsed: periodUsed,
      periodTotal: total,
    );
  }

  Future<QuotaDecision> _checkContractorOrVisitor({
    required bool isContractor,
    required int personId,
    required DateTime now,
    required int quantity,
  }) async {
    final label = isContractor ? 'Contractor staff' : 'Visitor';
    final typeName =
        isContractor ? EmployeeType.contractor.name : EmployeeType.visitor.name;
    int? daily;
    DateTime? start;
    DateTime? end;
    bool fresh;

    if (isContractor) {
      final row = await _db.getContractorStaff(personId);
      if (row == null) {
        return const QuotaDecision.allowLegacy(
          reason: 'Contractor staff not synced yet.',
        );
      }
      fresh = _isFresh(row.syncStatus, row.syncUpdatedAt);
      daily = row.dailyQuota;
      start = DateTime.tryParse(row.startDate);
      end = DateTime.tryParse(row.endDate);
    } else {
      final row = await _db.getVisitor(personId);
      if (row == null) {
        return const QuotaDecision.allowLegacy(
          reason: 'Visitor not synced yet.',
        );
      }
      fresh = _isFresh(row.syncStatus, row.syncUpdatedAt);
      daily = row.dailyQuota;
      start = row.startDate != null ? DateTime.tryParse(row.startDate!) : null;
      end = row.endTime != null ? DateTime.tryParse(row.endTime!) : null;
    }

    if (!fresh) {
      return const QuotaDecision.allowLegacy(reason: 'Person data is stale.');
    }
    if (daily == null || daily <= 0) {
      return const QuotaDecision.allowLegacy(
        reason: 'No daily quota configured.',
      );
    }

    final today = DateTime(now.year, now.month, now.day);
    if (start != null &&
        today.isBefore(DateTime(start.year, start.month, start.day))) {
      return QuotaDecision.block(
        reason: '$label stay has not started.',
        dailyUsed: 0,
        dailyQuota: daily,
        periodUsed: 0,
        periodTotal: 0,
      );
    }
    if (end != null &&
        today.isAfter(DateTime(end.year, end.month, end.day))) {
      return QuotaDecision.block(
        reason: '$label stay has ended.',
        dailyUsed: 0,
        dailyQuota: daily,
        periodUsed: 0,
        periodTotal: 0,
      );
    }

    final windowStart = start ?? today;
    final windowEnd = end ?? today;
    final days =
        DateTime(windowEnd.year, windowEnd.month, windowEnd.day)
            .difference(
              DateTime(windowStart.year, windowStart.month, windowStart.day),
            )
            .inDays +
        1;
    final total = daily * days.clamp(1, 100000);

    final dailyUsed = await _db.countOrdersByPerson(
      personId: personId,
      employeeType: typeName,
      dayPrefix: _dayPrefix(now),
    );
    final periodUsed = await _db.countOrdersByPerson(
      personId: personId,
      employeeType: typeName,
      windowStartIso:
          '${_dayPrefix(windowStart)}T00:00:00.000',
      windowEndIso: '${_dayPrefix(windowEnd)}T23:59:59.999',
    );

    if (dailyUsed + quantity > daily) {
      return QuotaDecision.block(
        reason: 'Daily meal quota exhausted ($dailyUsed/$daily used today).',
        dailyUsed: dailyUsed,
        dailyQuota: daily,
        periodUsed: periodUsed,
        periodTotal: total,
      );
    }
    if (periodUsed + quantity > total) {
      return QuotaDecision.block(
        reason: 'Stay meal quota exhausted ($periodUsed/$total used).',
        dailyUsed: dailyUsed,
        dailyQuota: daily,
        periodUsed: periodUsed,
        periodTotal: total,
      );
    }
    return QuotaDecision(
      allowed: true,
      dailyUsed: dailyUsed,
      dailyQuota: daily,
      periodUsed: periodUsed,
      periodTotal: total,
    );
  }

  Future<QuotaDecision> _checkDependent(
    int dependentId,
    DateTime now,
    int quantity, {
    bool suppressWarning = false,
  }) async {
    final dependent = await _db.getDependent(dependentId);
    if (dependent == null) {
      return const QuotaDecision.allowLegacy(
        reason: 'Dependent not synced yet.',
      );
    }
    if (!_isFresh(dependent.syncStatus, dependent.syncUpdatedAt)) {
      return const QuotaDecision.allowLegacy(
        reason: 'Dependent data is stale.',
      );
    }

    final today = _dayPrefix(now);
    final visit = await _db.getActiveVisitForDependent(dependentId, today);
    if (visit == null) {
      final hasVisits = await _db.hasAnyVisitForDependent(dependentId);
      if (hasVisits) {
        return QuotaDecision.block(
          // Function mode keeps the same block but drops the verbose copy.
          reason: suppressWarning
              ? 'Dependent is not on an active visit.'
              : 'No active visit for this dependent today.',
          dailyUsed: 0,
          dailyQuota: 0,
          periodUsed: 0,
          periodTotal: 0,
        );
      }
      return const QuotaDecision.allowLegacy(
        reason: 'Dependent visits not synced yet.',
      );
    }

    if ((dependent.parentStatus ?? 'active') != 'active') {
      return QuotaDecision.block(
        reason: suppressWarning
            ? 'Dependent is not eligible.'
            : 'The parent record is no longer active.',
        dailyUsed: 0,
        dailyQuota: 0,
        periodUsed: 0,
        periodTotal: 0,
      );
    }

    final daily = await _resolveDependentDaily(dependent);
    if (daily == null || daily <= 0) {
      return const QuotaDecision.allowLegacy(
        reason: 'No daily quota configured.',
      );
    }

    final visitStart = visit.startDate.substring(0, 10);
    final visitEnd = visit.endDate.substring(0, 10);
    final days =
        DateTime.parse(visitEnd).difference(DateTime.parse(visitStart)).inDays +
        1;
    final total = daily * days.clamp(1, 100000);

    final dailyUsed = await _db.countOrdersByPerson(
      personId: dependentId,
      employeeType: EmployeeType.dependent.name,
      dayPrefix: today,
    );
    final periodUsed = await _db.countOrdersByPerson(
      personId: dependentId,
      employeeType: EmployeeType.dependent.name,
      windowStartIso: '${visitStart}T00:00:00.000',
      windowEndIso: '${visitEnd}T23:59:59.999',
    );

    if (dailyUsed + quantity > daily) {
      return QuotaDecision.block(
        reason: 'Daily meal quota exhausted ($dailyUsed/$daily used today).',
        dailyUsed: dailyUsed,
        dailyQuota: daily,
        periodUsed: periodUsed,
        periodTotal: total,
      );
    }
    if (periodUsed + quantity > total) {
      return QuotaDecision.block(
        reason: 'Visit meal quota exhausted ($periodUsed/$total used).',
        dailyUsed: dailyUsed,
        dailyQuota: daily,
        periodUsed: periodUsed,
        periodTotal: total,
      );
    }
    return QuotaDecision(
      allowed: true,
      dailyUsed: dailyUsed,
      dailyQuota: daily,
      periodUsed: periodUsed,
      periodTotal: total,
    );
  }

  /// Inherited daily: staff parent -> shift daily; contractor parent ->
  /// contractor dailyQuota. Null when the parent row/quota is missing.
  Future<int?> _resolveDependentDaily(Dependent dependent) async {
    if (dependent.contractorStaffId != null) {
      final parent = await _db.getContractorStaff(
        dependent.contractorStaffId!,
      );
      return parent?.dailyQuota;
    }
    if (dependent.staffId == null) return null;
    final parent = await _db.getStaff(dependent.staffId!);
    if (parent?.shiftId == null) return null;
    final shift = await _db.getShift(parent!.shiftId!);
    return shift?.dailyMealQuota;
  }
}

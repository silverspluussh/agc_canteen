import 'package:agc_canteen/core/enums/employee_type.enum.dart';
import 'package:agc_canteen/services/database/app_database.dart';
import 'package:agc_canteen/services/pos/quota_gate_service.dart';
import 'package:flutter/material.dart';

/// Shows remaining daily/period quota for the selected person, or a stale-data
/// note when the device has no fresh quota data (orders still allowed).
class QuotaIndicator extends StatelessWidget {
  final AppDatabase db;
  final EmployeeType type;
  final int personId;
  final String? label;

  const QuotaIndicator({
    super.key,
    required this.db,
    required this.type,
    required this.personId,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuotaDecision>(
      future: QuotaGateService(
        db: db,
      ).checkCanOrder(type: type, personId: personId, quantity: 0),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final decision = snapshot.data!;
        final cs = Theme.of(context).colorScheme;

        if (decision.dailyQuota <= 0 && decision.periodTotal <= 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              decision.stale
                  ? 'Quota: unverified offline — will reconcile on sync.'
                  : 'No quota limit configured.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          );
        }

        final blocked = !decision.allowed;
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: blocked
                ? cs.errorContainer.withOpacity(0.5)
                : cs.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                blocked ? Icons.block : Icons.restaurant,
                size: 18,
                color: blocked ? cs.error : cs.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  blocked
                      ? (decision.reason ?? 'Quota exhausted.')
                      : 'Today: ${decision.dailyUsed}/${decision.dailyQuota} · '
                          'Period: ${decision.periodUsed}/${decision.periodTotal}'
                          '${label != null ? ' · $label' : ''}'
                          '${decision.stale ? ' (offline data)' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: blocked ? cs.error : cs.onSurface,
                    fontWeight: blocked ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

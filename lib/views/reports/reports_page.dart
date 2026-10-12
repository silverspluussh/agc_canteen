import 'package:agc_canteen/core/utils/app_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../reports/orders_page.dart';

enum ReportPeriod { today, yesterday, thisWeek, thisMonth, allTime }

extension ReportPeriodLabel on ReportPeriod {
  String label(AppLocalizations l10n) => switch (this) {
    ReportPeriod.today => l10n.today,
    ReportPeriod.yesterday => l10n.yesterday,
    ReportPeriod.thisWeek => l10n.thisWeek,
    ReportPeriod.thisMonth => l10n.thisMonth,
    ReportPeriod.allTime => l10n.all,
  };
}

extension _PeriodFilter on ReportPeriod {
  DateTime? get start {
    final now = DateTime.now();
    return switch (this) {
      ReportPeriod.today => DateTime(now.year, now.month, now.day),
      ReportPeriod.yesterday => DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 1)),
      ReportPeriod.thisWeek => DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: now.weekday - 1)),
      ReportPeriod.thisMonth => DateTime(now.year, now.month, 1),
      ReportPeriod.allTime => null,
    };
  }

  DateTime? get end => switch (this) {
    ReportPeriod.yesterday => start!.add(const Duration(days: 1)),
    ReportPeriod.thisWeek => DateTime.now(),
    ReportPeriod.thisMonth => DateTime.now(),
    _ => null,
  };
}

class _ReportSummary {
  final int totalOrders;
  final int peopleServed;
  final Map<String, int> personnelCounts;
  final Map<String, int> mealTypeCounts;

  const _ReportSummary({
    required this.totalOrders,
    required this.peopleServed,
    required this.personnelCounts,
    required this.mealTypeCounts,
  });
}

String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// Maps a raw `orders.employee_type` value to its personnel bucket label.
String _personnelBucket(String employeeType) => switch (employeeType) {  'contractor' => 'Contractor staff',
  'visitor' => 'Visitor',
  'dependent' => 'Dependent',
  'permanent' ||
  'graduateTrainee' ||
  'nationalService' ||
  'intern' ||
  'shortTermContractor' => 'Staff',
  _ => 'Other',
};

extension _PeriodBounds on ReportPeriod {
  ({String? from, String? toInclusive}) get bounds {
    final start = this.start;
    final end = this.end;
    if (this == ReportPeriod.allTime) {
      return (from: null, toInclusive: null);
    }
    if (this == ReportPeriod.yesterday && start != null && end != null) {
      return (
        from: start.toIso8601String(),
        toInclusive: end
            .subtract(const Duration(milliseconds: 1))
            .toIso8601String(),
      );
    }
    return (
      from: start?.toIso8601String(),
      toInclusive: end?.toIso8601String() ?? DateTime.now().toIso8601String(),
    );
  }
}

final reportSummaryProvider =
    FutureProvider.family<_ReportSummary, ReportPeriod>((ref, period) async {
      final db = ref.watch(databaseProvider);
      final bounds = period.bounds;

      final totalOrders = await db.countUnifiedOrders(
        createdAtFrom: bounds.from,
        createdAtToInclusive: bounds.toInclusive,
      );
      final peopleServed = await db.countDistinctPersons(
        createdAtFrom: bounds.from,
        createdAtToInclusive: bounds.toInclusive,
      );

      final byEmployeeType = await db.countOrdersGrouped(
        createdAtFrom: bounds.from,
        createdAtToInclusive: bounds.toInclusive,
        column: 'employee_type',
      );
      final personnelCounts = <String, int>{
        'Staff': 0,
        'Contractor staff': 0,
        'Visitor': 0,
        'Dependent': 0,
      };
      byEmployeeType.forEach((type, count) {
        final bucket = _personnelBucket(type);
        personnelCounts[bucket] = (personnelCounts[bucket] ?? 0) + count;
      });

      final mealTypeCounts = await db.countOrdersGrouped(
        createdAtFrom: bounds.from,
        createdAtToInclusive: bounds.toInclusive,
        column: 'meal_type',
      );

      return _ReportSummary(
        // Group vouchers are ordinary rows in `orders`; the retired
        // `group_orders` table contributed nothing to these totals.
        totalOrders: totalOrders,
        peopleServed: peopleServed,
        personnelCounts: personnelCounts,
        mealTypeCounts: mealTypeCounts,
      );
    });

class ReportsDashboardPage extends ConsumerStatefulWidget {
  const ReportsDashboardPage({super.key});

  @override
  ConsumerState<ReportsDashboardPage> createState() =>
      _ReportsDashboardPageState();
}

class _ReportsDashboardPageState extends ConsumerState<ReportsDashboardPage> {
  ReportPeriod _period = ReportPeriod.today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final summaryAsync = ref.watch(reportSummaryProvider(_period));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(
          "Vouchers Summary",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ReportsPage())),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.list_alt, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text("Vouchers", style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPeriodFilter(theme),
          Expanded(
            child: summaryAsync.when(
              data: (summary) => _buildSummaryCards(summary, theme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) {
                appLog(e.toString(), name: 'ReportsPage');
                return Center(child: Text('${l10n.failedToLoadMeals} $e'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodFilter(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: ReportPeriod.values.map((period) {
          final selected = _period == period;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(period.label(AppLocalizations.of(context))),
              selected: selected,
              selectedColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: selected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (_) => setState(() => _period = period),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryCards(_ReportSummary summary, ThemeData theme) {
    final mealTypeEntries = summary.mealTypeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(reportSummaryProvider(_period)),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _SummaryCard(
            icon: Icons.receipt_long_rounded,
            label: 'Vouchers',
            value: summary.totalOrders.toString(),
          ),
          _SummaryCard(
            icon: Icons.groups_rounded,
            label: 'People served',
            value: summary.peopleServed.toString(),
          ),
          _BreakdownCard(
            icon: Icons.badge_outlined,
            title: 'By personnel type',
            entries: summary.personnelCounts.entries.toList(),
          ),
          _BreakdownCard(
            icon: Icons.restaurant_menu_rounded,
            title: 'By meal type',
            entries: mealTypeEntries
                .map((e) => MapEntry(_cap(e.key), e.value))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: scheme.onSurface, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A plain themed card that lists a quantity per row (personnel type, meal type).
class _BreakdownCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<MapEntry<String, int>> entries;

  const _BreakdownCard({
    required this.icon,
    required this.title,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: scheme.onSurface, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              Text(
                'No vouchers',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else
              ...entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.key,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        e.value.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

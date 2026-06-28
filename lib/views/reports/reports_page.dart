import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
      ReportPeriod.yesterday => DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1)),
      ReportPeriod.thisWeek => DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1)),
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
  final double totalRevenue;
  final int totalMealTypes;
  final int totalStaff;

  const _ReportSummary({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalMealTypes,
    required this.totalStaff,
  });
}

final reportSummaryProvider = FutureProvider.family<_ReportSummary, ReportPeriod>((ref, period) async {
  final db = ref.watch(databaseProvider);

  final orders = await db.getAllOrders();
  final groupOrders = await db.getAllGroupOrders();
  final mealTypes = await db.getAllMealTypes();
  final staff = await db.getAllStaff();

  bool inRange(String? isoString) {
    if (isoString == null) return false;
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return false;
    final start = period.start;
    final end = period.end;
    if (start != null && dt.isBefore(start)) return false;
    if (end != null && dt.isAfter(end)) return false;
    return true;
  }

  final isAllTime = period == ReportPeriod.allTime;

  final filteredMealTypes = isAllTime
      ? mealTypes
      : mealTypes.where((m) => inRange(m.createdAt)).toList();

  final filteredOrderCount = isAllTime
      ? orders.length + groupOrders.length
      : orders.where((o) => inRange(o.createdAt)).length +
          groupOrders.where((o) => inRange(o.createdAt)).length;

  final orderRevenue = isAllTime
      ? orders.fold<double>(0, (sum, o) => sum + o.total)
      : orders.where((o) => inRange(o.createdAt)).fold<double>(0, (sum, o) => sum + o.total);

  final groupOrderRevenue = isAllTime
      ? groupOrders.fold<double>(0, (sum, o) => sum + o.total)
      : groupOrders.where((o) => inRange(o.createdAt)).fold<double>(0, (sum, o) => sum + o.total);

  final totalRevenue = orderRevenue + groupOrderRevenue;

  return _ReportSummary(
    totalOrders: filteredOrderCount,
    totalRevenue: totalRevenue,
    totalMealTypes: filteredMealTypes.length,
    totalStaff: staff.length,
  );
});

final _currencyFormat = NumberFormat('#,##0.00', 'en_US');

class ReportsDashboardPage extends ConsumerStatefulWidget {
  const ReportsDashboardPage({super.key});

  @override
  ConsumerState<ReportsDashboardPage> createState() => _ReportsDashboardPageState();
}

class _ReportsDashboardPageState extends ConsumerState<ReportsDashboardPage> {
  ReportPeriod _period = ReportPeriod.allTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final summaryAsync = ref.watch(reportSummaryProvider(_period));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(l10n.reports),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ReportsPage()),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.list_alt, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(l10n.orders, style: const TextStyle(color: Colors.white)),
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
                log(e.toString());
                return Center(
                child: Text('${l10n.failedToLoadMeals} $e'),
              );}
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
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(reportSummaryProvider(_period)),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _SummaryCard(
            icon: Icons.receipt_long_rounded,
            label: AppLocalizations.of(context).transactions,
            value: summary.totalOrders.toString(),
            color: Colors.blue,
          ),
          _SummaryCard(
            icon: Icons.attach_money_rounded,
            label: AppLocalizations.of(context).totalRevenue,
            value: 'GH₵ ${_currencyFormat.format(summary.totalRevenue)}',
            color: Colors.green,
          ),
          _SummaryCard(
            icon: Icons.category_rounded,
            label: AppLocalizations.of(context).mealType,
            value: summary.totalMealTypes.toString(),
            color: Colors.purple,
          ),
          _SummaryCard(
            icon: Icons.people_rounded,
            label: AppLocalizations.of(context).staffManagement,
            value: summary.totalStaff.toString(),
            color: Colors.indigo,
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
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
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

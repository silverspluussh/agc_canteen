import 'package:canteen_staff_enrollment/views/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../core/theme/app_colors.dart';

class OverviewPage extends ConsumerWidget {
  final VoidCallback onNavigateToStaff;
  final VoidCallback onNavigateToVisitors;
  final VoidCallback onNavigateToDependents;
  final VoidCallback onNavigateToContractors;

  const OverviewPage({
    super.key,
    required this.onNavigateToStaff,
    required this.onNavigateToVisitors,
    required this.onNavigateToDependents,
    required this.onNavigateToContractors,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(overviewStatsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(overviewStatsProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          child: statsAsync.when(
            data: (stats) {
              final total = stats['totalStaff']! +
                  stats['totalVisitors']! +
                  stats['totalDependents']! +
                  stats['totalContractorStaff']!;

              final enrolled = stats['enrolledStaff']! + stats['enrolledDependents']!;

              final pending = total - enrolled;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsGrid(context, total, enrolled, pending),
                  const SizedBox(height: 20),
                  _buildQuickActions(context),
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load summary details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      onPressed: () => ref.invalidate(overviewStatsProvider),
                      label: const Text('Retry', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    int total,
    int enrolled,
    int pending,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context: context,
          title: 'Total Personnel',
          value: total.toString(),
          icon: Icons.people_outline,
          gradient: const LinearGradient(
            colors: [AppColors.gold500, AppColors.gold700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          textColor: Colors.white,
        ),
        _buildStatCard(
          context: context,
          title: 'Enrolled',
          value: enrolled.toString(),
          icon: Icons.fingerprint,
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          textColor: Colors.white,
        ),
        _buildStatCard(
          context: context,
          title: 'Pending',
          value: pending.toString(),
          icon: Icons.pending_actions_outlined,
          gradient: const LinearGradient(
            colors: [Color(0xFFE65100), Color(0xFFBF360C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          textColor: Colors.white,
        ),
        _buildStatCard(
          context: context,
          title: 'Completion Rate',
          value: total > 0
              ? '${((enrolled / total) * 100).toStringAsFixed(1)}%'
              : '0%',
          icon: Icons.donut_large,
          gradient: const LinearGradient(
            colors: [Color(0xFF0288D1), Color(0xFF01579B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          textColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Gradient gradient,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: textColor.withValues(alpha: 0.8), size: 24),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardTheme.color ??
            Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.group,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: const Text('Staff Enrollment Directory', style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            subtitle: const Text('View staff list and enroll fingerprints'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onNavigateToStaff,
          ),
          const Divider(height: 4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: AppColors.gold500.withValues(alpha: 0.15),
              child: const Icon(Icons.person_outline, color: AppColors.gold600),
            ),
            title: const Text('Visitor Directory', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('View visitors and manage their biodata'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onNavigateToVisitors,
          ),
          const Divider(height: 4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.teal.withValues(alpha: 0.15),
              child: const Icon(Icons.family_restroom, color: Colors.teal),
            ),
            title: const Text('Dependent Directory', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('View dependents and manage their biodata'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onNavigateToDependents,
          ),
          const Divider(height: 4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.indigo.withValues(alpha: 0.15),
              child: const Icon(Icons.engineering_outlined, color: Colors.indigo),
            ),
            title: const Text('Contractor Staff Directory', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('View contractor staff and manage their biodata'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onNavigateToContractors,
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/staff_controller.dart';
import '../../core/theme/app_colors.dart';

class OverviewPage extends ConsumerWidget {
  final VoidCallback onNavigateToStaff;

  const OverviewPage({super.key, required this.onNavigateToStaff});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffListProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(staffListProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             

              staffAsync.when(
                data: (staffList) {
                  log(staffList.toString());

                  final totalStaff = staffList.length;
                  final enrolledStaff = staffList
                      .where((s) => s.bioData != null && s.bioData!.isNotEmpty)
                      .length;
                  final pendingEnrollment = totalStaff - enrolledStaff;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsGrid(
                        context,
                        totalStaff,
                        enrolledStaff,
                        pendingEnrollment,
                      ),
                      const SizedBox(height: 32),
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
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load summary details: $err',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.refresh(staffListProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          context: context,
          title: 'Total Staff',
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
          title: 'Enrolled Staff',
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
          title: 'Pending Staff',
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: textColor.withValues(alpha: 0.8), size: 24),
              Text(
                title,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
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
          SizedBox(height: 15,),
          Text(
            'Quick Actions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
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
        ],
      ),
    );
  }
}

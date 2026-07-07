import 'dart:developer';

import 'package:canteen_staff_enrollment/views/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/contractor_controller.dart';
import '../../controllers/dependant_controller.dart';
import '../../controllers/staff_controller.dart';
import '../../controllers/visitor_controller.dart';
import '../../core/theme/app_colors.dart';

class OverviewPage extends ConsumerWidget {
  final VoidCallback onNavigateToStaff;
  final VoidCallback onNavigateToVisitors;
  final VoidCallback onNavigateToDependants;
  final VoidCallback onNavigateToContractors;

  const OverviewPage({
    super.key,
    required this.onNavigateToStaff,
    required this.onNavigateToVisitors,
    required this.onNavigateToDependants,
    required this.onNavigateToContractors,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffListProvider);
    final visitorAsync = ref.watch(visitorListProvider);
    final dependantAsync = ref.watch(dependantListProvider);
    final contractorAsync = ref.watch(contractorStaffListProvider);
    final biodataCounts = ref.watch(allBiodataProvider).value ?? {};

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          ref.refresh(staffListProvider.future),
          ref.refresh(visitorListProvider.future),
          ref.refresh(dependantListProvider.future),
          ref.refresh(contractorStaffListProvider.future),
          ref.refresh(allBiodataProvider.future),
        ]),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCombinedStats(context, ref, staffAsync, visitorAsync, dependantAsync, contractorAsync, biodataCounts),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedStats(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List> staffAsync,
    AsyncValue<List> visitorAsync,
    AsyncValue<List> dependantAsync,
    AsyncValue<List> contractorAsync,
    Map<int, int> biodataCounts,
  ) {
    final isLoading = staffAsync.isLoading || visitorAsync.isLoading || dependantAsync.isLoading || contractorAsync.isLoading;
    final hasError = staffAsync.hasError || visitorAsync.hasError || dependantAsync.hasError || contractorAsync.hasError;

    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hasError) {
      return Center(
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
                onPressed: () {
                  ref.invalidate(staffListProvider);
                  ref.invalidate(visitorListProvider);
                  ref.invalidate(dependantListProvider);
                  ref.invalidate(contractorStaffListProvider);
                },
                label: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final staffList = staffAsync.value ?? [];
    final visitorList = visitorAsync.value ?? [];
    final dependantList = dependantAsync.value ?? [];
    final contractorList = contractorAsync.value ?? [];


    final totalPersonnel = staffList.length + visitorList.length + dependantList.length + contractorList.length;

    final enrolledStaff = staffList.where((s) {
      return (biodataCounts[(s as dynamic).id] ?? 0) > 0;
    }).length;

    final enrolledVisitors = (visitorList).where((v) {
      final b = (v as dynamic).bioData;
      return b != null && b.isNotEmpty;
    }).length;

    final enrolledDependants = (dependantList).where((d) {
      final b = (d as dynamic).bioData;
      return b != null && b.isNotEmpty;
    }).length;

    final enrolledContractors = (contractorList).where((c) {
      final b = (c as dynamic).bioData;
      return b != null && b.isNotEmpty;
    }).length;

    final enrolledPersonnel = enrolledStaff + enrolledVisitors + enrolledDependants + enrolledContractors;
    final pendingPersonnel = totalPersonnel - enrolledPersonnel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsGrid(context, totalPersonnel, enrolledPersonnel, pendingPersonnel),
        const SizedBox(height: 20),
        _buildQuickActions(context),
      ],
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
            title: const Text('Dependant Directory', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('View dependants and manage their biodata'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onNavigateToDependants,
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

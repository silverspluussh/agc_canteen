import 'dart:developer';

import 'package:canteen_staff_enrollment/views/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:canteen_staff_enrollment/models/biodata.model.dart';
import 'package:canteen_staff_enrollment/models/employee_type.enum.dart';

import '../../controllers/staff_controller.dart';
import '../../core/network/network_api_dio.dart';
import '../../core/theme/app_colors.dart';
import '../../models/staff.model.dart';
import '../../repos/biodata_service.dart';
import 'biometric_enrollment_page.dart';

// ─── Page ─────────────────────────────────────────────────────────────────────

class StaffBiodataPage extends ConsumerStatefulWidget {
  final Staff staff;

  const StaffBiodataPage({super.key, required this.staff});

  @override
  ConsumerState<StaffBiodataPage> createState() => _StaffBiodataPageState();
}

class _StaffBiodataPageState extends ConsumerState<StaffBiodataPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  final Set<int> _togglingBiodataIds = {};

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  int get _staffId => widget.staff.id;

  ({int id, EmployeeType type}) get _biodataArgs {
    final employeeType = EmployeeType.values.firstWhere(
      (e) => e.name == widget.staff.employeeType,
      orElse: () => EmployeeType.permanent,
    );
    return (id: _staffId, type: employeeType);
  }

  String _fingerLabel(Finger finger) {
    switch (finger) {
      case Finger.thumb:
        return 'Thumb';
      case Finger.indexFinger:
        return 'Index Finger';
      case Finger.middle:
        return 'Middle Finger';
      case Finger.ring:
        return 'Ring Finger';
      case Finger.little:
        return 'Little (Pinky)';
    }
  }

  IconData _fingerIcon(Finger finger) {
    switch (finger) {
      case Finger.thumb:
        return Icons.thumb_up_outlined;
      case Finger.indexFinger:
        return Icons.touch_app_outlined;
      case Finger.middle:
        return Icons.pan_tool_outlined;
      case Finger.ring:
        return Icons.circle_outlined;
      case Finger.little:
        return Icons.fingerprint;
    }
  }


  Future<void> _confirmDelete(BioData biodata) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Fingerprint'),
        content: Text(
          'Are you sure you want to remove the "${_fingerLabel(biodata.finger)}" biometric record? '
          'This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          DestructiveButton(
            width: 120,
            onPressed: () => Navigator.pop(ctx, false),
            label: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          PrimaryButton(
            width: 120,

            onPressed: () => Navigator.pop(ctx, true),
            label: const Text(
              'Remove',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    _showDeletingDialog(biodata);
  }

  void _showDeletingDialog(BioData biodata) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Removing fingerprint...',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    _deleteBiodata(biodata);
  }

  Future<void> _deleteBiodata(BioData biodata) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final service = StaffBioDataService(networkAPI: NetworkAPI());
      await service.deleteBioData(biodata.id);
      ref.invalidate(staffBiodataProvider(_biodataArgs));
      ref.invalidate(staffListProvider);
      ref.invalidate(allBiodataProvider);
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('${_fingerLabel(biodata.finger)} removed successfully'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('Failed to remove fingerprint: $e')),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }

    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  // ─── Toggle biodata active/inactive ─────────────────────────────────────────

  Future<void> _confirmToggle(BioData biodata) async {
    final isCurrentlyActive = biodata.isActive;
    final finger = _fingerLabel(biodata.finger);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isCurrentlyActive ? 'Deactivate Fingerprint' : 'Activate Fingerprint'),
        content: Text(
          isCurrentlyActive
              ? 'Are you sure you want to deactivate the "$finger" biometric record? '
                  'The staff member will not be able to use this finger for authentication.'
              : 'Are you sure you want to activate the "$finger" biometric record? '
                  'The staff member will be able to use this finger for authentication.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          DestructiveButton(
            width: 120,
            onPressed: () => Navigator.pop(ctx, false),
            label: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          PrimaryButton(
            width: 120,
            onPressed: () => Navigator.pop(ctx, true),
            label: Text(
              isCurrentlyActive ? 'Deactivate' : 'Activate',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await _toggleBiodataActive(biodata);
  }

  Future<void> _toggleBiodataActive(BioData biodata) async {
    final messenger = ScaffoldMessenger.of(context);
    final isCurrentlyActive = biodata.isActive;

    setState(() => _togglingBiodataIds.add(biodata.id));

    try {
      final service = StaffBioDataService(networkAPI: NetworkAPI());
      if (isCurrentlyActive) {
        await service.deactivateBioData(biodata.id);
      } else {
        await service.activateBioData(biodata.id);
      }
      ref.invalidate(staffBiodataProvider(_biodataArgs));
      ref.invalidate(staffListProvider);
      ref.invalidate(allBiodataProvider);
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                '${_fingerLabel(biodata.finger)} ${isCurrentlyActive ? 'deactivated' : 'activated'}',
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      log('Error toggling biodata: $e');
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Failed to update fingerprint status: $e'),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      setState(() => _togglingBiodataIds.remove(biodata.id));
    }
  }

  // ─── Navigate to enrollment ────────────────────────────────────────────────

  Future<void> _goToEnrollment() async {
    final employeeType = EmployeeType.values.firstWhere(
      (e) => e.name == widget.staff.employeeType,
      orElse: () => EmployeeType.permanent,
    );
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BiometricEnrollmentPage(
          referenceId: widget.staff.id,
          employeeType: employeeType,
          displayName: widget.staff.fullname,
          subtitle: 'Employee ID: ${widget.staff.empId}',
          existingBioData: widget.staff.bioData,
          onEnrolled: () {
            ref.invalidate(staffBiodataProvider(_biodataArgs));
            ref.invalidate(staffListProvider);
            ref.invalidate(allBiodataProvider);
          },
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final biodataAsync = ref.watch(staffBiodataProvider(_biodataArgs));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.gold600,
        leading: BackButton(color: Colors.white),
        title: const Text('Staff Biodata'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PrimaryButton(
              width: 160,
              height: 40,
              onPressed: _goToEnrollment,
              prefixChild: const Icon(Icons.add, size: 18, color: Colors.white),
              label: const Text(
                'Add Fingerprint',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(staffBiodataProvider(_biodataArgs));
            ref.invalidate(staffListProvider);
            ref.invalidate(allBiodataProvider);
            await ref.read(staffBiodataProvider(_biodataArgs).future);
          },
          child: CustomScrollView(
            slivers: [
            // ── Staff Header ──────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildStaffHeader(context, isDark)),

            // ── Section Title ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: Row(
                  children: [
                    const Icon(Icons.fingerprint, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Enrolled Fingerprints',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Biodata List ──────────────────────────────────────────────
            biodataAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) =>
                  SliverFillRemaining(child: _buildErrorState(context, err)),
              data: (list) {
                if (list.isEmpty) {
                  return SliverFillRemaining(child: _buildEmptyState(context));
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  sliver: SliverList.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) =>
                        _buildBiodataCard(ctx, list[i], isDark),
                  ),
                );
              },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Staff header card ─────────────────────────────────────────────────────

  Widget _buildStaffHeader(BuildContext context, bool isDark) {
    final staff = widget.staff;
    final theme = Theme.of(context);
    final initials =
        staff.fullname.isNotEmpty ? staff.fullname[0] : '';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.gold800, AppColors.darkSecondary]
              : [AppColors.gold100, AppColors.gold50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.gold700 : AppColors.gold200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 25,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.fullname,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                _infoRow(Icons.badge_outlined, staff.empId),
                if (staff.department != null) ...[
                  const SizedBox(height: 2),
                  _infoRow(Icons.apartment_outlined, staff.department!.name),
                ],
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.55),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ─── Biodata card ──────────────────────────────────────────────────────────

  Widget _buildBiodataCard(BuildContext context, BioData bio, bool isDark) {
    final theme = Theme.of(context);
    final createdLabel = bio.createdAt != null
        ? 'Enrolled ${_formatDate(bio.createdAt!)}'
        : 'Enrolled date unknown';

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Row(
          children: [
            // Finger icon bubble
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _fingerIcon(bio.finger),
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Label + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fingerLabel(bio.finger),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    createdLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Status chip (tappable to toggle active/inactive)
            _togglingBiodataIds.contains(bio.id)
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _confirmToggle(bio),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: bio.isActive
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            bio.isActive
                                ? Icons.toggle_on
                                : Icons.toggle_off,
                            size: 20,
                            color: bio.isActive
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            bio.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: bio.isActive
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            const SizedBox(width: 8),

            // Delete button
            IconButton(
              tooltip: 'Remove fingerprint',
              icon: const Icon(Icons.delete_outline, size: 25),
              color: AppColors.error,
              onPressed: () => _confirmDelete(bio),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty / Error states ──────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint,
              size: 72,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 20),
            Text(
              'No fingerprints enrolled',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Add Fingerprint" to enroll a new finger.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 28),
            PrimaryButton( onPressed: _goToEnrollment,
              prefixChild: const Icon(Icons.add),
              label: const Text('Add Fingerprint',style: TextStyle(
                color: Colors.white
              ),),)
            
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load biodata',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            err.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(staffBiodataProvider(_biodataArgs)),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ─── Utilities ─────────────────────────────────────────────────────────────

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

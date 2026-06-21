import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/enrollment_controller.dart';
import '../../controllers/staff_controller.dart';
import '../../models/staff.model.dart';
import '../../core/theme/app_colors.dart';
import '../app_buttons.widget.dart';

class BiometricEnrollmentPage extends ConsumerStatefulWidget {
  final Staff staff;

  const BiometricEnrollmentPage({super.key, required this.staff});

  @override
  ConsumerState<BiometricEnrollmentPage> createState() =>
      _BiometricEnrollmentPageState();
}

class _BiometricEnrollmentPageState
    extends ConsumerState<BiometricEnrollmentPage> {
  Finger _selectedFinger = Finger.thumb;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(enrollmentProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final enrollmentState = ref.watch(enrollmentProvider);

    // Listen for enrollment state changes to trigger UI side-effects (e.g. snackbars or pop back)
    ref.listen(enrollmentProvider, (previous, next) {
      if (next.step == EnrollmentStep.enrolled) {
        ref.invalidate(staffListProvider);
        ref.invalidate(staffBiodataProvider(widget.staff.id.toString()));
        ref.invalidate(allBiodataProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint enrolled successfully!'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
        Navigator.pop(context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Enrollment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(enrollmentProvider.notifier).reset();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Staff Details Header Card
            _buildStaffHeaderCard(context),
            const SizedBox(height: 24),

            // Select Finger Section
            Text(
              'Select Finger to Enroll',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildFingerSelector(context),
            const SizedBox(height: 32),

            // Enrollment Interactive Panel
            _buildEnrollmentControlPanel(context, enrollmentState),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffHeaderCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.staff.firstName} ${widget.staff.lastName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Employee ID: ${widget.staff.empId}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  if (widget.staff.department != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Department: ${widget.staff.department?.name}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFingerSelector(BuildContext context) {
    final existingBio = widget.staff.bioData ?? [];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: Finger.values.map((finger) {
        final hasFinger = existingBio.any((bio) => bio.finger == finger);
        final isSelected = _selectedFinger == finger;

        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasFinger) ...[
                const Icon(Icons.check, size: 14, color: Colors.green),
                const SizedBox(width: 4),
              ],
              Text(
                _getFingerLabel(finger),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedFinger = finger;
              });
              ref.read(enrollmentProvider.notifier).reset();
            }
          },
        );
      }).toList(),
    );
  }

  String _getFingerLabel(Finger finger) {
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
        return 'Little Finger';
    }
  }

  Widget _buildEnrollmentControlPanel(
    BuildContext context,
    EnrollmentState state,
  ) {
    switch (state.step) {
      case EnrollmentStep.idle:
        return _buildPanelContainer(
          context,
          icon: Icons.fingerprint,
          color: Theme.of(context).colorScheme.primary,
          title: 'Ready to Capture',
          description:
              'Press the button below and place the staff member\'s selected finger on the scanner sensor.',
          actionButton: PrimaryButton(
            onPressed: () {
              ref
                  .read(enrollmentProvider.notifier)
                  .startEnrollment(widget.staff.id.toString(), _selectedFinger);
            },
            label: const Text(
              'Start Capture',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );

      case EnrollmentStep.capturing:
        return _buildPanelContainer(
          context,
          icon: Icons.sync,
          color: Theme.of(context).colorScheme.primary,
          title: 'Scanning...',
          description:
              'Place selected finger firmly on the POS fingerprint scanner.',
          isSpinning: true,
          actionButton: OutlineButton(
            onPressed: () {
              ref.read(enrollmentProvider.notifier).reset();
            },
            label: const Text('Cancel'),
          ),
        );

      case EnrollmentStep.captured:
        return _buildPanelContainer(
          context,
          icon: Icons.task_alt,
          color: const Color(0xFF2E7D32),
          title: 'Fingerprint Captured',
          description:
              'The fingerprint template was successfully extracted. Click confirm to enroll and save biodata.',
          imageWidget: state.captureResult?.imageBase64 != null
              ? Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 140,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.memory(
                    base64Decode(state.captureResult!.imageBase64!),
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          actionButton: Column(
            children: [
              PrimaryButton(
                onPressed: () {
                  ref.read(enrollmentProvider.notifier).confirmEnrollment();
                },
                color: const Color(0xFF2E7D32),
                label: const Text(
                  'Confirm & Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlineButton(
                onPressed: () {
                  ref
                      .read(enrollmentProvider.notifier)
                      .reset(); // Discards the current scan
                },
                label: const Text('Discard Scan'),
              ),
            ],
          ),
        );

      case EnrollmentStep.storing:
        return _buildPanelContainer(
          context,
          icon: Icons.cloud_upload_outlined,
          color: Theme.of(context).colorScheme.primary,
          title: 'Saving Biodata...',
          description: 'Sending biometric details to server. Please wait...',
          isSpinning: true,
        );

      case EnrollmentStep.enrolled:
        return _buildPanelContainer(
          context,
          icon: Icons.check_circle,
          color: const Color(0xFF2E7D32),
          title: 'Enrolled Successfully!',
          description: 'Staff biometrics saved in database.',
        );

      case EnrollmentStep.error:
        return _buildPanelContainer(
          context,
          icon: Icons.error_outline,
          color: AppColors.error,
          title: 'Capture Error',
          description:
              state.error ?? 'An unknown error occurred during capture.',
          actionButton: Column(
            children: [
              PrimaryButton(
                onPressed: () {
                  ref.read(enrollmentProvider.notifier).retry();
                },
                label: const Text(
                  'Retry Capture',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlineButton(
                onPressed: () {
                  ref.read(enrollmentProvider.notifier).reset();
                },
                label: const Text('Cancel'),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildPanelContainer(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    bool isSpinning = false,
    Widget? imageWidget,
    Widget? actionButton,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardTheme.color ??
            Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        children: [
          if (imageWidget != null)
            imageWidget
          else if (isSpinning)
            RotationTransition(
              turns: const AlwaysStoppedAnimation(
                0.2,
              ), // Simple static rotation or custom animation
              child: AnimatedRotation(
                turns: 1.0,
                duration: const Duration(seconds: 1),
                child: Icon(icon, size: 64, color: color),
              ),
            )
          else
            Icon(icon, size: 64, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          if (actionButton != null) ...[
            const SizedBox(height: 24),
            actionButton,
          ],
        ],
      ),
    );
  }
}

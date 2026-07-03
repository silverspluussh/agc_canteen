import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../core/enums/employee_type.enum.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/staff.model.dart';
import '../widgets/app_buttons.widget.dart';

class FingerprintEnrollmentSheet extends ConsumerStatefulWidget {
  const FingerprintEnrollmentSheet({
    required this.entityId,
    required this.displayName,
    this.entityType = EmployeeType.permanent,
    super.key,
  });

  final int entityId;
  final String displayName;
  final EmployeeType entityType;

  static Future<bool?> show(
    BuildContext context, {
    required int entityId,
    required String displayName,
    EmployeeType entityType = EmployeeType.permanent,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => FingerprintEnrollmentSheet(
          entityId: entityId,
          displayName: displayName,
          entityType: entityType,
        ),
      ),
    );
  }

  @override
  ConsumerState<FingerprintEnrollmentSheet> createState() =>
      _FingerprintEnrollmentSheetState();
}

class _FingerprintEnrollmentSheetState
    extends ConsumerState<FingerprintEnrollmentSheet> {
  Finger? _selectedFinger;
  bool _isScanning = false;

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
        return 'Pinky';
    }
  }

  Future<void> _enroll() async {
    if (_selectedFinger == null) return;

    try {
      final authService = ref.read(fingerprintAuthProvider);

      final alreadyExists = await authService.hasFingerType(
        widget.entityId,
        _selectedFinger!,
        entityType: widget.entityType,
      );
      if (alreadyExists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${_fingerLabel(_selectedFinger!)} is already enrolled. Remove the existing one first.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      setState(() => _isScanning = true);

      final isAvailable = await authService.isAvailable;
      if (!isAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fingerprint scanner not available')),
          );
          Navigator.of(context).pop();
        }
        return;
      }

      final fingerprintId = await authService.enroll(
        widget.entityId,
        _selectedFinger!,
        entityType: widget.entityType,
      );

      if (!mounted) return;

      if (fingerprintId != null) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fingerprint enrolled successfully')),
        );
      } else {
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint enrollment failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enrollment error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isScanning ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.enrollFingerprint),
      ),
      body: _isScanning
          ? _buildScanningView(colorScheme)
          : _buildSelectionView(l10n, colorScheme),
    );
  }

  Widget _buildSelectionView(AppLocalizations l10n, ColorScheme colorScheme) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fingerprint,
                size: 150,
                color: colorScheme.primary.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 24),
              Text(
                widget.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Text('Finger:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<Finger?>(
                      hint: const Text(
                        'Select finger',
                        style: TextStyle(fontSize: 16),
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: Finger.values.map((finger) {
                        return DropdownMenuItem(
                          value: finger,
                          child: Text(_fingerLabel(finger)),
                        );
                      }).toList(),
                      onChanged: (finger) {
                        setState(() => _selectedFinger = finger);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                onPressed: _selectedFinger == null ? null : _enroll,
                prefixChild: const Icon(Icons.fingerprint, color: Colors.white),
                label: Text(
                  l10n.enrollFingerprint,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanningView(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(strokeWidth: 4),
            ),
            const SizedBox(height: 32),
            Icon(Icons.fingerprint, size: 72, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              widget.displayName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedFinger != null ? _fingerLabel(_selectedFinger!) : '',
              style: TextStyle(fontSize: 16, color: colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Place your finger on the scanner...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

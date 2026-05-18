import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/pos/pos_fingerprint_service.dart';
import 'providers.dart';

enum EnrollmentStep { idle, capturing, captured, storing, enrolled, error }

class EnrollmentState {
  final EnrollmentStep step;
  final String? staffId;
  final String? fingerprintId;
  final FingerprintResult? captureResult;
  final String? error;

  const EnrollmentState({
    this.step = EnrollmentStep.idle,
    this.staffId,
    this.fingerprintId,
    this.captureResult,
    this.error,
  });

  EnrollmentState copyWith({
    EnrollmentStep? step,
    String? staffId,
    String? fingerprintId,
    FingerprintResult? captureResult,
    String? error,
  }) {
    return EnrollmentState(
      step: step ?? this.step,
      staffId: staffId ?? this.staffId,
      fingerprintId: fingerprintId ?? this.fingerprintId,
      captureResult: captureResult ?? this.captureResult,
      error: error ?? this.error,
    );
  }

  bool get isIdle => step == EnrollmentStep.idle;
  bool get isCapturing => step == EnrollmentStep.capturing;
  bool get showPreview => step == EnrollmentStep.captured;
  bool get isEnrolled => step == EnrollmentStep.enrolled;
  bool get hasError => step == EnrollmentStep.error;
}

class EnrollmentController extends Notifier<EnrollmentState> {
  @override
  EnrollmentState build() => const EnrollmentState();

  Future<void> startEnrollment(String staffId) async {
    state = state.copyWith(
      step: EnrollmentStep.capturing,
      staffId: staffId,
      error: null,
    );

    try {
      final device = ref.read(fingerprintDeviceProvider);
      final result = await device.capture();

      if (result == null || !result.success) {
        state = state.copyWith(
          step: EnrollmentStep.error,
          error: 'Fingerprint capture failed. Please try again.',
        );
        return;
      }

      state = state.copyWith(
        step: EnrollmentStep.captured,
        captureResult: result,
      );
    } catch (e) {
      state = state.copyWith(
        step: EnrollmentStep.error,
        error: e.toString(),
      );
    }
  }

  Future<void> confirmEnrollment() async {
    final staffId = state.staffId;
    if (staffId == null || state.captureResult == null) return;

    state = state.copyWith(step: EnrollmentStep.storing);

    try {
      final fingerprintAuth = ref.read(fingerprintAuthProvider);
      final fpId = await fingerprintAuth.enroll(staffId);

      if (fpId == null) {
        state = state.copyWith(
          step: EnrollmentStep.error,
          error: 'Failed to store fingerprint.',
        );
        return;
      }

      state = state.copyWith(
        step: EnrollmentStep.enrolled,
        fingerprintId: fpId,
      );
    } catch (e) {
      state = state.copyWith(
        step: EnrollmentStep.error,
        error: e.toString(),
      );
    }
  }

  void retry() {
    final staffId = state.staffId;
    if (staffId != null) {
      startEnrollment(staffId);
    } else {
      reset();
    }
  }

  void reset() {
    state = const EnrollmentState();
  }
}

final enrollmentProvider =
    NotifierProvider<EnrollmentController, EnrollmentState>(
  EnrollmentController.new,
);

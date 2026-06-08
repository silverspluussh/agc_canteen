import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/staff.model.dart';
import '../services/pos/pos_fingerprint_service.dart';
import 'providers.dart';

enum EnrollmentStep { idle, capturing, captured, storing, enrolled, error }

class EnrollmentState {
  final EnrollmentStep step;
  final String? staffId;
  final Finger? finger;
  final int? fingerprintId;
  final FingerprintResult? captureResult;
  final String? error;

  const EnrollmentState({
    this.step = EnrollmentStep.idle,
    this.staffId,
    this.finger,
    this.fingerprintId,
    this.captureResult,
    this.error,
  });

  EnrollmentState copyWith({
    EnrollmentStep? step,
    String? staffId,
    Finger? finger,
    int? fingerprintId,
    FingerprintResult? captureResult,
    String? error,
  }) {
    return EnrollmentState(
      step: step ?? this.step,
      staffId: staffId ?? this.staffId,
      finger: finger ?? this.finger,
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

  Future<void> startEnrollment(String staffId, Finger finger) async {
    state = state.copyWith(
      step: EnrollmentStep.capturing,
      staffId: staffId,
      finger: finger,
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
    if (staffId == null || state.finger == null || state.captureResult == null) return;

    state = state.copyWith(step: EnrollmentStep.storing);

    try {
      final fingerprintAuth = ref.read(fingerprintAuthProvider);
      final fpId = await fingerprintAuth.enroll(staffId, state.finger!);

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
    final finger = state.finger;
    if (staffId != null && finger != null) {
      startEnrollment(staffId, finger);
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

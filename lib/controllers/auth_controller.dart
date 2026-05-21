import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/injection_container.dart';
import '../services/activity_log_service.dart';
import '../services/auth/pos_auth_service.dart';
import 'providers.dart';

enum AuthStep { unauthenticated, authenticating, authenticated, completed, error }

class AuthState {
  final AuthStep step;
  final StaffAuthResult? staff;
  final String? error;

  const AuthState({
    this.step = AuthStep.unauthenticated,
    this.staff,
    this.error,
  });

  AuthState copyWith({
    AuthStep? step,
    StaffAuthResult? staff,
    String? error,
  }) {
    return AuthState(
      step: step ?? this.step,
      staff: staff ?? this.staff,
      error: error ?? this.error,
    );
  }

  bool get isUnauthenticated => step == AuthStep.unauthenticated;
  bool get isAuthenticating => step == AuthStep.authenticating;
  bool get isAuthenticated => step == AuthStep.authenticated;
  bool get isCompleted => step == AuthStep.completed;
  bool get hasError => step == AuthStep.error;
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> authenticate() async {
    state = state.copyWith(
      step: AuthStep.authenticating,
      error: null,
    );

    try {
      final posAuth = ref.read(posAuthProvider);
      final result = await posAuth.authenticateWithFingerprint();

      if (result == null) {
        getIt<ActivityLogService>().log(
          type: 'staff_auth_failure',
          message: 'Staff fingerprint authentication failed: no match',
          actorType: 'staff',
          metadata: {'reason': 'no_match'},
        );
        state = state.copyWith(
          step: AuthStep.error,
          error: 'Fingerprint not matched. Try again.',
        );
        return;
      }

      state = state.copyWith(
        step: AuthStep.authenticated,
        staff: result,
      );
      getIt<ActivityLogService>().log(
        type: 'staff_auth_success',
        message: 'Staff authenticated: ${result.firstName} ${result.lastName}',
        actorType: 'staff',
        actorId: result.staffId,
        actorName: '${result.firstName} ${result.lastName}',
      );
    } catch (e) {
      getIt<ActivityLogService>().log(
        type: 'staff_auth_failure',
        message: 'Staff authentication error: $e',
        actorType: 'staff',
        metadata: {'reason': 'exception', 'error': e.toString()},
      );
      state = state.copyWith(
        step: AuthStep.error,
        error: e.toString(),
      );
    }
  }

  /// Called after an order is completed — de-authenticates the current staff
  /// after a brief delay so the user can see the success feedback.
  Future<void> completeOrder() async {
    if (state.isAuthenticated) {
      final staff = state.staff;
      getIt<ActivityLogService>().log(
        type: 'staff_sign_out',
        message: 'Staff completed order and signed out: ${staff?.firstName ?? ""} ${staff?.lastName ?? ""}',
        actorType: 'staff',
        actorId: staff?.staffId,
        actorName: staff != null ? '${staff.firstName} ${staff.lastName}' : null,
      );
      await Future.delayed(const Duration(seconds: 3));
      state = const AuthState(step: AuthStep.completed);
    }
  }

  void reset() {
    if (state.isAuthenticated) {
      final staff = state.staff;
      getIt<ActivityLogService>().log(
        type: 'staff_sign_out',
        message: 'Staff session reset: ${staff?.firstName ?? ""} ${staff?.lastName ?? ""}',
        actorType: 'staff',
        actorId: staff?.staffId,
        actorName: staff != null ? '${staff.firstName} ${staff.lastName}' : null,
      );
    }
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(
      step: AuthStep.unauthenticated,
      error: null,
    );
  }
}

final authProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

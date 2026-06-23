import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../services/auth/admin_auth_service.dart';

enum AdminAuthStep {
  checking,
  unauthenticated,
  loading,
  awaitingOtp,
  authenticated,
  authenticatedOffline,
  error,
}

class AdminAuthState {
  final AdminAuthStep step;
  final String? token;
  final String? errorMessage;
  final String? sessionToken;
  final String? email;
  final String? password;

  const AdminAuthState({
    this.step = AdminAuthStep.checking,
    this.token,
    this.errorMessage,
    this.sessionToken,
    this.email,
    this.password,
  });

  AdminAuthState copyWith({
    AdminAuthStep? step,
    String? token,
    String? errorMessage,
    String? sessionToken,
    String? email,
    String? password,
  }) {
    return AdminAuthState(
      step: step ?? this.step,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
      sessionToken: sessionToken ?? this.sessionToken,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  bool get isChecking => step == AdminAuthStep.checking;
  bool get isUnauthenticated => step == AdminAuthStep.unauthenticated;
  bool get isLoading => step == AdminAuthStep.loading;
  bool get isAwaitingOtp => step == AdminAuthStep.awaitingOtp;
  bool get isAuthenticated =>
      step == AdminAuthStep.authenticated ||
      step == AdminAuthStep.authenticatedOffline;
  bool get isOffline => step == AdminAuthStep.authenticatedOffline;
  bool get hasError => step == AdminAuthStep.error;
}

class AdminAuthController extends Notifier<AdminAuthState> {
  @override
  // Start unauthenticated — tryAutoLogin() will set state to `checking`.
  // Starting as `checking` would cause the re-entrancy guard to fire on the
  // first call and leave the app stuck on the splash screen.
  AdminAuthState build() => const AdminAuthState(step: AdminAuthStep.unauthenticated);

  AdminAuthService get _service => getIt<AdminAuthService>();

  Future<void> tryAutoLogin() async {
    // Re-entrancy guard: if we are already in the middle of checking, bail out.
    // This prevents the AuthGate → _SplashScreen.initState → tryAutoLogin()
    // → setState(checking) → AuthGate rebuild → remount loop.
    if (state.isChecking) return;

    state = const AdminAuthState(step: AdminAuthStep.checking);

    final result = await _service.tryAutoLogin();

    switch (result.status) {
      case AdminAuthStatus.authenticated:
        state = AdminAuthState(
          step: AdminAuthStep.authenticated,
          token: result.token,
        );
      case AdminAuthStatus.authenticatedOffline:
        state = AdminAuthState(
          step: AdminAuthStep.authenticatedOffline,
          token: result.token,
        );
      case AdminAuthStatus.unauthenticated:
        state = const AdminAuthState(step: AdminAuthStep.unauthenticated);
      case AdminAuthStatus.error:
        state = const AdminAuthState(step: AdminAuthStep.unauthenticated);
      case AdminAuthStatus.loading:
      case AdminAuthStatus.awaitingOtp:
        break;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AdminAuthState(step: AdminAuthStep.loading);

    final result = await _service.login(email, password);

    switch (result.status) {
      case AdminAuthStatus.authenticated:
        state = AdminAuthState(
          step: AdminAuthStep.authenticated,
          token: result.token,
        );
       
        unawaited(_service.fetchSecretKey());
      case AdminAuthStatus.authenticatedOffline:
        state = AdminAuthState(
          step: AdminAuthStep.authenticatedOffline,
          token: result.token,
        );
      case AdminAuthStatus.awaitingOtp:
        state = AdminAuthState(
          step: AdminAuthStep.awaitingOtp,
          sessionToken: result.sessionToken,
          email: email.trim().toLowerCase(),
          password: password,
        );
      case AdminAuthStatus.error:
        state = AdminAuthState(
          step: AdminAuthStep.error,
          errorMessage: result.message,
        );
      case AdminAuthStatus.unauthenticated:
        state = const AdminAuthState(step: AdminAuthStep.unauthenticated);
      case AdminAuthStatus.loading:
        break;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    final sessionToken = state.sessionToken;
    final email = state.email;
    final password = state.password;
    if (sessionToken == null || email == null || password == null) return false;

    state = const AdminAuthState(step: AdminAuthStep.loading);

    final result = await _service.verifyOtp(
      sessionToken: sessionToken,
      otp: otp,
      email: email,
      password: password,
    );

    switch (result.status) {
      case AdminAuthStatus.authenticated:
        state = AdminAuthState(
          step: AdminAuthStep.authenticated,
          token: result.token,
        );
        unawaited(_service.fetchSecretKey());
        return true;
      case AdminAuthStatus.error:
      default:
        state = AdminAuthState(
          step: AdminAuthStep.awaitingOtp,
          errorMessage: result.message ?? 'OTP verification failed',
          sessionToken: sessionToken,
          email: email,
          password: password,
        );
        return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    state = const AdminAuthState(step: AdminAuthStep.unauthenticated);
  }

  void clearError() {
    if (state.isAwaitingOtp) {
      state = state.copyWith(step: AdminAuthStep.awaitingOtp, errorMessage: null);
    } else {
      state = AdminAuthState(
        step: AdminAuthStep.unauthenticated,
        token: state.token,
      );
    }
  }
}

final adminAuthProvider =
    NotifierProvider<AdminAuthController, AdminAuthState>(
  AdminAuthController.new,
);

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../services/auth/admin_auth_service.dart';
import '../../services/remote_data_sync_service.dart';

enum AdminAuthStep {
  checking,
  unauthenticated,
  loading,
  authenticated,
  authenticatedOffline,
  error,
}

class AdminAuthState {
  final AdminAuthStep step;
  final String? token;
  final String? errorMessage;

  const AdminAuthState({
    this.step = AdminAuthStep.checking,
    this.token,
    this.errorMessage,
  });

  AdminAuthState copyWith({
    AdminAuthStep? step,
    String? token,
    String? errorMessage,
  }) {
    return AdminAuthState(
      step: step ?? this.step,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isChecking => step == AdminAuthStep.checking;
  bool get isUnauthenticated => step == AdminAuthStep.unauthenticated;
  bool get isLoading => step == AdminAuthStep.loading;
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
        unawaited(getIt<RemoteDataSyncService>().syncAll());
      case AdminAuthStatus.authenticatedOffline:
        state = AdminAuthState(
          step: AdminAuthStep.authenticatedOffline,
          token: result.token,
        );
        unawaited(getIt<RemoteDataSyncService>().syncAll());
      case AdminAuthStatus.unauthenticated:
        state = const AdminAuthState(step: AdminAuthStep.unauthenticated);
      case AdminAuthStatus.error:
        state = const AdminAuthState(step: AdminAuthStep.unauthenticated);
      case AdminAuthStatus.loading:
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
        unawaited(getIt<RemoteDataSyncService>().syncAll());
      case AdminAuthStatus.authenticatedOffline:
        state = AdminAuthState(
          step: AdminAuthStep.authenticatedOffline,
          token: result.token,
        );
        unawaited(getIt<RemoteDataSyncService>().syncAll());
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

  Future<void> logout() async {
    await _service.logout();
    state = const AdminAuthState(step: AdminAuthStep.unauthenticated);
  }

  void clearError() {
    state = AdminAuthState(
      step: AdminAuthStep.unauthenticated,
      token: state.token,
    );
  }
}

final adminAuthProvider =
    NotifierProvider<AdminAuthController, AdminAuthState>(
  AdminAuthController.new,
);

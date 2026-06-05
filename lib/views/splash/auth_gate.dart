import 'dart:developer' as dev;
import 'package:agc_canteen/views/auth/staff_auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../controllers/admin_auth_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/providers.dart';
import '../../core/di/injection_container.dart';
import '../../services/pos/pos_device_service.dart';
import '../auth/admin_login_page.dart';
import '../pos/pos_page.dart';


class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminAuthProvider.notifier).tryAutoLogin();
      _initFingerprint();
      _initPosDevice();
    });
  }

  Future<void> _initFingerprint() async {
    dev.log('[AuthGate] Initializing fingerprint SDK on app start...',
        name: 'POS_AUTH');
    try {
      final posAuth = ref.read(posAuthProvider);
      final ok = await posAuth.init();
      if (ok) {
        dev.log('[AuthGate] Fingerprint SDK initialized successfully at startup',
            name: 'POS_AUTH');
      } else {
        dev.log('[AuthGate] Fingerprint SDK init returned false at startup',
            name: 'POS_AUTH');
      }
    } catch (e, st) {
      dev.log('[AuthGate] Fingerprint SDK init FAILED at startup: $e',
          name: 'POS_AUTH', error: e, stackTrace: st);
    }
  }

  Future<void> _initPosDevice() async {
    dev.log('[AuthGate] Initializing POS device SDK on app start...',
        name: 'POS_AUTH');
    try {
      final deviceService = getIt<PosDeviceService>();
      final ok = await deviceService.init();
      if (ok) {
        dev.log('[AuthGate] POS device SDK initialized successfully at startup',
            name: 'POS_AUTH');
      } else {
        dev.log('[AuthGate] POS device SDK init returned false at startup',
            name: 'POS_AUTH');
      }
    } catch (e, st) {
      dev.log('[AuthGate] POS device SDK init FAILED at startup: $e',
          name: 'POS_AUTH', error: e, stackTrace: st);
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminAuthProvider);
    final staffState = ref.watch(authProvider);

    ref.listen(authProvider, (prev, next) {
      if (next.isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) ref.read(authProvider.notifier).reset();
        });
      }
    });

    if (adminState.isChecking) {
      return _buildSplash(context);
    }

    if (adminState.isAuthenticated) {
      if (staffState.isAuthenticated) {
        return const PosPage();
      }
      return const StaffAuthPage();
    }

    return const AdminLoginPage();
  }

  Widget _buildSplash(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/app_logo.png', width: 120),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context).startingApp),
          ],
        ),
      ),
    );
  }
}

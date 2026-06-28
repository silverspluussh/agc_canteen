import 'dart:developer' as dev;
import 'package:canteen_staff_enrollment/controllers/admin_auth_controller.dart';
import 'package:canteen_staff_enrollment/controllers/injection_container.dart';
import 'package:canteen_staff_enrollment/views/auth/admin_login_page.dart';
import 'package:canteen_staff_enrollment/views/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/pos/pos_device_service.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _posInitStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminAuthProvider.notifier).tryAutoLogin();
    });
  }

  Future<void> _initPosDevice() async {
    if (_posInitStarted) return;
    _posInitStarted = true;

    dev.log('[AuthGate] Initializing POS device SDK after login...',
        name: 'POS_AUTH');
    try {
      final deviceService = getIt<PosDeviceService>();
      final ok = await deviceService.init();
      if (ok) {
        dev.log('[AuthGate] POS device SDK initialized successfully',
            name: 'POS_AUTH');
      } else {
        dev.log('[AuthGate] POS device SDK init returned false',
            name: 'POS_AUTH');
      }
    } catch (e, st) {
      dev.log('[AuthGate] POS device SDK init FAILED: $e',
          name: 'POS_AUTH', error: e, stackTrace: st);
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminAuthProvider);

    ref.listen(adminAuthProvider, (prev, next) {
      if (next.isAuthenticated && (prev == null || !prev.isAuthenticated)) {
        _initPosDevice();
      }
    });

    if (adminState.isChecking) {
      return _buildSplash(context);
    }

    if (adminState.isAuthenticated) {
      return const DashboardPage();
    }

//login
    return const AdminLoginPage();
  }

  Widget _buildSplash(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                   Image.asset('assets/app_logo.png', width: 200, height: 200),
            const SizedBox(height: 24),
            const LinearProgressIndicator(
              minHeight: 5,
            
            ),
            const SizedBox(height: 16),
            const Text('Loading...', style: TextStyle(fontSize: 20)),  ],
        ),
      ),
    );
  }
}

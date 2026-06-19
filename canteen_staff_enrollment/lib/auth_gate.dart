import 'dart:developer' as dev;
import 'package:canteen_staff_enrollment/controllers/admin_auth_controller.dart';
import 'package:canteen_staff_enrollment/controllers/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/pos/pos_device_service.dart';

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
      _initPosDevice();
    });
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

  

    if (adminState.isChecking) {
      return _buildSplash(context);
    }

    if (adminState.isAuthenticated) {
      
      return const SizedBox();
    }

//login
    return const SizedBox();
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

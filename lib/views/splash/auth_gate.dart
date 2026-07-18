import 'dart:async';
import 'dart:developer' as dev;
import 'package:agc_canteen/views/auth/single_auth_pos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/admin_auth_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../core/di/injection_container.dart';
import '../../services/pos/pos_device_service.dart';
import '../../services/sync_services/sync_from_remote_to_local.dart';
import '../auth/admin_login_page.dart';
import '../settings/pos_selection_dialog.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _syncStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminAuthProvider.notifier).tryAutoLogin();
      Future.delayed(const Duration(milliseconds: 500), _initPosDevice);
    });
  }

  Future<void> _startSyncWithPosCheck() async {
    if (_syncStarted) return;
    _syncStarted = true;

    final syncService = getIt<RemoteToLocalSyncService>();
    final alreadyRegistered = await syncService.isPosDeviceRegistered;

    if (!alreadyRegistered && mounted) {
      final selected = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const PosSelectionDialog(),
      );
      if (selected != true || !mounted) return;
    }

    if (mounted) {
      unawaited(syncService.syncDepartmentsOnly());
      unawaited(syncService.syncMealTypesOnly());
      unawaited(syncService.syncShiftsOnly());
      //  unawaited(syncService.syncAll());
    }
  }

  Future<void> _initPosDevice() async {
    dev.log(
      '[AuthGate] Initializing POS device SDK on app start...',
      name: 'POS_AUTH',
    );
    try {
      final deviceService = getIt<PosDeviceService>();
      final ok = await deviceService.init();
      if (ok) {
        dev.log(
          '[AuthGate] POS device SDK initialized successfully at startup',
          name: 'POS_AUTH',
        );
      } else {
        dev.log(
          '[AuthGate] POS device SDK init returned false at startup',
          name: 'POS_AUTH',
        );
      }
    } catch (e, st) {
      dev.log(
        '[AuthGate] POS device SDK init FAILED at startup: $e',
        name: 'POS_AUTH',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminAuthProvider);

    ref.listen(authProvider, (prev, next) {
      if (next.isCompleted && prev?.isCompleted != true) {
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) ref.read(authProvider.notifier).reset();
        });
      }
    });

    ref.listen(adminAuthProvider, (prev, next) {
      if (next.isAuthenticated && (prev == null || !prev.isAuthenticated)) {
        _startSyncWithPosCheck();
      }
    });

    if (adminState.isChecking) {
      return _buildSplash(context);
    }

    if (adminState.isAuthenticated) {
      return const SingleAuthPosPage();
    }

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
            const LinearProgressIndicator(minHeight: 5),
            const SizedBox(height: 16),
            const Text('Loading...', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}


// 
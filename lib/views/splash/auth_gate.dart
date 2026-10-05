import 'dart:async';

import 'package:agc_canteen/views/auth/single_auth_pos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/admin_auth_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/providers.dart';
import '../../core/di/injection_container.dart';
import '../../services/sync_services/sync_from_remote_to_local.dart';
import '../../services/sync_services/sync_scheduler.dart';
import '../auth/admin_login_page.dart';
import '../settings/pos_selection_dialog.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _syncStarted = false;
  late final SyncScheduler _scheduler;
  DateTime? _lastHandledSync;

  @override
  void initState() {
    super.initState();
    _scheduler = getIt<SyncScheduler>();
    _scheduler.snapshot.addListener(_onSyncSnapshot);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminAuthProvider.notifier).tryAutoLogin();
    });
  }

  @override
  void dispose() {
    _scheduler.snapshot.removeListener(_onSyncSnapshot);
    super.dispose();
  }

  /// Refresh the departments cache the moment a background cycle lands, so admin
  /// edits appear without the operator restarting the app. `ref.invalidate` on
  /// an unwatched provider is cheap — the stream only re-runs if a screen is
  /// currently listening.
  void _onSyncSnapshot() {
    final last = _scheduler.snapshot.value.lastSyncedAt;
    if (last == null || last == _lastHandledSync) return;
    _lastHandledSync = last;
    if (!mounted) return;
    ref.invalidate(departmentsProvider);
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
      // Departments first so the picker has data to render, then hand periodic
      // syncing to the scheduler (its immediate cycle covers the rest).
      unawaited(() async {
        await syncService.syncDepartmentsOnly();
        if (mounted) ref.invalidate(departmentsProvider);
      }());
      unawaited(_scheduler.start());
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
      } else if (!next.isAuthenticated && (prev?.isAuthenticated ?? false)) {
        _syncStarted = false;
        unawaited(_scheduler.stop());
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
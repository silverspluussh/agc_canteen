import 'package:agc_canteen/views/auth/staff_auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../controllers/admin_auth_controller.dart';
import '../../controllers/auth_controller.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminAuthProvider);
    final staffState = ref.watch(authProvider);

    if (adminState.isChecking) {
      return _buildSplash(context);
    }

    if (adminState.isAuthenticated) {
      if (staffState.isCompleted) {
        ref.read(authProvider.notifier).reset();
      }
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

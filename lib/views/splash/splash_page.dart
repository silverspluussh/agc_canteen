import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/admin_auth_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(adminAuthProvider, _handleAuthChange);
    ref.read(adminAuthProvider.notifier).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
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
            const Text('Loading...', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  void _handleAuthChange(AdminAuthState? prev, AdminAuthState next) {
    if (!mounted) return;

    if (next.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/staff-auth');
    } else if (next.isUnauthenticated) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}

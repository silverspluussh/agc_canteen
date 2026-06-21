import 'dart:async';
import 'dart:developer';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:canteen_staff_enrollment/auth_gate.dart';
import 'package:canteen_staff_enrollment/controllers/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';


void main() async => runZoneGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();
  final startupResults = await Future.wait([
    dotenv.load(),
    AdaptiveTheme.getThemeMode(),
    SharedPreferences.getInstance(),
  ]);

  final savedThemeMode = startupResults[1] as AdaptiveThemeMode?;

  await setupServiceLocator();
  runApp(ProviderScope(child: MyApp(savedThemeMode: savedThemeMode)));
});

void runZoneGuarded(void Function() body) {
  runZonedGuarded(body, (error, stack) {
    log(error.toString());
  });
}

class MyApp extends ConsumerWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveTheme(
      light: AppTheme.light,
      dark: AppTheme.dark,
      initial: savedThemeMode ?? AppTheme.initialMode,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'AGC Canteen',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,

        home: const AuthGate(),
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }
}

Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
  Widget page;
  switch (settings.name) {
    case '/biofinger-enrollment':
      page = const SizedBox();
      break;
    case '/staff-table':
      page = const SizedBox();
      break;
    case '/sync':
      page = const SizedBox();
      break;
    default:
      return null;
  }

  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
        child: FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).chain(CurveTween(curve: Curves.easeOut)).animate(animation),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
  );
}

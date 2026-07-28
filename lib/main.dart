import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/injection_container.dart';
import 'services/print/print_service_manager.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'views/splash/auth_gate.dart';
import 'views/reports/reports_page.dart';
import 'views/settings/settings_page.dart';
import 'views/staff/staff_management_page.dart';
import 'views/settings/sync_page.dart';
import 'views/pos/pos_settings_page.dart';
import 'views/pos/manual_order_page.dart';
import 'views/auth/group_order_auth_pos.dart';
import 'views/settings/printer_settings_page.dart';

final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('en');
});

void main() async => runZoneGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();
  final startupResults = await Future.wait([
    dotenv.load(),
    AdaptiveTheme.getThemeMode(),
    SharedPreferences.getInstance(),
  ]);

  final savedThemeMode = startupResults[1] as AdaptiveThemeMode?;
  final prefs = startupResults[2] as SharedPreferences;
  final savedLang = prefs.getString('app_language') ?? 'en';
  final savedLocale = Locale(savedLang);

  await setupServiceLocator();
  unawaited(getIt<PrintServiceManager>().ensureLoaded());
  runApp(
    ProviderScope(
      overrides: [localeProvider.overrideWith((ref) => savedLocale)],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
});

void runZoneGuarded(void Function() body) {
  runZonedGuarded(body, (error, stack) {
    runApp(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'App failed to start',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.runtimeType.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });
}

class MyApp extends ConsumerWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return AdaptiveTheme(
      light: AppTheme.light,
      dark: AppTheme.dark,
      initial: savedThemeMode ?? AppTheme.initialMode,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'ASG Canteen',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        locale: currentLocale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        localeResolutionCallback: (locale, supportedLocales) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: const AuthGate(),
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }
}

Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
  Widget page;
  switch (settings.name) {
    case '/':
      page = const AuthGate();
      break;
    case '/reports':
      page = const ReportsDashboardPage();
      break;
    case '/settings':
      page = const SettingsPage();
      break;
    case '/staff':
      page = const StaffManagementPage();
      break;
    case '/sync':
      page = const SyncPage();
      break;
    case '/pos':
      page = const PosSettingsPage();
      break;
    case '/printer-settings':
      page = const PrinterSettingsPage();
      break;
    case '/create-manual-order':
      page = const ManualOrderPage();
      break;
    case '/group-order':
      page = const GroupOrderAuthPos();
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

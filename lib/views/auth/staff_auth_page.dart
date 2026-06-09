import 'dart:developer' as dev;
import 'package:agc_canteen/main.dart';
import 'package:agc_canteen/views/settings/settings_page.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/auth_controller.dart';
import '../../core/di/injection_container.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/activity_log_service.dart';

class StaffAuthPage extends ConsumerStatefulWidget {
  const StaffAuthPage({super.key});

  @override
  ConsumerState<StaffAuthPage> createState() => _StaffAuthPageState();
}

class _StaffAuthPageState extends ConsumerState<StaffAuthPage> {
  Future<void> _startAuth() async {
    dev.log(
      '[StaffAuthPage] Scan button tapped — starting fingerprint auth',
      name: 'POS_AUTH',
    );
    await ref.read(authProvider.notifier).authenticate();
  }

  Future<void> _showAdminCodeDialog() async {
    final codeController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isWrong = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              constraints: const BoxConstraints(minWidth: 400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).adminAccess,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).enterAdminPin,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      obscureText: true,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '● ● ● ● ● ●',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                          letterSpacing: 6,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: isWrong
                            ? AppLocalizations.of(context).incorrectCode
                            : null,
                      ),
                      onChanged: (_) {
                        if (isWrong) {
                          setDialogState(() => isWrong = false);
                        }
                      },
                      validator: (v) {
                        if (v == null || v.trim().length != 6) {
                          return AppLocalizations.of(context).enter6Digits;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    AppLocalizations.of(context).cancel,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),

                PrimaryButton(
                  width: 120,
                  height: 48,
                  onPressed: () {
                    final accescode =
                        dotenv.env['ADMIN_ACCESS_CODE'] ?? '123456';
                    if (!formKey.currentState!.validate()) return;
                    if (codeController.text.trim() == accescode) {
                      Navigator.of(context).pop();
                      getIt<ActivityLogService>().log(
                        type: 'admin_code_access',
                        message:
                            'Admin accessed settings via PIN from staff auth screen',
                        actorType: 'admin',
                      );
                      Navigator.pushNamed(context, '/settings');
                    } else {
                      setDialogState(() => isWrong = true);
                      codeController.clear();
                    }
                  },
                  label: Text(
                    AppLocalizations.of(context).confirm,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    Size size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: OutlineButton(
            onPressed: _showLanguageDialog,
            prefixChild: const Icon(Icons.translate),
            label: Text(
              AppLocalizations.of(context).changeLanguage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: _showAdminCodeDialog,
              icon: Icon(
                Icons.settings,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),

        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        AppLocalizations.of(context).staffSignIn,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      // const SizedBox(height: 20),
                      const Spacer(),
                      AvatarGlow(
                        glowColor: Theme.of(context).colorScheme.primary,
                  
                        child: SvgPicture.asset(
                          'assets/illustrations/pos_auth_finger.svg',
                          width: 200,
                          height: 200,
                        ),
                      ),
                      const Spacer(),
                  
                      if (state.isUnauthenticated &&
                          !state.isAuthenticating &&
                          !state.hasError) ...[
                        const SizedBox(height: 20),
                        PrimaryButton(
                          width: 280,
                          height: 56,
                          onPressed: _startAuth,
                          prefixChild: const Icon(
                            Icons.fingerprint,
                            color: Colors.white,
                            size: 28,
                          ),
                          label: Text(
                            AppLocalizations.of(context).biometricLogin,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                      if (state.isAuthenticating) ...[
                        const LinearProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context).scanning,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                      if (state.isAuthenticated && state.staff != null) ...[
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${state.staff!.firstName} ${state.staff!.lastName}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                      if (state.hasError) ...[
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.error ??
                              AppLocalizations.of(context).somethingWentWrong,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _startAuth,
                          icon: const Icon(Icons.fingerprint),
                          label: Text(
                            AppLocalizations.of(context).retry,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog() async {
    const languages = [
      Lang('English', 'en'),
      Lang('French', 'fr'),
      Lang('Spanish', 'es'),
    ];

    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getString('app_language') ?? 'en';

    if (!mounted) return;
    String selected = current;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setD) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.translate),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context).language),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: languages.map((lang) {
                  return RadioListTile<String>(
                    value: lang.code,
                    groupValue: selected,
                    title: Text(lang.label),
                    onChanged: (v) => setD(() => selected = v!),
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(AppLocalizations.of(context).cancel),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                  ),
                  onPressed: () async {
                    await prefs.setString('app_language', selected);
                    ref.read(localeProvider.notifier).state = Locale(selected);
                    getIt<ActivityLogService>().log(
                      type: 'language_changed',
                      message:
                          'Language changed from POS: $current → $selected',
                      actorType: 'staff',
                      metadata: {
                        'old_language': current,
                        'new_language': selected,
                      },
                    );
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context).save,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

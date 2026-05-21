import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAuth();
    });
  }

  Future<void> _startAuth() async {
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
                    Text(AppLocalizations.of(context).enterAdminPin),
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
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                
                PrimaryButton(
                  width: 90,
                  height: 48,
                  onPressed: () {
                    final accescode = dotenv.env['ADMIN_ACCESS_CODE']!;               
                    if (!formKey.currentState!.validate()) return;
                    if (codeController.text.trim() == accescode) {
                      Navigator.of(context).pop();
                      getIt<ActivityLogService>().log(
                        type: 'admin_code_access',
                        message: 'Admin accessed settings via PIN from staff auth screen',
                        actorType: 'admin',
                      );
                      Navigator.pushNamed(context, '/settings');
                    } else {
                      setDialogState(() => isWrong = true);
                      codeController.clear();
                    }
                  },label: Text(
                    AppLocalizations.of(context).confirm,
                    style: const TextStyle(color: Colors.white),
                  ),)

               
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

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context).staffSignIn,
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(AppLocalizations.of(context).placeFinger),
                      Spacer(),
                      AvatarGlow(
                        glowColor: Theme.of(context).colorScheme.primary,

                        child: SvgPicture.asset(
                          'assets/illustrations/pos_auth_finger.svg',
                          width: 200,
                          height: 200,
                        ),
                      ),
                      Spacer(),

                      if (state.isAuthenticating) ...[
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(AppLocalizations.of(context).scanning),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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

              Positioned(
                top: 0,
                right: 20,
                child: IconButton(
                  onPressed: _showAdminCodeDialog,
                  icon: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

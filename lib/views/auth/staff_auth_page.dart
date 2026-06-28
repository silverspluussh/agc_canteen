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
import '../../controllers/providers.dart';
import '../../core/di/injection_container.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/database/activity_log_service.dart';

class StaffAuthPage extends ConsumerStatefulWidget {
  const StaffAuthPage({super.key});

  @override
  ConsumerState<StaffAuthPage> createState() => _StaffAuthPageState();
}

class _StaffAuthPageState extends ConsumerState<StaffAuthPage> {
  bool _fingerprintReady = false;
  bool _fingerprintInitFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFingerprint());
  }

  Future<void> _initFingerprint() async {
    dev.log(
      '[StaffAuthPage] Initializing fingerprint SDK...',
      name: 'POS_AUTH',
    );
    try {
      final posAuth = ref.read(posAuthProvider);
      final ok = await posAuth.init();
      if (mounted) {
        setState(() {
          _fingerprintReady = ok;
          _fingerprintInitFailed = !ok;
        });
      }
      if (ok) {
        dev.log(
          '[StaffAuthPage] Fingerprint SDK initialized successfully',
          name: 'POS_AUTH',
        );
      }
    } catch (e, st) {
      dev.log(
        '[StaffAuthPage] Fingerprint SDK init FAILED: $e',
        name: 'POS_AUTH',
        error: e,
        stackTrace: st,
      );
      if (mounted) setState(() => _fingerprintInitFailed = true);
    }
  }

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
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,

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
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 20),
                      AvatarGlow(
                        glowColor: Theme.of(context).colorScheme.primary,

                        child: SvgPicture.asset(
                          'assets/illustrations/pos_auth_finger.svg',
                          width: 200,
                          height: 200,
                        ),
                      ),
                      const Spacer(),

                      if (!_fingerprintReady && !_fingerprintInitFailed) ...[
                        const SizedBox(height: 20),
                        const LinearProgressIndicator(),
                        const SizedBox(height: 16),
                        const Text(
                          'Initializing biometrics...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                      if (state.isUnauthenticated &&
                          !state.isAuthenticating &&
                          !state.hasError &&
                          _fingerprintReady) ...[
                        const SizedBox(height: 20),
                        PrimaryButton(
                          width: 280,
                          height: 60,
                          onPressed: _startAuth,
                          prefixChild: const Icon(
                            Icons.fingerprint,
                            color: Colors.white,
                            size: 35,
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
                      if (state.isPlacingOrder) ...[
                        const LinearProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Printing voucher...',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                      if (state.isCompleted && state.orderCode != null) ...[
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Voucher Printed',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                        ),
                        const SizedBox(height: 16),
                        _VoucherCard(
                          orderCode: state.orderCode!,
                          staffName:
                              '${state.staff?.firstName ?? ""} ${state.staff?.lastName ?? ""}',
                          mealType: state.mealType ?? '',
                          orderTime: state.orderTime ?? '',
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
                          icon: const Icon(Icons.fingerprint, size: 30,),
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
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 10),
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
}

class _VoucherCard extends StatelessWidget {
  final String orderCode;
  final String staffName;
  final String mealType;
  final String orderTime;

  const _VoucherCard({
    required this.orderCode,
    required this.staffName,
    required this.mealType,
    required this.orderTime,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mealLabel =
        mealType[0].toUpperCase() + mealType.substring(1).replaceAll('_', ' ');
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'AGC CANTEEN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              orderCode,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            const Divider(height: 20),
            _row(context, 'Time', orderTime),
            _row(context, 'Staff', staffName),
            _row(context, 'Meal', mealLabel),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

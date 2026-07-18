import 'dart:developer' as dev;
import 'package:agc_canteen/core/theme/app_colors.dart';
import 'package:agc_canteen/views/auth/group_order_auth_pos.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:agc_canteen/views/widgets/avatarglow.widget.dart';
import 'package:agc_canteen/views/widgets/department_dropdown.widget.dart';
import 'package:agc_canteen/views/widgets/voucher_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/auth_settings_controller.dart';
import '../../controllers/providers.dart';
import '../../core/di/injection_container.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/database/activity_log_service.dart';

class SingleAuthPosPage extends ConsumerStatefulWidget {
  const SingleAuthPosPage({super.key});

  @override
  ConsumerState<SingleAuthPosPage> createState() => _SinglePosAuthPageState();
}

class _SinglePosAuthPageState extends ConsumerState<SingleAuthPosPage> {
  bool _fingerprintReady = false;
  bool _fingerprintInitFailed = false;
  int? _selectedDepartmentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).reset();
      _initFingerprint();
    });
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
      '[StaffAuthPage] Scan button tapped — starting fingerprint auth (departmentId=$_selectedDepartmentId)',
      name: 'POS_AUTH',
    );
    await ref.read(authProvider.notifier).authenticate(departmentId: _selectedDepartmentId);
  }

  List<Widget> _authButtons() {
    final settings = ref.watch(authSettingsProvider);
    final l10n = AppLocalizations.of(context);
    final buttons = <Widget>[];

    if (settings.enableFinger) {
      buttons.add(
        Expanded(
          child: PosButton(
            onPressed: _startAuth,
            prefixChild: const Icon(
              Icons.fingerprint,
              color: Colors.white,
              size: 35,
            ),
            label: Text(
              l10n.biometricLogin,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    if (settings.enableNfc) {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(width: 12));
      }
      buttons.add(
        Expanded(
          child: PosButton(
            color: AppColors.success,
            onPressed: () async {
              await ref.read(authProvider.notifier).authenticateWithNfc(departmentId: _selectedDepartmentId);
            },
            prefixChild: const Icon(
              Icons.nfc,
              color: Colors.white,
              size: 35,
            ),
            label: const Text(
              'Tap Card',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    if (buttons.isEmpty) return [];

    return [
      const SizedBox(height: 20),
      Row(children: buttons),
    ];
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
          backgroundColor: AppColors.gold600,
          automaticallyImplyLeading: false,
          centerTitle: false,
          toolbarHeight: 70,
          title: PrimaryButton(
            noShadow: true,
            width: 150,
            height: 50,
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(
                context,
                GroupOrderAuthPos.routeID,
              ).then((_) => ref.read(authProvider.notifier).reset());
            },
            prefixChild: Icon(Icons.group, color: Colors.white),
            label: Text(
              "Group Order",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          actions: [
            IconButton(
              onPressed: _showAdminCodeDialog,
              icon: Icon(Icons.settings, size: 30, color: Colors.white),
            ),
            SizedBox(width: 20),
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
                      Text(
                        "Generate Meal Voucher",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Department selector
                      DepartmentDropdown(
                        value: _selectedDepartmentId,
                        onChanged: (id) => setState(() => _selectedDepartmentId = id),
                      ),

                      const Spacer(),

                      BiometricGlow(),
                      const Spacer(),
                      if (!_fingerprintReady && !_fingerprintInitFailed) ...[
                        const SizedBox(height: 10),
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

                        ..._authButtons(),
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
                        VoucherCard(
                          orderCode: state.orderCode!,
                          staffName: state.staff?.displayName ?? "",
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
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                         ..._authButtons(),
                        
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
}

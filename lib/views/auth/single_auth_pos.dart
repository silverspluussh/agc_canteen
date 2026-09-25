import 'package:agc_canteen/core/utils/app_log.dart';
import 'package:agc_canteen/core/theme/app_colors.dart';
import 'package:agc_canteen/views/auth/group_order_auth_pos.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:agc_canteen/views/widgets/avatarglow.widget.dart';
import 'package:agc_canteen/views/widgets/department_search_field.widget.dart';
import 'package:agc_canteen/views/widgets/voucher_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/auth_settings_controller.dart';
import '../../controllers/providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../views/widgets/pos_meal_time_refresh.widget.dart';

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
    appLog('[StaffAuthPage] Initializing fingerprint SDK...', name: 'POS_AUTH');
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
        appLog(
          '[StaffAuthPage] Fingerprint SDK initialized successfully',
          name: 'POS_AUTH',
        );
      }
    } catch (e, st) {
      appLog(
        '[StaffAuthPage] Fingerprint SDK init FAILED: $e',
        name: 'POS_AUTH',
        error: e,
        stackTrace: st,
      );
      if (mounted) setState(() => _fingerprintInitFailed = true);
    }
  }

  Future<int?> _effectiveDepartmentId() async {
    if (_selectedDepartmentId != null) return _selectedDepartmentId;
    final departments = ref.read(departmentsProvider).value ?? [];
    if (departments.length == 1) return departments.first.id;
    return null;
  }

  Future<void> _startAuth() async {
    final departmentId = await _effectiveDepartmentId();
    appLog(
      '[StaffAuthPage] Scan button tapped — starting fingerprint auth (departmentId=$departmentId)',
      name: 'POS_AUTH',
    );
    await ref
        .read(authProvider.notifier)
        .authenticate(departmentId: departmentId);
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
              final departmentId = await _effectiveDepartmentId();
              await ref
                  .read(authProvider.notifier)
                  .authenticateWithNfc(departmentId: departmentId);
            },
            prefixChild: const Icon(Icons.nfc, color: Colors.white, size: 35),
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

    return [const SizedBox(height: 20), Row(children: buttons)];
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    return PosMealTimeRefresh(
      child: PopScope(
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
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                icon: Icon(Icons.settings, size: 30, color: Colors.white),
              ),
              const SizedBox(width: 20),
            ],
          ),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),

                  Text(
                    "Generate Meal Voucher",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Select Department",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  DepartmentSearchField(
                    value: _selectedDepartmentId,
                    onChanged: (id) =>
                        setState(() => _selectedDepartmentId = id),
                  ),
                  Expanded(child: Center(child: BiometricGlow())),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!_fingerprintReady &&
                              !_fingerprintInitFailed) ...[
                            const SizedBox(height: 15),
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
                            const SizedBox(height: 15),
                            ..._authButtons(),
                          ],
                          if (state.isAuthenticating) ...[
                            const LinearProgressIndicator(),
                            const SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context).scanning,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: () =>
                                  ref.read(authProvider.notifier).cancel(),
                              icon: const Icon(Icons.close, size: 18),
                              label: const Text('Cancel'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ],
                          if (state.isPlacingOrder) ...[
                            const LinearProgressIndicator(),
                            const SizedBox(height: 10),
                            Text(
                              'Printing voucher',
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
                            const SizedBox(height: 10),
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
                                  AppLocalizations.of(
                                    context,
                                  ).somethingWentWrong,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ..._authButtons(),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

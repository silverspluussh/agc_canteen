import 'package:agc_canteen/core/utils/app_log.dart';
import 'package:agc_canteen/core/theme/app_colors.dart';
import 'package:agc_canteen/views/auth/group_order_auth_pos.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:agc_canteen/views/widgets/avatarglow.widget.dart';
import 'package:agc_canteen/views/widgets/department_search_field.widget.dart';
import 'package:agc_canteen/views/widgets/voucher_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:agc_canteen/views/widgets/pos_mode_indicator.widget.dart';
import 'package:agc_canteen/views/widgets/fingerprint_init_recovery.widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/auth_settings_controller.dart';
import '../../controllers/providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/database/app_database.dart';
import '../../views/widgets/pos_meal_time_refresh.widget.dart';
import 'scan_department.dart';

class SingleAuthPosPage extends ConsumerStatefulWidget {
  const SingleAuthPosPage({super.key});

  @override
  ConsumerState<SingleAuthPosPage> createState() => _SinglePosAuthPageState();
}

class _SinglePosAuthPageState extends ConsumerState<SingleAuthPosPage> {
  bool _fingerprintReady = false;
  bool _fingerprintInitFailed = false;
  /// Guards against stacking init attempts; a retry takes ~20s.
  bool _fingerprintInitInProgress = false;
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
    // Give the kernel SPI driver time to probe before first launch() — the
    // sensor needs ~9s from cold boot (see logs: 5752→5826) while the old
    // 1s/2s/3s retry only covered ~6s.
    await Future.delayed(const Duration(seconds: 2));
    // Skip init if another page already brought the SDK up.
    try {
      final posAuth = ref.read(posAuthProvider);
      if (await posAuth.isFingerprintAvailable) {
        appLog('[StaffAuthPage] Fingerprint already available — skipping init',
            name: 'POS_AUTH');
        if (mounted) setState(() => _fingerprintReady = true);
        return;
      }
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

  /// Re-runs fingerprint initialisation after a failed first attempt.
  ///
  /// Safe to call repeatedly: the auth service short-circuits once the SDK is up
  /// and clears its own initialised flag when an attempt throws, so a retry
  /// genuinely re-probes rather than replaying a cached failure. Any auth session
  /// already in flight is dropped first so the page returns to a clean start.
  Future<void> _retryFingerprint() async {
    if (_fingerprintInitInProgress) return;

    setState(() {
      _fingerprintInitInProgress = true;
      // Back to the pre-init state so the spinner gives feedback during the retry.
      _fingerprintReady = false;
      _fingerprintInitFailed = false;
    });

    ref.read(authProvider.notifier).reset();

    try {
      await _initFingerprint();
    } finally {
      if (mounted) setState(() => _fingerprintInitInProgress = false);
    }

    if (!mounted) return;

    final ready = _fingerprintReady;
    appLog(
      ready
          ? '[StaffAuthPage] Fingerprint reload succeeded'
          : '[StaffAuthPage] Fingerprint reload failed again',
      name: 'POS_AUTH',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          ready
              ? 'Fingerprint reader ready.'
              : 'Fingerprint reader still unavailable. Check the connection '
                    'and try again.',
        ),
      ),
    );
  }

  /// The department a scan will run against, or null when the operator still
  /// has to choose one.
  ///
  /// A terminal that serves a single department auto-resolves it, so the
  /// operator never has to pick; every other terminal must select one before a
  /// scan can start. A scan without a department would search every enrolled
  /// fingerprint, which is both slow and ambiguous.
  int? _resolveDepartmentId(List<Department> departments) =>
      resolveScanDepartmentId(
        selectedDepartmentId: _selectedDepartmentId,
        departmentIds: [for (final d in departments) d.id],
      );

  Future<void> _startAuth(int departmentId) async {
    appLog(
      '[StaffAuthPage] Scan button tapped — starting fingerprint auth (departmentId=$departmentId)',
      name: 'POS_AUTH',
    );
    await ref
        .read(authProvider.notifier)
        .authenticate(departmentId: departmentId);
  }

  Future<void> _startNfc(int departmentId) async {
    appLog(
      '[StaffAuthPage] Card button tapped — starting NFC auth (departmentId=$departmentId)',
      name: 'POS_AUTH',
    );
    await ref
        .read(authProvider.notifier)
        .authenticateWithNfc(departmentId: departmentId);
  }

  List<Widget> _authButtons(int? departmentId) {
    final settings = ref.watch(authSettingsProvider);
    final l10n = AppLocalizations.of(context);
    final buttons = <Widget>[];

    if (settings.enableFinger) {
      buttons.add(
        Expanded(
          child: PosButton(
            onPressed: departmentId == null ? null : () => _startAuth(departmentId),
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
            onPressed: departmentId == null ? null : () => _startNfc(departmentId),
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

    return [
      const SizedBox(height: 20),
      if (departmentId == null) ...[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 18, color: AppColors.gold700),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Select a department to start scanning.',
                style: TextStyle(fontSize: 15, color: AppColors.gold700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
      Row(children: buttons),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final departments = ref.watch(departmentsProvider).value ?? const [];

    // A single-department terminal auto-selects it so the field reflects what a
    // scan will use, without asking the operator to pick.
    ref.listen(departmentsProvider, (previous, next) {
      final list = next.value ?? const [];
      if (_selectedDepartmentId == null && list.length == 1 && mounted) {
        setState(() => _selectedDepartmentId = list.first.id);
      }
    });

    final resolvedDepartmentId = _resolveDepartmentId(departments);
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
              FingerprintReloadAction(
                busy: _fingerprintInitInProgress,
                onPressed: _retryFingerprint,
              ),
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
                  const PosModeIndicator(),
                  const SizedBox(height: 12),
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
                          // The auth buttons below are gated on _fingerprintReady,
                          // so without this the page renders blank after a failed
                          // init: no buttons, no spinner, no explanation.
                          if (_fingerprintInitFailed)
                            FingerprintInitFailureCard(
                              busy: _fingerprintInitInProgress,
                              onRetry: _retryFingerprint,
                            ),
                          if (state.isUnauthenticated &&
                              !state.isAuthenticating &&
                              !state.hasError &&
                              _fingerprintReady) ...[
                            const SizedBox(height: 15),
                            ..._authButtons(resolvedDepartmentId),
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
                            ..._authButtons(resolvedDepartmentId),
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

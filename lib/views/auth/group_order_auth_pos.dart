import 'dart:async';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:agc_canteen/controllers/auth_controller.dart';
import 'package:agc_canteen/controllers/providers.dart';
import 'package:agc_canteen/core/theme/app_colors.dart';
import 'package:agc_canteen/l10n/generated/app_localizations.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:agc_canteen/views/widgets/avatarglow.widget.dart';
import 'package:agc_canteen/views/widgets/groupselector.widget.dart';
import 'package:agc_canteen/views/widgets/voucher_card.widget.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/injection_container.dart';
import '../../services/database/activity_log_service.dart';
import '../../services/database/app_database.dart';
import '../../services/auth/pos_auth_service.dart';
import '../../services/print/print_service_manager.dart';
import '../../services/sync_services/sync_from_local_to_remote.dart';

class GroupOrderAuthPos extends ConsumerStatefulWidget {
  const GroupOrderAuthPos({super.key});
  static const String routeID = '/group-order';

  @override
  ConsumerState<GroupOrderAuthPos> createState() => _GroupOrderAuthPosState();
}

class _GroupOrderAuthPosState extends ConsumerState<GroupOrderAuthPos> {
  bool _fingerprintReady = false;
  bool _fingerprintInitFailed = false;
  int _groupCount = 1;
  bool _isPlacingOrders = false;
  int _ordersPlaced = 0;
  String? _orderCode;
  String? _staffName;
  String? _mealType;
  String? _orderTime;

  void _increment() => setState(() => _groupCount++);
  void _decrement() => setState(() {
        if (_groupCount > 1) _groupCount--;
      });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)  {_initFingerprint();
        ref.read(authProvider.notifier).reset();

    });
    ref.listenManual(authProvider, (prev, next) {
      if (prev != null && !prev.isStaffReady && next.isStaffReady) {
        _placeGroupOrders(next.staff!);
      }
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
    await ref.read(authProvider.notifier).authenticateOnly();
  }

  Future<void> _placeGroupOrders(AuthResult staff) async {
    setState(() { _isPlacingOrders = true; _ordersPlaced = 0; });

    final db = getIt<AppDatabase>();

    final staffData = staff.staffId != null ? await db.getStaff(staff.staffId!) : null;

    if (staffData == null || staffData.allowGroupOrder != true) {
      if (mounted) {
        setState(() => _isPlacingOrders = false);
        ref.read(authProvider.notifier).reset();
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text('Group orders are not allowed for this staff member.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final maxAllowed = staffData.maxOrderCount;
    if (maxAllowed != null && maxAllowed > 0 && _groupCount > maxAllowed) {
      _groupCount = maxAllowed;
    }

    final allTypes = await db.getAllMealTypes();
    final now = DateTime.now();
    final nowIso = now.toIso8601String();
    final staffName = staff.displayName ?? 'Unknown';

    // Resolve current meal type
    final hour = now.hour;
    final mealType = hour < 10 ? 'breakfast' : hour < 15 ? 'lunch' : 'dinner';
    final matchedType = allTypes
        .where((t) => t.name.toLowerCase() == mealType)
        .firstOrNull;
    if (matchedType == null || matchedType.price <= 0) {
      if (!mounted) return;
      setState(() => _isPlacingOrders = false);
      ref.read(authProvider.notifier).reset();
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('$mealType meal type not found or has no price'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final price = matchedType.price;

    _mealType = mealType;
    _staffName = staffName;

    try {
      final posDevices = await db.getAllPosDevices();
      final posDevice = posDevices.firstOrNull;

      // Pre-generate all order codes in one pass
      final startCode = await db.nextOrderCode(
        staff.entityType?.entityName.substring(0, 1) ?? '',
        posDevice!.id,
        posDevice.kitchenId!,
      );
      final prefix = startCode.substring(0, startCode.lastIndexOf('-') + 1);
      final startNum = int.tryParse(startCode.split('-').last) ?? 0;
      final orders = <OrdersCompanion>[];

      for (int i = 0; i < _groupCount; i++) {
        final orderCode = '$prefix${(startNum + i).toString().padLeft(4, '0')}';
        if (i == 0) _orderCode = orderCode;

        orders.add(OrdersCompanion(
          id: Value(DateTime.now().millisecondsSinceEpoch + i),
          uuid: Value(const Uuid().v4()),
          orderCode: Value(orderCode),
          status: const Value('completed'),
          orderType: const Value('group'),
          mealType: Value(mealType),
          total: Value(price),
          groupCount: const Value(1),
          description:
              Value('[Group] $mealType (${i + 1}/$_groupCount)'),
          orderedById: Value(staff.staffId!),
          employeeType: Value(staff.entityType!.name),
          createdAt: Value(nowIso),
          updatedAt: Value(nowIso),
          syncStatus: const Value(0),
          syncUpdatedAt: const Value.absent(),
        ));
      }

      // Single transaction for all inserts
      await db.transaction(() async {
        for (int i = 0; i < orders.length; i++) {
          await db.insertOrder(orders[i]);
          setState(() => _ordersPlaced = i + 1);

          unawaited(_printGroupReceipt(
            orderCode: orders[i].orderCode.value,
            mealType: mealType,
            staffName: staffName,
            index: i + 1,
            total: _groupCount,
          ));
        }
      });

      unawaited(getIt<LocalToRemoteSyncService>().syncSingleOrders());

      getIt<ActivityLogService>().log(
        type: 'group_order_placed',
        message: 'Group order: $_groupCount vouchers ($mealType) for $staffName',
        actorType: 'Staff',
        actorId: staff.staffId,
        actorName: staffName,
        sourceTable: 'orders',
        metadata: {
          'order_codes': orders.map((o) => o.orderCode.value).toList(),
          'meal_type': mealType,
          'group_count': _groupCount,
          'order_type': 'group_fingerprint',
        },
      );

      _orderTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      if (mounted) {
        ref.read(authProvider.notifier).setOrderDetails(
              orderCode: _orderCode,
              mealType: mealType,
              orderTime: _orderTime,
            );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPlacingOrders = false);
        ref.read(authProvider.notifier).reset();
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text('Failed to place group orders: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _printGroupReceipt({
    required String orderCode,
    required String mealType,
    required String staffName,
    required int index,
    required int total,
  }) async {
    try {
      final printer = getIt<PrintServiceManager>();
      final now = DateTime.now();
      final pad = (int n) => n.toString().padLeft(2, '0');
      final date = '${now.year}-${pad(now.month)}-${pad(now.day)} '
          '${pad(now.hour)}:${pad(now.minute)}';

      final b = BytesBuilder();

      void ln(String s) => b.add('$s\n'.codeUnits);
      void boldOn() => b.add(const [0x1B, 0x45, 0x01]);
      void boldOff() => b.add(const [0x1B, 0x45, 0x00]);
      void centerOn() => b.add(const [0x1B, 0x61, 0x01]);
      void centerOff() => b.add(const [0x1B, 0x61, 0x00]);

      centerOn();
      ln('====================');
      ln('    AGC CANTEEN');
      ln('   [Group Order]');
      ln('====================');
      centerOn();
      boldOn();
      ln(orderCode);
      boldOff();
      ln('Time:  $date');
      ln('Staff: $staffName');
      ln('Meal:  ${mealType[0].toUpperCase()}${mealType.substring(1)}');
      ln('Qty:   $index / $total');
      ln('--------------------');
      ln('     THANK YOU!');
      ln('');

      final bytes = Uint8List.fromList(b.toBytes());
      final printed = await printer.printRawBytes(bytes);
      if (printed) {
        await printer.cutPaper();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.gold600,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 70,
        leading: BackButton(color: Colors.white),

        title: Text("Group Order Page"),
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
                  Text("Generate Group Meal Vouchers", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                                            const Spacer(),
                    BiometricGlow(),
                    const SizedBox(height: 30),

                    // ── Group count selector ──
                    GroupCountSelector(
                      count: _groupCount,
                      onIncrement: _increment,
                      onDecrement: _decrement,
                    ),

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
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
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
                    if (_isPlacingOrders && _ordersPlaced < _groupCount) ...[
                      const LinearProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Printing voucher ${_ordersPlaced + 1} / $_groupCount...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                    if (_ordersPlaced >= _groupCount &&
                        _groupCount > 0 &&
                        _orderCode != null) ...[
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_groupCount Vouchers Printed',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Staff: ${_staffName ?? ""} · $_mealType',
                        style: const TextStyle(fontSize: 14),
                      ),
                      VoucherCard(
                        orderCode: _orderCode!,
                        staffName: _staffName ?? '',
                        mealType: _mealType ?? '',
                        orderTime: _orderTime ?? '',
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
                      PrimaryButton(
                        onPressed: _startAuth,
                        prefixChild: const Icon(Icons.fingerprint, size: 30),
                        label: Text(
                          "Retry Scan",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        width: 280,
                        height: 60,
                        
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// mary adarkwa
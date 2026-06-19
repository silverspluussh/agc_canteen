import 'dart:async';
import 'dart:developer';
import 'package:agc_canteen/l10n/generated/app_localizations.dart';
import 'package:agc_canteen/main.dart';
import 'package:agc_canteen/views/pos/confirm_order_page.dart';
import 'package:agc_canteen/views/settings/settings_page.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:agc_canteen/views/widgets/meal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/providers.dart';
import '../../core/di/injection_container.dart';
import '../../services/activity_log_service.dart';
import '../../services/database/app_database.dart';
import '../../services/auth/pos_auth_service.dart';
import '../../services/meal_time_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PosPage extends ConsumerStatefulWidget {
  const PosPage({super.key});

  @override
  ConsumerState<PosPage> createState() => _PosPageState();
}

class _PosPageState extends ConsumerState<PosPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final staff = authState.staff;
    final orderState = ref.watch(orderProvider);
    final mealsAsync = ref.watch(mealsProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: _PosAppBar(
            staff: staff,
            onCancel: _showCancelOrderDialog,
            onLanguage: _showLanguageDialog,
          ),
          body: ref.watch(mealsProvider).when(
            data: (meals) {
              return _buildBody(meals, orderState);
            },
            loading: () => SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Loading meals, please wait...",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 20),
                  LinearProgressIndicator(),
                ],
              ),
            ),
            error: (e, _) => Center(
              child: Text(
                AppLocalizations.of(context).failedToLoadMeals(e.toString()),
              ),
            ),
          ),
          bottomNavigationBar: orderState.isEmpty
              ? null
              : _buildBottomBar(orderState),
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
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setD) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.language),
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

  Widget _buildBody(List<Meal> meals, OrderState orderState) {
    final selectedId = orderState.selectedMeal?.id;
    final availableTypes = ref.watch(availableMealTypesProvider);

    final mealTypeFiltered = meals.where((meal) {
      // return availableTypes.contains(meal.mealType.toLowerCase());
      return true;
    }).toList();
log(meals.first.toJsonString());
    final filteredMeals = mealTypeFiltered.where((meal) {
      final query = _searchQuery.toLowerCase().trim();
      if (query.isEmpty) return true;
      final nameMatches = meal.name.toLowerCase().contains(query);

      final typeMatches = meal.mealType.toLowerCase().contains(query);
      return nameMatches || typeMatches;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              onChanged: (_) {
                _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(milliseconds: 200), () {
                  setState(() {
                    _searchQuery = _searchController.text;
                  });
                });
              },
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).searchByNameOrType,
                hintStyle: const TextStyle(fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 18),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: filteredMeals.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No meals available at the moment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: 200,
                        child: PrimaryButton(
                          height: 45,
                          onPressed: () => ref.refresh(mealsProvider.future),
                          label: Text(
                            "Refresh",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.refresh(mealsProvider.future),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = filteredMeals[index];
                      final isSelected = meal.id == selectedId;
                      return MealCard(
                        meal: meal,
                        isSelected: isSelected,
                        onTap: () {
                          ref.read(orderProvider.notifier).selectMeal(meal);
                        },
                      );
                    },
                  ),
                ),
        ),
        if (orderState.error != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              orderState.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }

  Widget? _buildBottomBar(OrderState orderState) {
    final meal = orderState.selectedMeal;
    if (meal == null) {
      return BottomAppBar(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
        child: Center(
          child: Text(
            AppLocalizations.of(context).selectMealToBegin,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return BottomAppBar(
      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              meal.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          PrimaryButton(
            height: 50,
            width: 140,
            onPressed: orderState.step == OrderStep.processing
                ? null
                : () => _showConfirmation(orderState),
            prefixChild: orderState.step == OrderStep.processing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            label: Text(
              orderState.step == OrderStep.processing
                  ? AppLocalizations.of(context).placing
                  : AppLocalizations.of(context).confirmOrder,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).cancelOrder),
          ],
        ),
        content: Text(
          AppLocalizations.of(context).cancelOrderConfirm,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context).noContinue,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),

          DestructiveButton(
            width: 110,
            onPressed: () {
              Navigator.pop(context);
              ref.read(orderProvider.notifier).reset();
              final staff = ref.read(authProvider).staff;
              getIt<ActivityLogService>().log(
                type: 'staff_exit_pos',
                message:
                    'Staff exited POS: ${staff?.firstName ?? ''} ${staff?.lastName ?? ''}',
                actorType: 'staff',
                actorId: staff?.staffId,
                actorName: staff != null
                    ? '${staff.firstName} ${staff.lastName}'
                    : null,
              );
              ref.read(authProvider.notifier).reset();
            },
            label: Text(
              AppLocalizations.of(context).yesSignOut,
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmation(OrderState orderState) {
    final meal = orderState.selectedMeal;
    if (meal == null) return;

    final staff = ref.read(authProvider).staff;
    final staffName = staff != null
        ? '${staff.firstName} ${staff.lastName}'
        : 'Unknown';

    showDialog(
      context: context,
      fullscreenDialog: true,
      useSafeArea: false,
      barrierDismissible: false,
      barrierLabel: AppLocalizations.of(context).confirmOrder,
      builder: (ctx) => Dialog.fullscreen(
        child: ConfirmOrderSheet(
          meal: meal,
          staffName: staffName,
          onChangeMeal: () => ref.read(orderProvider.notifier).changeMeal(),
          onPlaceOrder: (desc, orderType) =>
              _placeOrder(description: desc, orderType: orderType),
          onDone: () {
            ref.read(orderProvider.notifier).reset();
            ref.read(authProvider.notifier).reset();
            getIt<ActivityLogService>().log(
              type: 'staff_exit_pos',
              message:
                  'Staff exited POS after order: ${staff?.firstName ?? ''} ${staff?.lastName ?? ''}',
              actorType: 'staff',
              actorId: staff?.staffId,
              actorName: staffName,
            );
          },
        ),
      ),
    );
  }

  Future<String?> _placeOrder({
    String? description,
    String orderType = 'dine_in',
  }) async {
    final staff = ref.read(authProvider).staff;
    if (staff == null) {
      return null;
    }

    await ref
        .read(orderProvider.notifier)
        .completeOrder(
          staff.staffId!,
          '${staff.firstName} ${staff.lastName}',
          description: description,
          orderType: orderType,
        );

    return ref.read(orderProvider).lastOrderCode;
  }
}

class _PosAppBar extends StatelessWidget implements PreferredSizeWidget {
  final StaffAuthResult? staff;
  final VoidCallback onCancel;
  final VoidCallback onLanguage;

  const _PosAppBar({
    this.staff,
    required this.onCancel,
    required this.onLanguage,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).appTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      actions: [
        if (staff != null) ...[
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Chip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              avatar: const Icon(Icons.person, size: 15, color: Colors.white),
              label: Text(
                '${staff!.firstName} ${staff!.lastName}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          InkWell(
            onTap: onCancel,
            child: Chip(
              color: const WidgetStatePropertyAll(Colors.red),
              backgroundColor: Colors.red,
              label: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
          ),
          // IconButton(
          //   onPressed: onLanguage,
          //   icon: const Icon(Icons.language),
          //   tooltip: AppLocalizations.of(context).language,
          // ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}

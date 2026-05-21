import 'dart:developer';

import 'package:agc_canteen/l10n/generated/app_localizations.dart';
import 'package:agc_canteen/main.dart';
import 'package:agc_canteen/views/settings/settings_page.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/providers.dart';
import '../../core/di/injection_container.dart';
import '../../services/activity_log_service.dart';
import '../../services/database/app_database.dart';
import '../../services/auth/pos_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PosPage extends ConsumerStatefulWidget {
  const PosPage({super.key});

  @override
  ConsumerState<PosPage> createState() => _PosPageState();
}

class _PosPageState extends ConsumerState<PosPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
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
          appBar: _buildAppBar(staff),
          body: mealsAsync.when(
            data: (meals) => _buildBody(meals, orderState),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text(
                AppLocalizations.of(context).failedToLoadMeals(e.toString()),
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(orderState),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(StaffAuthResult? staff) {
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
                '${staff.firstName} ${staff.lastName}',
                style: TextStyle(color: Colors.white,fontSize: 12),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            tooltip: AppLocalizations.of(context).cancelOrderAndExit,
            onPressed: () => _showCancelOrderDialog(),
          ),
          const SizedBox(width: 8),
        ],
        if (staff == null) ...[
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Chip(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              avatar: Icon(Icons.person, size: 15, color: Colors.white),
              label: Text(
                'Test Staff 1',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          IconButton(
            onPressed: _showLanguageDialog,
            icon: Icon(Icons.language),
            tooltip: AppLocalizations.of(context).language,
          ),

          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            tooltip: AppLocalizations.of(context).cancelOrderAndExit,
            onPressed: () => _showCancelOrderDialog(),
          ),
          const SizedBox(width: 8),
        ],
      ],
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

    final filteredMeals = meals.where((meal) {
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
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context).selectMeal,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
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
            ],
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
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context).noMealsMatch(_searchQuery),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: filteredMeals.length,
                  itemBuilder: (context, index) {
                    final meal = filteredMeals[index];
                    final isSelected = meal.id == selectedId;
                    return _MealCard(
                      meal: meal,
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(orderProvider.notifier).selectMeal(meal);
                      },
                    );
                  },
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          const SizedBox(width: 12),
          PrimaryButton(
            height: 50,
            width: 120,
            onPressed: orderState.step == OrderStep.processing
                ? null
                : () => _showConfirmation(orderState),prefixChild: orderState.step == OrderStep.processing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  
          ): null,
                  label: Text(
              orderState.step == OrderStep.processing
                  ? AppLocalizations.of(context).placing
                  : AppLocalizations.of(context).confirm,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
                  
                  )
          
        ],
      ),
    );
  }

  void _showCancelOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).cancelOrder),
          ],
        ),
        content: Text(AppLocalizations.of(context).cancelOrderConfirm),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).noContinue),
          ),

          DestructiveButton(
            width: 110,
            onPressed:  () {
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
            label: Text(AppLocalizations.of(context).yesSignOut, style: const TextStyle(color: Colors.white)),
            )
         
        ],
      ),
    );
  }

  void _showConfirmation(OrderState orderState) {
    final meal = orderState.selectedMeal;
    if (meal == null) return;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: _ConfirmOrderSheet(
          meal: meal,
          onChangeMeal: () => ref.read(orderProvider.notifier).changeMeal(),
          onPlaceOrder: (desc, orderType) {
            _placeOrder(description: desc, orderType: orderType);
          },
        ),
      ),
    );
  }

  void _placeOrder({String? description, String orderType = 'dine_in'}) {
    final staff = ref.read(authProvider).staff;
    if (staff == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ref
        .read(orderProvider.notifier)
        .completeOrder(
          staff.staffId,
          '${staff.firstName} ${staff.lastName}',
          description: description,
          orderType: orderType,
        );

    final meal = ref.read(orderProvider).selectedMeal;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(meal != null
            ? '${meal.name} — ${AppLocalizations.of(context).orderPlaced}'
            : AppLocalizations.of(context).orderPlaced),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

Widget _summaryRow(String label, String value, {bool bold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            fontSize: bold ? 18 : 14,
          ),
        ),
      ],
    ),
  );
}

class _ConfirmOrderSheet extends StatefulWidget {
  final Meal meal;
  final VoidCallback onChangeMeal;
  final void Function(String? description, String orderType) onPlaceOrder;

  const _ConfirmOrderSheet({
    required this.meal,
    required this.onChangeMeal,
    required this.onPlaceOrder,
  });

  @override
  State<_ConfirmOrderSheet> createState() => _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState extends State<_ConfirmOrderSheet> {
  final _descriptionController = TextEditingController();
  String _orderType = 'dine_in';
  String? _descriptionError;

  bool get _isLaCarte => widget.meal.mealType == 'la_carte';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder() {
    final desc = _descriptionController.text.trim();

    if (_isLaCarte && desc.isEmpty) {
      setState(() => _descriptionError = 'Description is required for A la carte');
      return;
    }

    Navigator.pop(context);
    widget.onPlaceOrder(desc.isEmpty ? null : desc, _orderType);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context).confirmOrder,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _summaryRow(AppLocalizations.of(context).meal, widget.meal.name),
          _summaryRow(
            AppLocalizations.of(context).mealType,
            widget.meal.mealType,
          ),

          const SizedBox(height: 15),
          TextField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: null,
            decoration: InputDecoration(
              labelText: _isLaCarte
                  ? '${AppLocalizations.of(context).description} *'
                  : AppLocalizations.of(context).description,
              border: const OutlineInputBorder(),
              hintText: _isLaCarte
                  ? 'Describe what you want to order'
                  : AppLocalizations.of(context).description,
              errorText: _descriptionError,
            ),
            onChanged: (_) {
              if (_descriptionError != null) {
                setState(() => _descriptionError = null);
              }
            },
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'dine_in', label: Text('Dine-in'), icon: Icon(Icons.table_restaurant)),
              ButtonSegment(value: 'takeout', label: Text('Takeout'), icon: Icon(Icons.takeout_dining)),
            ],
            selected: {_orderType},
            onSelectionChanged: (v) => setState(() => _orderType = v.first),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onChangeMeal();
                  },
                  child: Text(AppLocalizations.of(context).changeMeal),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: PrimaryButton(onPressed: _handlePlaceOrder, label: Text(AppLocalizations.of(context).placeOrder, style: const TextStyle(color: Colors.white)))),
            
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final Meal meal;
  final bool isSelected;
  final VoidCallback onTap;

  const _MealCard({
    required this.meal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
   
    return Card(
      elevation: isSelected ? 4 : 1,
      shadowColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Image.network(meal.photoUrl!, height: 50, fit: BoxFit.cover)),
                  CachedNetworkImage(
                    imageUrl: meal.photoUrl??"",
                    height: 90,
                    imageBuilder: (context, imageProvider) =>
                        Image(image: imageProvider, height: 80),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset("assets/app_logo.png", height: 80, width: 80),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    meal.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              Positioned(
                top: 0,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    meal.mealType,
                    style: const TextStyle(fontSize: 12),
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

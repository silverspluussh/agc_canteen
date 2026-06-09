import 'package:agc_canteen/l10n/generated/app_localizations.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../services/database/app_database.dart';

class ConfirmOrderSheet extends StatefulWidget {
  final Meal meal;
  final VoidCallback onChangeMeal;
  final void Function(String? description, String orderType) onPlaceOrder;

  const ConfirmOrderSheet({
    super.key,
    required this.meal,
    required this.onChangeMeal,
    required this.onPlaceOrder,
  });

  @override
  State<ConfirmOrderSheet> createState() => _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState extends State<ConfirmOrderSheet> {
  final _descriptionController = TextEditingController();
  String _orderType = 'dine_in';
  String? _descriptionError;

  bool get _isLaCarte => widget.meal.menuTypeId == '18';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder() {
    final desc = _descriptionController.text.trim();

    if (_isLaCarte && desc.isEmpty) {
      setState(
        () => _descriptionError = 'Description is required for A la carte',
      );
      return;
    }

    Navigator.pop(context);
    widget.onPlaceOrder(desc.isEmpty ? null : desc, _orderType);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context).confirmOrder,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _summaryRow(
                AppLocalizations.of(context).meal,
                widget.meal.name,
                bold: true,
              ),
              _summaryRow(
                AppLocalizations.of(context).mealType,
                widget.meal.mealType,
                bold: true,
              ),
              Divider(),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: null,
                keyboardType: TextInputType.multiline,

                decoration: InputDecoration(
                  labelText: _isLaCarte
                      ? '${AppLocalizations.of(context).description} *'
                      : AppLocalizations.of(context).description,
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      hintStyle: Theme.of(context).textTheme.titleMedium,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),

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
              const SizedBox(height: 30),
              SegmentedButton<String>(
                style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(
                    Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                segments: [
                  ButtonSegment(
                    value: 'dine_in',
                    label: Text(
                      'Dine-in',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    icon: Icon(Icons.table_restaurant),
                  ),
                  ButtonSegment(
                    value: 'takeout',
                    label: Text(
                      'Takeout',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    icon: Icon(Icons.takeout_dining),
                  ),
                ],
                selected: {_orderType},
                onSelectionChanged: (v) => setState(() => _orderType = v.first),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onChangeMeal();
                      },
                      style: ButtonStyle(
                        side: WidgetStatePropertyAll(
                          BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context).changeMeal,style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: _handlePlaceOrder,
                      label: Text(
                        AppLocalizations.of(context).placeOrder,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

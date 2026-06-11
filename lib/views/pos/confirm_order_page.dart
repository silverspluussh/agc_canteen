import 'package:agc_canteen/l10n/generated/app_localizations.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import '../../services/database/app_database.dart';

class ConfirmOrderSheet extends StatefulWidget {
  final Meal meal;
  final String staffName;
  final VoidCallback onChangeMeal;
  final Future<String?> Function(String? description, String orderType)
      onPlaceOrder;
  final VoidCallback onDone;

  const ConfirmOrderSheet({
    super.key,
    required this.meal,
    required this.staffName,
    required this.onChangeMeal,
    required this.onPlaceOrder,
    required this.onDone,
  });

  @override
  State<ConfirmOrderSheet> createState() => _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState extends State<ConfirmOrderSheet> {
  final _descriptionController = TextEditingController();
  String _orderType = 'dine_in';
  String? _descriptionError;
  String? _orderCode;
  bool _isPlacing = false;

  bool get _isLaCarte => widget.meal.menuTypeId == '18';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handlePlaceOrder() async {
    final desc = _descriptionController.text.trim();

    if (_isLaCarte && desc.isEmpty) {
      setState(
        () => _descriptionError = 'Description is required for A la carte',
      );
      return;
    }

    setState(() => _isPlacing = true);

    final orderCode =
        await widget.onPlaceOrder(desc.isEmpty ? null : desc, _orderType);

    if (!mounted) return;
    setState(() {
      _isPlacing = false;
      _orderCode = orderCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_orderCode != null) {
      return _buildReceipt(context);
    }
    return _buildForm(context);
  }

  Widget _buildReceipt(BuildContext context) {
    final now = DateTime.now();
    final date =
        '${now.year}-${_pad(now.month)}-${_pad(now.day)} '
        '${_pad(now.hour)}:${_pad(now.minute)}';
    final orderTypeLabel = _orderType == 'takeout' ? 'Takeout' : 'Dine-in';
    final desc = _descriptionController.text.trim();

    return PopScope(
      canPop: false,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 56,
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context).orderPlaced,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _dividerLine(),
                const SizedBox(height: 8),
                Text(
                  'AGC CANTEEN',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  _orderCode!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _receiptRow('Time', date),
                _receiptRow('Staff', widget.staffName),
                _receiptRow('Type', orderTypeLabel),
                const SizedBox(height: 8),
                _dividerLine(),
                const SizedBox(height: 8),
                _receiptRow(AppLocalizations.of(context).meal,
                    widget.meal.name),
                _receiptRow(
                    AppLocalizations.of(context).mealType, widget.meal.mealType),
                if (desc.isNotEmpty) _receiptRow('Description', desc),
                // _dividerLine(),
                // const SizedBox(height: 8),
                // _receiptRow(
                //   'TOTAL',
                //   '\$${widget.meal.price.toStringAsFixed(2)}',
                //   bold: true,
                // ),
                const SizedBox(height: 8),
                _dividerLine(),
                const SizedBox(height: 16),
                Text(
                  'THANK YOU!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onDone();
                    },
                    label: Text(
                      'Okay',
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
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
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
                      onPressed:
                          _isPlacing
                              ? null
                              : () {
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
                      child: Text(
                        AppLocalizations.of(context).changeMeal,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: _isPlacing ? null : _handlePlaceOrder,
                      label: _isPlacing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
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

  String _pad(int n) => n.toString().padLeft(2, '0');
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

Widget _receiptRow(String label, String value, {bool bold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _dividerLine() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 2),
    child: Divider(thickness: 1),
  );
}

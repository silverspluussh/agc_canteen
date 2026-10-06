import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../services/database/app_database.dart';

/// Searchable staff picker backed by SQL (`LIMIT 20`).
class StaffSearchField extends StatefulWidget {
  const StaffSearchField({
    super.key,
    this.value,
    required this.onChanged,
    this.validator,
    this.hintText = 'Search staff by name or ID',
  });

  final StaffData? value;
  final ValueChanged<StaffData?> onChanged;
  final String? Function(StaffData?)? validator;
  final String hintText;

  @override
  State<StaffSearchField> createState() => _StaffSearchFieldState();
}

class _StaffSearchFieldState extends State<StaffSearchField> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  int _searchGeneration = 0;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));
    _syncTextFromValue();
  }

  @override
  void didUpdateWidget(StaffSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _syncTextFromValue();
    }
  }

  void _syncTextFromValue() {
    final staff = widget.value;
    if (staff != null) {
      final label = _displayLabel(staff);
      if (_textController.text != label) {
        _textController.text = label;
      }
    } else if (widget.value == null) {
      _textController.clear();
    }
  }

  String _displayLabel(StaffData staff) =>
      '${staff.firstName} ${staff.lastName} (${staff.empId})';

  Future<List<StaffData>> _searchDebounced(String query) async {
    final generation = ++_searchGeneration;
    await Future.delayed(const Duration(milliseconds: 300));
    if (generation != _searchGeneration) return [];
    return getIt<AppDatabase>().searchStaff(query, limit: 20);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<StaffData>(
      initialValue: widget.value,
      validator: widget.validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RawAutocomplete<StaffData>(
              textEditingController: _textController,
              focusNode: _focusNode,
              displayStringForOption: _displayLabel,
              optionsBuilder: (textEditingValue) =>
                  _searchDebounced(textEditingValue.text),
              onSelected: (staff) {
                field.didChange(staff);
                widget.onChanged(staff);
                _textController.text = _displayLabel(staff);
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: widget.hintText,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              controller.clear();
                              field.didChange(null);
                              widget.onChanged(null);
                            },
                          )
                        : null,
                  ),
                  onChanged: (_) {
                    field.didChange(null);
                    widget.onChanged(null);
                  },
                  onFieldSubmitted: (_) => onFieldSubmitted(),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 240),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final staff = options.elementAt(index);
                          return ListTile(
                            dense: true,
                            title: Text(
                              '${staff.firstName} ${staff.lastName}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              staff.empId,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () => onSelected(staff),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

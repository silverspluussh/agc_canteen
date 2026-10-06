import 'package:agc_canteen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../services/database/app_database.dart';

/// Searchable department picker for POS screens — in-memory filter over synced departments.
class DepartmentSearchField extends ConsumerStatefulWidget {
  const DepartmentSearchField({
    super.key,
    this.value,
    required this.onChanged,
    this.hintText = 'Select your department',
  });

  final int? value;
  final ValueChanged<int?> onChanged;
  final String hintText;

  @override
  ConsumerState<DepartmentSearchField> createState() =>
      _DepartmentSearchFieldState();
}

class _DepartmentSearchFieldState extends ConsumerState<DepartmentSearchField> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  static const _fieldHeight = 56.0;
  static const _optionMinHeight = 56.0;
  static const _maxOptions = 20;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));
    _syncTextFromValue();
  }

  @override
  void didUpdateWidget(DepartmentSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _syncTextFromValue();
    }
  }

  void _syncTextFromValue() {
    final departments = ref.read(departmentsProvider).value ?? [];
    if (widget.value != null) {
      Department? match;
      for (final d in departments) {
        if (d.id == widget.value) {
          match = d;
          break;
        }
      }
      if (match != null) {
        final label = match.name;
        if (_textController.text != label) {
          _textController.text = label;
        }
        return;
      }
    }
    if (widget.value == null && !_focusNode.hasFocus) {
      _textController.clear();
    }
  }

  String _displayLabel(Department department) => department.name;

  List<Department> _filterDepartments(String query, List<Department> all) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return all.take(_maxOptions).toList();
    }
    return all
        .where((d) => d.name.toLowerCase().contains(normalized))
        .take(_maxOptions)
        .toList();
  }

  void _dismissKeyboard() {
    _focusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departmentsAsync = ref.watch(departmentsProvider);
    final departments = departmentsAsync.value ?? [];
    final isLoading = departmentsAsync.isLoading && departments.isEmpty;
    final hasError = departmentsAsync.hasError && departments.isEmpty;

    final hint = isLoading
        ? 'Loading departments...'
        : hasError
        ? 'Failed to load departments'
        : departments.isEmpty
        ? 'No departments synced yet'
        : widget.hintText;

    ref.listen(departmentsProvider, (previous, next) {
      if (next.hasValue && widget.value != null) {
        _syncTextFromValue();
      }
    });

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold600, width: 2),
        borderRadius: BorderRadius.circular(0),
      ),
      child: RawAutocomplete<Department>(
        textEditingController: _textController,
        focusNode: _focusNode,
        displayStringForOption: _displayLabel,
        optionsBuilder: (textEditingValue) =>
            _filterDepartments(textEditingValue.text, departments),
        onSelected: (department) {
          widget.onChanged(department.id);
          _textController.text = _displayLabel(department);
          _dismissKeyboard();
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return SizedBox(
            height: _fieldHeight,
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              enabled: !isLoading,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                color: AppColors.black900,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                hintText: hint,
                hintStyle: TextStyle(
                  color: AppColors.gold600.withOpacity(0.7),
                  fontSize: 18,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 28,
                  color: AppColors.gold600,
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        iconSize: 28,
                        icon: Icon(Icons.clear, color: AppColors.gold700),
                        tooltip: 'Clear (all departments)',
                        onPressed: () {
                          controller.clear();
                          widget.onChanged(null);
                        },
                      )
                    : null,
              ),
              onChanged: (_) {
                if (widget.value != null) {
                  widget.onChanged(null);
                }
              },
              onFieldSubmitted: (_) {
                onFieldSubmitted();
                _dismissKeyboard();
              },
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          if (options.isEmpty) return const SizedBox.shrink();

          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 6,
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final department = options.elementAt(index);
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onSelected(department),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: _optionMinHeight,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                department.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

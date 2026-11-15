import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Один пункт кастомного випадаючого списку фільтра.
class AppFilterItem<T> {
  const AppFilterItem({
    required this.value,
    required this.label,
    this.detail,
  });

  /// Значення, яке потрапить у `onChanged` при виборі пункту.
  final T value;
  /// Текст пункту у списку.
  final String label;
  /// Додатковий рядок під назвою.
  final String? detail;
}

/// Кастомний випадаючий список для фільтрів: водойми, типи водойм,
/// види риби, періоди тощо.
///
/// Простий список під полем — без модального вікна, без іконок і без анімацій.
/// Відкривається при натисканні на поле, закривається при виборі пункту або
/// дотику поза списком.
class AppFilterDropdown<T> extends StatefulWidget {
  const AppFilterDropdown({
    super.key,
    this.label,
    required this.hint,
    required this.items,
    this.value,
    required this.onChanged,
    this.allOptionLabel,
    this.searchable = false,
    this.enabled = true,
    this.width,
  });

  /// Підпис над полем (наприклад, 'Водойма', 'Вид риби').
  final String? label;
  /// Текст-заглушка, коли нічого не обрано.
  final String hint;
  /// Доступні варіанти.
  final List<AppFilterItem<T>> items;
  /// Поточне обране значення (`null` — нічого / "Усі").
  final T? value;
  /// Викликається з новим значенням (або `null` при виборі "Усі").
  final ValueChanged<T?> onChanged;
  /// Якщо задано — додається перший рядок із таким текстом; вибір скидає значення у `null`.
  final String? allOptionLabel;
  /// Показувати поле пошуку всередині списку (для довгих переліків).
  final bool searchable;
  /// Чи дозволено відкривати список.
  final bool enabled;
  final double? width;

  @override
  State<AppFilterDropdown<T>> createState() => _AppFilterDropdownState<T>();
}

class _AppFilterDropdownState<T> extends State<AppFilterDropdown<T>> {
  OverlayEntry? _overlayEntry;
  String _query = '';

  AppFilterItem<T>? _selectedItem() {
    for (final item in widget.items) {
      if (item.value == widget.value) {
        return item;
      }
    }
    return null;
  }

  /// Чи відкрито зараз випадаючий список.
  bool get _isOpen => _overlayEntry != null;

  List<AppFilterItem<T>> _filteredItems() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items.where((item) {
      return item.label.toLowerCase().contains(q) ||
          (item.detail != null && item.detail!.toLowerCase().contains(q));
    }).toList();
  }

  String _displayText() {
    final selected = _selectedItem();
    if (selected != null) return selected.label;
    if (widget.value != null) return widget.value.toString();
    return widget.hint;
  }

  void _toggle() {
    if (!widget.enabled) return;
    if (_overlayEntry != null) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _query = '';
    _overlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, setDropdownState) => Stack(
          children: [
            // Дотік поза списком закриває його
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _close,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 6,
              width: widget.width ?? size.width,
              child: _buildDropdown(setDropdownState),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildDropdown(StateSetter setDropdownState) {
    final filtered = _filteredItems();
    final hasAll = widget.allOptionLabel != null;
    final total = filtered.length + (hasAll ? 1 : 0);
    final maxVisible = 4;
    final itemHeight = 44.0;

    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.searchable)
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                autofocus: true,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Пошук',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F9F8),
                  contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primaryTeal,
                      width: 1.5,
                    ),
                  ),
                  isDense: true,
                ),
                onChanged: (value) {
                  _query = value;
                  setDropdownState(() {});
                },
              ),
            ),
          if (total == 0)
            const SizedBox(
              height: 44,
              child: Center(
                child: Text(
                  'Немає варіантів',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
            )
          else
            SizedBox(
              height: (total < maxVisible ? total : maxVisible).toDouble() * itemHeight,
              child: ScrollbarTheme(
                data: ScrollbarThemeData(
                  thickness: WidgetStateProperty.all(6.0),
                  radius: const Radius.circular(4),
                  thumbColor: WidgetStateProperty.all(AppColors.primaryTeal),
                  trackColor: WidgetStateProperty.all(
                    AppColors.cardBorder.withValues(alpha: 0.25),
                  ),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  radius: const Radius.circular(4),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: total,
                    itemBuilder: (context, index) {
                  final isAll = hasAll && index == 0;
                  final item = isAll
                      ? null
                      : filtered[index - (hasAll ? 1 : 0)];
                  final selected = isAll
                      ? widget.value == null
                      : item != null && item.value == widget.value;
                  return InkWell(
                    borderRadius: BorderRadius.circular(selected ? 12 : 0),
                    onTap: () {
                      _close();
                      widget.onChanged(isAll ? null : item!.value);
                    },
                    child: Container(
                      height: itemHeight,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.lightTealBg : Colors.white,
                        borderRadius: BorderRadius.circular(selected ? 12 : 0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          if (selected) ...[
                            const Icon(
                              Icons.check,
                              size: 16,
                              color: AppColors.primaryTeal,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              isAll ? widget.allOptionLabel! : item!.label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    selected ? FontWeight.w700 : FontWeight.w600,
                                color: selected
                                    ? AppColors.primaryTeal
                                    : AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        SizedBox(
          width: widget.width,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: widget.enabled ? _toggle : null,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isOpen ? AppColors.primaryTeal : AppColors.cardBorder,
                  width: 1.2,
                ),
                boxShadow: _isOpen
                    ? [
                        BoxShadow(
                          color: AppColors.primaryTeal.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14.5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _displayText(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _selectedItem() != null || widget.value != null
                              ? AppColors.textPrimary
                              : const Color(0xFF9AA8A7),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color:
                          _isOpen || _selectedItem() != null || widget.value != null
                              ? AppColors.primaryTeal
                              : AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

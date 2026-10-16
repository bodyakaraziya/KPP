import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Віджет для групи кнопок дій (Редагувати, Видалити тощо)
class ActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isVertical; // true = вертикальна розмітка, false = горизонтальна
  final double iconSize;
  final Color? editColor;
  final Color? deleteColor;
  final Color? backgroundColor;
  final double? padding;
  final double? spacing; // для вертикальної розмітки
  final bool showBackground; // чи показувати фон за іконками

  const ActionButtons({
    super.key,
    this.onEdit,
    this.onDelete,
    this.isVertical = false,
    this.iconSize = 20.0,
    this.editColor,
    this.deleteColor,
    this.backgroundColor,
    this.padding,
    this.spacing,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null) ...[
            _buildActionIcon(
              Icons.edit_outlined,
              onEdit,
              editColor ?? AppColors.textPrimary,
            ),
            if (onDelete != null) ...[
              SizedBox(height: spacing ?? 8.0),
            ],
          ],
          if (onDelete != null) ...[
            _buildActionIcon(
              Icons.delete_outlined,
              onDelete,
              deleteColor ?? const Color(0xFFB3261E),
            ),
          ],
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null) ...[
            _buildActionIcon(
              Icons.edit_outlined,
              onEdit,
              editColor ?? AppColors.textPrimary,
            ),
            if (onDelete != null) ...[
              SizedBox(width: spacing ?? 8.0),
            ],
          ],
          if (onDelete != null) ...[
            _buildActionIcon(
              Icons.delete_outlined,
              onDelete,
              deleteColor ?? const Color(0xFFB3261E),
            ),
          ],
        ],
      );
    }
  }

  Widget _buildActionIcon(IconData icon, VoidCallback? onTap, Color color) {
    if (showBackground && backgroundColor != null) {
      return Container(
        width: iconSize + (padding ?? 4.0) * 2,
        height: iconSize + (padding ?? 4.0) * 2,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular((iconSize + (padding ?? 4.0) * 2) / 2),
        ),
        child: IconButton(
          icon: Icon(icon, size: iconSize, color: color),
          onPressed: onTap,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      );
    } else {
      return IconButton(
        icon: Icon(icon, size: iconSize, color: color),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }
  }
}
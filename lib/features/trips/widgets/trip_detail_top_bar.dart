import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Верхня панель навігації та дій (кнопки "Назад", "Редагувати", "Видалити").
class TripDetailTopBar extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TripDetailTopBar({super.key, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(10),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chevron_left, color: AppColors.primaryTeal, size: 22),
                SizedBox(width: 4),
                Text(
                  'До списку виїздів',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            _buildActionIconButton(icon: Icons.edit_outlined, onTap: onEdit),
            const SizedBox(width: 8),
            _buildActionIconButton(icon: Icons.delete_outline, onTap: onDelete),
          ],
        ),
      ],
    );
  }

  Widget _buildActionIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }
}

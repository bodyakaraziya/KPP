import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Картка з аватаром, ім'ям та статистикою користувача.
class UserSummaryCard extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final String initial;
  final VoidCallback onAvatarTap;

  const UserSummaryCard({
    super.key,
    required this.name,
    this.avatarUrl,
    required this.initial,
    required this.onAvatarTap,
  });

  Widget _buildAvatar() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          avatarUrl!,
          width: 78,
          height: 78,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _avatarPlaceholder(),
        ),
      );
    }
    return _avatarPlaceholder();
  }

  Widget _avatarPlaceholder() {
    return ClipOval(
      child: Container(
        width: 78,
        height: 78,
        color: AppColors.lightAmberBg,
        alignment: Alignment.center,
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.accentAmber,
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Аватар
              GestureDetector(
                onTap: onAvatarTap,
                child: Stack(
                  children: [
                    Container(
                      width: 78,
                      height: 78,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryTeal,
                          width: 2.2,
                        ),
                      ),
                      child: _buildAvatar(),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Ім'я
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'У спільноті з травня 2023',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 16),

          // Статистика: 18 виїзди | 86,4 кг улов | 12 видів
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildStatColumn(value: '18', label: 'виїзди'),
                ),
                const VerticalDivider(
                  color: AppColors.cardBorder,
                  thickness: 1,
                ),
                Expanded(
                  child: _buildStatColumn(value: '86,4', label: 'кг улов'),
                ),
                const VerticalDivider(
                  color: AppColors.cardBorder,
                  thickness: 1,
                ),
                Expanded(
                  child: _buildStatColumn(value: '12', label: 'видів'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

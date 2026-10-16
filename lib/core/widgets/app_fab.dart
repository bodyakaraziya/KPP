import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Custom Floating Action Button with consistent app styling
class AppFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? heroTag;
  final double iconSize;

  const AppFab({
    super.key,
    required this.onPressed,
    required this.icon,
    this.heroTag,
    this.iconSize = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: AppColors.primaryTeal,
      foregroundColor: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      onPressed: onPressed,
      child: Icon(icon, size: iconSize),
    );
  }
}
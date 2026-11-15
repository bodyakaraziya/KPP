import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../statistics/screens/statistics_screen.dart';
import '../../tackle/screens/tackle_screen.dart';
import '../widgets/arsenal_card.dart';
import '../widgets/recent_trips_section.dart';
import '../widgets/statistics_card.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    // Дані користувача беруться реактивно з AuthProvider (лаба №5, завдання 3.1–3.2).
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final profile = auth.profile;

    final userName = (profile?.displayName ?? user?.displayName ?? '')
        .trim()
        .isNotEmpty
        ? (profile?.displayName ?? user?.displayName ?? 'Користувач')
        : 'Користувач';
    final avatarUrl = (profile?.photoURL ?? user?.photoURL ?? '').isNotEmpty
        ? (profile?.photoURL ?? user?.photoURL)
        : null;
    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'К';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          stops: [0.0, 0.35],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, userName, avatarUrl, userInitial),
              const SizedBox(height: 22),

              StatisticsCard(
                onStatisticsTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StatisticsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              ArsenalCard(
                onTackleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TackleScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              const RecentTripsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, String userName, String? avatarUrl, String userInitial) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Привіт, $userName!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Гарний день, щоб згадати останній улов.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildAvatar(context, avatarUrl, userInitial),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, String? avatarUrl, String userInitial) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.lightAmberBg,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.lightAmberBg,
      child: Text(
        userInitial,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.accentAmber,
        ),
      ),
    );
  }
}

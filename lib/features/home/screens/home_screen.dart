import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../tackle/screens/tackle_screen.dart';
import '../../trips/screens/trip_detail_screen.dart';
import '../../statistics/screens/statistics_screen.dart';
import '../../auth/repositories/auth_repository.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthRepository _authRepository = AuthRepository();
  StreamSubscription<User?>? _authSubscription;

  String _userName = 'Користувач';
  String? _avatarUrl;
  String _userInitial = 'К';

  @override
  void initState() {
    super.initState();
    _updateUser(_authRepository.currentUser);
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (mounted) _updateUser(user);
    });
  }

  void _updateUser(User? user) {
    _userName = (user?.displayName ?? '').trim().isNotEmpty
        ? user!.displayName!
        : 'Користувач';
    _avatarUrl = user?.photoURL;
    _userInitial = _userName.isNotEmpty ? _userName[0].toUpperCase() : 'К';
    setState(() {});
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _openTackleScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TackleScreen()),
    );
  }

  void _openStatisticsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StatisticsScreen()),
    );
  }

  Widget _buildAvatar() {
    if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.lightAmberBg,
        backgroundImage: NetworkImage(_avatarUrl!),
      );
    }
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.lightAmberBg,
      child: Text(
        _userInitial,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.accentAmber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              // 1. Шапка: Привітання + Аватар
              _buildHeader(context),
              const SizedBox(height: 22),

              // 2. Єдина картка "Статистика сезону" (в одному стилі з Арсеналом)
              _buildStatisticsCard(context),
              const SizedBox(height: 16),

              // 3. Блок "Мій арсенал"
              _buildArsenalCard(context),
              const SizedBox(height: 24),

              // 4. Секція "Останні виїзди"
              _buildRecentTripsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Привіт, $_userName!',
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
        _buildAvatar(),
      ],
    );
  }

  Widget _buildStatisticsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок картки
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Статистика сезону',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Ваші досягнення та динаміка улову',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Верхній ряд: 2 чисті симетричні плитки (Виїзди + Загальний улов)
          Row(
            children: [
              Expanded(
                child: _buildStatMiniBox(
                  icon: Icons.calendar_today_outlined,
                  iconBgColor: AppColors.lightTealBg,
                  iconColor: AppColors.primaryTeal,
                  label: 'ВИЇЗДІВ ЗА РІК',
                  value: '18',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatMiniBox(
                  icon: Icons.set_meal_outlined,
                  iconBgColor: AppColors.lightGreenBg,
                  iconColor: AppColors.accentGreen,
                  label: 'ЗАГАЛЬНИЙ УЛОВ',
                  value: '86,4 кг',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Нижня плашка: Найкращий трофей
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightAmberBg.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.lightAmberBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.emoji_events_outlined,
                    color: AppColors.accentAmber,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'НАЙКРАЩИЙ ТРОФЕЙ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Щука · Дніпровська затока',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '8,2 кг',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentAmber,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Кнопка переходу
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () => _openStatisticsScreen(context),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.lightTealBg,
                foregroundColor: AppColors.primaryTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Детальна статистика',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatMiniBox({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Верхній ряд: Іконка зліва + Велика цифра справа
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Підпис тепер має ВСЮ ширину плитки і ніколи не обрізається
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArsenalCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Мій арсенал',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Снасті під рукою',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Позиція 1: Вудка
          _buildTackleItem(
            icon: Icons.set_meal_outlined,
            iconBgColor: AppColors.lightTealBg,
            iconColor: AppColors.primaryTeal,
            category: 'ВУДКА',
            name: 'Спінінг Favorite X1 2.1м',
          ),
          const SizedBox(height: 14),

          // Позиція 2: Котушка
          _buildTackleItem(
            icon: Icons.wb_sunny_outlined,
            iconBgColor: AppColors.lightGreenBg,
            iconColor: AppColors.accentGreen,
            category: 'КОТУШКА',
            name: 'Shimano Nasci C3000',
          ),
          const SizedBox(height: 18),

          // Кнопка "Весь арсенал >"
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () => _openTackleScreen(context),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.lightTealBg,
                foregroundColor: AppColors.primaryTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Весь арсенал',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTackleItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String category,
    required String name,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTripsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Останні виїзди',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Ваші найсвіжіші пригоди на воді',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        _buildRecentTripCard(
          context,
          title: 'Озеро Біле — Ранковий спінінг',
          date: '12 жовтня · 06:30',
          catchSummary: 'Щука 8.2 кг, Окунь 0.6 кг',
        ),
        const SizedBox(height: 10),
        _buildRecentTripCard(
          context,
          title: 'Річка Дністер — Фідерна сесія',
          date: '5 жовтня · 05:00',
          catchSummary: 'Лящ 2.4 кг, Плітка 1.1 кг',
        ),
      ],
    );
  }

  Widget _buildRecentTripCard(
    BuildContext context, {
    required String title,
    required String date,
    required String catchSummary,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TripDetailScreen(
              tripName: title,
              tripDate: date,
              tripLocation: title.split(' — ').first,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.lightTealBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.place_outlined,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    catchSummary,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

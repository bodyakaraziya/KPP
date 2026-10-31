import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_fab.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../auth/screens/login_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../trips/screens/trips_screen.dart';
import '../../water_bodies/screens/water_bodies_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../trips/screens/add_trip_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthRepository _authRepository = AuthRepository();
  StreamSubscription<User?>? _authSubscription;
  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user == null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _switchTab),
      const TripsScreen(),
      const WaterBodiesScreen(),
      const ProfileScreen(),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        floatingActionButton: _currentIndex == 0 || _currentIndex == 1
            ? AppFab(
                heroTag: 'main_screen_fab',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddTripScreen()),
                  );
                },
                icon: Icons.add,
              )
            : null,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.cardBorder, width: 0.8),
            ),
          ),
          child: NavigationBar(
            height: 70,
            selectedIndex: _currentIndex,
            onDestinationSelected: _switchTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_outlined),
                label: 'Головна',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: 'Виїзди',
              ),
              NavigationDestination(
                icon: Icon(Icons.water_drop_outlined),
                selectedIcon: Icon(Icons.water_drop),
                label: 'Водойми',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Профіль',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

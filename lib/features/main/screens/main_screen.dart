import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../home/screens/home_screen.dart';
import '../../trips/screens/trips_screen.dart';
import '../../water_bodies/screens/water_bodies_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../trips/screens/add_trip_screen.dart';

import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
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
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            Brightness.dark, // ⚫ ТЕМНІ кнопки на світлому тлі
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        floatingActionButton: _currentIndex == 0 || _currentIndex == 1
            ? FloatingActionButton(
                heroTag: 'main_screen_fab',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddTripScreen()),
                  );
                },
                backgroundColor: AppColors.primaryTeal,
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.add, size: 30),
              )
            : null,
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

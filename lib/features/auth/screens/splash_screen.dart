import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _progressTimer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startProgressAnimation();
  }

  void _startProgressAnimation() {
    const duration = Duration(milliseconds: 2600);
    const steps = 100;
    final stepDuration = Duration(
      milliseconds: duration.inMilliseconds ~/ steps,
    );

    _progressTimer = Timer.periodic(stepDuration, (timer) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          _progressTimer?.cancel();
          _navigateToLogin();
        }
      });
    });
  }

  void _navigateToLogin() {
    if (!mounted) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light, // ⚪ Білий годинник і батарея вгорі
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            Brightness.light, // ⚪ Білі системні кнопки внизу
        systemNavigationBarContrastEnforced: false,
      ),
      child: GestureDetector(
        onTap: _navigateToLogin,
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A393D),
                  Color(0xFF0D4E45),
                  Color(0xFF13503B),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Декоративна тонка дуга на фоні справа знизу (як у Figma)
                Positioned(
                  right: -120,
                  bottom: -60,
                  child: Container(
                    width: 380,
                    height: 520,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),

                // Основний контент по центру
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Іконка з подвійним концентричним ореолом
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(42),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(34),
                          ),
                          child: Container(
                            width: 108,
                            height: 108,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF00979C), Color(0xFF005B60)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00A3A8)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.set_meal_outlined,
                              color: Colors.white,
                              size: 52,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Напис "ВАШ РИБАЛЬСЬКИЙ ЩОДЕННИК"
                      const Text(
                        'ВАШ РИБАЛЬСЬКИЙ ЩОДЕННИК',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF63BDB4),
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Заголовок "Щоденник риболовлі"
                      const Text(
                        'Щоденник',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const Text(
                        'риболовлі',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7CE8DC),
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Підзаголовок
                      Text(
                        'Улови · Водойми · Спогади',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(height: 44),

                      // Смужка прогресу
                      SizedBox(
                        width: 185,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 4,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.15,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF5CE1D2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      Text(
                        'Завантаження...',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

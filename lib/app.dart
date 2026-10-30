import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/screens/reset_password_screen.dart';
import 'features/auth/screens/splash_screen.dart';

class FishLogApp extends StatefulWidget {
  final String? initialOobCode;

  const FishLogApp({super.key, this.initialOobCode});

  @override
  State<FishLogApp> createState() => _FishLogAppState();
}

class _FishLogAppState extends State<FishLogApp> {
  StreamSubscription<Uri?>? _linkSubscription;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      final code = _oobCodeFromUri(uri);
      if (code != null && code.isNotEmpty && mounted) {
        _openResetScreen(code);
      }
    }, onError: (_) {});
  }

  void _openResetScreen(String oobCode) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        settings: const RouteSettings(name: '/reset-password'),
        builder: (_) => ResetPasswordScreen(
          authRepository: AuthRepository(),
          oobCode: oobCode,
        ),
      ),
    );
  }

  String? _oobCodeFromUri(Uri? uri) {
    if (uri == null) return null;
    return uri.queryParameters['oobCode'];
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'FishLog — Щоденник риболовлі',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      home: SplashScreen(initialOobCode: widget.initialOobCode),
    );
  }
}

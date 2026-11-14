import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/services/local_storage_service.dart';
import 'firebase_options.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/profile/providers/settings_provider.dart';
import 'features/tackle/providers/tackle_provider.dart';
import 'features/trips/providers/trips_provider.dart';
import 'features/water_bodies/providers/water_bodies_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Ініціалізація локального сховища налаштувань (SharedPreferences)
  await LocalStorageService.init();

  // Ініціалізація Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Перехоплення помилок Flutter для Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Перехоплення асинхронних помилок платформи для Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Фіксація запуску додатку у Firebase Analytics
  await FirebaseAnalytics.instance.logAppOpen();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => TripsProvider()..loadTrips(TripsProvider.demoTrips()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              WaterBodiesProvider()..loadWaterBodies(WaterBodiesProvider.demoWaterBodies()),
        ),
        ChangeNotifierProvider(
          create: (_) => TackleProvider()..loadTackle(TackleProvider.demoTackle()),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(LocalStorageService()),
        ),
      ],
      child: const FishLogApp(),
    ),
  );
}

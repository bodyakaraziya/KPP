import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:app_links/app_links.dart';

import 'app.dart';
import 'firebase_options.dart';

String? _oobCodeFromLink(Uri? link) {
  if (link == null) return null;
  return link.queryParameters['oobCode'];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // Посилання для скидання паролю, якщо додаток відкрито з листа на пошту
  Uri? initialLink;
  try {
    initialLink = await AppLinks().getInitialAppLink();
  } on Exception {
    initialLink = null;
  }

  runApp(FishLogApp(initialOobCode: _oobCodeFromLink(initialLink)));
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  // Робимо системні панелі (вгорі та внизу) повністю прозорими
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Верхній рядок (годинник, батарея)
      systemNavigationBarColor:
          Colors.transparent, // Нижній рядок (системні кнопки)
      systemNavigationBarContrastEnforced:
          false, // Відключаємо системне затемнення Android
    ),
  );

  // Умикаємо режим Edge-to-Edge (вміст заходить під системні панелі)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const FishLogApp());
}

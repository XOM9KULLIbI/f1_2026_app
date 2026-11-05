import 'package:flutter/material.dart';
import 'app/di/di.dart';
import 'app/f1_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Настройка обработчика ошибок Talker
  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack);
  };

  // Инициализация сервисов и зависимостей (Dio, Talker, Repositories, BLoCs)
  await setupLocator();

  runApp(const F1App());
}

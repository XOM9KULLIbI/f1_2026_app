import 'package:flutter/material.dart';
import 'router/router.dart';
import 'theme/theme_data.dart';

class F1App extends StatelessWidget {
  const F1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'F1 2026 Чемпионат Мира',
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}

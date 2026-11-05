import 'package:flutter/material.dart';
import 'theme_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ThemeColors.darkCarbon,
      primaryColor: ThemeColors.racingRed,
      colorScheme: const ColorScheme.dark(
        primary: ThemeColors.racingRed,
        secondary: ThemeColors.racingRed,
        surface: ThemeColors.surfaceCard,
        onSurface: ThemeColors.white,
      ),
      appBarTheme: const AppBarTheme(
        toolbarHeight: 56,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: ThemeColors.darkCarbon,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ThemeColors.white,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: ThemeColors.white),
      ),
      cardTheme: CardThemeData(
        color: ThemeColors.surfaceCard,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ThemeColors.cardBorder, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: ThemeColors.white,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ThemeColors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: ThemeColors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: ThemeColors.grey,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: ThemeColors.grey,
        ),
      ),
    );
  }
}

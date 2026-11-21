import 'package:flutter/material.dart';

/// Couleurs reprises de la charte graphique du site Aotomatismoù.
abstract final class AppColors {
  static const ink = Color(0xFF18344A);
  static const muted = Color(0xFF637587);
  static const cream = Color(0xFFF6F2E8);
  static const paper = Color(0xFFFFFDF8);
  static const orange = Color(0xFFF07843);
  static const orangeDark = Color(0xFFA7431B);
  static const teal = Color(0xFF287B73);
  static const line = Color(0xFFE4DFD3);
  static const mint = Color(0xFFEFFAF7);
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.ink,
      brightness: Brightness.light,
      primary: AppColors.ink,
      secondary: AppColors.teal,
      surface: AppColors.paper,
      error: const Color(0xFFB3261E),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.cream,
      fontFamily: 'Andika',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.ink,
        width: 320,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 42,
          fontWeight: FontWeight.w900,
          height: 1.08,
        ),
        headlineMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 30,
          fontWeight: FontWeight.w900,
          height: 1.12,
        ),
        titleLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(color: AppColors.ink, fontSize: 18, height: 1.5),
        bodyMedium: TextStyle(color: AppColors.muted, fontSize: 16, height: 1.5),
      ),
      cardTheme: CardThemeData(
        color: AppColors.paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0x1418344A)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? AppColors.teal : null),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      dividerColor: const Color(0x1AFFFFFF),
    );
  }
}


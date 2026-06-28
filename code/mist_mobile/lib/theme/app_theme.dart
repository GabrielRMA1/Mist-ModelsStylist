import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color gold        = Color(0xFFB8965A);
  static const Color goldLight   = Color(0xFFF5ECD9);
  static const Color dark        = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2A2A2A);
  static const Color surface     = Color(0xFFF7F5F2);
  static const Color muted       = Color(0xFF7A7570);
  static const Color border      = Color(0xFFE5E0D8);
  static const Color white       = Color(0xFFFFFFFF);

  // Status
  static const Color pendingBg      = Color(0xFFFFF7E6);
  static const Color pendingText    = Color(0xFF8B5E00);
  static const Color pendingDot     = Color(0xFFF0A500);
  static const Color acceptedBg     = Color(0xFFE8F5EC);
  static const Color acceptedText   = Color(0xFF1A6B35);
  static const Color acceptedDot    = Color(0xFF2E9E52);
  static const Color refusedBg      = Color(0xFFFDECEA);
  static const Color refusedText    = Color(0xFF8B1F1F);
  static const Color refusedDot     = Color(0xFFE53935);
  static const Color inProgressBg   = Color(0xFFE8F0FE);
  static const Color inProgressText = Color(0xFF1A3E8B);
  static const Color inProgressDot  = Color(0xFF3B6FE8);
  static const Color doneBg         = Color(0xFFF0F0F0);
  static const Color doneText       = Color(0xFF444444);
  static const Color doneDot        = Color(0xFF888888);
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.surface,
    colorScheme: const ColorScheme.light(
      primary: AppColors.gold,
      onPrimary: AppColors.white,
      surface: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.dark,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: AppColors.dark,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: AppColors.gold, size: 22),
    ),
    dividerColor: AppColors.border,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.gold,
        side: const BorderSide(color: AppColors.gold, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.gold),
    ),
  );
}

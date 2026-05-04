import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFF0D0D1A);
  static const surface = Color(0xFF1A1A2E);
  static const primary = Color(0xFF4A7EFF);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF8E8EA0);
}

class AppTextStyles {
  static const planetName = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 38,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );
  static const weightDisplay = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 60,
    fontWeight: FontWeight.w700,
    height: 1,
  );
  static const weightUnit = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 26,
  );
  static const stepperValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 34,
    fontWeight: FontWeight.w700,
  );
  static const sectionLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );
  static const sectionTag = TextStyle(
    color: AppColors.primary,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );
  static const cardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static const cardSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
  );
  static const cardMeta = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
  );
  static const cardTagLabel = TextStyle(
    color: AppColors.primary,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
  );
  static const toggleActive = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static const toggleInactive = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 15,
  );
  static const planetCardName = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const earthCardName = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );
  static const badgeLabel = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}

class CustomTheme {
  static ThemeData mainTheme(BuildContext context) {
    return ThemeData(
      brightness: .dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const .dark(
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.barlowTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: .light,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: .w600,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }
}

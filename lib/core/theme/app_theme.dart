// PATH FILE: lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_radius.dart';

/// ✅ NEO-BRUTALISM: shadow KERAS tanpa blur
class AppShadows {
  static List<BoxShadow> hard([double d = 4]) => [
        BoxShadow(
          color: AppColors.ink,
          offset: Offset(d, d),
          blurRadius: 0,
        ),
      ];
}

/// ✅ NEO-BRUTALISM: border hitam tebal
Border appBorder([double w = 2]) =>
    Border.all(color: AppColors.border, width: w);

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.button,
          surface: AppColors.cream,
          error: AppColors.dangerText,
          onPrimary: AppColors.cream,
          onSurface: AppColors.ink,
        ),

        // --- APP BAR (solid pink, tanpa shadow) ---
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: AppTextStyles.headingMedium.copyWith(
            color: AppColors.cream,
          ),
          iconTheme: const IconThemeData(color: AppColors.cream),
        ),

        // --- INPUT (border HITAM 2px) ---
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.appWhite,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.border, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.border, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.border, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide:
                const BorderSide(color: AppColors.dangerText, width: 2),
          ),
          hintStyle: AppTextStyles.bodySmall,
          labelStyle: AppTextStyles.label,
        ),

        // --- BUTTON (pink + border HITAM) ---
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.button,
            foregroundColor: AppColors.cream,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              side: const BorderSide(color: AppColors.border, width: 2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: AppTextStyles.button,
          ),
        ),

        // --- CARD (border HITAM) ---
        cardTheme: CardThemeData(
          color: AppColors.appWhite,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: const BorderSide(color: AppColors.border, width: 2),
          ),
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.button,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.cream.withValues(alpha: 0.7),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),

        dividerTheme: const DividerThemeData(
          color: Color(0xFFE5D9CC),
          thickness: 1,
        ),

        textTheme: GoogleFonts.interTextTheme(),
      );
}
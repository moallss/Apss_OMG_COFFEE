// PATH FILE: lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // --- BRAND (BBH Hegarty fallback → Outfit ExtraBold) ---
  static TextStyle get brand => GoogleFonts.outfit(
        fontWeight: FontWeight.w800,
        fontSize: 24,
        color: AppColors.brandGreen,
      );

  // --- JUDUL HALAMAN (Outfit Bold/ExtraBold 22–28) ---
  static TextStyle get headingLarge => GoogleFonts.outfit(
        fontWeight: FontWeight.w800,
        fontSize: 28,
        color: AppColors.ink,
      );

  static TextStyle get headingMedium => GoogleFonts.outfit(
        fontWeight: FontWeight.w700,
        fontSize: 22,
        color: AppColors.ink,
      );

  // --- ANGKA BESAR (Outfit ExtraBold 26–32, tabular) ---
  static TextStyle get numberLarge => GoogleFonts.outfit(
        fontWeight: FontWeight.w800,
        fontSize: 28,
        color: AppColors.ink,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  // --- JUDUL SECTION (Outfit Bold 16–18, title-case) ---
  static TextStyle get sectionTitle => GoogleFonts.outfit(
        fontWeight: FontWeight.w700,
        fontSize: 17,
        color: AppColors.ink,
      );

  // --- TOMBOL (Outfit Bold 14–16) ---
  static TextStyle get button => GoogleFonts.outfit(
        fontWeight: FontWeight.w700,
        fontSize: 15,
        color: AppColors.cream,
      );

  // --- BODY / DESKRIPSI (Inter Regular 13–14) ---
  static TextStyle get body => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.ink,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 13,
        color: AppColors.muted,
      );

  // --- LABEL KECIL (Inter Medium 12–13, title-case) ---
  static TextStyle get label => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: AppColors.muted,
      );

  // --- NAV & QUICK LABEL (Inter Medium 10, UPPERCASE) ---
  static TextStyle get navLabel => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 10,
        color: AppColors.cream,
        letterSpacing: 0.8,
      );

  // --- ANGKA DATA (Inter SemiBold 13–16, tabular) ---
  static TextStyle get numberData => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.ink,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  // --- LINK SEKUNDER (Inter + aksen hijau/pink) ---
  static TextStyle get linkGreen => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 13,
        color: AppColors.brandGreen,
      );

  static TextStyle get linkPink => GoogleFonts.inter(
        fontWeight: FontWeight.w700,
        fontSize: 13,
        color: AppColors.primary,
      );

  // --- CHIP STATUS (Inter Medium 11–12) ---
  static TextStyle chipText(Color color) => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        color: color,
      );

  // --- ERROR INPUT (Inter 12, danger) ---
  static TextStyle get errorInput => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AppColors.dangerText,
      );

  // ==========================================
  // ✅ NEO-BRUTALISM STYLES (BARU)
  // ==========================================

  /// JUDUL HERO PUTIH + BAYANGAN HITAM (retro style)
  static TextStyle get heroShadow => GoogleFonts.outfit(
        fontWeight: FontWeight.w900,
        fontSize: 36,
        color: Colors.white,
        shadows: const [
          Shadow(color: AppColors.ink, offset: Offset(3, 3)),
        ],
      );

  /// LABEL UPPERCASE KECIL (EMAIL, PASSWORD, dll)
  static TextStyle get labelUpper => GoogleFonts.inter(
        fontWeight: FontWeight.w700,
        fontSize: 10,
        letterSpacing: 1.2,
        color: AppColors.ink,
      );

  /// TEKS TOMBOL BRUTAL
  static TextStyle get buttonBrutal => GoogleFonts.inter(
        fontWeight: FontWeight.w800,
        fontSize: 14,
        color: Colors.white,
      );
}

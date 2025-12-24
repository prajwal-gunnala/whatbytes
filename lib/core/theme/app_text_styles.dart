import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system - Modern & Bold
class AppTextStyles {
  // Private constructor
  AppTextStyles._();

  // Font family - Poppins (Modern, geometric, perfect for dark UI)
  static String get fontFamily => GoogleFonts.poppins().fontFamily!;

  // ========== Headings ==========
  static TextStyle h1 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle h2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ========== Body Text ==========
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ========== Labels & Buttons ==========
  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textTertiary,
    height: 1.3,
  );
}

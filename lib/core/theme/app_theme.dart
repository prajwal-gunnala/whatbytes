import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App theme configuration - Premium Dark Theme
class AppTheme {
  // Private constructor
  AppTheme._();

  /// Main app theme (Dark Theme)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        surface: AppColors.bgSecondary,
        error: AppColors.errorColor,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.bgPrimary,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.bgPrimary,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.bgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textPrimary,
          elevation: 4,
          shadowColor: AppColors.primaryGlow,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: const BorderSide(color: AppColors.borderColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgInput,
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textTertiary,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentColor,
        foregroundColor: AppColors.bgPrimary,
        elevation: 8,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerColor,
        thickness: 1,
        space: 1,
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentColor;
          }
          return AppColors.borderColor;
        }),
        checkColor: WidgetStateProperty.all(AppColors.bgPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentColor;
          }
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color.fromRGBO(34, 211, 238, 0.5);
          }
          return AppColors.borderColor;
        }),
      ),

      // Text Theme
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.textPrimary),
          displayMedium: TextStyle(color: AppColors.textPrimary),
          displaySmall: TextStyle(color: AppColors.textPrimary),
          headlineLarge: TextStyle(color: AppColors.textPrimary),
          headlineMedium: TextStyle(color: AppColors.textPrimary),
          headlineSmall: TextStyle(color: AppColors.textPrimary),
          titleLarge: TextStyle(color: AppColors.textPrimary),
          titleMedium: TextStyle(color: AppColors.textPrimary),
          titleSmall: TextStyle(color: AppColors.textPrimary),
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textPrimary),
          bodySmall: TextStyle(color: AppColors.textSecondary),
          labelLarge: TextStyle(color: AppColors.textPrimary),
          labelMedium: TextStyle(color: AppColors.textSecondary),
          labelSmall: TextStyle(color: AppColors.textTertiary),
        ),
      ),
    );
  }
}

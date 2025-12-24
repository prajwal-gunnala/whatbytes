import 'package:flutter/material.dart';

/// App color palette - Premium Dark Theme
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ========== Background Colors - Deep Dark ==========
  static const Color bgPrimary = Color(0xFF0F172A); // Slate 900 - Main background
  static const Color bgSecondary = Color(0xFF1E293B); // Slate 800 - Cards/Surface
  static const Color bgTertiary = Color(0xFF334155); // Slate 700 - Elevated surfaces
  static const Color bgInput = Color(0xFF1E293B); // Input field background

  // ========== Primary Brand Color - Vibrant Indigo ==========
  static const Color primaryColor = Color(0xFF6366F1); // Indigo 500 - Main brand
  static const Color primaryLight = Color(0xFF818CF8); // Indigo 400 - Hover state
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo 600 - Active state
  static const Color primaryGlow = Color(0x4D6366F1); // Glow effect (30% opacity)

  // ========== Accent Color - Electric Cyan ==========
  static const Color accentColor = Color(0xFF22D3EE); // Cyan 400 - CTAs, highlights
  static const Color accentLight = Color(0xFF67E8F9); // Cyan 300
  static const Color accentGlow = Color(0x4D22D3EE); // Accent glow (30% opacity)

  // ========== Text Colors - High Contrast ==========
  static const Color textPrimary = Color(0xFFE5E7EB); // Gray 200 - Main text
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400 - Secondary text
  static const Color textTertiary = Color(0xFF64748B); // Slate 500 - Muted text
  static const Color textDisabled = Color(0xFF475569); // Slate 600 - Disabled

  // ========== Priority Colors (Dark Theme Optimized) ==========
  // Low Priority - Soft Green
  static const Color priorityLow = Color(0xFF34D399); // Emerald 400
  static const Color priorityLowBg = Color(0xFF064E3B); // Emerald 900 (dark bg)
  static const Color priorityLowBorder = Color(0xFF10B981); // Emerald 500

  // Medium Priority - Warm Amber
  static const Color priorityMedium = Color(0xFFFBBF24); // Amber 400
  static const Color priorityMediumBg = Color(0xFF78350F); // Amber 900
  static const Color priorityMediumBorder = Color(0xFFF59E0B); // Amber 500

  // High Priority - Bold Red
  static const Color priorityHigh = Color(0xFFF87171); // Red 400
  static const Color priorityHighBg = Color(0xFF7F1D1D); // Red 900
  static const Color priorityHighBorder = Color(0xFFEF4444); // Red 500

  // ========== Semantic Colors ==========
  // Success - Fresh Green
  static const Color successColor = Color(0xFF34D399); // Emerald 400
  static const Color successBg = Color(0xFF064E3B); // Emerald 900

  // Error - Vibrant Red
  static const Color errorColor = Color(0xFFF87171); // Red 400
  static const Color errorBg = Color(0xFF7F1D1D); // Red 900

  // Warning - Warm Orange
  static const Color warningColor = Color(0xFFFBBF24); // Amber 400
  static const Color warningBg = Color(0xFF78350F); // Amber 900

  // Info - Cool Blue
  static const Color infoColor = Color(0xFF60A5FA); // Blue 400
  static const Color infoBg = Color(0xFF1E3A8A); // Blue 900

  // ========== UI Element Colors ==========
  // Borders & Dividers - Subtle
  static const Color borderColor = Color(0xFF334155); // Slate 700
  static const Color borderLight = Color(0xFF475569); // Slate 600
  static const Color dividerColor = Color(0xFF1E293B); // Slate 800

  // Overlay & Shadow
  static const Color overlayColor = Color(0xCC0F172A); // 80% dark overlay
  static const Color shadowColor = Color(0x40000000); // Soft black shadow

  // ========== Helper Methods ==========
  /// Get priority color by priority level
  static Color getPriorityColor(dynamic priority) {
    final priorityStr = priority.toString().split('.').last.toLowerCase();
    switch (priorityStr) {
      case 'low':
        return priorityLow;
      case 'medium':
        return priorityMedium;
      case 'high':
        return priorityHigh;
      default:
        return priorityMedium;
    }
  }

  /// Get priority background color
  static Color getPriorityBgColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return priorityLowBg;
      case 'medium':
        return priorityMediumBg;
      case 'high':
        return priorityHighBg;
      default:
        return priorityMediumBg;
    }
  }

  /// Get priority border color
  static Color getPriorityBorderColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return priorityLowBorder;
      case 'medium':
        return priorityMediumBorder;
      case 'high':
        return priorityHighBorder;
      default:
        return priorityMediumBorder;
    }
  }
}

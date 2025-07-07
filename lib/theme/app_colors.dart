import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryVariantLight = Color(0xFF4F46E5);
  static const Color secondaryLight = Color(0xFF10B981);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF1E293B);
  static const Color onSurfaceLight = Color(0xFF334155);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF818CF8);
  static const Color primaryVariantDark = Color(0xFF6366F1);
  static const Color secondaryDark = Color(0xFF34D399);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color errorDark = Color(0xFFF87171);
  static const Color onPrimaryDark = Color(0xFF1E293B);
  static const Color onSecondaryDark = Color(0xFF1E293B);
  static const Color onBackgroundDark = Color(0xFFF1F5F9);
  static const Color onSurfaceDark = Color(0xFFCBD5E1);
  static const Color onErrorDark = Color(0xFF1E293B);

  // Category Colors
  static const Color entertainmentColor = Color(0xFFE11D48);
  static const Color productivityColor = Color(0xFF3B82F6);
  static const Color healthColor = Color(0xFF10B981);
  static const Color educationColor = Color(0xFFF59E0B);
  static const Color businessColor = Color(0xFF6366F1);
  static const Color lifestyleColor = Color(0xFFEC4899);
  static const Color otherColor = Color(0xFF6B7280);

  // Status Colors
  static const Color activeColor = Color(0xFF10B981);
  static const Color expiredColor = Color(0xFFEF4444);
  static const Color trialColor = Color(0xFFF59E0B);
  static const Color cancelledColor = Color(0xFF6B7280);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primaryVariantLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'entertainment':
        return entertainmentColor;
      case 'productivity':
        return productivityColor;
      case 'health':
        return healthColor;
      case 'education':
        return educationColor;
      case 'business':
        return businessColor;
      case 'lifestyle':
        return lifestyleColor;
      default:
        return otherColor;
    }
  }
}
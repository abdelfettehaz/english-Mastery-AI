import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00263F);
  static const Color primaryContainer = Color(0xFF0B3C5D);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF006876);
  static const Color secondaryContainer = Color(0xFF58E6FF);
  static const Color onSecondaryContainer = Color(0xFF006573);
  static const Color tertiary = Color(0xFF2C0071);
  static const Color tertiaryContainer = Color(0xFF4400A9);
  static const Color surface = Color(0xFFF7F9FB);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E5);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF42474E);
  static const Color outlineVariant = Color(0xFFC2C7CE);
  static const Color primaryFixedDim = Color(0xA3CBF2FF); // Adjusted to ARGB
  
  // Custom Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

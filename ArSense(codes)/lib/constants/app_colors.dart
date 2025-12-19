import 'package:flutter/material.dart';

class AppColors {
  // Main theme colors from home screen
  static const Color darkBlue = Color(0xFF0A2540);
  static const Color tealBlue = Color(0xFF0FB9B1);

  // Gradient for buttons and accents
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [darkBlue, tealBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text colors
  static const Color whiteText = Colors.white;
  static const Color white70Text = Colors.white70;
  static const Color primaryText = darkBlue;

  // Background colors
  static const Color whiteBackground = Colors.white;
  static Color darkBlueBackground = darkBlue;
  static Color darkBlueWithOpacity = darkBlue.withValues(alpha: 0.6);
  static Color darkBlueWithOpacity08 = darkBlue.withValues(alpha: 0.8);
  static Color darkBlueWithOpacity07 = darkBlue.withValues(alpha: 0.7);
  static Color darkBlueWithOpacity05 = darkBlue.withValues(alpha: 0.05);
  static Color darkBlueWithOpacity04 = darkBlue.withValues(alpha: 0.04);
  static Color darkBlueWithOpacity01 = darkBlue.withValues(alpha: 0.1);
  static Color darkBlueWithOpacity03 = darkBlue.withValues(alpha: 0.3);

  static Color tealBlueWithOpacity08 = tealBlue.withValues(alpha: 0.8);
  static Color tealBlueWithOpacity06 = tealBlue.withValues(alpha: 0.6);
  static Color tealBlueWithOpacity03 = tealBlue.withValues(alpha: 0.3);
  static Color tealBlueWithOpacity01 = tealBlue.withValues(alpha: 0.1);

  // Confidence colors
  static Color getConfidenceColor(double confidence) {
    if (confidence >= 80) return darkBlue;
    if (confidence >= 60) return tealBlue;
    return Colors.orange.shade400;
  }

  // Class colors for charts
  static List<Color> getClassColors() {
    return [
      darkBlue,
      tealBlue,
      darkBlue.withValues(alpha: 0.8),
      tealBlue.withValues(alpha: 0.8),
      darkBlue.withValues(alpha: 0.6),
      tealBlue.withValues(alpha: 0.6),
      Colors.blue.shade700,
      Colors.cyan.shade600,
      Colors.indigo.shade600,
      Colors.teal.shade700,
    ];
  }

  static Color getClassColor(String className) {
    final colors = getClassColors();
    final hash = className.hashCode;
    return colors[hash.abs() % colors.length];
  }
}

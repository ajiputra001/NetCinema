import 'package:flutter/material.dart';

class AppColors {
  // Netflix Brand Colors
  static const Color primary = Color(0xFFE50914); // Netflix Red
  static const Color background = Color(0xFF141414); // Deep Dark
  static const Color surface = Color(0xFF1F1F1F); // Dark Card Surface
  static const Color cardDark = Color(0xFF2B2B2B);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textMuted = Color(0xFF757575);

  // Accents & Badges
  static const Color ratingYellow = Color(0xFFFFC107);
  static const Color accentBlue = Color(0xFF0071EB);
  static const Color top10Badge = Color(0xFFE50914);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x80141414),
      Color(0xFF141414),
    ],
    stops: [0.3, 0.75, 1.0],
  );

  static const LinearGradient topNavGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xCC000000),
      Colors.transparent,
    ],
  );
}

import 'package:flutter/material.dart';

class AppTheme {
  // INFLU App Color System

  // 1. Primary Colors
  static const Color primaryColor = Color(0xFF341969); // Royal Deep Purple
  static const Color secondaryColor = Color(0xFF6A4AE4); // Vivid Violet
  static const Color errorColor = Color(0xFF341969);
  // 2. Accent Colors
  static const Color accentCoral = Color(
    0xFFFF6F61,
  ); // Coral Red - alerts, errors, urgent notifications
  static const Color accentMint = Color(
    0xFF00C49A,
  ); // Mint Green - success, positive stats, earnings
  static const Color accentYellow = Color(
    0xFFFFD54F,
  ); // Warm Yellow - highlights, promotions

  // 3. Neutral / Base Colors
  static const Color backgroundLight = Color(
    0xFFF8F9FB,
  ); // Off-white - main background
  static const Color backgroundDark = Color(
    0xFF1A1A2E,
  ); // Rich Navy Black - dark mode
  static const Color textPrimary = Color(
    0xFF212121,
  ); // Dark Charcoal - high readability
  static const Color textSecondary = Color(
    0xFF6E6E6E,
  ); // Medium Gray - captions, hints
  static const Color dividerColor = Color(
    0xFFE0E0E0,
  ); // Soft Gray - borders, dividers

  // 4. Special Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, secondaryColor], // For splash screen, banners
  );

  static const LinearGradient actionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryColor, accentMint], // For important CTA blocks
  );

  // Legacy colors (keeping for backward compatibility)
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF111115), // top 0%
      Color(0xFF8853F4), // bottom 100%
    ],
    stops: [0.0, 1.0],
  );

  static const Color bodyBackground = backgroundLight;
  static const Color primaryPurple = primaryColor;
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color bodyText = textPrimary;
  static const Color disabled = Color(0xFF626264);
  static const Color quickActionsCard = Color(0xFF9575D4);
  static const Color backgroundTwo = Color(0xFF210E47);
  static const Color gradientStart = Color(0xFF111115);
  static const Color gradientEnd = Color(0xFF8853F4);

  // Text Styles with new color system
  static const TextStyle headlineStyle = TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subHeadlineStyle = TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyTextStyle = TextStyle(color: textPrimary);

  static const TextStyle secondaryTextStyle = TextStyle(color: textSecondary);

  static const TextStyle buttonTextStyle = TextStyle(
    color: buttonText,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle linkStyle = TextStyle(
    color: primaryColor,
    decoration: TextDecoration.underline,
  );

  static const TextStyle disabledTextStyle = TextStyle(color: disabled);

  // Success and Error Text Styles
  static const TextStyle successTextStyle = TextStyle(
    color: accentMint,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle errorTextStyle = TextStyle(
    color: accentCoral,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle warningTextStyle = TextStyle(
    color: accentYellow,
    fontWeight: FontWeight.w500,
  );
}

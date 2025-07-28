import 'package:flutter/material.dart';

class AppTheme {
  // Purple Linear Gradient - top 0% #111115 to bottom #8853F4 100%
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF111115), // top 0%
      Color(0xFF8853F4), // bottom 100%
    ],
    stops: [0.0, 1.0],
  );

  // Primary Colors
  static const Color bodyBackground = Color(0xFFFFFFFF); // white
  static const Color primaryPurple = Color(0xFF341969); // headlines, links, active navigation, buttons, sub headlines
  static const Color buttonText = Color(0xFFFFFFFF); // white
  static const Color bodyText = Color(0xFF000000); // black
  static const Color disabled = Color(0xFF626264);
  static const Color quickActionsCard = Color(0xFF9575D4);
  static const Color backgroundTwo = Color(0xFF210E47);

  // Additional gradient colors for easy access
  static const Color gradientStart = Color(0xFF111115);
  static const Color gradientEnd = Color(0xFF8853F4);

  // Text Styles
  static const TextStyle headlineStyle = TextStyle(
    color: primaryPurple,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subHeadlineStyle = TextStyle(
    color: primaryPurple,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    color: bodyText,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: buttonText,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle linkStyle = TextStyle(
    color: primaryPurple,
    decoration: TextDecoration.underline,
  );

  static const TextStyle disabledTextStyle = TextStyle(
    color: disabled,
  );
}
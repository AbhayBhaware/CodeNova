import 'package:flutter/material.dart';

/// Central spacing, border radius, and dimension tokens for the design system.
///
/// Ensures pixel-consistent layouts across all screens, cards, buttons, and inputs.
abstract final class AppDimensions {
  AppDimensions._();

  // ── Spacing Tokens (4px / 8px Grid) ───────────────────────────
  static const double spaceXXS = 2.0;
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;
  static const double space3XL = 64.0;

  // ── Border Radius Tokens ──────────────────────────────────────
  /// Small radius (4px) – Badges, tags, micro elements.
  static const double radiusXS = 4.0;

  /// Medium-small radius (8px) – Chips, small inputs, small cards.
  static const double radiusSM = 8.0;

  /// Standard radius (12px) – Buttons, input fields, standard cards.
  static const double radiusMD = 12.0;

  /// Large radius (16px) – Prominent cards, dialogs, sheets.
  static const double radiusLG = 16.0;

  /// Extra large radius (24px) – Hero cards, bottom sheets.
  static const double radiusXL = 24.0;

  /// Pill / Circular radius (999px) – Avatars, pill badges, active tab indicator.
  static const double radiusCircle = 999.0;

  // ── Icon Sizes ────────────────────────────────────────────────
  static const double iconXS = 14.0;
  static const double iconSM = 16.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 48.0;

  // ── Button Dimensions (WCAG Touch Target Compliant) ───────────
  /// Minimum accessible touch target height (48dp).
  static const double buttonHeight = 48.0;

  /// Compact button height (40dp).
  static const double buttonHeightSM = 40.0;

  /// Standard button horizontal padding.
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: spaceLG,
    vertical: spaceMD,
  );

  /// Compact button padding.
  static const EdgeInsets buttonPaddingSM = EdgeInsets.symmetric(
    horizontal: spaceMD,
    vertical: spaceSM,
  );

  // ── Card Specifications ───────────────────────────────────────
  static const double cardElevation = 0.0; // Restrained flat styling with 1px border
  static const EdgeInsets cardPadding = EdgeInsets.all(spaceMD);
  static const EdgeInsets cardPaddingLG = EdgeInsets.all(spaceLG);

  // ── Screen Padding ────────────────────────────────────────────
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: spaceMD,
    vertical: spaceMD,
  );

  static const EdgeInsets screenPaddingLG = EdgeInsets.symmetric(
    horizontal: spaceLG,
    vertical: spaceLG,
  );

  // ── Navigation Bar ────────────────────────────────────────────
  static const double bottomNavHeight = 64.0;

  // ── Ambient Box Shadows (Subtle, non-excessive) ───────────────
  static const List<BoxShadow> cardShadowLight = [
    BoxShadow(
      color: Color(0x0A0F172A), // 4% black
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x1F0F4C81), // 12% deep blue
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
}

/// Font sizes scale used across typography tokens.
abstract final class AppTextSizes {
  AppTextSizes._();

  static const double xs = 11.0;
  static const double sm = 13.0;
  static const double body = 14.0;
  static const double bodyLg = 16.0;
  static const double subtitle = 18.0;
  static const double title = 20.0;
  static const double heading = 24.0;
  static const double display = 28.0;
  static const double hero = 34.0;
}

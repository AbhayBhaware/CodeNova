import 'package:flutter/material.dart';

/// Central color tokens for CodeNova Tech Solutions Design System.
///
/// Follows a restrained professional palette for a modern IT company:
/// - White: Backgrounds & cards
/// - Deep Blue: Primary brand identity
/// - Blue Accent: Interactive highlights & CTAs
/// - Dark Navy: Contrast elements & Dark mode surfaces
/// - Neutral Gray: Borders, dividers & subtle text
abstract final class AppColors {
  AppColors._();

  // ── Brand Tokens ──────────────────────────────────────────────
  /// Deep blue brand primary – conveys trust, authority, and tech capability.
  static const Color primary = Color(0xFF0F4C81);

  /// Dark navy – used for contrast elements, hero containers, and dark theme.
  static const Color primaryDark = Color(0xFF0A192F);

  /// Vibrant blue accent – used for active tab indicators, CTAs, and links.
  static const Color accent = Color(0xFF007AFF);

  /// Warm secondary amber/orange – for highlight tags and featured badges.
  static const Color secondary = Color(0xFFFF6B35);

  // ── Neutral Gray Scale ────────────────────────────────────────
  /// Off-white light background (reduces eye fatigue vs stark white).
  static const Color neutral50 = Color(0xFFF8FAFC);

  /// Subtle gray surface / hover tint.
  static const Color neutral100 = Color(0xFFF1F5F9);

  /// Standard border and divider line.
  static const Color neutral200 = Color(0xFFE2E8F0);

  /// Subtle outline border.
  static const Color neutral300 = Color(0xFFCBD5E1);

  /// Placeholder & muted icon gray.
  static const Color neutral400 = Color(0xFF94A3B8);

  /// Secondary body text gray.
  static const Color neutral600 = Color(0xFF475569);

  /// Dark slate for deep contrast surfaces in dark mode.
  static const Color neutral800 = Color(0xFF1E293B);

  /// Primary high-contrast text slate (WCAG AAA compliant on white).
  static const Color neutral900 = Color(0xFF0F172A);

  /// Pure white.
  static const Color white = Color(0xFFFFFFFF);

  // ── Light Theme Semantic Tokens ───────────────────────────────
  static const Color backgroundLight = neutral50;
  static const Color surfaceLight = white;
  static const Color cardLight = white;
  static const Color borderLight = neutral200;

  // ── Dark Theme Semantic Tokens ────────────────────────────────
  static const Color backgroundDark = primaryDark;
  static const Color backgroundCard = Color(0xFF111827);
  static const Color backgroundSurface = neutral800;
  static const Color borderDark = Color(0xFF1E2D40);

  // ── Typography Semantic Tokens ────────────────────────────────
  /// Default high-contrast primary text.
  static const Color textPrimary = neutral900;

  /// Secondary supporting body text.
  static const Color textSecondary = neutral600;

  /// Muted caption and placeholder text.
  static const Color textMuted = neutral400;

  /// Dark mode primary text.
  static const Color textPrimaryDark = Color(0xFFF8FAFC);

  /// Dark mode secondary text.
  static const Color textSecondaryDark = Color(0xFFAAB4C8);

  // ── Utility / Feedback ────────────────────────────────────────
  static const Color divider = neutral200;
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = accent;

  // ── Gradients ─────────────────────────────────────────────────
  /// Subtle brand gradient (Deep Blue to Blue Accent).
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, accent],
  );

  /// Dark navy hero gradient for contrast hero cards.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, Color(0xFF0D254C)],
  );

  /// Clean light card gradient (subtle pure surface).
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, neutral50],
  );

  /// Dark mode card gradient.
  static const LinearGradient cardGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundCard, backgroundSurface],
  );
}

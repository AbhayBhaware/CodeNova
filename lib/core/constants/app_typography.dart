import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

/// Centralized typographic scale and standard text styles for CodeNova.
///
/// Follows Material 3 typographic scale with Plus Jakarta Sans / Poppins
/// for a crisp, modern IT enterprise aesthetic.
abstract final class AppTypography {
  AppTypography._();

  // ── Display & Headings ────────────────────────────────────────

  /// Display hero heading – 32px, bold. Used for main hero headers.
  static TextStyle display({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.hero,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
        color: color ?? AppColors.textPrimary,
      );

  /// Heading 1 / Section Title – 26px, bold.
  static TextStyle h1({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.heading,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.3,
        color: color ?? AppColors.textPrimary,
      );

  /// Heading 2 / Screen subtitle – 20px, semibold.
  static TextStyle h2({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.title,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color ?? AppColors.textPrimary,
      );

  /// Heading 3 / Card title – 18px, semibold.
  static TextStyle h3({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.subtitle,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color ?? AppColors.textPrimary,
      );

  // ── Body Styles ───────────────────────────────────────────────

  /// Subtitle / Lead text – 16px, medium.
  static TextStyle subtitle({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.bodyLg,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: color ?? AppColors.textSecondary,
      );

  /// Body Large – 16px, regular.
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.bodyLg,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color ?? AppColors.textSecondary,
      );

  /// Body Medium – 14px, regular (standard UI text).
  static TextStyle bodyMedium({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.body,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color ?? AppColors.textSecondary,
      );

  /// Body Small – 13px, regular.
  static TextStyle bodySmall({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.sm,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color ?? AppColors.textMuted,
      );

  // ── Captions & Interactive ────────────────────────────────────

  /// Caption / Microcopy – 12px, medium.
  static TextStyle caption({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.xs,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: color ?? AppColors.textMuted,
      );

  /// Button text – 15px, semibold, letter-spaced.
  static TextStyle button({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.body,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: color ?? Colors.white,
      );

  /// Overline / Eyebrow badge text – 11px, bold, uppercase tracking.
  static TextStyle overline({Color? color}) => GoogleFonts.poppins(
        fontSize: AppTextSizes.xs - 1,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: color ?? AppColors.accent,
      );
}

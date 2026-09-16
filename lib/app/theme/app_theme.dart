import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/constants.dart';

/// Centralized [ThemeData] configuration for CodeNova Tech Solutions.
///
/// Implements Material 3 design specifications with a restrained,
/// enterprise-ready IT palette:
/// - Light theme: Clean off-white surface, deep blue primary, crisp borders, WCAG AAA text contrast.
/// - Dark theme: Professional dark navy, subtle slate surfaces, blue accent highlights.
abstract final class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────────────────────
  // ── LIGHT THEME (Default) ────────────────────────────────────
  // ─────────────────────────────────────────────────────────────
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        primaryContainer: Color(0xFFE0EFFF),
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.accent,
        onSecondary: AppColors.white,
        tertiary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimary,
        surfaceContainerLowest: AppColors.white,
        surfaceContainerLow: AppColors.neutral50,
        surfaceContainer: AppColors.neutral100,
        outline: AppColors.neutral200,
        outlineVariant: AppColors.neutral100,
        error: AppColors.error,
        onError: AppColors.white,
      ),

      // ── AppBar ──────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: AppTextSizes.title,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // ── Navigation Bar (Material 3) ────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primary.withAlpha(25),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: AppDimensions.bottomNavHeight + 16,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.primary,
              size: AppDimensions.iconMD,
            );
          }
          return const IconThemeData(
            color: AppColors.neutral400,
            size: AppDimensions.iconMD,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: AppTextSizes.xs,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return GoogleFonts.poppins(
            fontSize: AppTextSizes.xs,
            fontWeight: FontWeight.w500,
            color: AppColors.neutral400,
          );
        }),
      ),

      // ── Card ────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          side: const BorderSide(color: AppColors.neutral200, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Chip ────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.neutral100,
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: AppTextSizes.xs,
          fontWeight: FontWeight.w500,
        ),
        side: const BorderSide(color: AppColors.neutral200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        ),
      ),

      // ── Divider ─────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── Input ────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMD,
          vertical: AppDimensions.spaceMD - 2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          borderSide: const BorderSide(color: AppColors.neutral200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          borderSide: const BorderSide(color: AppColors.neutral200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
        hintStyle: GoogleFonts.poppins(color: AppColors.neutral400),
      ),

      // ── Text Theme ──────────────────────────────────────────
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: AppTextSizes.hero,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: AppTextSizes.display,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.25,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: AppTextSizes.heading,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: AppTextSizes.title,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: AppTextSizes.subtitle,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: AppTextSizes.bodyLg,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: AppTextSizes.bodyLg,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: AppTextSizes.body,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: AppTextSizes.sm,
          color: AppColors.neutral400,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: AppTextSizes.body,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.3,
        ),
      ),

      // ── Elevated Button ──────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(64, AppDimensions.buttonHeight),
          padding: AppDimensions.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: AppTextSizes.body,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Outlined Button ──────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.neutral200, width: 1.5),
          minimumSize: const Size(64, AppDimensions.buttonHeight),
          padding: AppDimensions.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: AppTextSizes.body,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Text Button ──────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(48, AppDimensions.buttonHeightSM),
          textStyle: GoogleFonts.poppins(
            fontSize: AppTextSizes.body,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ── DARK THEME ───────────────────────────────────────────────
  // ─────────────────────────────────────────────────────────────
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        onPrimary: AppColors.white,
        primaryContainer: Color(0xFF1E3A8A),
        onPrimaryContainer: AppColors.white,
        secondary: AppColors.accent,
        tertiary: AppColors.secondary,
        surface: AppColors.backgroundCard,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerLowest: AppColors.backgroundDark,
        surfaceContainerLow: AppColors.backgroundCard,
        surfaceContainer: AppColors.backgroundSurface,
        outline: AppColors.borderDark,
        error: AppColors.error,
        onError: AppColors.white,
      ),

      // ── AppBar ──────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: AppTextSizes.title,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),

      // ── Navigation Bar (Material 3) ────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.backgroundCard,
        indicatorColor: AppColors.accent.withAlpha(35),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: AppDimensions.bottomNavHeight + 16,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.accent,
              size: AppDimensions.iconMD,
            );
          }
          return const IconThemeData(
            color: AppColors.neutral400,
            size: AppDimensions.iconMD,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: AppTextSizes.xs,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            );
          }
          return GoogleFonts.poppins(
            fontSize: AppTextSizes.xs,
            fontWeight: FontWeight.w500,
            color: AppColors.neutral400,
          );
        }),
      ),

      // ── Card ────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.backgroundCard,
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Chip ────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundSurface,
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondaryDark,
          fontSize: AppTextSizes.xs,
        ),
        side: const BorderSide(color: AppColors.borderDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        ),
      ),

      // ── Divider ─────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      // ── Input ────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMD,
          vertical: AppDimensions.spaceMD - 2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondaryDark),
        hintStyle: GoogleFonts.poppins(color: AppColors.neutral400),
      ),

      // ── Text Theme ──────────────────────────────────────────
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: AppTextSizes.hero,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: AppTextSizes.display,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
          height: 1.25,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: AppTextSizes.heading,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: AppTextSizes.title,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: AppTextSizes.subtitle,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: AppTextSizes.bodyLg,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: AppTextSizes.bodyLg,
          color: AppColors.textSecondaryDark,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: AppTextSizes.body,
          color: AppColors.textSecondaryDark,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: AppTextSizes.sm,
          color: AppColors.neutral400,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: AppTextSizes.body,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
          letterSpacing: 0.3,
        ),
      ),

      // ── Elevated Button ──────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(64, AppDimensions.buttonHeight),
          padding: AppDimensions.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: AppTextSizes.body,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Outlined Button ──────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent, width: 1.5),
          minimumSize: const Size(64, AppDimensions.buttonHeight),
          padding: AppDimensions.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: AppTextSizes.body,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Text Button ──────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          minimumSize: const Size(48, AppDimensions.buttonHeightSM),
          textStyle: GoogleFonts.poppins(
            fontSize: AppTextSizes.body,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

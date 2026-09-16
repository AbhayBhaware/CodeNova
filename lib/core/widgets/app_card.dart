import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// A premium, restrained card for the CodeNova Design System.
///
/// Adapts seamlessly to Light and Dark themes:
/// - Light theme: Clean pure white card with subtle 1px neutral border and soft ambient shadow.
/// - Dark theme: Dark slate container with subtle 1px border.
/// - Avoids excessive glows and heavy shadows.
///
/// Usage:
/// ```dart
/// AppCard(child: Text('Card Content'))
/// AppCard.glass(child: Text('Frosted Card'))
/// AppCard.gradient(child: Text('Banner'), gradient: AppColors.brandGradient)
/// ```
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onTap,
    this.borderRadius,
    this.elevation = 0.0,
  });

  /// Factory constructor for a clean, bordered glass/surface style card.
  const AppCard.glass({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.borderColor,
  })  : gradient = null,
        backgroundColor = null,
        borderWidth = 1.0,
        elevation = 0.0;

  /// Factory constructor for a gradient card (e.g. promotional banners).
  const AppCard.gradient({
    super.key,
    required this.child,
    required this.gradient,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
  })  : backgroundColor = null,
        elevation = 0.0;

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(AppDimensions.radiusLG);

    final resolvedBorderColor = borderColor ??
        (isDark ? AppColors.borderDark : AppColors.neutral200);

    final resolvedBackgroundColor = backgroundColor ??
        (isDark ? AppColors.backgroundCard : AppColors.cardLight);

    final shadows = (gradient == null && !isDark && elevation >= 0)
        ? AppDimensions.cardShadowLight
        : const <BoxShadow>[];

    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? resolvedBackgroundColor : null,
        gradient: gradient,
        borderRadius: radius,
        border: Border.all(
          color: resolvedBorderColor,
          width: borderWidth,
        ),
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: AppColors.primary.withAlpha(20),
          highlightColor: AppColors.primary.withAlpha(10),
          child: Padding(
            padding: padding ?? AppDimensions.cardPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}

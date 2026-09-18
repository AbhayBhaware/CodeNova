import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Branded gradient button with restrained styling for primary CTAs.
///
/// Features:
/// - Guarantees minimum 48dp touch-target height.
/// - Uses restrained brand gradient (Deep Blue to Blue Accent).
/// - Subtle ambient shadow (no excessive glow).
class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient = AppColors.brandGradient,
    this.padding,
    this.width,
    this.height = AppDimensions.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final LinearGradient gradient;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: isEnabled ? gradient : null,
          color: isEnabled ? null : AppColors.neutral400,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          boxShadow: isEnabled ? AppDimensions.buttonShadow : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            splashColor: Colors.white.withAlpha(30),
            highlightColor: Colors.white.withAlpha(15),
            child: Padding(
              padding: padding ?? AppDimensions.buttonPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppDimensions.iconSM, color: Colors.white),
                    const SizedBox(width: AppDimensions.spaceSM),
                  ],
                  Text(
                    label,
                    style: AppTypography.button(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A restrained, high-contrast tag / chip badge for categories & status labels.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.color = AppColors.primary,
    this.textColor,
    this.backgroundColor,
  });

  final String label;
  final Color color;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? color;
    final effectiveBgColor = backgroundColor ?? color.withAlpha(24);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSM + 2,
        vertical: AppDimensions.spaceXXS + 1,
      ),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        border: Border.all(color: color.withAlpha(60), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: AppTextSizes.xs,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Section header with optional accent mark and subtitle.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.textAlign = TextAlign.left,
    this.action,
  });

  final String title;
  final String? subtitle;
  final TextAlign textAlign;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: textAlign == TextAlign.center
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: textAlign == TextAlign.center
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  // Clean accent indicator bar
                  Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceSM),
                  Text(
                    title,
                    style: tt.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: textAlign,
                  ),
                ],
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: AppDimensions.spaceSM),
              action!,
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimensions.spaceXS + 2),
          Text(
            subtitle!,
            style: tt.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: textAlign,
          ),
        ],
      ],
    );
  }
}

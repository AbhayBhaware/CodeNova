import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Button visual variant types.
enum AppButtonVariant {
  /// Filled deep blue primary button.
  primary,

  /// Outlined button with 1.5px border.
  outline,

  /// Subtle gray tonal background button.
  tonal,

  /// Clean text button without background or border.
  text,
}

/// A standardized, accessible button for the CodeNova Design System.
///
/// Features:
/// - Guarantees minimum 48dp height for WCAG touch-target compliance.
/// - Supports loading state with an inline spinner.
/// - Supports leading/trailing icons.
/// - Configurable full-width or wrap-content sizing.
/// - Built-in Semantics for screen readers.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height = AppDimensions.buttonHeight,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Factory constructor for an Outlined button.
  const AppButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height = AppDimensions.buttonHeight,
    this.borderRadius,
    this.foregroundColor,
  })  : variant = AppButtonVariant.outline,
        backgroundColor = null;

  /// Factory constructor for a Text button.
  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height = AppDimensions.buttonHeightSM,
    this.borderRadius,
    this.foregroundColor,
  })  : variant = AppButtonVariant.text,
        backgroundColor = null;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final radius = borderRadius ?? BorderRadius.circular(AppDimensions.radiusMD);

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoadingColor(colorScheme),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSM),
        ] else if (icon != null) ...[
          Icon(icon, size: AppDimensions.iconSM),
          const SizedBox(width: AppDimensions.spaceSM),
        ],
        Text(
          label,
          style: AppTypography.button().copyWith(
            color: _isDisabled ? colorScheme.onSurface.withAlpha(96) : null,
          ),
        ),
        if (!isLoading && trailingIcon != null) ...[
          const SizedBox(width: AppDimensions.spaceSM),
          Icon(trailingIcon, size: AppDimensions.iconSM),
        ],
      ],
    );

    Widget button;

    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(
          onPressed: _isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? colorScheme.primary,
            foregroundColor: foregroundColor ?? colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            elevation: 0,
            minimumSize: Size(isFullWidth ? double.infinity : 64, height),
            shape: RoundedRectangleBorder(borderRadius: radius),
            padding: AppDimensions.buttonPadding,
          ),
          child: content,
        );
        break;

      case AppButtonVariant.outline:
        button = OutlinedButton(
          onPressed: _isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? colorScheme.primary,
            side: BorderSide(
              color: _isDisabled
                  ? colorScheme.outline.withAlpha(80)
                  : (foregroundColor ?? colorScheme.primary),
              width: 1.5,
            ),
            minimumSize: Size(isFullWidth ? double.infinity : 64, height),
            shape: RoundedRectangleBorder(borderRadius: radius),
            padding: AppDimensions.buttonPadding,
          ),
          child: content,
        );
        break;

      case AppButtonVariant.tonal:
        button = FilledButton.tonal(
          onPressed: _isDisabled ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? colorScheme.surfaceContainer,
            foregroundColor: foregroundColor ?? colorScheme.onSurface,
            minimumSize: Size(isFullWidth ? double.infinity : 64, height),
            shape: RoundedRectangleBorder(borderRadius: radius),
            padding: AppDimensions.buttonPadding,
          ),
          child: content,
        );
        break;

      case AppButtonVariant.text:
        button = TextButton(
          onPressed: _isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? colorScheme.primary,
            minimumSize: Size(isFullWidth ? double.infinity : 64, height),
            shape: RoundedRectangleBorder(borderRadius: radius),
            padding: AppDimensions.buttonPaddingSM,
          ),
          child: content,
        );
        break;
    }

    return Semantics(
      button: true,
      enabled: !_isDisabled,
      label: label,
      child: button,
    );
  }

  Color _getLoadingColor(ColorScheme scheme) {
    switch (variant) {
      case AppButtonVariant.primary:
        return scheme.onPrimary;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return scheme.primary;
      case AppButtonVariant.tonal:
        return scheme.onSurface;
    }
  }
}

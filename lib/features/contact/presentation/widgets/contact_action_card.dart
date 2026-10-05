import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Reusable interactive card for verified company contact details.
/// Features a primary action (e.g. call, email, maps, website) and
/// a secondary copy-to-clipboard action with feedback.
class ContactActionCard extends StatelessWidget {
  const ContactActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    required this.actionLabel,
    required this.actionIcon,
    required this.accentColor,
    required this.onAction,
    this.onCopy,
    this.copyTooltip = 'Copy to clipboard',
  });

  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final String actionLabel;
  final IconData actionIcon;
  final Color accentColor;
  final VoidCallback onAction;
  final VoidCallback? onCopy;
  final String copyTooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tt = theme.textTheme;

    return AppCard.glass(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Accent Icon Avatar ──────────────────────────────────
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(isDark ? 40 : 25),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  border: Border.all(
                    color: accentColor.withAlpha(isDark ? 90 : 60),
                  ),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: AppDimensions.iconMD,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMD),

              // ── Title & Value ───────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: tt.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SelectableText(
                      value,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: AppTextSizes.body,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: tt.bodySmall?.copyWith(
                          fontSize: AppTextSizes.xs,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ── Copy Icon Button ────────────────────────────────────
              if (onCopy != null)
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  tooltip: copyTooltip,
                  color: AppColors.textSecondary,
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  onPressed: onCopy,
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Action Button ───────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: onAction,
              icon: Icon(actionIcon, size: 16),
              label: Text(actionLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: accentColor,
                side: BorderSide(
                  color: accentColor.withAlpha(isDark ? 140 : 100),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

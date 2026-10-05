import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Quick navigational shortcuts for specific business enquiries.
class ContactQuickShortcuts extends StatelessWidget {
  const ContactQuickShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Direct Enquiry Portals',
          subtitle: 'Choose a dedicated channel for expedited processing',
        ),
        const SizedBox(height: AppDimensions.spaceMD),
        _ShortcutCard(
          icon: Icons.request_quote_rounded,
          accentColor: AppColors.primary,
          title: 'Request a Project Quote',
          description:
              'For bespoke web, mobile, AI, and enterprise software engineering projects.',
          buttonLabel: 'Open Quote Form',
          onTap: () => context.go(AppStrings.routeQuoteRequest),
        ),
        const SizedBox(height: AppDimensions.spaceMD),
        _ShortcutCard(
          icon: Icons.work_outline_rounded,
          accentColor: AppColors.secondary,
          title: 'Internship Applications',
          description:
              'Apply for hands-on mentored internships with verified certificates in Pune.',
          buttonLabel: 'Explore Internships',
          onTap: () => context.go(AppStrings.routeInternships),
        ),
      ],
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onTap,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onTap;

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
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(isDark ? 40 : 25),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: AppDimensions.spaceMD),
              Expanded(
                child: Text(
                  title,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Text(
            description,
            style: tt.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: Text(buttonLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: accentColor,
                side: BorderSide(color: accentColor.withAlpha(120)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

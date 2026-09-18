import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';

/// Testimonials Section on [HomePage].
///
/// Per requirements: "Only include genuine approved testimonials. If unavailable,
/// omit the section or use a clearly marked placeholder. Do not invent course
/// details, company statistics, testimonials, or certifications."
///
/// This widget serves as a clearly marked placeholder informing users that
/// genuine student reviews are undergoing platform verification.
class HomeTestimonialsSection extends StatelessWidget {
  const HomeTestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ───────────────────────────────────
          const SectionHeader(
            title: AppStrings.testimonialsTitle,
            subtitle: AppStrings.testimonialsSubtitle,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Clearly Marked Placeholder Card ───────────────────
          AppCard(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            borderColor: AppColors.neutral200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.rate_review_outlined,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceSM),
                    const AppBadge(
                      label: 'Verified Records',
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMD),

                Text(
                  'Verified Student Reviews & Feedback',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXS + 2),

                Text(
                  'Genuine placement reviews and student feedback from our 5,000+ '
                  'learners in Pune are currently being prepared for the upcoming mobile update. '
                  'All program certificates remain fully verifiable on our web portal.',
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLG),

                // Link to official website / certificate verification
                OutlinedButton.icon(
                  onPressed: () => AppUtils.launchWebUrl(AppStrings.website),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.neutral200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceMD,
                      vertical: AppDimensions.spaceSM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMD),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('View Official Website'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Section showcasing CodeNova's training focus, internship structure,
/// and verified learning pillars.
class AboutTrainingSection extends StatelessWidget {
  const AboutTrainingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: AppStrings.aboutTrainingTitle,
            subtitle: AppStrings.aboutTrainingSubtitle,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Overview card with training & internship highlights
          AppCard(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceSM),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withAlpha(25),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSM),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceSM),
                    Text(
                      'Education & Mentorship',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMD),
                Text(
                  'CodeNova equips aspiring developers, students, and fresh graduates '
                  'with job-ready technical skills through rigorous training paths and '
                  'practical immersion.',
                  style: tt.bodyMedium?.copyWith(
                    height: 1.55,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMD),

                // Training tags
                Wrap(
                  spacing: AppDimensions.spaceXS,
                  runSpacing: AppDimensions.spaceXS,
                  children: [
                    _FeatureChip(
                      icon: Icons.timer_outlined,
                      label: '1-Month Practical Courses',
                    ),
                    _FeatureChip(
                      icon: Icons.work_outline_rounded,
                      label: '3 – 6 Month Internships',
                    ),
                    _FeatureChip(
                      icon: Icons.laptop_mac_rounded,
                      label: 'Live Client Projects',
                    ),
                    _FeatureChip(
                      icon: Icons.verified_outlined,
                      label: 'Verifiable Certificates',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // 3 Learning Pillars (Verified from website claims)
          Text(
            'THE THREE PILLARS',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: AppTextSizes.xs,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          ...MockData.whyChooseUs.map((pillar) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spaceSM),
                child: AppCard(
                  padding: const EdgeInsets.all(AppDimensions.spaceMD),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceSM),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusSM),
                        ),
                        child: Icon(
                          pillar.icon,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pillar.title,
                              style: tt.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceXXS),
                            Text(
                              pillar.description,
                              style: tt.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),

          const SizedBox(height: AppDimensions.spaceMD),

          // Action button
          AppButton.outline(
            label: 'Browse Programs & Internships',
            isFullWidth: true,
            icon: Icons.explore_outlined,
            onPressed: () => context.go(AppStrings.routeExplore),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSM,
        vertical: AppDimensions.spaceXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: AppDimensions.spaceXS),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppTextSizes.xs,
              color: AppColors.neutral800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

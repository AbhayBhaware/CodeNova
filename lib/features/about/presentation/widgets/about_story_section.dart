import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Narrative section detailing company overview and the 4 verified core values.
class AboutStorySection extends StatelessWidget {
  const AboutStorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: AppStrings.aboutTitle,
            subtitle: 'Where Code Meets Innovation',
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Overview Narrative Card
          AppCard(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceXS + 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSM),
                      ),
                      child: const Icon(
                        Icons.business_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceSM),
                    Text(
                      'Who We Are',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMD),
                Text(
                  AppStrings.aboutIntro,
                  style: tt.bodyMedium?.copyWith(
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMD),
                Text(
                  AppStrings.aboutEducationSummary,
                  style: tt.bodyMedium?.copyWith(
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // Core Values Subsection
          Text(
            'OUR CORE VALUES',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: AppTextSizes.xs,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          // Responsive list of 4 core values
          ...MockData.companyValues.map((value) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spaceSM),
                child: AppCard(
                  padding: const EdgeInsets.all(AppDimensions.spaceMD),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceSM),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(20),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusSM),
                        ),
                        child: Icon(
                          value.icon,
                          color: AppColors.accent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value.title,
                              style: tt.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceXXS),
                            Text(
                              value.description,
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
        ],
      ),
    );
  }
}

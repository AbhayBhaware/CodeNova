import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Mission & Vision section showcasing verified company purpose and long-term vision.
class AboutMissionVisionSection extends StatelessWidget {
  const AboutMissionVisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Mission & Vision',
            subtitle: 'Guiding our principles and community impact',
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Mission Card
          AppCard(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.spaceSM),
                          decoration: BoxDecoration(
                            gradient: AppColors.brandGradient,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusSM),
                          ),
                          child: const Icon(
                            Icons.flag_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceSM),
                        Text(
                          'Our Mission',
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const AppBadge(
                      label: 'PURPOSE',
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMD),
                Text(
                  AppStrings.mission,
                  style: tt.bodyMedium?.copyWith(
                    height: 1.55,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Vision Card
          AppCard(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.spaceSM),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusSM),
                          ),
                          child: const Icon(
                            Icons.visibility_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceSM),
                        Text(
                          'Our Vision',
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const AppBadge(
                      label: 'FUTURE',
                      color: AppColors.accent,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMD),
                Text(
                  AppStrings.vision,
                  style: tt.bodyMedium?.copyWith(
                    height: 1.55,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Slogan Callout
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.format_quote_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: AppDimensions.spaceSM),
                Expanded(
                  child: Text(
                    AppStrings.appTagline,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

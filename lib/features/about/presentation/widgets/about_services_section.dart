import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Section showcasing the 6 verified IT enterprise services offered by CodeNova.
class AboutServicesSection extends StatelessWidget {
  const AboutServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Core IT Services',
            subtitle: 'Modern digital engineering for businesses & startups',
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Intro summary
          Text(
            AppStrings.aboutServicesSummary,
            style: tt.bodyMedium?.copyWith(
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Services list
          ...MockData.services.map((service) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spaceSM),
                child: AppCard(
                  padding: const EdgeInsets.all(AppDimensions.spaceMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(AppDimensions.spaceSM),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusSM),
                            ),
                            child: Icon(
                              service.icon,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceMD),
                          Expanded(
                            child: Text(
                              service.title,
                              style: tt.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      Text(
                        service.description,
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      Wrap(
                        spacing: AppDimensions.spaceXS,
                        runSpacing: AppDimensions.spaceXS,
                        children: service.tags
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimensions.spaceSM,
                                    vertical: AppDimensions.spaceXXS,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.neutral100,
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusXS),
                                    border: Border.all(
                                      color: AppColors.neutral200,
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: AppTextSizes.xs,
                                      color: AppColors.neutral800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              )),

          const SizedBox(height: AppDimensions.spaceMD),

          // Navigation CTA to services tab
          AppButton.outline(
            label: 'Explore All Services',
            isFullWidth: true,
            icon: Icons.business_center_outlined,
            onPressed: () => context.go(AppStrings.routeServices),
          ),
        ],
      ),
    );
  }
}

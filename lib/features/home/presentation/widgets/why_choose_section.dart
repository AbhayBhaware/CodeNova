import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// "Why Choose CodeNova" verified company claims section on [HomePage].
///
/// Strictly displays claims verified from the company website ($f array):
/// 1. Expert Mentors
/// 2. Hands-on Projects
/// 3. Verified Certificates
class WhyChooseSection extends StatelessWidget {
  const WhyChooseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = MockData.whyChooseUs;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ───────────────────────────────────
          const SectionHeader(
            title: AppStrings.whyChooseTitle,
            subtitle: AppStrings.whyChooseSubtitle,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Cards Grid / Column ──────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: claims.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimensions.spaceMD),
            itemBuilder: (context, index) {
              return _BenefitCard(item: claims[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.item});

  final FeatureItem item;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: Icon(
              item.icon,
              color: AppColors.primary,
              size: AppDimensions.iconMD,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: AppTextSizes.bodyLg,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXXS),
                Text(
                  item.description,
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
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

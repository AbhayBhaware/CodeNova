import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// "Why CodeNova?" feature grid section on [HomePage].
class WhyChooseSection extends StatelessWidget {
  const WhyChooseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: AppStrings.whyChooseTitle),
          const SizedBox(height: AppDimensions.spaceLG),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimensions.spaceMD,
              mainAxisSpacing: AppDimensions.spaceMD,
              childAspectRatio: 1.1,
            ),
            itemCount: MockData.whyChooseUs.length,
            itemBuilder: (context, index) {
              final item = MockData.whyChooseUs[index];
              return _FeatureCard(item: item);
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.item});

  final FeatureItem item;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppCard.glass(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: Icon(
              item.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Text(
            item.title,
            style: tt.titleMedium?.copyWith(fontSize: AppTextSizes.body),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Expanded(
            child: Text(
              item.description,
              style: tt.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

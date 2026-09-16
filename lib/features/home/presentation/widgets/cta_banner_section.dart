import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';

/// Full-width CTA banner at the bottom of [HomePage].
class CtaBannerSection extends StatelessWidget {
  const CtaBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      padding: const EdgeInsets.all(AppDimensions.spaceXL),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0F4C81),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.ctaBannerTitle,
            style: tt.displayMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Text(
            AppStrings.ctaBannerSubtitle,
            style: tt.bodyLarge?.copyWith(
              color: Colors.white.withAlpha(210),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),
          OutlinedButton(
            onPressed: () => context.go(AppStrings.routeContact),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 1.5),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceLG,
                vertical: AppDimensions.spaceMD,
              ),
            ),
            child: Text(
              AppStrings.ctaBannerButton,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

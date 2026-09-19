import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';

/// Top hero header displaying CodeNova branding, verified tagline,
/// and location badge.
class AboutHeroHeader extends StatelessWidget {
  const AboutHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG,
        vertical: AppDimensions.spaceXXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Monogram logo badge
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: Colors.white.withAlpha(60),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(100),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'CN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Company Name
          Text(
            AppStrings.appName,
            style: tt.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceXS),

          // Tagline
          Text(
            AppStrings.appTagline,
            style: tt.bodyMedium?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Verified location chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMD,
              vertical: AppDimensions.spaceXS,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
              border: Border.all(
                color: Colors.white.withAlpha(40),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Colors.white70,
                  size: 15,
                ),
                SizedBox(width: AppDimensions.spaceXS),
                Text(
                  AppStrings.address,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextSizes.xs,
                    fontWeight: FontWeight.w500,
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';

/// Full-width CTA banner at the bottom of [HomePage].
///
/// Features an attractive enquiry call-to-action and direct contact channels.
class CtaBannerSection extends StatelessWidget {
  const CtaBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0F4C81),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(35),
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
            ),
            child: const Text(
              'GET IN TOUCH',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppTextSizes.xs,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Title
          Text(
            AppStrings.ctaBannerTitle,
            style: tt.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          // Subtitle
          Text(
            AppStrings.ctaBannerSubtitle,
            style: tt.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(220),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Action Buttons (Wrap for responsive support)
          Wrap(
            spacing: AppDimensions.spaceMD,
            runSpacing: AppDimensions.spaceSM,
            children: [
              ElevatedButton(
                onPressed: () => context.go(AppStrings.routeContact),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: AppDimensions.buttonPadding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Enquire Now',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: AppTextSizes.body,
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceXS),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => AppUtils.launchPhone(AppStrings.phoneDialable),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70, width: 1.5),
                  padding: AppDimensions.buttonPadding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                ),
                icon: const Icon(Icons.phone_rounded, size: 16, color: Colors.white),
                label: const Text('Call Support'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Quick contact indicators
          Row(
            children: const [
              Icon(Icons.location_on_outlined, size: 14, color: Colors.white70),
              SizedBox(width: 4),
              Text(
                'Pune, Maharashtra, India',
                style: TextStyle(color: Colors.white70, fontSize: AppTextSizes.xs),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

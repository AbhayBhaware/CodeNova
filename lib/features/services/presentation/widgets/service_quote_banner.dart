import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import 'quote_request_sheet.dart';

/// Promotional hero card offering quick project consultation and quote requests.
class ServiceQuoteBanner extends StatelessWidget {
  const ServiceQuoteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical: AppDimensions.spaceSM,
      ),
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow tag
          Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceSM,
                  vertical: AppDimensions.spaceXXS + 1,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withAlpha(40),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                  border: Border.all(
                    color: AppColors.accent.withAlpha(80),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      color: AppColors.accent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'ENTERPRISE & STARTUP SOLUTIONS',
                        style: AppTypography.overline(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Title
          const Text(
            'Need a Custom Software or AI Solution?',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppTextSizes.subtitle,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXS + 2),

          // Subtitle
          Text(
            'From web & mobile app engineering to cloud infrastructure and AI automation, CodeNova builds reliable digital systems tailored to your business.',
            style: TextStyle(
              color: Colors.white.withAlpha(200),
              fontSize: AppTextSizes.sm,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // CTA Action
          AppGradientButton(
            label: 'Request a Quote',
            icon: Icons.request_quote_rounded,
            gradient: const LinearGradient(
              colors: [AppColors.accent, Color(0xFF0091EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onPressed: () => QuoteRequestSheet.show(context),
          ),
        ],
      ),
    );
  }
}

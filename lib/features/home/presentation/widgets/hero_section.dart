import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Full-bleed hero banner shown at the top of [HomePage].
///
/// Headline, description, and statistics are verified from the official
/// CodeNova Tech Solutions website (codenovatechsolutions.in).
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceMD,
        AppDimensions.spaceLG,
        AppDimensions.spaceMD,
        AppDimensions.spaceXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Eyebrow Badge ─────────────────────────────────────
          const AppBadge(
            label: AppStrings.heroEyebrow,
            color: AppColors.accent,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Hero Headline ─────────────────────────────────────
          Text(
            AppStrings.heroTitle,
            style: tt.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          // ── Subheading ─────────────────────────────────────────
          Text(
            AppStrings.heroSubtitle,
            style: tt.bodyLarge?.copyWith(
              fontSize: AppTextSizes.bodyLg,
              color: Colors.white.withAlpha(220),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── CTA Buttons (Responsive Wrap) ─────────────────────
          Wrap(
            spacing: AppDimensions.spaceMD,
            runSpacing: AppDimensions.spaceMD,
            children: [
              AppGradientButton(
                label: AppStrings.heroCtaPrimary,
                icon: Icons.explore_rounded,
                onPressed: () => context.go(AppStrings.routeExplore),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70, width: 1.5),
                  padding: AppDimensions.buttonPadding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                ),
                icon: const Icon(Icons.work_outline_rounded,
                    size: 16, color: Colors.white),
                label: const Text(AppStrings.heroCtaSecondary),
                onPressed: () => context.go(AppStrings.routeInternships),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // ── Verified Stats Row ────────────────────────────────
          const _VerifiedStatsCard(),
        ],
      ),
    );
  }
}

/// Stat card displaying official metrics verified from the company website.
class _VerifiedStatsCard extends StatelessWidget {
  const _VerifiedStatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical: AppDimensions.spaceMD,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: Colors.white.withAlpha(30)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatMetric(
              value: AppStrings.statsStudentsValue,
              label: AppStrings.statsStudentsLabel,
              icon: Icons.school_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withAlpha(40),
          ),
          Expanded(
            child: _StatMetric(
              value: AppStrings.statsPartnersValue,
              label: AppStrings.statsPartnersLabel,
              icon: Icons.handshake_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatMetric extends StatelessWidget {
  const _StatMetric({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.accent),
            const SizedBox(width: AppDimensions.spaceXS),
            Text(
              value,
              style: const TextStyle(
                fontSize: AppTextSizes.heading,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceXXS),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: AppTextSizes.xs,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Full-bleed hero banner shown at the top of [HomePage].
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height * 0.48),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceMD,
        AppDimensions.spaceLG,
        AppDimensions.spaceMD,
        AppDimensions.spaceXXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow badge
          const AppBadge(
            label: '🎓  IT Training & Internships · Pune',
            color: AppColors.accent,
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Hero headline
          Text(
            AppStrings.heroTitle,
            style: tt.displayLarge?.copyWith(
              foreground: Paint()
                ..shader = AppColors.brandGradient.createShader(
                  const Rect.fromLTWH(0, 0, 300, 80),
                ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Subheading
          Text(
            AppStrings.heroSubtitle,
            style: tt.bodyLarge?.copyWith(
              fontSize: AppTextSizes.bodyLg,
              color: Colors.white.withAlpha(220),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // CTA Row
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
          const SizedBox(height: AppDimensions.spaceXXL),

          // Stats row
          const _StatsRow(),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(value: '500+', label: 'Students'),
        _divider(),
        _StatItem(value: '6+', label: 'Courses'),
        _divider(),
        _StatItem(value: '95%', label: 'Placement'),
        _divider(),
        _StatItem(value: '2+', label: 'Years'),
      ],
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 36,
        color: Colors.white24,
      );
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.brandGradient.createShader(bounds),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: AppTextSizes.display,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: AppTextSizes.xs,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

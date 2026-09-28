import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';

/// Animated shimmer skeleton for loading state (3 cards placeholder).
class InternshipLoadingSkeleton extends StatefulWidget {
  const InternshipLoadingSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  State<InternshipLoadingSkeleton> createState() =>
      _InternshipLoadingSkeletonState();
}

class _InternshipLoadingSkeletonState extends State<InternshipLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? AppColors.backgroundSurface : AppColors.neutral100;
    final shimmerColor = isDark ? AppColors.backgroundCard : AppColors.white;

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final color = Color.lerp(baseColor, shimmerColor, _anim.value)!;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMD,
            vertical: AppDimensions.spaceSM,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.itemCount,
          separatorBuilder: (_, _) =>
              const SizedBox(height: AppDimensions.spaceMD),
          itemBuilder: (context, _) => _SkeletonCard(shimmerColor: color),
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.shimmerColor});

  final Color shimmerColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        isDark ? AppColors.borderDark : AppColors.borderLight;

    Widget box(double w, double h, {double radius = 6}) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(radius),
          ),
        );

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.backgroundCard : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              box(48, 48, radius: AppDimensions.radiusMD),
              const SizedBox(width: AppDimensions.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    box(double.infinity, 16),
                    const SizedBox(height: 6),
                    box(120, 12),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSM),
              box(72, 26, radius: AppDimensions.radiusCircle),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Row(
            children: [
              box(80, 22, radius: AppDimensions.radiusXS),
              const SizedBox(width: AppDimensions.spaceXS),
              box(64, 22, radius: AppDimensions.radiusXS),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          box(double.infinity, 13),
          const SizedBox(height: 6),
          box(200, 13),
          const SizedBox(height: AppDimensions.spaceSM),
          Row(
            children: [
              box(56, 22, radius: AppDimensions.radiusCircle),
              const SizedBox(width: AppDimensions.spaceXS),
              box(70, 22, radius: AppDimensions.radiusCircle),
              const SizedBox(width: AppDimensions.spaceXS),
              box(50, 22, radius: AppDimensions.radiusCircle),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          box(double.infinity, 44, radius: AppDimensions.radiusMD),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class InternshipEmptyState extends StatelessWidget {
  const InternshipEmptyState({
    super.key,
    required this.onResetFilters,
    this.searchQuery = '',
    this.category = 'All',
  });

  final VoidCallback onResetFilters;
  final String searchQuery;
  final String category;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hasFilters = searchQuery.isNotEmpty || category != 'All';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.work_off_rounded,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            Text(
              'No Internships Found',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceXS),
            Text(
              hasFilters
                  ? 'No programmes match "${searchQuery.isNotEmpty ? searchQuery : category}". Try a different search or reset filters.'
                  : 'No internship programmes are available right now. Check back soon!',
              style: tt.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: AppDimensions.spaceLG),
              AppButton.outline(
                label: 'Reset Filters',
                icon: Icons.refresh_rounded,
                onPressed: onResetFilters,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Error State ───────────────────────────────────────────────────────────────
class InternshipErrorState extends StatelessWidget {
  const InternshipErrorState({
    super.key,
    required this.onRetry,
    this.errorMessage,
  });

  final VoidCallback onRetry;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: AppColors.error,
                size: 36,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            Text(
              'Unable to Load Internships',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceXS),
            Text(
              errorMessage ??
                  'An unexpected error occurred. Please check your connection and try again.',
              style: tt.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceLG),
            AppButton(
              label: 'Try Again',
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Apply CTA Banner ──────────────────────────────────────────────────────────

/// Gradient top-of-page CTA banner encouraging applications.
class InternshipApplyBanner extends StatelessWidget {
  const InternshipApplyBanner({super.key, required this.openCount});

  final int openCount;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.spaceMD,
        AppDimensions.spaceXS,
        AppDimensions.spaceMD,
        AppDimensions.spaceMD,
      ),
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, Color(0xFF0D3A6B)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (openCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceSM,
                      vertical: AppDimensions.spaceXXS + 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(40),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusCircle),
                      border: Border.all(
                          color: AppColors.success.withAlpha(80)),
                    ),
                    child: Text(
                      '$openCount position${openCount != 1 ? 's' : ''} open',
                      style: const TextStyle(
                        fontSize: AppTextSizes.xs,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                const SizedBox(height: AppDimensions.spaceSM),
                Text(
                  'Start Your IT Career',
                  style: tt.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                Text(
                  'Apply directly via email or call us to enquire about open slots.',
                  style: tt.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(180),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMD),
                Wrap(
                  spacing: AppDimensions.spaceSM,
                  children: [
                    _BannerButton(
                      icon: Icons.email_rounded,
                      label: 'Email Us',
                      onTap: () => AppUtils.launchEmail(
                        AppStrings.email,
                        subject: 'Internship Application Enquiry',
                      ),
                    ),
                    _BannerButton(
                      icon: Icons.phone_rounded,
                      label: AppStrings.phone,
                      onTap: () =>
                          AppUtils.launchPhone(AppStrings.phoneDialable),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rocket_launch_rounded,
              color: Colors.white,
              size: AppDimensions.iconLG,
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerButton extends StatelessWidget {
  const _BannerButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceSM + 2,
          vertical: AppDimensions.spaceXS + 2,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(22),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          border: Border.all(color: Colors.white.withAlpha(50)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: AppDimensions.spaceXS),
            Text(
              label,
              style: const TextStyle(
                fontSize: AppTextSizes.xs,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

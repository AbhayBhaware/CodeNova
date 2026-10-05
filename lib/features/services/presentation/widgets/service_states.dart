import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Shimmer-like loading skeleton placeholder list for IT services.
class ServicesLoadingSkeleton extends StatelessWidget {
  const ServicesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderColor =
        isDark ? AppColors.backgroundSurface : AppColors.neutral200;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spaceMD),
      itemBuilder: (_, _) => AppCard(
        padding: const EdgeInsets.all(AppDimensions.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSM),
            Container(
              width: 220,
              height: 14,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            Row(
              children: List.generate(
                3,
                (i) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 60,
                  height: 22,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state when no services match the active category or query.
class ServicesEmptyState extends StatelessWidget {
  const ServicesEmptyState({
    super.key,
    required this.onReset,
    this.searchQuery = '',
    this.selectedCategory = 'All',
  });

  final VoidCallback onReset;
  final String searchQuery;
  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceXL,
          vertical: AppDimensions.spaceXXL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLG),
            Text(
              'No Services Found',
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceSM),
            Text(
              searchQuery.isNotEmpty
                  ? 'We couldn\'t find any services matching "$searchQuery". Try checking for spelling or resetting your filters.'
                  : 'No services available under the "$selectedCategory" category right now.',
              style: tt.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceLG),
            AppButton(
              label: 'Reset Filters',
              icon: Icons.refresh_rounded,
              onPressed: onReset,
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state with retry callback for IT services.
class ServicesErrorState extends StatelessWidget {
  const ServicesErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceXL,
          vertical: AppDimensions.spaceXXL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 36,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLG),
            Text(
              'Unable to Load Services',
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceSM),
            Text(
              message,
              style: tt.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
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

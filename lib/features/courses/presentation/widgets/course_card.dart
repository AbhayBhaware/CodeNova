import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/course_model.dart';

/// Reusable course card widget for the CodeNova courses catalog.
///
/// Features:
/// - Category icon with brand gradient styling
/// - Title and verified duration badge ("1 Month")
/// - Category and level chips
/// - Concise description
/// - Technology badges
/// - "View Details" button with minimum 48dp touch target
class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    this.onViewDetails,
  });

  final CourseModel course;
  final VoidCallback? onViewDetails;

  void _handleViewDetails(BuildContext context) {
    if (onViewDetails != null) {
      onViewDetails!();
    } else {
      // Navigate to the full Course Detail screen.
      context.push(
        '/courses/${course.id}',
        extra: course,
      );
    }
  }

  Color _levelColor(CourseLevel level) {
    switch (level) {
      case CourseLevel.beginner:
        return AppColors.success;
      case CourseLevel.intermediate:
        return AppColors.warning;
      case CourseLevel.advanced:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Semantics(
      label: '${course.title}, ${course.category}, ${course.duration}',
      child: AppCard(
        onTap: () => _handleViewDetails(context),
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row: Category Icon, Title, Duration Badge ─────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMD),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(40),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    course.icon,
                    color: Colors.white,
                    size: AppDimensions.iconMD,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              course.title,
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: AppTextSizes.bodyLg,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (course.isFeatured) ...[
                            const SizedBox(width: AppDimensions.spaceXS),
                            const AppBadge(
                              label: 'Featured',
                              color: AppColors.secondary,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceXXS),
                      Text(
                        course.subtitle,
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                          fontSize: AppTextSizes.xs,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // ── Metadata Chips: Category, Duration, Level ────────
            Wrap(
              spacing: AppDimensions.spaceXS,
              runSpacing: AppDimensions.spaceXS,
              children: [
                // Category Chip
                AppBadge(
                  label: course.category,
                  color: AppColors.primary,
                ),
                // Verified Duration Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceXS + 2,
                    vertical: AppDimensions.spaceXXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(20),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.duration,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                // Level Badge
                AppBadge(
                  label: course.level.label,
                  color: _levelColor(course.level),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // ── Description ───────────────────────────────────────
            Text(
              course.description,
              style: tt.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // ── Technology Tags ───────────────────────────────────
            Wrap(
              spacing: AppDimensions.spaceXS,
              runSpacing: AppDimensions.spaceXS,
              children: course.tags
                  .map(
                    (tag) => AppBadge(
                      label: tag,
                      color: AppColors.neutral600,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // ── Action Footer: View Details CTA ───────────────────
            AppButton.outline(
              label: 'View Details',
              icon: Icons.info_outline_rounded,
              isFullWidth: true,
              height: 44,
              onPressed: () => _handleViewDetails(context),
            ),
          ],
        ),
      ),
    );
  }
}

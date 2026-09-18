import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/models.dart';

/// Featured Courses Section on [HomePage].
///
/// Displays verified course programs with title, description, duration,
/// and a functional "View Details" action.
class FeaturedCoursesSection extends StatelessWidget {
  const FeaturedCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = MockData.courses;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ───────────────────────────────────
          SectionHeader(
            title: AppStrings.featuredCoursesTitle,
            subtitle: AppStrings.featuredCoursesSubtitle,
            action: TextButton.icon(
              onPressed: () => context.go(AppStrings.routeExplore),
              icon: const Text('View All'),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Horizontal Cards Carousel ─────────────────────────
          SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: courses.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppDimensions.spaceMD),
              itemBuilder: (context, index) {
                return _HomeCourseCard(course: courses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Card widget representing an individual course with "View Details" button.
class _HomeCourseCard extends StatelessWidget {
  const _HomeCourseCard({required this.course});

  final CourseModel course;

  void _showCourseDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CourseDetailsSheet(course: course),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppCard(
      onTap: () => _showCourseDetails(context),
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon + Duration Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: Icon(
                    course.icon,
                    color: AppColors.primary,
                    size: AppDimensions.iconMD,
                  ),
                ),
                AppBadge(
                  label: course.duration,
                  color: AppColors.accent,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // Course Title
            Text(
              course.title,
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: AppTextSizes.bodyLg,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spaceXS),

            // Short Description
            Expanded(
              child: Text(
                course.description,
                style: tt.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // View Details Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showCourseDetails(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spaceXS + 4,
                  ),
                  side: const BorderSide(color: AppColors.neutral200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View Details',
                      style: AppTypography.caption(color: AppColors.primary)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: AppDimensions.spaceXS),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Detailed modal bottom sheet opened on "View Details".
class _CourseDetailsSheet extends StatelessWidget {
  const _CourseDetailsSheet({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceLG,
        AppDimensions.spaceMD,
        AppDimensions.spaceLG,
        AppDimensions.spaceXL,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
                decoration: BoxDecoration(
                  color: AppColors.neutral300,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                ),
              ),
            ),

            // Title & Icon
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: Icon(course.icon, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: AppDimensions.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: tt.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Duration: ${course.duration} · ${course.level.label}',
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceLG),

            // Description
            Text('About this Program', style: tt.titleMedium),
            const SizedBox(height: AppDimensions.spaceXS),
            Text(
              course.description,
              style: tt.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // Topics / Tags
            Text('Key Technologies & Topics', style: tt.titleMedium),
            const SizedBox(height: AppDimensions.spaceSM),
            Wrap(
              spacing: AppDimensions.spaceSM,
              runSpacing: AppDimensions.spaceSM,
              children: course.tags
                  .map((tag) => AppBadge(label: tag, color: AppColors.primary))
                  .toList(),
            ),
            const SizedBox(height: AppDimensions.spaceXL),

            // Action CTA
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: AppDimensions.buttonPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMD),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMD),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go(AppStrings.routeContact);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: AppDimensions.buttonPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMD),
                      ),
                    ),
                    child: const Text('Enquire Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

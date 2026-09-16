import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/models.dart';

/// Horizontal scrollable list of featured courses on [HomePage].
class FeaturedCoursesSection extends StatelessWidget {
  const FeaturedCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final featured =
        MockData.courses.where((c) => c.isFeatured).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: AppStrings.featuredCoursesTitle,
            subtitle: AppStrings.featuredCoursesSubtitle,
          ),
          const SizedBox(height: AppDimensions.spaceLG),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featured.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppDimensions.spaceMD),
              itemBuilder: (context, index) {
                return _CourseTile(course: featured[index]);
              },
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context.go(AppStrings.routeExplore),
              icon: const Text('View All Courses'),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      borderColor: AppColors.divider,
      onTap: () {},
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Icon(
                course.icon,
                color: Colors.white,
                size: AppDimensions.iconMD,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            Text(
              course.title,
              style: tt.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spaceXS),
            Text(
              course.duration,
              style: tt.bodySmall?.copyWith(color: AppColors.accent),
            ),
            const Spacer(),
            AppBadge(
              label: course.level.label,
              color: _levelColor(course.level),
            ),
          ],
        ),
      ),
    );
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
}

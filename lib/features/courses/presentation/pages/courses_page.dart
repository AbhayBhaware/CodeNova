import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/models.dart';

/// All courses listing page with filter chips.
class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  CourseLevel? _selectedLevel;

  List<CourseModel> get _filtered => _selectedLevel == null
      ? MockData.courses
      : MockData.courses
          .where((c) => c.level == _selectedLevel)
          .toList();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navCourses)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Filter Chips ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.spaceMD,
              AppDimensions.spaceMD,
              AppDimensions.spaceMD,
              0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _selectedLevel == null,
                    onSelected: (_) =>
                        setState(() => _selectedLevel = null),
                  ),
                  const SizedBox(width: AppDimensions.spaceSM),
                  ...CourseLevel.values.map((level) => Padding(
                        padding: const EdgeInsets.only(
                            right: AppDimensions.spaceSM),
                        child: _FilterChip(
                          label: level.label,
                          selected: _selectedLevel == level,
                          onSelected: (_) =>
                              setState(() => _selectedLevel = level),
                        ),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          // ── Course Count ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceMD),
            child: Text(
              '${_filtered.length} programme${_filtered.length != 1 ? 's' : ''} found',
              style: tt.bodySmall,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Course List ─────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMD),
              itemCount: _filtered.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppDimensions.spaceMD),
              itemBuilder: (context, index) {
                return _CourseListCard(course: _filtered[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.accent : AppColors.primary;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: activeColor.withAlpha(isDark ? 60 : 30),
      checkmarkColor: activeColor,
      labelStyle: TextStyle(
        color: selected ? activeColor : AppColors.textSecondary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        fontSize: AppTextSizes.sm,
      ),
      side: BorderSide(
        color: selected ? activeColor : theme.colorScheme.outline,
      ),
      backgroundColor:
          isDark ? AppColors.backgroundSurface : AppColors.neutral100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
      ),
    );
  }
}

// ── Course Card ──────────────────────────────────────────────────────────────

class _CourseListCard extends StatelessWidget {
  const _CourseListCard({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppCard.glass(
      onTap: () {
        // TODO: Navigate to course detail page when implemented
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 52,
            height: 52,
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
          const SizedBox(width: AppDimensions.spaceMD),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        course.title,
                        style: tt.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (course.isFeatured)
                      AppBadge(
                        label: 'Featured',
                        color: AppColors.secondary,
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                Text(
                  course.subtitle,
                  style: tt.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                Text(
                  course.description,
                  style: tt.bodySmall?.copyWith(
                      color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 14, color: AppColors.textMuted),
                    const SizedBox(width: AppDimensions.spaceXS),
                    Text(course.duration, style: tt.bodySmall),
                    const SizedBox(width: AppDimensions.spaceMD),
                    AppBadge(
                      label: course.level.label,
                      color: _levelColor(course.level),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                Wrap(
                  spacing: AppDimensions.spaceXS,
                  runSpacing: AppDimensions.spaceXS,
                  children: course.tags
                      .map((tag) => AppBadge(
                            label: tag,
                            color: AppColors.primary,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
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

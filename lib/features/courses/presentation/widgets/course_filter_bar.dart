import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../models/course_model.dart';

/// Horizontal filter bar for course category and learner level.
class CourseFilterBar extends StatelessWidget {
  const CourseFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.selectedLevel,
    required this.onLevelSelected,
    this.categories = MockData.courseCategories,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final CourseLevel? selectedLevel;
  final ValueChanged<CourseLevel?> onLevelSelected;
  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Category Filter Chips ────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
          child: Row(
            children: categories.map((category) {
              final isSelected = selectedCategory.toLowerCase() == category.toLowerCase();
              return Padding(
                padding: const EdgeInsets.only(right: AppDimensions.spaceSM),
                child: _CategoryChip(
                  label: category,
                  isSelected: isSelected,
                  onTap: () => onCategorySelected(category),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceSM),

        // ── Level Filter Chips ───────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
          child: Row(
            children: [
              _LevelFilterChip(
                label: 'All Levels',
                isSelected: selectedLevel == null,
                onTap: () => onLevelSelected(null),
              ),
              const SizedBox(width: AppDimensions.spaceXS),
              ...CourseLevel.values.map(
                (level) => Padding(
                  padding: const EdgeInsets.only(right: AppDimensions.spaceXS),
                  child: _LevelFilterChip(
                    label: level.label,
                    isSelected: selectedLevel == level,
                    onTap: () => onLevelSelected(level),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label category filter',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMD,
              vertical: AppDimensions.spaceSM - 2,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.backgroundSurface
                      : AppColors.neutral100),
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppTextSizes.sm,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textPrimaryDark : AppColors.textSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelFilterChip extends StatelessWidget {
  const _LevelFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label level filter',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceSM,
              vertical: AppDimensions.spaceXXS + 2,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withAlpha(25)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              border: Border.all(
                color: isSelected
                    ? AppColors.accent
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppTextSizes.xs,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.accent
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textMuted),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

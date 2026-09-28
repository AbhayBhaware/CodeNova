import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../models/internship_model.dart';

/// Horizontal scrolling category filter bar for the internships listing.
class InternshipFilterBar extends StatelessWidget {
  const InternshipFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final categories = MockData.internshipCategories;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Row(
        children: categories.map((cat) {
          final isSelected = cat == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceSM),
            child: _CategoryChip(
              label: cat,
              isSelected: isSelected,
              onTap: () => onCategorySelected(cat),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Category chip built with InkWell & Container for instant rendering.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: '$label filter',
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMD,
            vertical: AppDimensions.spaceXS + 2,
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
                  : (isDark ? AppColors.borderDark : AppColors.neutral200),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppTextSizes.sm,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal scrolling status filter (All / Open / Coming Soon).
class InternshipStatusFilterBar extends StatelessWidget {
  const InternshipStatusFilterBar({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  final InternshipStatus? selectedStatus;
  final ValueChanged<InternshipStatus?> onStatusSelected;

  static const _statuses = [
    null, // "All"
    InternshipStatus.open,
    InternshipStatus.comingSoon,
    InternshipStatus.closed,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Row(
        children: _statuses.map((status) {
          final isSelected = status == selectedStatus;
          final label = status == null ? 'All Status' : status.label;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceSM),
            child: _StatusChip(
              label: label,
              color: status?.color ?? AppColors.primary,
              isSelected: isSelected,
              onTap: () => onStatusSelected(status),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: '$label status filter',
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMD,
            vertical: AppDimensions.spaceXS + 2,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withAlpha(isDark ? 50 : 25)
                : (isDark
                    ? AppColors.backgroundSurface
                    : AppColors.neutral100),
            borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
            border: Border.all(
              color: isSelected
                  ? color
                  : (isDark ? AppColors.borderDark : AppColors.neutral200),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppTextSizes.sm,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? color
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

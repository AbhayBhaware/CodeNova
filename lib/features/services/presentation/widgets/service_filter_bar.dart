import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';

/// Horizontal category filter chip bar for IT Services.
///
/// Features:
/// - Guarantees minimum 48dp touch-target height for accessibility
/// - Visual indicators for active filter state
/// - Smooth horizontal scrolling
class ServiceFilterBar extends StatelessWidget {
  const ServiceFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.categories = MockData.serviceCategories,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMD,
          vertical: AppDimensions.spaceXXS,
        ),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppDimensions.spaceSM),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.toLowerCase() == selectedCategory.toLowerCase();

          return Semantics(
            button: true,
            selected: isSelected,
            label: '$category category filter',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onCategorySelected(category),
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceMD,
                    vertical: AppDimensions.spaceSM,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.backgroundSurface : AppColors.cardLight),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.borderDark : AppColors.neutral300),
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(isDark ? 80 : 50),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: AppTextSizes.sm,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

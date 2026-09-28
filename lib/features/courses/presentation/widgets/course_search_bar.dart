import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';

/// Accessible and styled search bar for the courses catalog.
class CourseSearchBar extends StatefulWidget {
  const CourseSearchBar({
    super.key,
    required this.onChanged,
    this.initialValue = '',
    this.hintText = 'Search courses, technologies, or keywords…',
  });

  final ValueChanged<String> onChanged;
  final String initialValue;
  final String hintText;

  @override
  State<CourseSearchBar> createState() => _CourseSearchBarState();
}

class _CourseSearchBarState extends State<CourseSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant CourseSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      label: 'Search courses input field',
      child: TextField(
        controller: _controller,
        onChanged: (val) {
          widget.onChanged(val);
          setState(() {});
        },
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: AppTextSizes.body,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textMuted,
            size: 22,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  tooltip: 'Clear search',
                  onPressed: _clear,
                )
              : null,
          filled: true,
          fillColor: isDark
              ? AppColors.backgroundSurface
              : AppColors.neutral100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMD,
            vertical: AppDimensions.spaceSM + 2,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            borderSide: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            borderSide: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

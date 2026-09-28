import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';

/// Accessible and styled search bar for the internships catalog.
class InternshipSearchBar extends StatefulWidget {
  const InternshipSearchBar({
    super.key,
    required this.onChanged,
    this.initialValue = '',
    this.hintText = 'Search by role, skill, or technology…',
  });

  final ValueChanged<String> onChanged;
  final String initialValue;
  final String hintText;

  @override
  State<InternshipSearchBar> createState() => _InternshipSearchBarState();
}

class _InternshipSearchBarState extends State<InternshipSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant InternshipSearchBar oldWidget) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: 'Search internships input field',
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onChanged: (val) {
          widget.onChanged(val);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.neutral400,
            size: AppDimensions.iconMD,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    size: AppDimensions.iconSM + 4,
                    color: AppColors.neutral400,
                  ),
                  tooltip: 'Clear search',
                  onPressed: _clear,
                )
              : null,
          fillColor: isDark
              ? AppColors.backgroundSurface
              : AppColors.surfaceLight,
        ),
      ),
    );
  }
}

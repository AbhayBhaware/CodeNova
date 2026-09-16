import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/models.dart';

/// Explore tab – the courses discovery hub.
///
/// Provides a search bar, category filter chips, and a full course grid
/// so users can browse all available programmes in one place.
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  CourseLevel? _selectedLevel;
  String _query = '';

  // ── Derived list ───────────────────────────────────────────
  List<CourseModel> get _filtered {
    var list = MockData.courses;
    if (_selectedLevel != null) {
      list = list.where((c) => c.level == _selectedLevel).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where((c) =>
              c.title.toLowerCase().contains(q) ||
              c.subtitle.toLowerCase().contains(q) ||
              c.tags.any((t) => t.toLowerCase().contains(q)))
          .toList();
    }
    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spaceMD,
                AppDimensions.spaceLG,
                AppDimensions.spaceMD,
                AppDimensions.spaceMD,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore',
                    style: tt.displayMedium,
                    semanticsLabel: 'Explore courses',
                  ),
                  const SizedBox(height: AppDimensions.spaceXS),
                  Text(
                    'Discover your next tech skill',
                    style: tt.bodyLarge,
                  ),
                  const SizedBox(height: AppDimensions.spaceLG),

                  // Search bar
                  Semantics(
                    label: 'Search courses',
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search courses, topics, skills…',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textMuted,
                        ),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded,
                                    color: AppColors.textMuted),
                                tooltip: 'Clear search',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMD),

                  // Level filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _LevelChip(
                          label: 'All',
                          selected: _selectedLevel == null,
                          onTap: () => setState(() => _selectedLevel = null),
                        ),
                        const SizedBox(width: AppDimensions.spaceSM),
                        ...CourseLevel.values.map((l) => Padding(
                              padding: const EdgeInsets.only(
                                  right: AppDimensions.spaceSM),
                              child: _LevelChip(
                                label: l.label,
                                selected: _selectedLevel == l,
                                onTap: () =>
                                    setState(() => _selectedLevel = l),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Course count ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMD),
              child: Text(
                '${_filtered.length} programme${_filtered.length != 1 ? 's' : ''}',
                style: tt.bodySmall,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // ── Grid ─────────────────────────────────────────
            Expanded(
              child: _filtered.isEmpty
                  ? _EmptyState(query: _query)
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spaceMD,
                        vertical: AppDimensions.spaceSM,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppDimensions.spaceMD,
                        mainAxisSpacing: AppDimensions.spaceMD,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _filtered.length,
                      itemBuilder: (ctx, i) =>
                          _ExploreCard(course: _filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Level Filter Chip ────────────────────────────────────────────────────────

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.accent : AppColors.primary;

    return Semantics(
      label: '$label filter',
      selected: selected,
      button: true,
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
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
      ),
    );
  }
}

// ── Explore Course Card ──────────────────────────────────────────────────────

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({required this.course});

  final CourseModel course;

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
    final tt = Theme.of(context).textTheme;

    return Semantics(
      label: '${course.title}, ${course.level.label}, ${course.duration}',
      button: true,
      child: AppCard.glass(
        onTap: () {
          // TODO: navigate to course detail when implemented
        },
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Icon(
                course.icon,
                color: Colors.white,
                size: AppDimensions.iconMD,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSM),
            Text(
              course.title,
              style: tt.titleMedium?.copyWith(fontSize: AppTextSizes.body),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spaceXS),
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 12, color: AppColors.textMuted),
                const SizedBox(width: AppDimensions.spaceXXS),
                Text(
                  course.duration,
                  style: tt.bodySmall?.copyWith(color: AppColors.accent),
                ),
              ],
            ),
            const Spacer(),
            AppBadge(
              label: course.level.label,
              color: _levelColor(course.level),
            ),
            if (course.isFeatured) ...[
              const SizedBox(height: AppDimensions.spaceXS),
              const AppBadge(
                label: '⭐ Featured',
                color: AppColors.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (b) =>
                  AppColors.brandGradient.createShader(b),
              child: const Icon(
                Icons.search_off_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            Text('No results found', style: tt.headlineMedium),
            const SizedBox(height: AppDimensions.spaceSM),
            Text(
              query.isNotEmpty
                  ? 'No courses match "$query". Try a different search.'
                  : 'No courses match the selected filter.',
              style: tt.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

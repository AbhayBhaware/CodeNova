import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../controllers/courses_controller.dart';
import '../widgets/courses_widgets.dart';

/// The primary Courses Listing screen for CodeNova Tech Solutions.
///
/// Features:
/// - Clean screen header with title, subtitle, and live programme count
/// - Multi-field search (title, subtitle, description, category, tags)
/// - Horizontal category and level filter chips
/// - Decoupled state management via [CoursesController]
/// - Loading skeleton placeholders, empty state with filter reset, and error retry state
/// - Reusable [CourseCard] items with verified 1-Month duration and details sheet
/// - Pull-to-refresh support
class CoursesPage extends StatefulWidget {
  const CoursesPage({
    super.key,
    this.controller,
  });

  /// Optional controller injection (for tests or custom dependency injection).
  final CoursesController? controller;

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late final CoursesController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = CoursesController();
      _ownsController = true;
      _controller.loadCourses();
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final canPop = Navigator.canPop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Programmes'),
        centerTitle: false,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Back',
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => _controller.loadCourses(forceRefresh: true),
          color: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Screen Header & Search ──────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.spaceMD,
                  AppDimensions.spaceXS,
                  AppDimensions.spaceMD,
                  AppDimensions.spaceSM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Industry-focused 1-month technical training designed to make you job-ready.',
                      style: tt.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceSM),
                    CourseSearchBar(
                      initialValue: _controller.searchQuery,
                      onChanged: _controller.search,
                    ),
                  ],
                ),
              ),

              // ── Category & Level Filters ────────────────────────────
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CourseFilterBar(
                    selectedCategory: _controller.selectedCategory,
                    onCategorySelected: _controller.setCategory,
                    selectedLevel: _controller.selectedLevel,
                    onLevelSelected: _controller.setLevel,
                  );
                },
              ),
              const SizedBox(height: AppDimensions.spaceSM),

              // ── Live Result Count Bar ───────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMD,
                ),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final count = _controller.filteredCount;
                    final total = _controller.totalCount;
                    final hasFilters = _controller.hasActiveFilters;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hasFilters
                              ? '$count of $total programme${count != 1 ? 's' : ''}'
                              : '$total available programme${total != 1 ? 's' : ''}',
                          style: tt.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (hasFilters)
                          InkWell(
                            onTap: _controller.clearFilters,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusXS),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: Text(
                                'Clear filters',
                                style: tt.bodySmall?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spaceSM),

              // ── Course Catalog Content Area ─────────────────────────
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    switch (_controller.status) {
                      case CoursesStatus.initial:
                      case CoursesStatus.loading:
                        return const CourseLoadingSkeleton(itemCount: 3);

                      case CoursesStatus.error:
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 400,
                            child: CourseErrorState(
                              onRetry: _controller.retry,
                              errorMessage: _controller.errorMessage,
                            ),
                          ),
                        );

                      case CoursesStatus.empty:
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 400,
                            child: CourseEmptyState(
                              onResetFilters: _controller.clearFilters,
                              searchQuery: _controller.searchQuery,
                              category: _controller.selectedCategory,
                            ),
                          ),
                        );

                      case CoursesStatus.success:
                        final courses = _controller.courses;

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 600;

                            if (isWide) {
                              return GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.spaceMD,
                                  vertical: AppDimensions.spaceSM,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: AppDimensions.spaceMD,
                                  mainAxisSpacing: AppDimensions.spaceMD,
                                  childAspectRatio: 0.82,
                                ),
                                itemCount: courses.length,
                                itemBuilder: (context, index) {
                                  return CourseCard(course: courses[index]);
                                },
                              );
                            }

                            return ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spaceMD,
                                vertical: AppDimensions.spaceSM,
                              ),
                              itemCount: courses.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: AppDimensions.spaceMD),
                              itemBuilder: (context, index) {
                                return CourseCard(course: courses[index]);
                              },
                            );
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

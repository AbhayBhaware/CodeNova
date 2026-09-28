import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../controllers/internships_controller.dart';
import '../widgets/internships_widgets.dart';

/// The primary Internships Listing screen for CodeNova Tech Solutions.
///
/// Features:
/// - Gradient apply banner with open position count and email/phone CTAs
/// - Real-time text search across title, domain, description, and skills
/// - Tech category filter chips and status filter chips
/// - Live result count with clear-filters shortcut
/// - Loading skeleton, empty state, and error retry state
/// - Reusable [InternshipCard] items with modal detail sheet
/// - Pull-to-refresh support
class InternshipsPage extends StatefulWidget {
  const InternshipsPage({
    super.key,
    this.controller,
  });

  /// Optional controller injection (for tests or custom DI).
  final InternshipsController? controller;

  @override
  State<InternshipsPage> createState() => _InternshipsPageState();
}

class _InternshipsPageState extends State<InternshipsPage> {
  late final InternshipsController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = InternshipsController();
      _ownsController = true;
      _controller.loadInternships();
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Internships'),
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => _controller.loadInternships(forceRefresh: true),
          color: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Apply Banner ────────────────────────────────────────
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return InternshipApplyBanner(
                    openCount: _controller.openCount,
                  );
                },
              ),

              // ── Search Bar ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMD,
                ),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return InternshipSearchBar(
                      initialValue: _controller.searchQuery,
                      onChanged: _controller.search,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spaceSM),

              // ── Category Filter ─────────────────────────────────────
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return InternshipFilterBar(
                    selectedCategory: _controller.selectedCategory,
                    onCategorySelected: _controller.setCategory,
                  );
                },
              ),
              const SizedBox(height: AppDimensions.spaceSM),

              // ── Result Count Bar ────────────────────────────────────
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
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                        if (hasFilters)
                          InkWell(
                            onTap: _controller.clearFilters,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusXS),
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

              // ── Content ─────────────────────────────────────────────
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    switch (_controller.status) {
                      case InternshipsStatus.initial:
                      case InternshipsStatus.loading:
                        return const InternshipLoadingSkeleton(itemCount: 3);

                      case InternshipsStatus.error:
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 400,
                            child: InternshipErrorState(
                              onRetry: _controller.retry,
                              errorMessage: _controller.errorMessage,
                            ),
                          ),
                        );

                      case InternshipsStatus.empty:
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 380,
                            child: InternshipEmptyState(
                              onResetFilters: _controller.clearFilters,
                              searchQuery: _controller.searchQuery,
                              category: _controller.selectedCategory,
                            ),
                          ),
                        );

                      case InternshipsStatus.success:
                        final internships = _controller.internships;

                        return ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceMD,
                            vertical: AppDimensions.spaceSM,
                          ),
                          itemCount: internships.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppDimensions.spaceMD),
                          itemBuilder: (context, index) {
                            return InternshipCard(
                              internship: internships[index],
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

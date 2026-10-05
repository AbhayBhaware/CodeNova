import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../controllers/services_controller.dart';
import '../widgets/services_widgets.dart';

/// The primary IT Services Listing screen for CodeNova Tech Solutions.
///
/// Features:
/// - Clean screen header with back-navigation support
/// - Promotional "Request a Quote" hero banner
/// - Multi-field search across titles, descriptions, and technology tags
/// - Horizontal category filter bar
/// - Decoupled state management via [ServicesController]
/// - Loading skeleton, empty state with filter reset, and error retry state
/// - Reusable, accessible [ServiceCard] widgets
/// - Pull-to-refresh support
class ServicesPage extends StatefulWidget {
  const ServicesPage({
    super.key,
    this.controller,
  });

  /// Optional controller injection (for tests or custom dependency injection).
  final ServicesController? controller;

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late final ServicesController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      if (_controller.status == ServicesStatus.initial) {
        _controller.loadServices();
      }
    } else {
      _controller = ServicesController();
      _ownsController = true;
      _controller.loadServices();
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
        title: const Text('IT Services & Solutions'),
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
          onRefresh: () => _controller.loadServices(forceRefresh: true),
          color: AppColors.primary,
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // ── Hero Promotional Quote Banner ─────────────────────
                  const SliverToBoxAdapter(
                    child: ServiceQuoteBanner(),
                  ),

                  // ── Search & Filter Controls ──────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
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
                            'Engineering high-impact web, mobile, AI, cloud, and security systems.',
                            style: tt.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceSM),
                          ServiceSearchBar(
                            initialValue: _controller.searchQuery,
                            onChanged: _controller.search,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Category Filter Bar ───────────────────────────────
                  SliverToBoxAdapter(
                    child: ServiceFilterBar(
                      selectedCategory: _controller.selectedCategory,
                      onCategorySelected: _controller.setCategory,
                    ),
                  ),

                  // ── Result Count & Reset Filters ──────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spaceMD,
                        vertical: AppDimensions.spaceSM,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _controller.status == ServicesStatus.loading
                                ? 'Loading services…'
                                : 'Showing ${_controller.filteredCount} of ${_controller.totalCount} services',
                            style: tt.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (_controller.hasActiveFilters)
                            TextButton.icon(
                              onPressed: _controller.clearFilters,
                              icon: const Icon(Icons.clear_all_rounded, size: 16),
                              label: const Text('Reset'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                minimumSize: const Size(60, 32),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // ── Body State Rendering ──────────────────────────────
                  _buildContentSliver(_controller),

                  // Bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppDimensions.spaceXXL),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContentSliver(ServicesController controller) {
    switch (controller.status) {
      case ServicesStatus.initial:
      case ServicesStatus.loading:
        return const SliverToBoxAdapter(
          child: ServicesLoadingSkeleton(),
        );

      case ServicesStatus.error:
        return SliverToBoxAdapter(
          child: ServicesErrorState(
            message: controller.errorMessage ?? 'An unexpected error occurred.',
            onRetry: controller.loadServices,
          ),
        );

      case ServicesStatus.empty:
        return SliverToBoxAdapter(
          child: ServicesEmptyState(
            searchQuery: controller.searchQuery,
            selectedCategory: controller.selectedCategory,
            onReset: controller.clearFilters,
          ),
        );

      case ServicesStatus.success:
        return SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMD,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final service = controller.services[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
                  child: ServiceCard(service: service),
                );
              },
              childCount: controller.filteredCount,
            ),
          ),
        );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../widgets/home_internship_section.dart';
import '../widgets/home_services_section.dart';

/// The main landing / home screen for CodeNova Tech Solutions.
///
/// Features a clean, uncluttered layout focused on:
/// 1. Internships – displaying 2 domain internships with a "View All" option.
/// 2. Services – displaying 2 IT services with a "View All" option.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _NotificationsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar Header ─────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            scrolledUnderElevation: 1,
            title: InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              onTap: () => context.go(AppStrings.routeAbout),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spaceXXS,
                  horizontal: AppDimensions.spaceXS,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand logo mark
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSM),
                      ),
                      child: const Center(
                        child: Text(
                          'CN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceSM + 2),
                    Flexible(
                      child: Text(
                        'CodeNova',
                        style: theme.textTheme.titleLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              // Notification Icon Placeholder with Unread Dot
              IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textSecondary,
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                tooltip: 'Notifications',
                onPressed: () => _showNotificationsSheet(context),
              ),

              // About CodeNova Quick Action
              IconButton(
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.textSecondary,
                ),
                tooltip: 'About CodeNova',
                onPressed: () => context.go(AppStrings.routeAbout),
              ),

              // Profile / Account Quick Action
              IconButton(
                icon: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.textSecondary,
                ),
                tooltip: 'Profile',
                onPressed: () => context.go(AppStrings.routeProfile),
              ),
              const SizedBox(width: AppDimensions.spaceXS),
            ],
          ),

          // ── Content Sections ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppDimensions.spaceMD,
                bottom: AppDimensions.space3XL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // 1. Internships Section (2 domain internships + View All)
                  HomeInternshipSection(),
                  SizedBox(height: AppDimensions.spaceXXL),

                  // 2. Services Section (2 services + View All)
                  HomeServicesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Notification bottom sheet placeholder.
class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceLG,
        AppDimensions.spaceMD,
        AppDimensions.spaceLG,
        AppDimensions.spaceXL,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
                decoration: BoxDecoration(
                  color: AppColors.neutral300,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.notifications_active_outlined,
                    color: AppColors.primary),
                const SizedBox(width: AppDimensions.spaceSM),
                Text('Notifications', style: tt.titleLarge),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school_rounded,
                    color: AppColors.primary, size: 20),
              ),
              title: Text(
                'Welcome to CodeNova Tech Solutions!',
                style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Explore upcoming 1-month IT training batches and internship slots in Pune.',
                style: tt.bodySmall,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: AppDimensions.buttonPadding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                ),
                child: const Text('Dismiss'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

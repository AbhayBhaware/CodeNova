import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../widgets/hero_section.dart';
import '../widgets/featured_courses_section.dart';
import '../widgets/why_choose_section.dart';
import '../widgets/cta_banner_section.dart';

/// The main landing / home screen.
///
/// Composed of stateless section widgets for easy rearrangement and
/// future individual feature toggling.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Row(
              children: [
                // Brand logo mark
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'CN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceSM),
                Flexible(
                  child: Text(
                    'CodeNova',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_outline_rounded,
                    color: AppColors.textSecondary),
                tooltip: 'Profile',
                onPressed: () => context.go(AppStrings.routeProfile),
              ),
              const SizedBox(width: AppDimensions.spaceSM),
            ],
          ),

          // ── Content Sections ───────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              children: [
                const HeroSection(),
                const SizedBox(height: AppDimensions.spaceXXL),
                const FeaturedCoursesSection(),
                const SizedBox(height: AppDimensions.spaceXXL),
                const WhyChooseSection(),
                const SizedBox(height: AppDimensions.spaceXXL),
                const CtaBannerSection(),
                const SizedBox(height: AppDimensions.spaceXL),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

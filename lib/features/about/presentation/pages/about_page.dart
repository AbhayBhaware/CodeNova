import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../widgets/about_widgets.dart';

/// Premium About Company screen for CodeNova Tech Solutions.
///
/// Features exclusively verified content from the official company website:
/// - Hero branding banner with verified tagline and Pune location
/// - Company overview narrative and 4 core values
/// - Mission & Vision statements
/// - 6 Core IT Enterprise Services
/// - Training and Internship focus with 3 core pillars
/// - Company contact details with direct phone, email, web actions, and enquiry CTA
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About CodeNova'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go(AppStrings.routeHome);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded),
            tooltip: 'Visit Official Website',
            onPressed: () => AppUtils.launchWebUrl(AppStrings.website),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero Banner ───────────────────────────────────
          const SliverToBoxAdapter(
            child: AboutHeroHeader(),
          ),

          // ── Section 1: About CodeNova & Core Values ───────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: AppDimensions.spaceXL),
              child: AboutStorySection(),
            ),
          ),

          // ── Section 2: Mission & Vision ───────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: AppDimensions.spaceXL),
              child: AboutMissionVisionSection(),
            ),
          ),

          // ── Section 3: Core IT Services ───────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: AppDimensions.spaceXL),
              child: AboutServicesSection(),
            ),
          ),

          // ── Section 4: Training Focus & Pillars ───────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: AppDimensions.spaceXL),
              child: AboutTrainingSection(),
            ),
          ),

          // ── Section 5: Company Details & Contact CTA ──────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: AppDimensions.spaceXL),
              child: AboutContactSection(),
            ),
          ),

          // ── Brand Footer ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spaceMD,
                AppDimensions.spaceXXL,
                AppDimensions.spaceMD,
                AppDimensions.space3XL,
              ),
              child: Column(
                children: [
                  const Divider(color: AppColors.neutral200),
                  const SizedBox(height: AppDimensions.spaceMD),
                  Text(
                    AppStrings.appName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontSize: AppTextSizes.sm,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXXS),
                  Text(
                    AppStrings.appTagline,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                      fontSize: AppTextSizes.xs,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceSM),
                  const Text(
                    '© 2026 CodeNova Tech Solutions. All rights reserved.',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/service_model.dart';
import '../widgets/quote_request_sheet.dart';

/// Full-screen premium Service Details screen for CodeNova Tech Solutions.
///
/// Features:
/// - Parallax hero SliverAppBar with domain iconography and category chip
/// - Quick info parameter strip (Domain, Delivery Model, Assurance)
/// - Comprehensive overview with verified company standards
/// - Key technical capabilities & features breakdown
/// - Tangible project deliverables list
/// - Technology stack & frameworks chips
/// - 4-step engineering delivery workflow
/// - Verified Pune office contact details
/// - Sticky CTA bar with phone consultation and "Request a Quote" modal
class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage({
    super.key,
    required this.service,
  });

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ── Scrollable Body ─────────────────────────────────────────
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Gradient Hero SliverAppBar ──────────────────────────
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.white),
                leading: Semantics(
                  label: 'Back to services',
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                actions: [
                  Semantics(
                    label: 'Share service details',
                    child: IconButton(
                      icon: const Icon(Icons.share_rounded, color: Colors.white),
                      tooltip: 'Share',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sharing ${service.title} details'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: _HeroHeader(service: service),
                ),
              ),

              // ── Content Area ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.spaceMD,
                    AppDimensions.spaceLG,
                    AppDimensions.spaceMD,
                    // Clear sticky CTA bar
                    AppDimensions.spaceXXL + AppDimensions.spaceXL + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Quick Info Strip ───────────────────────────
                      _QuickInfoStrip(service: service, isDark: isDark),
                      const SizedBox(height: AppDimensions.spaceXL),

                      // ── Overview Section ───────────────────────────
                      const SectionHeader(
                        title: 'Service Overview',
                        subtitle: 'Tailored technology solutions designed for scale.',
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      Text(
                        service.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                          height: 1.6,
                          fontSize: AppTextSizes.body,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // Company commitment note
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceMD),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.backgroundSurface
                              : AppColors.neutral100,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusMD),
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.neutral200,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppDimensions.spaceSM),
                            Expanded(
                              child: Text(
                                'All CodeNova services adhere to clean architecture patterns, modern DevOps pipelines, and standard NDA data protection.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXL),

                      // ── Technical Capabilities ─────────────────────
                      if (service.features.isNotEmpty) ...[
                        const SectionHeader(
                          title: 'Technical Capabilities',
                          subtitle: 'Core capabilities and engineering standards included in this service.',
                        ),
                        const SizedBox(height: AppDimensions.spaceMD),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: service.features.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppDimensions.spaceSM),
                          itemBuilder: (context, index) {
                            final feature = service.features[index];
                            return _FeatureItem(feature: feature, isDark: isDark);
                          },
                        ),
                        const SizedBox(height: AppDimensions.spaceXL),
                      ],

                      // ── Tangible Deliverables ──────────────────────
                      if (service.deliverables.isNotEmpty) ...[
                        const SectionHeader(
                          title: 'Project Deliverables',
                          subtitle: 'Verified outcomes delivered upon project completion.',
                        ),
                        const SizedBox(height: AppDimensions.spaceMD),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: service.deliverables.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppDimensions.spaceSM),
                          itemBuilder: (context, index) {
                            final deliverable = service.deliverables[index];
                            return _DeliverableItem(
                              deliverable: deliverable,
                              isDark: isDark,
                            );
                          },
                        ),
                        const SizedBox(height: AppDimensions.spaceXL),
                      ],

                      // ── Technology Stack ───────────────────────────
                      if (service.tags.isNotEmpty) ...[
                        const SectionHeader(
                          title: 'Technologies & Frameworks',
                          subtitle: 'Core tech stack utilized in this domain.',
                        ),
                        const SizedBox(height: AppDimensions.spaceMD),
                        Wrap(
                          spacing: AppDimensions.spaceSM,
                          runSpacing: AppDimensions.spaceSM,
                          children: service.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spaceMD,
                                vertical: AppDimensions.spaceSM,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.backgroundSurface
                                    : AppColors.neutral100,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMD,
                                ),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.neutral300,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.terminal_rounded,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    tag,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppTextSizes.sm,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppDimensions.spaceXL),
                      ],

                      // ── 4-Step Engineering Workflow ────────────────
                      const SectionHeader(
                        title: 'Our Engineering Process',
                        subtitle: 'Structured, milestone-driven delivery lifecycle.',
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      _WorkflowSection(isDark: isDark),
                      const SizedBox(height: AppDimensions.spaceXL),

                      // ── Verified Company Contact Card ─────────────
                      _CompanyInfoCard(isDark: isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Sticky Bottom CTA Bar ───────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _StickyCtaBar(service: service, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

// ── Hero Header ─────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceMD,
        80,
        AppDimensions.spaceMD,
        AppDimensions.spaceMD,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  service.icon,
                  color: Colors.white,
                  size: AppDimensions.iconLG,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMD),
              AppBadge(
                label: service.category.toUpperCase(),
                color: AppColors.accent,
                textColor: Colors.white,
                backgroundColor: AppColors.accent.withAlpha(50),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Text(
            service.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppTextSizes.heading,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Info Strip ────────────────────────────────────────────────────────
class _QuickInfoStrip extends StatelessWidget {
  const _QuickInfoStrip({
    required this.service,
    required this.isDark,
  });

  final ServiceModel service;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical: AppDimensions.spaceMD,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundSurface : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.neutral200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickInfoTile(
            icon: Icons.category_rounded,
            label: 'Domain',
            value: service.category,
            isDark: isDark,
          ),
          _divider(),
          _QuickInfoTile(
            icon: Icons.speed_rounded,
            label: 'Delivery Model',
            value: 'Agile Sprints',
            isDark: isDark,
          ),
          _divider(),
          _QuickInfoTile(
            icon: Icons.shield_rounded,
            label: 'Assurance',
            value: 'NDA & SLA',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      color: isDark ? AppColors.borderDark : AppColors.neutral200,
    );
  }
}

class _QuickInfoTile extends StatelessWidget {
  const _QuickInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTextSizes.xs,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: AppTextSizes.sm,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Feature Item Card ───────────────────────────────────────────────────────
class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.feature,
    required this.isDark,
  });

  final String feature;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundSurface : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.neutral200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: AppTextSizes.body,
                height: 1.4,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Deliverable Item Card ───────────────────────────────────────────────────
class _DeliverableItem extends StatelessWidget {
  const _DeliverableItem({
    required this.deliverable,
    required this.isDark,
  });

  final String deliverable;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundSurface : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.neutral200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Text(
              deliverable,
              style: TextStyle(
                fontSize: AppTextSizes.body,
                height: 1.4,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Engineering Process ─────────────────────────────────────────────────────
class _WorkflowSection extends StatelessWidget {
  const _WorkflowSection({required this.isDark});

  final bool isDark;

  static const List<Map<String, String>> _steps = [
    {
      'step': '01',
      'title': 'Discovery & Technical Scoping',
      'desc': 'Detailed requirements elicitation, system architecture design, and timeline scoping.',
    },
    {
      'step': '02',
      'title': 'UI/UX Prototyping & Sprint Plan',
      'desc': 'Interactive wireframes, data model validation, and iterative milestone scheduling.',
    },
    {
      'step': '03',
      'title': 'Iterative Engineering & QA',
      'desc': 'Test-driven development, peer code reviews, continuous integration, and security checks.',
    },
    {
      'step': '04',
      'title': 'Production Deployment & SLA',
      'desc': 'Zero-downtime release, client verification sign-off, and ongoing support warranty.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _steps.map((step) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.spaceSM),
          padding: const EdgeInsets.all(AppDimensions.spaceMD),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundSurface : AppColors.cardLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.neutral200,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                child: Text(
                  step['step']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppTextSizes.body,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step['desc']!,
                      style: const TextStyle(
                        fontSize: AppTextSizes.sm,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Company Info Card ───────────────────────────────────────────────────────
class _CompanyInfoCard extends StatelessWidget {
  const _CompanyInfoCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundSurface : AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.neutral200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: AppDimensions.spaceSM),
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: AppTextSizes.bodyLg,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          const Text(
            'Official Tech Solutions Desk · Pune, Maharashtra, India',
            style: TextStyle(
              fontSize: AppTextSizes.sm,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          InkWell(
            onTap: () => AppUtils.launchPhone(AppStrings.phoneDialable),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.phone_rounded, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppStrings.phone,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => AppUtils.launchEmail(AppStrings.email),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.email_rounded, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppStrings.email,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
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

// ── Sticky CTA Bar ──────────────────────────────────────────────────────────
class _StickyCtaBar extends StatelessWidget {
  const _StickyCtaBar({
    required this.service,
    required this.isDark,
  });

  final ServiceModel service;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical: AppDimensions.spaceSM + 2,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundCard : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.neutral200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 30),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Quick Direct Call Button (WCAG 48dp target)
            Semantics(
              label: 'Call Pune consultation desk',
              button: true,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundSurface : AppColors.neutral100,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.neutral300,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => AppUtils.launchPhone(AppStrings.phoneDialable),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    child: const Icon(
                      Icons.phone_in_talk_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMD),

            // Primary "Request a Quote" CTA Button
            Expanded(
              child: AppGradientButton(
                label: 'Request a Quote',
                icon: Icons.request_quote_rounded,
                onPressed: () => QuoteRequestSheet.show(context, service: service),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

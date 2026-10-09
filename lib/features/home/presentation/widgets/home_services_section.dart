import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/models.dart';

/// Services Section on [HomePage].
///
/// Displays 2 highlighted IT services with a prominent "View All" option
/// beneath navigating directly to the full [ServicesPage].
class HomeServicesSection extends StatelessWidget {
  const HomeServicesSection({
    super.key,
    this.services,
  });

  /// Optional services list override (e.g. for testing). Defaults to [MockData.services].
  final List<ServiceModel>? services;

  @override
  Widget build(BuildContext context) {
    final list = (services ?? MockData.services).take(2).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ───────────────────────────────────
          SectionHeader(
            title: AppStrings.servicesSectionTitle,
            subtitle: AppStrings.servicesSectionSubtitle,
            action: TextButton.icon(
              onPressed: () => context.go(AppStrings.routeServices),
              icon: const Text('View All'),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── 2 Services Displayed ─────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: list.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimensions.spaceMD),
            itemBuilder: (context, index) {
              return _ServiceCard(service: list[index]);
            },
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Under It: View All Option ────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go(AppStrings.routeServices),
              icon: const Icon(Icons.business_center_outlined, size: 18),
              label: const Text('View All Services'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spaceSM + 4,
                  horizontal: AppDimensions.spaceMD,
                ),
                side: const BorderSide(color: AppColors.primary, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable service card component.
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppCard(
      onTap: () {
        try {
          context.push(
            AppStrings.routeServiceDetail.replaceFirst(':id', service.id),
            extra: service,
          );
        } catch (_) {
          context.go(AppStrings.routeServices);
        }
      },
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container with Brand Gradient
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              service.icon,
              color: Colors.white,
              size: AppDimensions.iconMD,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: AppTextSizes.bodyLg,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXXS + 1),
                Text(
                  service.description,
                  style: tt.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                Wrap(
                  spacing: AppDimensions.spaceXS,
                  runSpacing: AppDimensions.spaceXS,
                  children: service.tags
                      .map((t) => AppBadge(label: t, color: AppColors.neutral600))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/models.dart';

/// IT Services Section on [HomePage].
///
/// Displays company IT services using reusable modern cards.
class HomeServicesSection extends StatelessWidget {
  const HomeServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final services = MockData.services;

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
              icon: const Text('All Services'),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Reusable Service Cards Grid / List ────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length > 4 ? 4 : services.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimensions.spaceMD),
            itemBuilder: (context, index) {
              return _ServiceCard(service: services[index]);
            },
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // View All Services Button
          Center(
            child: OutlinedButton.icon(
              onPressed: () => context.go(AppStrings.routeServices),
              icon: const Icon(Icons.business_center_outlined, size: 16),
              label: const Text('View All IT Services'),
              style: OutlinedButton.styleFrom(
                padding: AppDimensions.buttonPadding,
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
          // Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: Icon(
              service.icon,
              color: AppColors.primary,
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
                    fontWeight: FontWeight.w600,
                    fontSize: AppTextSizes.bodyLg,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXXS),
                Text(
                  service.description,
                  style: tt.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
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

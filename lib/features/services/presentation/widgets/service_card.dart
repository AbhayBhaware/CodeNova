import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/service_model.dart';
import '../pages/service_detail_page.dart';

/// Reusable card displaying an IT Service offered by CodeNova Tech Solutions.
///
/// Features:
/// - Branded domain icon container with gradient background
/// - Verified category badge
/// - Service title & concise description
/// - Technology / skill tags wrap
/// - Accessible "View Details" button with minimum 48dp touch target
/// - Fallback navigation support for isolated widget testing environments
class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
    this.onViewDetails,
  });

  final ServiceModel service;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;

  void _handleNavigation(BuildContext context) {
    if (onViewDetails != null) {
      onViewDetails!();
      return;
    }
    if (onTap != null) {
      onTap!();
      return;
    }

    try {
      context.push(
        AppStrings.routeServiceDetail.replaceFirst(':id', service.id),
        extra: service,
      );
    } catch (_) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ServiceDetailPage(service: service),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      label: '${service.title}, category: ${service.category}',
      button: true,
      child: AppCard(
        onTap: () => _handleNavigation(context),
        padding: const EdgeInsets.all(AppDimensions.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row: Domain Icon & Category Badge ─────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Branded Icon Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(isDark ? 50 : 35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
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
                // Category Chip Badge
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AppBadge(
                      label: service.category,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // ── Service Headline Title ───────────────────────────
            Text(
              service.title,
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: AppTextSizes.subtitle,
                letterSpacing: -0.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spaceXS + 2),

            // ── Short Description ────────────────────────────────
            Text(
              service.description,
              style: tt.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // ── Technology / Skill Tags ──────────────────────────
            if (service.tags.isNotEmpty) ...[
              Wrap(
                spacing: AppDimensions.spaceXS + 2,
                runSpacing: AppDimensions.spaceXS,
                children: service.tags.take(4).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceSM,
                      vertical: AppDimensions.spaceXXS + 1,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.backgroundSurface
                          : AppColors.neutral100,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSM),
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.neutral200,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: tt.bodySmall?.copyWith(
                        fontSize: AppTextSizes.xs,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.spaceMD),
            ],

            // ── Divider ──────────────────────────────────────────
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? AppColors.borderDark : AppColors.neutral200,
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // ── Footer: Action Button ────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${service.features.length} Key Capabilities',
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _handleNavigation(context),
                  icon: Text(
                    'View Details',
                    style: AppTypography.button(
                      color: AppColors.primary,
                    ).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: AppTextSizes.body,
                    ),
                  ),
                  label: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(120, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceMD,
                      vertical: AppDimensions.spaceSM,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

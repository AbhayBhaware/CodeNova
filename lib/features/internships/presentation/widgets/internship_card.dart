import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../models/internship_model.dart';
import '../pages/internship_detail_page.dart';

/// Reusable internship card for the CodeNova internship catalog.
///
/// Displays verified internship details with:
/// - Domain icon with brand gradient
/// - Title, domain, and status badge
/// - Verified duration, optional mode
/// - Tech category chip + skill badges
/// - Description (2-line clamped)
/// - "View Details" CTA button (opens full InternshipDetailPage)
class InternshipCard extends StatelessWidget {
  const InternshipCard({
    super.key,
    required this.internship,
    this.onViewDetails,
  });

  final InternshipModel internship;
  final VoidCallback? onViewDetails;

  void _handleViewDetails(BuildContext context) {
    if (onViewDetails != null) {
      onViewDetails!();
    } else {
      try {
        context.push(
          AppStrings.routeInternshipDetail.replaceFirst(':id', internship.id),
          extra: internship,
        );
      } catch (_) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => InternshipDetailPage(internship: internship),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final status = internship.status;

    return Semantics(
      label:
          '${internship.title}, ${internship.domain}, ${status.label}, ${internship.duration}',
      child: AppCard(
        onTap: () => _handleViewDetails(context),
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row: Icon + Title + Status Badge ────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Domain Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(40),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    internship.icon,
                    color: Colors.white,
                    size: AppDimensions.iconMD,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMD),

                // Title + Domain
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        internship.title,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: AppTextSizes.bodyLg,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.spaceXXS + 1),
                      Text(
                        internship.domain,
                        style: tt.bodySmall?.copyWith(
                          color:
                              isDark ? AppColors.accent : AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: AppTextSizes.xs + 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Status Badge
                const SizedBox(width: AppDimensions.spaceSM),
                _StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // ── Metadata: Duration + Mode + Category ─────────────
            Wrap(
              spacing: AppDimensions.spaceXS,
              runSpacing: AppDimensions.spaceXS,
              children: [
                // Verified Duration
                _MetaBadge(
                  icon: Icons.access_time_rounded,
                  label: internship.duration,
                  color: AppColors.accent,
                ),
                // Work mode (only if set)
                if (internship.mode != null)
                  _MetaBadge(
                    icon: internship.mode!.icon,
                    label: internship.mode!.label,
                    color: AppColors.secondary,
                  ),
                // Tech Category
                AppBadge(
                  label: internship.techCategory,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // ── Description ───────────────────────────────────────
            Text(
              internship.description,
              style: tt.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // ── Skill Tags ─────────────────────────────────────────
            Wrap(
              spacing: AppDimensions.spaceXS,
              runSpacing: AppDimensions.spaceXS,
              children: internship.skills
                  .map(
                    (s) => AppBadge(
                      label: s,
                      color: AppColors.neutral600,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // ── CTA Button ─────────────────────────────────────────
            AppButton.outline(
              label: 'View Details',
              icon: Icons.info_outline_rounded,
              isFullWidth: true,
              height: 44,
              onPressed: () => _handleViewDetails(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status Badge ─────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final InternshipStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSM,
        vertical: AppDimensions.spaceXXS + 1,
      ),
      decoration: BoxDecoration(
        color: status.color.withAlpha(22),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        border: Border.all(color: status.color.withAlpha(70)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: AppTextSizes.xs,
              fontWeight: FontWeight.w700,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Meta Badge ────────────────────────────────────────────────────────────────
class _MetaBadge extends StatelessWidget {
  const _MetaBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceXS + 2,
        vertical: AppDimensions.spaceXXS,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── INTERNSHIP DETAIL BOTTOM SHEET ───────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════

/// Verified highlights shown in the detail sheet for all programmes.
const _sharedHighlights = [
  _Highlight(Icons.person_rounded, 'Expert Mentors',
      'Guided by industry professionals with real-world project experience.'),
  _Highlight(Icons.build_rounded, 'Hands-on Projects',
      'Work on live codebases — real deliverables for your portfolio.'),
  _Highlight(Icons.verified_rounded, 'Completion Certificate',
      'Receive a verifiable certificate from CodeNova Tech Solutions.'),
];

class _Highlight {
  const _Highlight(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

/// Modal bottom sheet with full internship details and apply CTA.
class InternshipDetailSheet extends StatelessWidget {
  const InternshipDetailSheet({super.key, required this.internship});

  final InternshipModel internship;

  static Future<void> show(
    BuildContext context, {
    required InternshipModel internship,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => InternshipDetailSheet(internship: internship),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor =
        isDark ? AppColors.backgroundCard : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final internship = this.internship;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Material(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXL),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Drag Handle
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppDimensions.spaceMD),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.neutral300,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusCircle),
                    ),
                  ),
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.spaceLG,
                    0,
                    AppDimensions.spaceLG,
                    AppDimensions.spaceLG,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ─────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: AppColors.brandGradient,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMD),
                            ),
                            child: Icon(internship.icon,
                                color: Colors.white,
                                size: AppDimensions.iconMD),
                          ),
                          const SizedBox(width: AppDimensions.spaceMD),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  internship.title,
                                  style: tt.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  internship.domain,
                                  style: tt.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.accent
                                        : AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            tooltip: 'Close',
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // ── Status + Duration + Mode ────────────────
                      Wrap(
                        spacing: AppDimensions.spaceSM,
                        runSpacing: AppDimensions.spaceXS,
                        children: [
                          _StatusBadge(status: internship.status),
                          _MetaBadge(
                            icon: Icons.access_time_rounded,
                            label: 'Duration: ${internship.duration}',
                            color: AppColors.accent,
                          ),
                          if (internship.mode != null)
                            _MetaBadge(
                              icon: internship.mode!.icon,
                              label: internship.mode!.label,
                              color: AppColors.secondary,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // ── Description ─────────────────────────────
                      Text(
                        'About This Programme',
                        style:
                            tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        internship.description,
                        style: tt.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // ── Skills ──────────────────────────────────
                      Text(
                        'Technologies & Skills',
                        style:
                            tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Wrap(
                        spacing: AppDimensions.spaceXS,
                        runSpacing: AppDimensions.spaceXS,
                        children: internship.skills
                            .map((s) => AppBadge(
                                label: s, color: AppColors.primary))
                            .toList(),
                      ),
                      const SizedBox(height: AppDimensions.spaceLG),

                      // ── Highlights ──────────────────────────────
                      Text(
                        'What You Get',
                        style:
                            tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.backgroundSurface
                              : AppColors.neutral50,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusMD),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: _sharedHighlights
                              .asMap()
                              .entries
                              .map((entry) {
                            final isLast =
                                entry.key == _sharedHighlights.length - 1;
                            final h = entry.value;
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(
                                      AppDimensions.spaceMD),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.primary.withAlpha(isDark ? 45 : 18),
                                          borderRadius: BorderRadius.circular(
                                              AppDimensions.radiusSM),
                                        ),
                                        child: Icon(h.icon,
                                            size: AppDimensions.iconSM + 2,
                                            color: isDark
                                                ? AppColors.accent
                                                : AppColors.primary),
                                      ),
                                      const SizedBox(width: AppDimensions.spaceSM),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(h.title,
                                                style: tt.labelLarge?.copyWith(
                                                    fontSize: AppTextSizes.body)),
                                            const SizedBox(height: 2),
                                            Text(h.description,
                                                style: tt.bodySmall?.copyWith(
                                                  color: isDark
                                                      ? AppColors
                                                          .textSecondaryDark
                                                      : AppColors.textSecondary,
                                                  height: 1.4,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isLast)
                                  Divider(
                                    height: 1,
                                    indent: AppDimensions.spaceMD,
                                    endIndent: AppDimensions.spaceMD,
                                    color: borderColor,
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceLG),

                      // ── Action Buttons ──────────────────────────
                      if (internship.status == InternshipStatus.open) ...[
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: 'Apply via Email',
                                icon: Icons.email_rounded,
                                isFullWidth: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                  AppUtils.launchEmail(
                                    AppStrings.email,
                                    subject:
                                        'Internship Application – ${internship.title}',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spaceMD),
                            AppButton.outline(
                              label: 'Call',
                              icon: Icons.phone_rounded,
                              onPressed: () {
                                Navigator.pop(context);
                                AppUtils.launchPhone(
                                    AppStrings.phoneDialable);
                              },
                            ),
                          ],
                        ),
                      ] else ...[
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(AppDimensions.spaceMD),
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusMD),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                internship.status ==
                                        InternshipStatus.comingSoon
                                    ? Icons.schedule_rounded
                                    : Icons.info_outline_rounded,
                                color: internship.status.color,
                                size: AppDimensions.iconMD,
                              ),
                              const SizedBox(width: AppDimensions.spaceSM),
                              Expanded(
                                child: Text(
                                  internship.status ==
                                          InternshipStatus.comingSoon
                                      ? 'This position will open soon. Contact us to express interest.'
                                      : 'Applications for this position are currently closed.',
                                  style: tt.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

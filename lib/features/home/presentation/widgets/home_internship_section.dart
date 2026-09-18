import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Internship Highlights Section on [HomePage].
///
/// Highlights the 3–6 month internship program verified from the official
/// company website with mentor guidance, live client projects, and verified certificates.
class HomeInternshipSection extends StatelessWidget {
  const HomeInternshipSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ───────────────────────────────────
          const SectionHeader(
            title: AppStrings.internshipSectionTitle,
            subtitle: AppStrings.internshipSectionSubtitle,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Main Feature Card ────────────────────────────────
          AppCard(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            borderColor: AppColors.neutral200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag + Duration (Wrap for responsive support)
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppDimensions.spaceSM,
                  runSpacing: AppDimensions.spaceXS,
                  children: [
                    const AppBadge(
                      label: '💼 Live Client Projects',
                      color: AppColors.primary,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: AppDimensions.spaceXXS),
                        Text(
                          '3 – 6 Months',
                          style: tt.bodySmall?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMD),

                // Title
                Text(
                  'Software Engineering & IT Internship',
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: AppTextSizes.title,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXS + 2),

                // Description from website
                Text(
                  'Get real-world experience working on live projects with guidance '
                  'from industry mentors. Build portfolio-grade applications and '
                  'earn a verified, industry-recognized certificate.',
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLG),

                // Highlight Pillars
                const _InternshipPillars(),
                const SizedBox(height: AppDimensions.spaceLG),

                // Explore Internships CTA Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go(AppStrings.routeInternships),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: AppDimensions.buttonPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMD),
                      ),
                    ),
                    icon: const Icon(Icons.work_outline_rounded, size: 18),
                    label: const Text('Explore Internships'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InternshipPillars extends StatelessWidget {
  const _InternshipPillars();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _PillarRow(
          icon: Icons.check_circle_outline_rounded,
          title: 'Live Project Experience',
          subtitle: 'Work on actual software codebases alongside senior developers.',
        ),
        SizedBox(height: AppDimensions.spaceSM),
        _PillarRow(
          icon: Icons.supervisor_account_rounded,
          title: 'One-on-One Mentorship',
          subtitle: 'Regular code reviews, technical guidance, and feedback.',
        ),
        SizedBox(height: AppDimensions.spaceSM),
        _PillarRow(
          icon: Icons.verified_user_outlined,
          title: 'Verified Certificate',
          subtitle: 'Digital verifiable certificate recognized by industry partners.',
        ),
      ],
    );
  }
}

class _PillarRow extends StatelessWidget {
  const _PillarRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: AppDimensions.spaceSM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: AppTextSizes.body,
                ),
              ),
              Text(
                subtitle,
                style: tt.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: AppTextSizes.xs + 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

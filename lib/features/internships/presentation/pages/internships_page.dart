import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../models/models.dart';

/// Internships listing page – open and closed opportunities.
class InternshipsPage extends StatelessWidget {
  const InternshipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final openInternships =
        MockData.internships.where((i) => i.isOpen).toList();
    final closedInternships =
        MockData.internships.where((i) => !i.isOpen).toList();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navInternships)),
      body: ListView(
        padding: AppDimensions.screenPadding,
        children: [
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Header ─────────────────────────────────────────
          const SectionHeader(
            title: 'Internship Programmes',
            subtitle:
                'Gain real-world experience and a certificate under expert mentorship.',
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // ── Apply CTA ──────────────────────────────────────
          AppCard(
            gradient: AppColors.brandGradient,
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ready to apply?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextSizes.subtitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                const Text(
                  'Contact us directly to submit your application or enquire about available slots.',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: AppTextSizes.body),
                ),
                const SizedBox(height: AppDimensions.spaceMD),
                OutlinedButton.icon(
                  icon: const Icon(Icons.phone_rounded,
                      size: 16, color: Colors.white),
                  label: Text(
                    AppStrings.phone,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () =>
                      AppUtils.launchPhone(AppStrings.phoneDialable),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          // ── Open Positions ─────────────────────────────────
          if (openInternships.isNotEmpty) ...[
            Row(
              children: [
                const AppBadge(label: 'Now Hiring', color: AppColors.success),
                const SizedBox(width: AppDimensions.spaceSM),
                Text(
                  '${openInternships.length} open position${openInternships.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppTextSizes.sm,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            ...openInternships.map(
              (i) => Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.spaceMD),
                child: _InternshipCard(internship: i),
              ),
            ),
          ],

          // ── Closed Positions ───────────────────────────────
          if (closedInternships.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spaceMD),
            const Text(
              'Closed Positions',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: AppTextSizes.sm,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            ...closedInternships.map(
              (i) => Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.spaceMD),
                child: _InternshipCard(internship: i),
              ),
            ),
          ],

          const SizedBox(height: AppDimensions.spaceXL),
        ],
      ),
    );
  }
}

class _InternshipCard extends StatelessWidget {
  const _InternshipCard({required this.internship});

  final InternshipModel internship;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppCard.glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(internship.title, style: tt.titleLarge),
              ),
              AppBadge(
                label: internship.isOpen ? 'Open' : 'Closed',
                color: internship.isOpen
                    ? AppColors.success
                    : AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            internship.domain,
            style: tt.bodySmall?.copyWith(color: AppColors.accent),
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Text(internship.description, style: tt.bodyMedium),
          const SizedBox(height: AppDimensions.spaceMD),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 14, color: AppColors.textMuted),
              const SizedBox(width: AppDimensions.spaceXS),
              Text(internship.duration, style: tt.bodySmall),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Wrap(
            spacing: AppDimensions.spaceXS,
            runSpacing: AppDimensions.spaceXS,
            children: internship.skills
                .map((s) => AppBadge(label: s, color: AppColors.primary))
                .toList(),
          ),
        ],
      ),
    );
  }
}

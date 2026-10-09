import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/models.dart';
import '../../../internships/presentation/widgets/internship_card.dart';

/// Internships Section on [HomePage].
///
/// Displays 2 highlighted internships across verified domains,
/// with a prominent "View All" option beneath navigating to the full [InternshipsPage].
class HomeInternshipSection extends StatelessWidget {
  const HomeInternshipSection({
    super.key,
    this.internships,
  });

  /// Optional internships list override (e.g. for testing). Defaults to [MockData.internships].
  final List<InternshipModel>? internships;

  @override
  Widget build(BuildContext context) {
    final list = (internships ?? MockData.internships).take(2).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ───────────────────────────────────
          SectionHeader(
            title: AppStrings.internshipSectionTitle,
            subtitle: AppStrings.internshipSectionSubtitle,
            action: TextButton.icon(
              onPressed: () => context.go(AppStrings.routeInternships),
              icon: const Text('View All'),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── 2 Internships Displayed ──────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: list.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimensions.spaceMD),
            itemBuilder: (context, index) {
              return InternshipCard(internship: list[index]);
            },
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Under It: View All Option ────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go(AppStrings.routeInternships),
              icon: const Icon(Icons.work_outline_rounded, size: 18),
              label: const Text('View All Internships'),
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


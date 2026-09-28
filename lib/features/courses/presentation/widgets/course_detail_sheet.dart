import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../models/course_model.dart';

/// Modal bottom sheet displaying verified course information, learning scope, and enquiry actions.
class CourseDetailSheet extends StatelessWidget {
  const CourseDetailSheet({
    super.key,
    required this.course,
  });

  final CourseModel course;

  /// Convenience launcher for this modal sheet.
  static Future<void> show(BuildContext context, {required CourseModel course}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CourseDetailSheet(course: course),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Material(
      color: theme.cardColor,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusXL),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppDimensions.spaceLG,
            right: AppDimensions.spaceLG,
            top: AppDimensions.spaceMD,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.spaceLG,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag Handle ───────────────────────────────────────
              Center(
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
              const SizedBox(height: AppDimensions.spaceMD),

              // ── Header: Category Icon, Title, Close Button ────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMD),
                    ),
                    child: Icon(
                      course.icon,
                      color: Colors.white,
                      size: AppDimensions.iconMD,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: tt.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          course.category,
                          style: tt.bodySmall?.copyWith(
                            color: AppColors.primary,
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

              // ── Verified Duration & Level Badges ──────────────────
              Wrap(
                spacing: AppDimensions.spaceSM,
                runSpacing: AppDimensions.spaceXS,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceSM,
                      vertical: AppDimensions.spaceXXS + 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(25),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSM),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Duration: ${course.duration}',
                          style: const TextStyle(
                            fontSize: AppTextSizes.xs,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppBadge(
                    label: 'Level: ${course.level.label}',
                    color: AppColors.primary,
                  ),
                  const AppBadge(
                    label: 'Hands-on Projects',
                    color: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMD),

              // ── Overview ──────────────────────────────────────────
              Text(
                'Programme Overview',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppDimensions.spaceXS),
              Text(
                course.description,
                style: tt.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMD),

              // ── Technology Stack / Curriculum Topics ──────────────
              Text(
                'Core Technologies & Topics',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppDimensions.spaceXS),
              Wrap(
                spacing: AppDimensions.spaceXS,
                runSpacing: AppDimensions.spaceXS,
                children: course.tags
                    .map(
                      (t) => AppBadge(
                        label: t,
                        color: AppColors.primary,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppDimensions.spaceLG),

              // ── Verified Highlights ───────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceMD),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  border: Border.all(
                    color: AppColors.primary.withAlpha(35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppDimensions.spaceMD),
                    Expanded(
                      child: Text(
                        'Mentored training with real-world practical code and verifiable completion certificate.',
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLG),

              // ── Action Buttons ────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Enquire for Batch',
                      icon: Icons.chat_bubble_outline_rounded,
                      isFullWidth: true,
                      onPressed: () {
                        Navigator.pop(context);
                        AppUtils.launchEmail(
                          AppStrings.email,
                          subject: 'Enquiry for ${course.title} Course',
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceMD),
                  AppButton.outline(
                    label: 'Call Us',
                    icon: Icons.phone_rounded,
                    onPressed: () {
                      Navigator.pop(context);
                      AppUtils.launchPhone(AppStrings.phoneDialable);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

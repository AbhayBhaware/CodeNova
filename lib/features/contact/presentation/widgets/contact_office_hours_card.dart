import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Card showing verified office hours, response SLA, and Pune operational details.
class ContactOfficeHoursCard extends StatelessWidget {
  const ContactOfficeHoursCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tt = theme.textTheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSM),
              Expanded(
                child: Text(
                  'Consultation Hours & Availability',
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceSM,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                  border: Border.all(color: AppColors.success.withAlpha(60)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'PUNE DESK',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          _HourRow(
            label: 'Working Days',
            value: 'Monday – Saturday',
            isDark: isDark,
          ),
          const SizedBox(height: 6),
          _HourRow(
            label: 'Office Hours',
            value: '9:30 AM – 6:30 PM IST',
            isDark: isDark,
          ),
          const SizedBox(height: 6),
          _HourRow(
            label: 'Sunday',
            value: 'Closed (Online enquiries open)',
            isDark: isDark,
            isDimmed: true,
          ),
          const SizedBox(height: 6),
          _HourRow(
            label: 'Enquiry SLA',
            value: 'Response within ${AppStrings.responseSLA}',
            isDark: isDark,
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _HourRow extends StatelessWidget {
  const _HourRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.isDimmed = false,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool isDark;
  final bool isDimmed;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppTextSizes.sm,
              color: isDimmed ? AppColors.textSecondary.withAlpha(160) : AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSM),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: AppTextSizes.sm,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
              color: highlight
                  ? AppColors.primary
                  : isDimmed
                      ? AppColors.textSecondary
                      : isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Administrative view for reviewing enterprise quote requests and business inquiries.
class AdminQuotesView extends StatelessWidget {
  const AdminQuotesView({
    super.key,
    required this.controller,
  });

  final AdminDashboardController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enterprise Quotes & Business Inquiries',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Triage incoming B2B software engineering requests and client inquiries.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Section 1: Enterprise Quotes
          Text(
            'Enterprise Project Quotes (${controller.quotes.length})',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          if (controller.quotes.isEmpty)
            const Text('No quote requests currently received.')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.quotes.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spaceMD),
              itemBuilder: (context, index) {
                final quote = controller.quotes[index];

                return AppCard(
                  padding: const EdgeInsets.all(AppDimensions.spaceMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quote.companyName ?? quote.fullName,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Contact: ${quote.fullName} (${quote.email})',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (quote.budgetRange != null)
                            Chip(
                              label: Text(quote.budgetRange!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              backgroundColor: AppColors.success.withValues(alpha: 0.12),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            label: Text(quote.projectType, style: const TextStyle(fontSize: 11)),
                            avatar: const Icon(Icons.category_rounded, size: 12),
                          ),
                          Chip(
                            label: Text('Via: ${quote.preferredContactMethod}', style: const TextStyle(fontSize: 11)),
                            avatar: const Icon(Icons.contact_mail_outlined, size: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimensions.spaceMD),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.backgroundCard : AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                        ),
                        child: Text(
                          quote.projectDescription,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          const SizedBox(height: AppDimensions.spaceXL),

          // Section 2: General Enquiries
          Text(
            'General Inquiries (${controller.enquiries.length})',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          if (controller.enquiries.isEmpty)
            const Text('No general inquiries.')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.enquiries.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spaceMD),
              itemBuilder: (context, index) {
                final enquiry = controller.enquiries[index];

                return AppCard(
                  padding: const EdgeInsets.all(AppDimensions.spaceMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            enquiry.fullName,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${enquiry.email} · ${enquiry.phone ?? "No phone"}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Category: ${enquiry.category}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      Text(enquiry.message),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

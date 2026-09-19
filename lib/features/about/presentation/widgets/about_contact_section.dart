import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/app_utils.dart';

/// Contact and Company Details section with interactive CTAs.
class AboutContactSection extends StatelessWidget {
  const AboutContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Connect With Us',
            subtitle:
                'Reach out for training, internships, or digital solutions',
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Company Details Card
          AppCard(
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            child: Column(
              children: [
                _ContactRow(
                  icon: Icons.location_on_rounded,
                  label: 'Location',
                  value: AppStrings.address,
                  iconColor: AppColors.primary,
                ),
                const Divider(height: AppDimensions.spaceLG),
                _ContactRow(
                  icon: Icons.phone_rounded,
                  label: 'Phone Support',
                  value: AppStrings.phone,
                  iconColor: AppColors.success,
                  onTap: () =>
                      AppUtils.launchPhone(AppStrings.phoneDialable),
                  actionHint: 'Tap to Call',
                ),
                const Divider(height: AppDimensions.spaceLG),
                _ContactRow(
                  icon: Icons.email_rounded,
                  label: 'Email Enquiries',
                  value: AppStrings.email,
                  iconColor: AppColors.accent,
                  onTap: () => AppUtils.launchEmail(
                    AppStrings.email,
                    subject: 'Enquiry for CodeNova Tech Solutions',
                  ),
                  actionHint: 'Tap to Email',
                ),
                const Divider(height: AppDimensions.spaceLG),
                _ContactRow(
                  icon: Icons.language_rounded,
                  label: 'Official Website',
                  value: AppStrings.website,
                  iconColor: AppColors.primary,
                  onTap: () => AppUtils.launchWebUrl(AppStrings.website),
                  actionHint: 'Tap to Open',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Contact CTA Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(60),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceSM,
                    vertical: AppDimensions.spaceXXS,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusCircle),
                  ),
                  child: const Text(
                    'GET IN TOUCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppTextSizes.xs,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMD),
                Text(
                  'Ready to accelerate your tech journey?',
                  style: tt.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                Text(
                  'Connect with our team in Pune for personalized guidance on courses, '
                  'internships, or bespoke software engineering services.',
                  style: tt.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(220),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLG),
                AppButton(
                  label: 'Enquire Now',
                  icon: Icons.chat_bubble_outline_rounded,
                  isFullWidth: true,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  onPressed: () => _showEnquiryModal(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEnquiryModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Material(
        color: Theme.of(ctx).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceLG),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceSM),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSM),
                      ),
                      child: const Icon(
                        Icons.contact_support_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact CodeNova',
                            style:
                                Theme.of(ctx).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                          Text(
                            'Select your preferred channel',
                            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceLG),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceSM),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(20),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSM),
                    ),
                    child: const Icon(Icons.phone_rounded,
                        color: AppColors.success),
                  ),
                  title: const Text('Call Us Directly',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text(AppStrings.phone),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(ctx);
                    AppUtils.launchPhone(AppStrings.phoneDialable);
                  },
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceSM),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(20),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSM),
                    ),
                    child: const Icon(Icons.email_outlined,
                        color: AppColors.accent),
                  ),
                  title: const Text('Send an Email',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text(AppStrings.email),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(ctx);
                    AppUtils.launchEmail(AppStrings.email,
                        subject: 'General Enquiry');
                  },
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceSM),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSM),
                    ),
                    child: const Icon(Icons.language_rounded,
                        color: AppColors.primary),
                  ),
                  title: const Text('Visit Official Website',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text(AppStrings.website),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(ctx);
                    AppUtils.launchWebUrl(AppStrings.website);
                  },
                ),
                const SizedBox(height: AppDimensions.spaceMD),
                AppButton.outline(
                  label: 'Cancel',
                  isFullWidth: true,
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.onTap,
    this.actionHint,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final VoidCallback? onTap;
  final String? actionHint;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceSM),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(20),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: AppDimensions.spaceMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: AppTextSizes.xs,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: onTap != null
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (actionHint != null) ...[
          const SizedBox(width: AppDimensions.spaceXS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceXS + 2,
              vertical: AppDimensions.spaceXXS,
            ),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
            ),
            child: Text(
              actionHint!,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXXS),
          child: content,
        ),
      );
    }

    return content;
  }
}

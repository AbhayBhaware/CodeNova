import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';

/// Data class for an approved social or digital channel.
class ApprovedSocialChannel {
  const ApprovedSocialChannel({
    required this.name,
    required this.handle,
    required this.url,
    required this.icon,
    this.isVerified = true,
  });

  final String name;
  final String handle;
  final String url;
  final IconData icon;
  final bool isVerified;
}

/// Card presenting verified digital communication channels and social transparency.
/// In accordance with requirements, only verified, approved links are presented without inventing unconfirmed profiles.
class ContactDigitalChannelsCard extends StatelessWidget {
  const ContactDigitalChannelsCard({
    super.key,
    this.approvedChannels = const [],
  });

  /// Optional list of verified and approved social media channels.
  final List<ApprovedSocialChannel> approvedChannels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tt = theme.textTheme;

    return AppCard.glass(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.accent.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                child: const Icon(
                  Icons.public_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSM),
              Expanded(
                child: Text(
                  'Verified Digital Channels',
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          // Primary Web Portal Tile
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundSurface : AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.neutral300,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.language_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: AppDimensions.spaceSM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Official Web Portal',
                        style: TextStyle(
                          fontSize: AppTextSizes.xs,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SelectableText(
                        'codenovatechsolutions.in',
                        style: TextStyle(
                          fontSize: AppTextSizes.sm,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => AppUtils.launchWebUrl(AppStrings.website, context: context),
                  child: const Text('Open'),
                ),
              ],
            ),
          ),

          // Render approved social media channels if any are provided
          if (approvedChannels.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spaceMD),
            Text(
              'Approved Social Channels',
              style: tt.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSM),
            ...approvedChannels.map((channel) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceSM),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(channel.icon, color: AppColors.primary),
                    title: Text(channel.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(channel.handle),
                    trailing: const Icon(Icons.open_in_new_rounded, size: 16),
                    onTap: () => AppUtils.launchWebUrl(channel.url, context: context),
                  ),
                )),
          ],

          const SizedBox(height: AppDimensions.spaceMD),

          // Security & Authenticity Advisory
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceSM),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(isDark ? 20 : 10),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              border: Border.all(color: AppColors.primary.withAlpha(40)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimensions.spaceSM),
                Expanded(
                  child: Text(
                    'Official company announcements and verified certificate validations are dispatched solely via our verified domain (codenovatechsolutions.in). CodeNova never solicits fees through unverified third-party handles.',
                    style: TextStyle(
                      fontSize: AppTextSizes.xs,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
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

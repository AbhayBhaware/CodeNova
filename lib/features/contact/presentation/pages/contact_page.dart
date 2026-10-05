import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../controllers/contact_controller.dart';
import '../widgets/widgets.dart';

/// Professional Contact Us screen for CodeNova Tech Solutions.
///
/// Features exclusively verified company contact details:
/// - Official Direct Phone Line (+91 8087480411) with tap-to-call and copy fallback
/// - Official Corporate Email (contact@codenovatechsolutions.in) with tap-to-email and copy fallback
/// - Pune Headquarters Location with Google Maps integration and copy fallback
/// - Verified Web Portal (codenovatechsolutions.in) with browser launch
/// - Consultation Hours & Response SLA details (Pune Office)
/// - Digital channels advisory maintaining zero-hallucination contact integrity
/// - Specialized shortcuts for IT Project Quotes and Internship applications
/// - Comprehensive interactive enquiry form with validation, loading, and recovery states
class ContactPage extends StatefulWidget {
  const ContactPage({
    super.key,
    this.controller,
  });

  /// Optional controller injection for testing.
  final ContactController? controller;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go(AppStrings.routeHome);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk_rounded),
            tooltip: 'Call Pune Desk',
            onPressed: () => AppUtils.launchPhone(
              AppStrings.phoneDialable,
              context: context,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.language_rounded),
            tooltip: 'Official Website',
            onPressed: () => AppUtils.launchWebUrl(
              AppStrings.website,
              context: context,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMD,
          vertical: AppDimensions.spaceLG,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Verified Headquarters Banner ────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spaceLG),
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
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
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'VERIFIED CORPORATE DESK · PUNE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppTextSizes.xs,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMD),
                  Text(
                    'We are here to assist your tech journey.',
                    style: tt.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXS),
                  Text(
                    'Reach out to CodeNova Tech Solutions for technical training admissions, internship openings, or custom software engineering enquiries.',
                    style: tt.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(220),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXL),

            // ── Section 1: Verified Direct Communication Channels ──────
            const SectionHeader(
              title: 'Direct Channels',
              subtitle:
                  'Reach our Pune team directly for immediate assistance',
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // 1. Direct Phone
            ContactActionCard(
              icon: Icons.phone_in_talk_rounded,
              title: 'Direct Phone Support',
              value: AppStrings.phone,
              subtitle: AppStrings.officeHours,
              actionLabel: 'Call Pune Desk',
              actionIcon: Icons.call_rounded,
              accentColor: AppColors.success,
              onAction: () => AppUtils.launchPhone(
                AppStrings.phoneDialable,
                context: context,
              ),
              onCopy: () => AppUtils.copyToClipboard(
                context,
                AppStrings.phone,
                successMessage: 'Phone number copied: ${AppStrings.phone}',
              ),
              copyTooltip: 'Copy phone number',
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // 2. Official Email
            ContactActionCard(
              icon: Icons.email_rounded,
              title: 'Official Enquiries Email',
              value: AppStrings.email,
              subtitle:
                  'Secondary support: ${AppStrings.emailSecondary}',
              actionLabel: 'Send Email',
              actionIcon: Icons.outgoing_mail,
              accentColor: AppColors.accent,
              onAction: () => AppUtils.launchEmail(
                AppStrings.email,
                subject: 'Enquiry for CodeNova Tech Solutions',
                context: context,
              ),
              onCopy: () => AppUtils.copyToClipboard(
                context,
                AppStrings.email,
                successMessage: 'Email address copied: ${AppStrings.email}',
              ),
              copyTooltip: 'Copy email address',
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // 3. Location & Google Maps
            ContactActionCard(
              icon: Icons.location_on_rounded,
              title: 'Registered Headquarters',
              value: AppStrings.address,
              subtitle: 'Primary Development & Training Center',
              actionLabel: 'Open in Maps',
              actionIcon: Icons.map_rounded,
              accentColor: AppColors.warning,
              onAction: () => AppUtils.launchMaps(
                AppStrings.address,
                context: context,
              ),
              onCopy: () => AppUtils.copyToClipboard(
                context,
                AppStrings.address,
                successMessage: 'Office address copied: ${AppStrings.address}',
              ),
              copyTooltip: 'Copy office location',
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // 4. Official Website
            ContactActionCard(
              icon: Icons.public_rounded,
              title: 'Official Web Portal',
              value: 'codenovatechsolutions.in',
              subtitle: 'Explore services, syllabi & verified certificates',
              actionLabel: 'Visit Website',
              actionIcon: Icons.open_in_browser_rounded,
              accentColor: AppColors.primary,
              onAction: () => AppUtils.launchWebUrl(
                AppStrings.website,
                context: context,
              ),
              onCopy: () => AppUtils.copyToClipboard(
                context,
                AppStrings.website,
                successMessage: 'Website URL copied: ${AppStrings.website}',
              ),
              copyTooltip: 'Copy website URL',
            ),
            const SizedBox(height: AppDimensions.spaceXL),

            // ── Section 2: Consultation Hours & Response SLA ───────────
            const ContactOfficeHoursCard(),
            const SizedBox(height: AppDimensions.spaceXL),

            // ── Section 3: Specialized Shortcuts ───────────────────────
            const ContactQuickShortcuts(),
            const SizedBox(height: AppDimensions.spaceXL),

            // ── Section 4: Send an Enquiry Form ────────────────────────
            const SectionHeader(
              title: 'Send an Enquiry',
              subtitle:
                  'Submit your requirements and our solutions team will respond promptly',
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            ContactEnquiryForm(controller: widget.controller),
            const SizedBox(height: AppDimensions.spaceXL),

            // ── Section 5: Verified Digital Channels Advisory ──────────
            const SectionHeader(
              title: 'Authenticity & Channels',
              subtitle: 'Official channels and consumer verification guidelines',
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            const ContactDigitalChannelsCard(),
            const SizedBox(height: AppDimensions.spaceXL),

            // ── Footer Note ────────────────────────────────────────────
            Center(
              child: Column(
                children: [
                  Text(
                    'CodeNova Tech Solutions · Pune, Maharashtra',
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Innovating Today, Empowering Tomorrow.',
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.textSecondary.withAlpha(160),
                      fontSize: AppTextSizes.xs,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLG),
          ],
        ),
      ),
    );
  }
}

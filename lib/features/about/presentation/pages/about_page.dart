import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// About page – company background, mission, and team introduction.
/// Content from https://www.codenovatechsolutions.in/
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navAbout)),
      body: ListView(
        padding: AppDimensions.screenPadding,
        children: [
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Who We Are ──────────────────────────────────────
          const SectionHeader(title: 'Who We Are'),
          const SizedBox(height: AppDimensions.spaceMD),
          Text(
            'CodeNova Tech Solutions is a Pune-based IT training and internship '
            'centre dedicated to bridging the gap between academic learning and '
            'industry demands. We equip students and fresh graduates with the '
            'practical skills, tools, and confidence they need to launch '
            'successful tech careers.',
            style: tt.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          // ── Mission & Vision ────────────────────────────────
          const SectionHeader(title: 'Mission & Vision'),
          const SizedBox(height: AppDimensions.spaceMD),
          AppCard.glass(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  icon: Icons.flag_rounded,
                  label: 'Mission',
                  value:
                      'To make quality IT education accessible and transform every '
                      'student into an industry-ready professional.',
                ),
                const SizedBox(height: AppDimensions.spaceLG),
                _InfoRow(
                  icon: Icons.visibility_rounded,
                  label: 'Vision',
                  value:
                      'To become the most trusted IT training partner in Maharashtra, '
                      'known for real-world outcomes and student success.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          // ── Company Details ──────────────────────────────────
          const SectionHeader(title: 'Company Details'),
          const SizedBox(height: AppDimensions.spaceMD),
          AppCard.glass(
            child: Column(
              children: [
                _DetailRow(
                    icon: Icons.location_on_rounded,
                    label: 'Location',
                    value: AppStrings.address),
                const Divider(height: AppDimensions.spaceXL),
                _DetailRow(
                    icon: Icons.phone_rounded,
                    label: 'Phone',
                    value: AppStrings.phone),
                const Divider(height: AppDimensions.spaceXL),
                _DetailRow(
                    icon: Icons.email_rounded,
                    label: 'Email',
                    value: AppStrings.email),
                const Divider(height: AppDimensions.spaceXL),
                _DetailRow(
                    icon: Icons.language_rounded,
                    label: 'Website',
                    value: AppStrings.website),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceSM),
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: AppDimensions.spaceMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: tt.labelLarge?.copyWith(color: AppColors.accent)),
              const SizedBox(height: AppDimensions.spaceXS),
              Text(value, style: tt.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: AppDimensions.iconMD),
        const SizedBox(width: AppDimensions.spaceMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: tt.bodySmall),
              Text(value,
                  style:
                      tt.bodyMedium?.copyWith(color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}

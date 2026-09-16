import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/app_utils.dart';

/// Contact page – real company contact details with action buttons.
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navContact)),
      body: ListView(
        padding: AppDimensions.screenPadding,
        children: [
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Header ─────────────────────────────────────────
          const SectionHeader(
            title: 'Get in Touch',
            subtitle:
                'We\'d love to hear from you. Reach out for course enquiries, '
                'internship applications, or business collaborations.',
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // ── Quick Contact Cards ─────────────────────────────
          _ContactActionCard(
            icon: Icons.phone_rounded,
            label: 'Call Us',
            value: AppStrings.phone,
            buttonLabel: 'Call Now',
            color: AppColors.success,
            onTap: () => AppUtils.launchPhone(AppStrings.phoneDialable),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          _ContactActionCard(
            icon: Icons.email_rounded,
            label: 'Email Us',
            value: AppStrings.email,
            buttonLabel: 'Send Email',
            color: AppColors.accent,
            onTap: () => AppUtils.launchEmail(
              AppStrings.email,
              subject: 'Enquiry from CodeNova App',
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          _ContactActionCard(
            icon: Icons.language_rounded,
            label: 'Visit Website',
            value: AppStrings.website,
            buttonLabel: 'Open Website',
            color: AppColors.secondary,
            onTap: () => AppUtils.launchWebUrl(AppStrings.website),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          _ContactActionCard(
            icon: Icons.location_on_rounded,
            label: 'Location',
            value: AppStrings.address,
            buttonLabel: 'Open Maps',
            color: AppColors.warning,
            onTap: () => AppUtils.launchWebUrl(
              'https://maps.google.com/?q=CodeNova+Tech+Solutions+Pune',
            ),
          ),

          const SizedBox(height: AppDimensions.spaceXXL),

          // ── Enquiry Form (UI Only) ──────────────────────────
          const SectionHeader(title: 'Send an Enquiry'),
          const SizedBox(height: AppDimensions.spaceMD),
          const _EnquiryForm(),

          const SizedBox(height: AppDimensions.spaceXL),
        ],
      ),
    );
  }
}

// ── Contact Action Card ──────────────────────────────────────────────────────

class _ContactActionCard extends StatelessWidget {
  const _ContactActionCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.buttonLabel,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String buttonLabel;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppCard.glass(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(color: color.withAlpha(80)),
            ),
            child: Icon(icon, color: color, size: AppDimensions.iconMD),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: tt.bodySmall),
                Text(
                  value,
                  style: tt.titleMedium?.copyWith(
                    fontSize: AppTextSizes.body,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSM),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(foregroundColor: color),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}

// ── Enquiry Form ─────────────────────────────────────────────────────────────

class _EnquiryForm extends StatefulWidget {
  const _EnquiryForm();

  @override
  State<_EnquiryForm> createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<_EnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Send to backend API when available.
      setState(() => _submitted = true);
      AppUtils.showSnackBar(context, 'Message received! We\'ll be in touch soon.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return AppCard.glass(
        padding: const EdgeInsets.all(AppDimensions.spaceXL),
        child: Column(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 48),
            const SizedBox(height: AppDimensions.spaceMD),
            Text(
              'Thank you!',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: AppColors.success),
            ),
            const SizedBox(height: AppDimensions.spaceSM),
            const Text(
              'Your enquiry has been submitted. Our team will get back to you shortly.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Name is required' : null,
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          TextFormField(
            controller: _messageController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Message',
              prefixIcon: Icon(Icons.message_outlined),
              alignLabelWithHint: true,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Message is required' : null,
          ),
          const SizedBox(height: AppDimensions.spaceLG),
          AppGradientButton(
            label: 'Send Message',
            icon: Icons.send_rounded,
            onPressed: _submit,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

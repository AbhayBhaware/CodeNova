import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/contact_enquiry_model.dart';
import '../controllers/contact_controller.dart';
import '../utils/contact_form_validators.dart';

/// Full interactive enquiry form with validation, loading states,
/// success tracking view, and error recovery banner.
class ContactEnquiryForm extends StatefulWidget {
  const ContactEnquiryForm({
    super.key,
    this.controller,
  });

  final ContactController? controller;

  @override
  State<ContactEnquiryForm> createState() => _ContactEnquiryFormState();
}

class _ContactEnquiryFormState extends State<ContactEnquiryForm> {
  final _formKey = GlobalKey<FormState>();

  late final ContactController _controller;
  bool _ownsController = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedCategory = 'General Question';

  static const List<String> _categories = [
    'General Question',
    'Course Admission',
    'Internship Opportunities',
    'IT Services & Solutions',
    'Corporate Training & Workshops',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = ContactController();
      _ownsController = true;
    }
    _controller.addListener(_onControllerUpdated);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdated);
    if (_ownsController) {
      _controller.dispose();
    }
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onControllerUpdated() {
    if (mounted) setState(() {});
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final enquiry = ContactEnquiryModel(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      category: _selectedCategory,
      message: _messageController.text.trim(),
      submittedAt: DateTime.now(),
    );

    await _controller.submitEnquiry(enquiry);
  }

  void _handleReset() {
    _controller.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _messageController.clear();
    setState(() {
      _selectedCategory = 'General Question';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tt = theme.textTheme;

    // ── Success State View ──────────────────────────────────────────
    if (_controller.isSuccess && _controller.submissionResult != null) {
      return _EnquirySuccessView(
        result: _controller.submissionResult!,
        isDark: isDark,
        onReset: _handleReset,
      );
    }

    // ── Active Form View ────────────────────────────────────────────
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Failure Banner ────────────────────────────────────────
          if (_controller.isFailure && _controller.errorMessage != null) ...[
            _EnquiryFailureBanner(
              errorMessage: _controller.errorMessage!,
              isDark: isDark,
              onRetry: _handleSubmit,
            ),
            const SizedBox(height: AppDimensions.spaceLG),
          ],

          // ── Full Name Field ───────────────────────────────────────
          TextFormField(
            controller: _nameController,
            enabled: !_controller.isSubmitting,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              hintText: 'e.g. Rahul Sharma',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: ContactFormValidators.validateFullName,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Email Field ───────────────────────────────────────────
          TextFormField(
            controller: _emailController,
            enabled: !_controller.isSubmitting,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email Address *',
              hintText: 'e.g. rahul@example.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: ContactFormValidators.validateEmail,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Phone / Mobile Field (Optional) ───────────────────────
          TextFormField(
            controller: _phoneController,
            enabled: !_controller.isSubmitting,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Phone / Mobile (Optional)',
              hintText: 'e.g. +91 9876543210',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: ContactFormValidators.validatePhone,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Enquiry Category Dropdown ─────────────────────────────
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Enquiry Category *',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(
                  category,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: _controller.isSubmitting
                ? null
                : (val) {
                    if (val != null) {
                      setState(() => _selectedCategory = val);
                    }
                  },
            validator: ContactFormValidators.validateCategory,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Message Field ─────────────────────────────────────────
          TextFormField(
            controller: _messageController,
            enabled: !_controller.isSubmitting,
            maxLines: 4,
            maxLength: 1500,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Message / Details *',
              hintText:
                  'Please specify your question, course of interest, or requirements...',
              prefixIcon: Icon(Icons.message_outlined),
              alignLabelWithHint: true,
            ),
            validator: ContactFormValidators.validateMessage,
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          // ── Development Transparency Notice ───────────────────────
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(isDark ? 25 : 15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(color: AppColors.accent.withAlpha(50)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.accent,
                ),
                const SizedBox(width: AppDimensions.spaceSM),
                Expanded(
                  child: Text(
                    'Development Environment: Submitting generates a verified local reference ID (DEV-ENQ-XXXX). For live urgent enquiries, reach out to our Pune desk directly at ${AppStrings.phone}.',
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: AppTextSizes.xs,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── Submit Button ─────────────────────────────────────────
          AppButton(
            label: _controller.isSubmitting
                ? 'Sending Message…'
                : 'Send Enquiry Message',
            icon: _controller.isSubmitting ? null : Icons.send_rounded,
            isLoading: _controller.isSubmitting,
            isFullWidth: true,
            onPressed: _controller.isSubmitting ? null : _handleSubmit,
          ),
        ],
      ),
    );
  }
}

// ── Success State View ───────────────────────────────────────────────────────
class _EnquirySuccessView extends StatelessWidget {
  const _EnquirySuccessView({
    required this.result,
    required this.isDark,
    required this.onReset,
  });

  final ContactSubmissionResult result;
  final bool isDark;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final enq = result.enquiry;

    return AppCard.glass(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 40,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Text(
            'Enquiry Transmitted',
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            'Thank you, ${enq.fullName}. Your enquiry has been recorded. Our team will review your message and respond within ${AppStrings.responseSLA}.',
            style: tt.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Reference ID Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundSurface : AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.neutral300,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'ENQUIRY REFERENCE ID',
                  style: AppTypography.overline(color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  result.referenceId,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    fontSize: AppTextSizes.title,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.isMock
                      ? 'Local Development Reference'
                      : 'Confirmed Backend Record',
                  style: const TextStyle(
                    fontSize: AppTextSizes.xs,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Summary details
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundSurface : AppColors.cardLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.neutral200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enquiry Summary',
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                _SummaryLine(label: 'Category', value: enq.category, isDark: isDark),
                _SummaryLine(label: 'Email', value: enq.email, isDark: isDark),
                if (enq.phone != null)
                  _SummaryLine(label: 'Phone', value: enq.phone!, isDark: isDark),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Reset Action
          OutlinedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.mail_outline_rounded, size: 16),
            label: const Text('Send Another Enquiry'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    required this.isDark,
  });

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: AppTextSizes.sm,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppTextSizes.sm,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Failure State Banner ────────────────────────────────────────────────────
class _EnquiryFailureBanner extends StatelessWidget {
  const _EnquiryFailureBanner({
    required this.errorMessage,
    required this.isDark,
    required this.onRetry,
  });

  final String errorMessage;
  final bool isDark;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(isDark ? 35 : 20),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(color: Colors.red.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.red, size: 20),
              const SizedBox(width: AppDimensions.spaceSM),
              const Expanded(
                child: Text(
                  'Submission Encountered An Issue',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: AppTextSizes.sm,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Wrap(
            spacing: AppDimensions.spaceSM,
            runSpacing: AppDimensions.spaceXS,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Retry Submission'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
              TextButton.icon(
                onPressed: () => AppUtils.launchEmail(
                  AppStrings.email,
                  subject: 'Direct Contact Enquiry',
                  context: context,
                ),
                icon: const Icon(Icons.email_outlined, size: 16),
                label: const Text('Email Directly'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

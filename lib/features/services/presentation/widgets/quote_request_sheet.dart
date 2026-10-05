import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/service_model.dart';
import '../pages/quote_request_page.dart';

/// Modal bottom sheet for requesting an enterprise or startup project quote.
///
/// Pre-populates the chosen [service] if provided, validates contact details,
/// and provides direct phone/email contact options for urgent consultations.
class QuoteRequestSheet extends StatefulWidget {
  const QuoteRequestSheet({
    super.key,
    this.initialService,
  });

  final ServiceModel? initialService;

  static Future<void> show(BuildContext context, {ServiceModel? service}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuoteRequestSheet(initialService: service),
    );
  }

  @override
  State<QuoteRequestSheet> createState() => _QuoteRequestSheetState();
}

class _QuoteRequestSheetState extends State<QuoteRequestSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _messageController;
  ServiceModel? _selectedService;
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _messageController = TextEditingController();
    _selectedService = widget.initialService;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    // Simulate brief network submission
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundCard : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 90 : 40),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.spaceLG,
              AppDimensions.spaceMD,
              AppDimensions.spaceLG,
              AppDimensions.spaceLG,
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
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.neutral300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMD),

                // ── Header Row ────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isSubmitted
                                ? 'Quote Request Received'
                                : 'Request a Project Quote',
                            style: tt.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: AppTextSizes.title,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceXXS),
                          Text(
                            _isSubmitted
                                ? 'Thank you! Our technical team in Pune will review your project.'
                                : 'Tailored digital solutions engineered for your business requirements.',
                            style: tt.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceLG),

                if (_isSubmitted)
                  _buildSuccessView(context)
                else
                  _buildFormView(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
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
            size: 36,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceLG),
        Text(
          'Requirements Logged Successfully',
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: AppTextSizes.bodyLg,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceSM),
        Text(
          'We have received your project details for ${_selectedService?.title ?? "our IT services"}. A senior technical consultant will contact you via email or phone within 24 to 48 business hours.',
          style: tt.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceXL),

        // Quick Direct Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => AppUtils.launchPhone(AppStrings.phoneDialable),
                icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
                label: const Text('Call Us'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, AppDimensions.buttonHeight),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMD),
            Expanded(
              child: AppButton(
                label: 'Done',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormView(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected Service Indicator / Dropdown
          if (_selectedService != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceMD,
                vertical: AppDimensions.spaceSM,
              ),
              margin: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(isDark ? 30 : 15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                border: Border.all(
                  color: AppColors.primary.withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _selectedService!.icon,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppDimensions.spaceSM),
                  Expanded(
                    child: Text(
                      _selectedService!.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  AppBadge(
                    label: _selectedService!.category,
                    color: AppColors.primary,
                  ),
                ],
              ),
            )
          else ...[
            DropdownButtonFormField<ServiceModel>(
              initialValue: _selectedService,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Select Service Required *',
                prefixIcon: const Icon(Icons.business_center_rounded),
                filled: true,
                fillColor: isDark
                    ? AppColors.backgroundSurface
                    : AppColors.neutral100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
              ),
              items: MockData.services.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(s.title, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              validator: (val) =>
                  val == null ? 'Please select a service' : null,
              onChanged: (val) => setState(() => _selectedService = val),
            ),
            const SizedBox(height: AppDimensions.spaceMD),
          ],

          // Full Name
          AppTextField(
            label: 'Your Name or Company',
            hintText: 'e.g. John Doe / TechCorp Ltd.',
            controller: _nameController,
            prefixIcon: const Icon(Icons.person_rounded),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter your name or company name';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Email
          AppTextField(
            label: 'Work Email Address',
            hintText: 'name@company.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_rounded),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter your email';
              }
              final emailRegex =
                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(val.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Phone
          AppTextField(
            label: 'Contact Phone Number',
            hintText: '10-digit mobile number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_rounded),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter your phone number';
              }
              final digits = val.replaceAll(RegExp(r'\D'), '');
              if (digits.length < 10) {
                return 'Please enter at least 10 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Message / Scope
          AppTextField(
            label: 'Project Scope & Requirements',
            hintText: 'Tell us about your project deliverables, timeline, or objectives…',
            controller: _messageController,
            maxLines: 3,
            prefixIcon: const Icon(Icons.notes_rounded),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please provide a brief project overview';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Submit Button
          AppGradientButton(
            label: 'Submit Quote Request',
            icon: Icons.send_rounded,
            width: double.infinity,
            onPressed: _isSubmitting ? null : _handleSubmit,
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          // Fast direct assistance
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                try {
                  context.push(AppStrings.routeQuoteRequest, extra: _selectedService);
                } catch (_) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QuoteRequestPage(initialService: _selectedService),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('Open Detailed Quote Request Form'),
            ),
          ),
          Center(
            child: TextButton.icon(
              onPressed: () => AppUtils.launchPhone(AppStrings.phoneDialable),
              icon: const Icon(Icons.headset_mic_rounded, size: 16),
              label: const Text('Prefer a direct call? Connect with Pune Office'),
            ),
          ),
        ],
      ),
    );
  }
}

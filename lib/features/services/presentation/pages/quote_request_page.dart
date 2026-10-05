import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/quote_request_model.dart';
import '../../../../models/service_model.dart';
import '../../data/repositories/quote_repository.dart';
import '../controllers/quote_controller.dart';
import '../utils/quote_form_validators.dart';

/// Professional Request a Quote page for CodeNova Tech Solutions.
///
/// Features:
/// - Validated required fields: Full Name, Email, Project Type, Description, Contact Method
/// - Optional fields: Company Name, Budget Range
/// - Decoupled state management via [QuoteController]
/// - Loading state with disabled inputs and button progress spinner
/// - Success state with simulated reference ID and transparent development notice
/// - Failure state with inline error banner, retry capability, and input preservation
/// - Direct fallback phone and email options for immediate procurement
class QuoteRequestPage extends StatefulWidget {
  const QuoteRequestPage({
    super.key,
    this.initialService,
    this.controller,
  });

  /// Optional pre-selected service if navigated from a specific service page.
  final ServiceModel? initialService;

  /// Optional controller injection for testing or dependency injection.
  final QuoteController? controller;

  @override
  State<QuoteRequestPage> createState() => _QuoteRequestPageState();
}

class _QuoteRequestPageState extends State<QuoteRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  late final QuoteController _controller;
  bool _ownsController = false;

  // Form Field Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _companyController;
  late final TextEditingController _descriptionController;

  // Selected State Values
  String? _selectedProjectType;
  String? _selectedBudgetRange;
  String _preferredContactMethod = 'Email';

  // Verified Project Types
  static const List<String> _projectTypes = [
    'Web Application Development',
    'Mobile App Development',
    'AI & Machine Learning',
    'Cloud Technologies',
    'Cybersecurity Solutions',
    'Custom Software Development',
    'Other / Custom Solution',
  ];

  // Budget Tiers
  static const List<String> _budgetRanges = [
    'Under ₹50,000 (< \$600)',
    '₹50,000 - ₹1,50,000 (\$600 - \$1,800)',
    '₹1,50,000 - ₹5,00,000 (\$1,800 - \$6,000)',
    '₹5,00,000+ (\$6,000+)',
    'Flexible / To be discussed',
  ];

  // Contact Methods
  static const List<Map<String, dynamic>> _contactMethods = [
    {'label': 'Email', 'icon': Icons.email_rounded},
    {'label': 'Phone Call', 'icon': Icons.phone_rounded},
    {'label': 'WhatsApp', 'icon': Icons.chat_rounded},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = QuoteController();
      _ownsController = true;
    }

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _companyController = TextEditingController();
    _descriptionController = TextEditingController();

    // Pre-populate project type if initialService is provided
    if (widget.initialService != null) {
      final matching = _projectTypes.firstWhere(
        (t) => t.toLowerCase() == widget.initialService!.title.toLowerCase(),
        orElse: () => widget.initialService!.title,
      );
      _selectedProjectType = matching;
    }

    _controller.addListener(_onControllerUpdated);
  }

  void _onControllerUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdated);
    if (_ownsController) {
      _controller.dispose();
    }
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    final request = QuoteRequestModel(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      companyName: _companyController.text.trim().isEmpty
          ? null
          : _companyController.text.trim(),
      projectType: _selectedProjectType ?? 'Custom Software Development',
      projectDescription: _descriptionController.text.trim(),
      budgetRange: _selectedBudgetRange,
      preferredContactMethod: _preferredContactMethod,
      serviceId: widget.initialService?.id,
      submittedAt: DateTime.now(),
    );

    await _controller.submitQuote(request);
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _companyController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedProjectType = null;
      _selectedBudgetRange = null;
      _preferredContactMethod = 'Email';
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a Quote'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk_rounded),
            tooltip: 'Call Consultation Desk',
            onPressed: () => AppUtils.launchPhone(AppStrings.phoneDialable),
          ),
        ],
      ),
      body: SafeArea(
        child: _controller.isSuccess
            ? _QuoteSuccessView(
                result: _controller.submissionResult!,
                isDark: isDark,
                onBackToServices: () => Navigator.of(context).pop(),
                onSubmitAnother: _resetForm,
              )
            : _buildForm(context, isDark),
      ),
    );
  }

  Widget _buildForm(BuildContext context, bool isDark) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // ── Failure Banner (if submission failed) ─────────────────
          if (_controller.isFailure) ...[
            _FailureBanner(
              message: _controller.errorMessage ?? 'Submission failed.',
              onRetry: _handleSubmit,
              isDark: isDark,
            ),
            const SizedBox(height: AppDimensions.spaceMD),
          ],

          // ── Header Card ───────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withAlpha(50),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.security_rounded,
                      color: AppColors.accent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'CONFIDENTIAL & NDA PROTECTED',
                      style: AppTypography.overline(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                const Text(
                  'Tailored Project Proposals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextSizes.title,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                Text(
                  'Submit your technical requirements to CodeNova\'s engineering team in Pune for architectural scoping, cost estimation, and delivery timelines.',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: AppTextSizes.sm,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── Section 1: Client & Company Information ───────────────
          Text(
            'Contact Information',
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: AppTextSizes.bodyLg,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          // Full Name
          AppTextField(
            label: 'Full Name *',
            hintText: 'e.g. John Doe',
            controller: _nameController,
            prefixIcon: const Icon(Icons.person_rounded),
            enabled: !_controller.isSubmitting,
            validator: QuoteFormValidators.validateFullName,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Work Email
          AppTextField(
            label: 'Work Email Address *',
            hintText: 'name@company.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_rounded),
            enabled: !_controller.isSubmitting,
            validator: QuoteFormValidators.validateEmail,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Company Name (Optional)
          AppTextField(
            label: 'Company Name (Optional)',
            hintText: 'e.g. TechCorp Solutions Ltd.',
            controller: _companyController,
            prefixIcon: const Icon(Icons.business_rounded),
            enabled: !_controller.isSubmitting,
            validator: QuoteFormValidators.validateCompanyName,
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── Section 2: Project Scope ──────────────────────────────
          Text(
            'Project Scope',
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: AppTextSizes.bodyLg,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          // Project Type Dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedProjectType,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Project Type *',
              prefixIcon: const Icon(Icons.category_rounded),
              filled: true,
              fillColor: isDark
                  ? AppColors.backgroundSurface
                  : AppColors.neutral100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                borderSide: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            items: _projectTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            validator: QuoteFormValidators.validateProjectType,
            onChanged: _controller.isSubmitting
                ? null
                : (val) => setState(() => _selectedProjectType = val),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Project Description
          AppTextField(
            label: 'Project Description & Objectives *',
            hintText:
                'Describe your required features, target platforms, system integrations, or deliverables (minimum 15 characters)…',
            controller: _descriptionController,
            maxLines: 4,
            prefixIcon: const Icon(Icons.description_rounded),
            enabled: !_controller.isSubmitting,
            validator: QuoteFormValidators.validateProjectDescription,
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── Section 3: Budget & Consultation Preferences ──────────
          Text(
            'Budget & Communication Preferences',
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: AppTextSizes.bodyLg,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),

          // Budget Range Dropdown (Optional)
          DropdownButtonFormField<String>(
            initialValue: _selectedBudgetRange,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Budget Range (Optional)',
              prefixIcon: const Icon(Icons.account_balance_wallet_rounded),
              filled: true,
              fillColor: isDark
                  ? AppColors.backgroundSurface
                  : AppColors.neutral100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                borderSide: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            items: _budgetRanges.map((range) {
              return DropdownMenuItem(
                value: range,
                child: Text(range, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: _controller.isSubmitting
                ? null
                : (val) => setState(() => _selectedBudgetRange = val),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Preferred Contact Method (Choice Chips)
          Text(
            'Preferred Contact Method *',
            style: tt.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXS + 2),
          Row(
            children: _contactMethods.map((method) {
              final label = method['label'] as String;
              final icon = method['icon'] as IconData;
              final isSelected = _preferredContactMethod == label;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: AppDimensions.spaceXS),
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: '$label contact method',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _controller.isSubmitting
                            ? null
                            : () => setState(() => _preferredContactMethod = label),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMD),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.spaceSM + 2,
                            horizontal: 4,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.backgroundSurface
                                    : AppColors.neutral100),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusMD),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.borderDark
                                      : AppColors.neutral300),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 18,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: AppTextSizes.xs,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── Development Mode Notice (Requirement 5) ───────────────
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundSurface : AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.neutral200,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: AppColors.accent,
                ),
                const SizedBox(width: AppDimensions.spaceSM),
                Expanded(
                  child: Text(
                    'Development Environment: Submitting generates a verified local reference ID (DEV-QUOTE-XXXX). For live commercial contracts, call our Pune office directly.',
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                      fontSize: AppTextSizes.xs,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // ── Submit CTA Button ─────────────────────────────────────
          AppButton(
            label: _controller.isSubmitting
                ? 'Transmitting Request…'
                : 'Submit Quote Request',
            icon: _controller.isSubmitting ? null : Icons.send_rounded,
            isLoading: _controller.isSubmitting,
            isFullWidth: true,
            onPressed: _controller.isSubmitting ? null : _handleSubmit,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Direct Desk Fallback ──────────────────────────────────
          Center(
            child: TextButton.icon(
              onPressed: () => AppUtils.launchPhone(AppStrings.phoneDialable),
              icon: const Icon(Icons.phone_rounded, size: 16),
              label: const Text('Prefer immediate consultation? Call Pune desk'),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),
        ],
      ),
    ),
  );
  }
}

// ── Failure State Banner ────────────────────────────────────────────────────
class _FailureBanner extends StatelessWidget {
  const _FailureBanner({
    required this.message,
    required this.onRetry,
    required this.isDark,
  });

  final String message;
  final VoidCallback onRetry;
  final bool isDark;

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
            message,
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
                  subject: 'Direct Quote Enquiry',
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

// ── Success View ────────────────────────────────────────────────────────────
class _QuoteSuccessView extends StatelessWidget {
  const _QuoteSuccessView({
    required this.result,
    required this.isDark,
    required this.onBackToServices,
    required this.onSubmitAnother,
  });

  final QuoteSubmissionResult result;
  final bool isDark;
  final VoidCallback onBackToServices;
  final VoidCallback onSubmitAnother;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final req = result.quoteRequest;

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      children: [
        const SizedBox(height: AppDimensions.spaceMD),
        // Success Circle Icon
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceLG),

        // Headline
        Text(
          'Quote Request Received',
          style: tt.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: AppTextSizes.heading,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceSM),

        // Personalized Message
        Text(
          'Thank you, ${req.fullName}. Your project enquiry has been logged successfully. A technical solutions consultant from our Pune office will reach out within 24 to 48 business hours.',
          style: tt.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceLG),

        // Tracking Reference ID Container
        Container(
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
                'YOUR ENQUIRY REFERENCE ID',
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
              const SizedBox(height: 6),
              Text(
                result.isMock
                    ? 'Generated in Development Mode'
                    : 'Verified Backend Confirmation',
                style: TextStyle(
                  fontSize: AppTextSizes.xs,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceLG),

        // Project Summary Card
        Container(
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
              _SummaryRow(label: 'Project Type', value: req.projectType, isDark: isDark),
              _SummaryRow(label: 'Email', value: req.email, isDark: isDark),
              if (req.companyName != null)
                _SummaryRow(label: 'Company', value: req.companyName!, isDark: isDark),
              _SummaryRow(
                label: 'Preferred Contact',
                value: req.preferredContactMethod,
                isDark: isDark,
              ),
              if (req.budgetRange != null)
                _SummaryRow(label: 'Budget Tier', value: req.budgetRange!, isDark: isDark),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXL),

        // Action Buttons
        AppButton(
          label: 'Back to IT Services',
          icon: Icons.business_center_rounded,
          isFullWidth: true,
          onPressed: onBackToServices,
        ),
        const SizedBox(height: AppDimensions.spaceSM),

        OutlinedButton.icon(
          onPressed: () => AppUtils.launchPhone(AppStrings.phoneDialable),
          icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
          label: const Text('Call Pune Consultation Desk'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceSM),

        Center(
          child: TextButton(
            onPressed: onSubmitAnother,
            child: const Text('Submit Another Quote Request'),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
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

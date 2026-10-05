import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/internship_application_model.dart';
import '../../../../models/internship_model.dart';
import '../../data/repositories/internship_application_repository.dart';
import '../controllers/internship_apply_controller.dart';
import '../utils/internship_form_validators.dart';

/// Professional Internship Application Form Screen for CodeNova Tech Solutions.
///
/// Features:
/// - Validated fields: Name, Email, Mobile, College, Course/Branch, Technology.
/// - Optional fields: Resume/Portfolio link and additional message.
/// - Proper keyboard actions, focus progression, and scroll-to-error handling.
/// - Responsive layout compatible with both small and large mobile viewports.
/// - Clear development mode disclaimers and honest success confirmation.
/// - Fallback channel to forward details directly via official company email.
class InternshipApplyPage extends StatefulWidget {
  const InternshipApplyPage({
    super.key,
    this.internship,
    this.controller,
  });

  /// Optional internship context if candidate is applying for a specific role.
  final InternshipModel? internship;

  /// Optional controller injection for unit/widget testing.
  final InternshipApplyController? controller;

  @override
  State<InternshipApplyPage> createState() => _InternshipApplyPageState();
}

class _InternshipApplyPageState extends State<InternshipApplyPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  late final InternshipApplyController _controller;
  bool _ownsController = false;

  // Text Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _collegeController;
  late final TextEditingController _courseController;
  late final TextEditingController _techController;
  late final TextEditingController _resumeController;
  late final TextEditingController _messageController;

  // Focus Nodes
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _collegeFocus = FocusNode();
  final _courseFocus = FocusNode();
  final _techFocus = FocusNode();
  final _resumeFocus = FocusNode();
  final _messageFocus = FocusNode();

  // Curated technology domain suggestions
  static const List<String> _suggestedTechnologies = [
    'Full Stack Development',
    'Python & AI',
    'Mobile / Flutter',
    'Web Development (React)',
    'Cloud & DevOps',
    'Data Science',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = InternshipApplyController();
      _ownsController = true;
    }

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _collegeController = TextEditingController();
    _courseController = TextEditingController();

    // Pre-populate preferred technology if arriving from a specific role
    final initialTech = widget.internship?.techCategory != 'General'
        ? (widget.internship?.title ?? '')
        : '';
    _techController = TextEditingController(text: initialTech);

    _resumeController = TextEditingController();
    _messageController = TextEditingController();

    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    if (_ownsController) {
      _controller.dispose();
    }

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _collegeController.dispose();
    _courseController.dispose();
    _techController.dispose();
    _resumeController.dispose();
    _messageController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _collegeFocus.dispose();
    _courseFocus.dispose();
    _techFocus.dispose();
    _resumeFocus.dispose();
    _messageFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // Dismiss soft keyboard
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      // Smooth scroll up to reveal top errors if needed
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    final application = InternshipApplicationModel(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      collegeName: _collegeController.text.trim(),
      courseBranch: _courseController.text.trim(),
      preferredTechnology: _techController.text.trim(),
      internshipId: widget.internship?.id,
      internshipTitle: widget.internship?.title,
      additionalMessage: _messageController.text.trim(),
      resumeUrl: _resumeController.text.trim(),
      submittedAt: DateTime.now(),
    );

    final success = await _controller.submitApplication(application);
    if (success && mounted) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _collegeController.clear();
    _courseController.clear();
    _techController.text = widget.internship?.title ?? '';
    _resumeController.clear();
    _messageController.clear();
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Internship Application'),
          centerTitle: false,
          actions: [
            if (_controller.isSuccess)
              IconButton(
                tooltip: 'New Application',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: _resetForm,
              ),
          ],
        ),
        body: _controller.isSuccess
            ? _SuccessView(
                result: _controller.result!,
                internship: widget.internship,
                onReset: _resetForm,
                onDone: () => Navigator.of(context).pop(),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.spaceMD,
                  AppDimensions.spaceMD,
                  AppDimensions.spaceMD,
                  MediaQuery.of(context).viewInsets.bottom +
                      AppDimensions.spaceXXL,
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header / Position Context Card ─────────────
                      if (widget.internship != null)
                        _PositionContextCard(
                          internship: widget.internship!,
                          isDark: isDark,
                        )
                      else
                        _GeneralApplicationHeader(isDark: isDark),

                      const SizedBox(height: AppDimensions.spaceMD),

                      // ── Development Mode Transparency Notice ────────
                      _DevModeBanner(isDark: isDark),

                      const SizedBox(height: AppDimensions.spaceLG),

                      // ── Error Banner (if submission failed) ─────────
                      if (_controller.hasError) ...[
                        _ErrorBanner(
                          message: _controller.errorMessage ??
                              'Submission failed. Please try again.',
                          onRetry: _handleSubmit,
                        ),
                        const SizedBox(height: AppDimensions.spaceLG),
                      ],

                      // ── SECTION 1: Personal Details ────────────────
                      _SectionHeader(
                        icon: Icons.person_outline_rounded,
                        title: 'Personal Details',
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // Full Name
                      AppTextField(
                        key: const Key('input_full_name'),
                        controller: _nameController,
                        label: 'Full Name *',
                        hintText: 'e.g. John Doe',
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => _emailFocus.requestFocus(),
                        validator: InternshipFormValidators.validateFullName,
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // Email Address
                      AppTextField(
                        key: const Key('input_email'),
                        controller: _emailController,
                        label: 'Email Address *',
                        hintText: 'e.g. candidate@example.com',
                        prefixIcon: const Icon(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => _phoneFocus.requestFocus(),
                        validator: InternshipFormValidators.validateEmail,
                        helperText: 'Interview updates will be sent to this email',
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // Mobile Number
                      AppTextField(
                        key: const Key('input_phone'),
                        controller: _phoneController,
                        label: 'Mobile Number *',
                        hintText: 'e.g. 9876543210',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => _collegeFocus.requestFocus(),
                        validator: InternshipFormValidators.validatePhone,
                        helperText: '10-digit number for SMS / WhatsApp verification',
                      ),

                      const SizedBox(height: AppDimensions.spaceXL),

                      // ── SECTION 2: Academic & Technical Profile ────
                      _SectionHeader(
                        icon: Icons.school_outlined,
                        title: 'Academic & Technical Background',
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // College Name
                      AppTextField(
                        key: const Key('input_college'),
                        controller: _collegeController,
                        label: 'College / University *',
                        hintText: 'e.g. Pune University / Government Engineering College',
                        prefixIcon: const Icon(Icons.account_balance_outlined),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => _courseFocus.requestFocus(),
                        validator: InternshipFormValidators.validateCollegeName,
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // Course / Branch
                      AppTextField(
                        key: const Key('input_course'),
                        controller: _courseController,
                        label: 'Course & Branch *',
                        hintText: 'e.g. B.Tech Computer Science, MCA, BE IT',
                        prefixIcon: const Icon(Icons.menu_book_outlined),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => _techFocus.requestFocus(),
                        validator: InternshipFormValidators.validateCourseBranch,
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // Preferred Technology Field + Chips
                      AppTextField(
                        key: const Key('input_technology'),
                        controller: _techController,
                        label: 'Preferred Technology / Domain *',
                        hintText: 'e.g. Full Stack, Python, Flutter, React',
                        prefixIcon: const Icon(Icons.code_rounded),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => _resumeFocus.requestFocus(),
                        validator:
                            InternshipFormValidators.validatePreferredTechnology,
                      ),
                      const SizedBox(height: AppDimensions.spaceXS + 2),

                      // Quick Technology Suggestion Chips
                      Text(
                        'Quick select popular domains:',
                        style: TextStyle(
                          fontSize: AppTextSizes.xs,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Wrap(
                        spacing: AppDimensions.spaceXS,
                        runSpacing: AppDimensions.spaceXS,
                        children: _suggestedTechnologies.map((tech) {
                          final isSelected =
                              _techController.text.trim().toLowerCase() ==
                                  tech.toLowerCase();
                          return ChoiceChip(
                            label: Text(tech),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _techController.text = selected ? tech : '';
                              });
                            },
                            labelStyle: TextStyle(
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
                            selectedColor: AppColors.primary,
                            backgroundColor: isDark
                                ? AppColors.backgroundCard
                                : AppColors.surfaceLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusCircle,
                              ),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark
                                        ? AppColors.borderDark
                                        : AppColors.borderLight),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppDimensions.spaceXL),

                      // ── SECTION 3: Optional Documentation ──────────
                      _SectionHeader(
                        icon: Icons.link_rounded,
                        title: 'Portfolio & Additional Notes',
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // Resume / Portfolio Link
                      AppTextField(
                        key: const Key('input_resume'),
                        controller: _resumeController,
                        label: 'Resume / Portfolio Link (Optional)',
                        hintText: 'https://drive.google.com/... or GitHub link',
                        prefixIcon: const Icon(Icons.link_outlined),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => _messageFocus.requestFocus(),
                        validator: InternshipFormValidators.validateResumeUrl,
                        helperText:
                            'Google Drive, GitHub, or LinkedIn portfolio link',
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // Additional Message
                      AppTextField(
                        key: const Key('input_message'),
                        controller: _messageController,
                        label: 'Additional Message / Notes (Optional)',
                        hintText:
                            'Highlight relevant projects, graduation timeline, or questions...',
                        prefixIcon: const Icon(Icons.edit_note_rounded),
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        validator:
                            InternshipFormValidators.validateAdditionalMessage,
                      ),

                      const SizedBox(height: AppDimensions.spaceMD),

                      // ── Privacy & Data Minimization Notice ─────────
                      _PrivacyNoticeCard(isDark: isDark),

                      const SizedBox(height: AppDimensions.spaceXL),

                      // ── Submit Button with Loading State ───────────
                      AppButton(
                        label: _controller.isSubmitting
                            ? 'Validating & Submitting...'
                            : 'Submit Application',
                        icon: Icons.send_rounded,
                        isLoading: _controller.isSubmitting,
                        isFullWidth: true,
                        height: 50,
                        onPressed: _controller.isSubmitting
                            ? null
                            : _handleSubmit,
                      ),

                      const SizedBox(height: AppDimensions.spaceMD),

                      // Secondary Direct Email Option
                      Center(
                        child: TextButton.icon(
                          icon: const Icon(Icons.mail_outline_rounded, size: 16),
                          label: const Text('Prefer applying directly via Email?'),
                          onPressed: () {
                            AppUtils.launchEmail(
                              AppStrings.email,
                              subject:
                                  'Internship Application – ${widget.internship?.title ?? "General"}',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── SUBWIDGETS ────────────────────────────────═══════════════════════════════
// ══════════════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: AppDimensions.spaceSM),
        Text(
          title,
          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _PositionContextCard extends StatelessWidget {
  const _PositionContextCard({
    required this.internship,
    required this.isDark,
  });

  final InternshipModel internship;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.backgroundCard : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: Icon(internship.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Applying for Position',
                  style: TextStyle(
                    fontSize: AppTextSizes.xs,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                Text(
                  internship.title,
                  style: const TextStyle(
                    fontSize: AppTextSizes.body,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${internship.duration} · ${internship.mode?.label ?? "Verified Programme"}',
                  style: TextStyle(
                    fontSize: AppTextSizes.xs,
                    color: isDark ? AppColors.accent : AppColors.primary,
                    fontWeight: FontWeight.w600,
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

class _GeneralApplicationHeader extends StatelessWidget {
  const _GeneralApplicationHeader({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join CodeNova Tech Solutions',
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Submit your profile for upcoming internship cohorts and live project deliverables.',
          style: TextStyle(
            fontSize: AppTextSizes.sm,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

/// Development mode transparent banner.
class _DevModeBanner extends StatelessWidget {
  const _DevModeBanner({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical: AppDimensions.spaceSM,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(isDark ? 30 : 18),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(
          color: AppColors.accent.withAlpha(isDark ? 80 : 50),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.developer_mode_rounded,
            size: 18,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppDimensions.spaceSM),
          Expanded(
            child: Text(
              'Development Preview: Form inputs are validated locally and simulation responses are clearly marked. Live backend integration is pending.',
              style: TextStyle(
                fontSize: AppTextSizes.xs,
                height: 1.4,
                color: isDark ? Colors.white70 : AppColors.neutral800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// In-line error banner for submission failures.
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(20),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(color: AppColors.error.withAlpha(70)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spaceSM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Submission Error',
                  style: TextStyle(
                    fontSize: AppTextSizes.sm,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: AppTextSizes.xs,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Privacy and security reassurance card.
class _PrivacyNoticeCard extends StatelessWidget {
  const _PrivacyNoticeCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundCard : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.privacy_tip_outlined,
            size: 16,
            color: isDark ? AppColors.accent : AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spaceSM),
          Expanded(
            child: Text(
              'Data Protection: CodeNova Tech Solutions collects only essential details required for internship evaluation. Your information is never sold or shared with external parties.',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full screen success state view.
class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.result,
    required this.internship,
    required this.onReset,
    required this.onDone,
  });

  final ApplicationSubmissionResult result;
  final InternshipModel? internship;
  final VoidCallback onReset;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppDimensions.spaceLG),

          // Success Animated / Gradient Badge
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(25),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.success, width: 2),
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 40,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Title
          Text(
            'Application Received',
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXXS),

          // Dev Mode Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(25),
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
            ),
            child: const Text(
              'Development Preview Mode',
              style: TextStyle(
                fontSize: AppTextSizes.xs,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Reference ID Box
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLG,
              vertical: AppDimensions.spaceSM,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundCard : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Application Reference',
                  style: TextStyle(
                    fontSize: AppTextSizes.xs,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  result.referenceId,
                  style: const TextStyle(
                    fontSize: AppTextSizes.subtitle,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spaceLG),

          // Explanation
          Text(
            result.message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTextSizes.sm,
              height: 1.5,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppDimensions.spaceLG),

          // Next steps card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundCard : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What Happens Next?',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: AppTextSizes.body,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                _StepItem(
                  number: '1',
                  text: 'Screening of your academic and technical background.',
                  isDark: isDark,
                ),
                _StepItem(
                  number: '2',
                  text: 'Shortlisted candidates will receive interview instructions via email.',
                  isDark: isDark,
                ),
                _StepItem(
                  number: '3',
                  text: 'Direct technical discussion with our mentor lead.',
                  isDark: isDark,
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spaceXL),

          // Primary Done Button
          AppButton(
            label: 'Done / Return to Internships',
            icon: Icons.check_circle_outline_rounded,
            isFullWidth: true,
            height: 48,
            onPressed: onDone,
          ),

          const SizedBox(height: AppDimensions.spaceSM),

          // Optional Email Fallback Button
          AppButton.outline(
            label: 'Also Send via Email to HR',
            icon: Icons.email_outlined,
            isFullWidth: true,
            height: 48,
            onPressed: () {
              final pos = internship?.title ?? 'Internship Position';
              AppUtils.launchEmail(
                AppStrings.email,
                subject: 'Internship Application [${result.referenceId}] – $pos',
              );
            },
          ),

          const SizedBox(height: AppDimensions.spaceSM),

          TextButton(
            onPressed: onReset,
            child: const Text('Submit Another Application'),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.number,
    required this.text,
    required this.isDark,
    this.isLast = false,
  });

  final String number;
  final String text;
  final bool isDark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.spaceSM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSM),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppTextSizes.sm,
                height: 1.4,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

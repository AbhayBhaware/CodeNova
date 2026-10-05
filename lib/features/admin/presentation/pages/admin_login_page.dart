import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../controllers/admin_auth_controller.dart';

/// Secure administrative login portal.
class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@codenovatechsolutions.in');
  final _passwordController = TextEditingController(text: 'Admin@12345');
  final _totpController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _totpController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = AdminAuthController.instance;
    final success = await controller.login(
      email: _emailController.text,
      password: _passwordController.text,
      totpCode: _totpController.text.trim().isEmpty ? null : _totpController.text.trim(),
    );

    if (success && mounted) {
      context.go(AppStrings.routeAdminDashboard);
    }
  }

  void _fillDemo(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = AdminAuthController.instance;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLG),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: AppCard(
              padding: const EdgeInsets.all(AppDimensions.spaceXL),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceMD),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings_rounded,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceMD),

                    // Header
                    Text(
                      'CodeNova Admin Portal',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      'Internal Management & Verified Credential Ledger',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXL),

                    // Error Message
                    ListenableBuilder(
                      listenable: auth,
                      builder: (context, _) {
                        if (auth.errorMessage == null) return const SizedBox.shrink();
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
                          padding: const EdgeInsets.all(AppDimensions.spaceMD),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                              const SizedBox(width: AppDimensions.spaceSM),
                              Expanded(
                                child: Text(
                                  auth.errorMessage!,
                                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Email Field
                    Text(
                      'Official Staff Email',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    AppTextField(
                      controller: _emailController,
                      hintText: 'name@codenovatechsolutions.in',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter official staff email';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.spaceMD),

                    // Password Field
                    Text(
                      'Password',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    AppTextField(
                      controller: _passwordController,
                      hintText: '••••••••',
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.spaceLG),

                    // Submit Button
                    ListenableBuilder(
                      listenable: auth,
                      builder: (context, _) {
                        return AppButton(
                          label: 'Sign In to Dashboard',
                          icon: Icons.login_rounded,
                          isLoading: auth.isLoading,
                          onPressed: _handleLogin,
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.spaceMD),

                    // Demo Accounts Helper
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceMD),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.backgroundCard : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.touch_app_rounded, size: 16, color: AppColors.accent),
                              const SizedBox(width: AppDimensions.spaceXS),
                              Expanded(
                                child: Text(
                                  'Quick Demo Credentials (Tap to fill):',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spaceSM),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ActionChip(
                                label: const Text('Super Admin', style: TextStyle(fontSize: 12)),
                                avatar: const Icon(Icons.security_rounded, size: 14),
                                onPressed: () => _fillDemo(
                                  'admin@codenovatechsolutions.in',
                                  'Admin@12345',
                                ),
                              ),
                              ActionChip(
                                label: const Text('Placement Officer', style: TextStyle(fontSize: 12)),
                                avatar: const Icon(Icons.work_outline_rounded, size: 14),
                                onPressed: () => _fillDemo(
                                  'placement@codenovatechsolutions.in',
                                  'Placement@123',
                                ),
                              ),
                              ActionChip(
                                label: const Text('Course Coordinator', style: TextStyle(fontSize: 12)),
                                avatar: const Icon(Icons.school_outlined, size: 14),
                                onPressed: () => _fillDemo(
                                  'courses@codenovatechsolutions.in',
                                  'Courses@123',
                                ),
                              ),
                              ActionChip(
                                label: const Text('Business Solutions', style: TextStyle(fontSize: 12)),
                                avatar: const Icon(Icons.business_center_outlined, size: 14),
                                onPressed: () => _fillDemo(
                                  'business@codenovatechsolutions.in',
                                  'Business@123',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceMD),

                    // DPDP Compliance Notice
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        const Icon(Icons.shield_outlined, size: 14, color: AppColors.textMuted),
                        Text(
                          'Protected under DPDP Act 2023. All actions audit logged.',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceSM),

                    // Back to Mobile Home
                    TextButton.icon(
                      onPressed: () => context.go(AppStrings.routeHome),
                      icon: const Icon(Icons.arrow_back_rounded, size: 16),
                      label: const Text('Return to Mobile App'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

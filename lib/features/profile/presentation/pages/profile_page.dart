import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/app_utils.dart';

/// Profile tab – user identity hub and quick-action menu.
///
/// Currently a polished placeholder. The avatar, name and email will be
/// populated from an auth provider in a future phase. Navigation links
/// to real sections (Contact, About) are wired immediately.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header banner ────────────────────────────────
          SliverToBoxAdapter(
            child: _ProfileHeader(screenWidth: size.width),
          ),

          // ── Quick Actions ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spaceMD,
                AppDimensions.spaceXL,
                AppDimensions.spaceMD,
                AppDimensions.spaceMD,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Actions', style: tt.headlineMedium),
                  const SizedBox(height: AppDimensions.spaceMD),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.school_rounded,
                          label: 'My Courses',
                          color: AppColors.primary,
                          semanticLabel: 'View my enrolled courses',
                          onTap: () => context.go(AppStrings.routeExplore),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceMD),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.work_rounded,
                          label: 'Internships',
                          color: AppColors.accent,
                          semanticLabel: 'Browse internship openings',
                          onTap: () =>
                              context.go(AppStrings.routeInternships),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceMD),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.card_membership_rounded,
                          label: 'Certificates',
                          color: AppColors.secondary,
                          semanticLabel:
                              'View your earned certificates (coming soon)',
                          onTap: () => _comingSoon(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Menu Section: Account ─────────────────────────
          _SectionHeader(title: 'Account'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMD),
              child: AppCard.glass(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profile',
                      subtitle: 'Coming soon',
                      enabled: false,
                      onTap: () => _comingSoon(context),
                    ),
                    const Divider(height: 1, indent: 56),
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      subtitle: 'Coming soon',
                      enabled: false,
                      onTap: () => _comingSoon(context),
                    ),
                    const Divider(height: 1, indent: 56),
                    _MenuItem(
                      icon: Icons.lock_outline_rounded,
                      label: 'Privacy & Security',
                      subtitle: 'Coming soon',
                      enabled: false,
                      onTap: () => _comingSoon(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Menu Section: Company ─────────────────────────
          _SectionHeader(title: 'Company'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMD),
              child: AppCard.glass(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.info_outline_rounded,
                      label: 'About CodeNova',
                      onTap: () => context.go(AppStrings.routeAbout),
                    ),
                    const Divider(height: 1, indent: 56),
                    _MenuItem(
                      icon: Icons.contact_mail_outlined,
                      label: 'Contact Us',
                      onTap: () => context.go(AppStrings.routeContact),
                    ),
                    const Divider(height: 1, indent: 56),
                    _MenuItem(
                      icon: Icons.language_rounded,
                      label: 'Visit Website',
                      trailing: const Icon(
                        Icons.open_in_new_rounded,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                      onTap: () =>
                          AppUtils.launchWebUrl(AppStrings.website),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Menu Section: Support ─────────────────────────
          _SectionHeader(title: 'Support'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMD),
              child: AppCard.glass(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.phone_rounded,
                      label: 'Call Support',
                      subtitle: AppStrings.phone,
                      iconColor: AppColors.success,
                      onTap: () =>
                          AppUtils.launchPhone(AppStrings.phoneDialable),
                    ),
                    const Divider(height: 1, indent: 56),
                    _MenuItem(
                      icon: Icons.email_outlined,
                      label: 'Email Support',
                      subtitle: AppStrings.email,
                      iconColor: AppColors.accent,
                      onTap: () => AppUtils.launchEmail(
                        AppStrings.email,
                        subject: 'Support Request – CodeNova App',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── App Version & Staff Portal footer ─────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceXXL),
              child: Column(
                children: [
                  Text(
                    'CodeNova Tech Solutions\nv1.0.0 (Build 1)',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spaceMD),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.admin_panel_settings_outlined, size: 16),
                    label: const Text(
                      'Staff & Admin Portal',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => context.go(AppStrings.routeAdminLogin),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    AppUtils.showSnackBar(context, '🚀 Coming soon in the next update!');
  }
}

// ── Profile Header ───────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceMD,
        AppDimensions.space3XL,
        AppDimensions.spaceMD,
        AppDimensions.spaceXL,
      ),
      child: Column(
        children: [
          // Avatar
          Semantics(
            label: 'User avatar, not signed in',
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent.withAlpha(80),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(80),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Name / sign-in CTA
          Text(
            'Welcome, Student!',
            style: tt.headlineLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            'Sign in to track your progress',
            style: tt.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Sign-in button (placeholder)
          AppGradientButton(
            label: 'Sign In / Register',
            icon: Icons.login_rounded,
            onPressed: null, // disabled – auth not yet implemented
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Text(
            'Authentication coming soon',
            style: tt.bodySmall?.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

// ── Quick Action Card ─────────────────────────────────────────────────────────

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.semanticLabel,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spaceMD,
            horizontal: AppDimensions.spaceSM,
          ),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            border: Border.all(color: color.withAlpha(60)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: AppDimensions.iconLG),
              const SizedBox(height: AppDimensions.spaceSM),
              Text(
                label,
                style: tt.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.spaceMD,
          AppDimensions.spaceXL,
          AppDimensions.spaceMD,
          AppDimensions.spaceSM,
        ),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: AppTextSizes.xs,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

// ── Menu Item ─────────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.iconColor,
    this.trailing,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final color = enabled ? (iconColor ?? AppColors.accent) : AppColors.textMuted;

    return Semantics(
      label: subtitle != null ? '$label, $subtitle' : label,
      enabled: enabled,
      button: true,
      child: ListTile(
        onTap: enabled ? onTap : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMD,
          vertical: AppDimensions.spaceXS,
        ),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          ),
          child: Icon(icon, color: color, size: AppDimensions.iconMD),
        ),
        title: Text(
          label,
          style: tt.bodyLarge?.copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.textMuted,
            fontSize: AppTextSizes.body,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: tt.bodySmall,
              )
            : null,
        trailing: trailing ??
            Icon(
              Icons.chevron_right_rounded,
              color: enabled ? AppColors.textMuted : AppColors.divider,
              size: AppDimensions.iconMD,
            ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/internship_model.dart';

/// Full-screen premium Internship Details screen for CodeNova Tech Solutions.
///
/// Implements verified company information, handles optional fields with
/// graceful fallbacks, and features a sticky CTA bar with application modal.
class InternshipDetailPage extends StatelessWidget {
  const InternshipDetailPage({
    super.key,
    required this.internship,
  });

  final InternshipModel internship;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ── Scrollable Body ─────────────────────────────────────────
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Gradient Hero SliverAppBar ──────────────────────────
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.white),
                leading: Semantics(
                  label: 'Back to internships',
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                actions: [
                  Semantics(
                    label: 'Share internship',
                    child: IconButton(
                      icon: const Icon(Icons.share_rounded, color: Colors.white),
                      tooltip: 'Share',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sharing ${internship.title}'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: _HeroHeader(internship: internship),
                ),
              ),

              // ── Main Content Area ───────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.spaceMD,
                    AppDimensions.spaceLG,
                    AppDimensions.spaceMD,
                    // Bottom padding to clear sticky CTA bar
                    AppDimensions.spaceXXL + AppDimensions.spaceXL + 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Quick Info Strip ───────────────────────────
                      _QuickInfoStrip(internship: internship, isDark: isDark),
                      const SizedBox(height: AppDimensions.spaceLG),

                      // ── Overview Section ───────────────────────────
                      _SectionHeader(
                        icon: Icons.article_rounded,
                        title: 'Internship Overview',
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      Text(
                        internship.description.isNotEmpty
                            ? internship.description
                            : 'No specific overview provided for this position.',
                        style: tt.bodyLarge?.copyWith(
                          height: 1.65,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceLG),

                      // ── Key Responsibilities (Optional) ────────────
                      if (internship.responsibilities.isNotEmpty) ...[
                        _SectionHeader(
                          icon: Icons.checklist_rounded,
                          title: 'Key Responsibilities',
                        ),
                        const SizedBox(height: AppDimensions.spaceSM),
                        ...internship.responsibilities.map((item) {
                          return _ListItemRow(
                            icon: Icons.check_circle_outline_rounded,
                            iconColor: AppColors.primary,
                            text: item,
                            isDark: isDark,
                          );
                        }),
                        const SizedBox(height: AppDimensions.spaceLG),
                      ],

                      // ── Required & Emphasized Skills (Optional) ────
                      if (internship.skills.isNotEmpty) ...[
                        _SectionHeader(
                          icon: Icons.military_tech_rounded,
                          title: 'Required & Emphasized Skills',
                        ),
                        const SizedBox(height: AppDimensions.spaceSM),
                        Wrap(
                          spacing: AppDimensions.spaceSM,
                          runSpacing: AppDimensions.spaceSM,
                          children: internship.skills.map((skill) {
                            return _SkillChip(label: skill, isDark: isDark);
                          }).toList(),
                        ),
                        const SizedBox(height: AppDimensions.spaceLG),
                      ],

                      // ── Learning Outcomes (Optional) ───────────────
                      if (internship.learningOutcomes.isNotEmpty) ...[
                        _SectionHeader(
                          icon: Icons.school_rounded,
                          title: 'Learning Outcomes',
                        ),
                        const SizedBox(height: AppDimensions.spaceSM),
                        ...internship.learningOutcomes.map((outcome) {
                          return _ListItemRow(
                            icon: Icons.verified_rounded,
                            iconColor: AppColors.accent,
                            text: outcome,
                            isDark: isDark,
                          );
                        }),
                        const SizedBox(height: AppDimensions.spaceLG),
                      ],

                      // ── Why Intern at CodeNova (Verified Benefits) ─
                      _SectionHeader(
                        icon: Icons.workspace_premium_rounded,
                        title: 'Why Intern at CodeNova',
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      _WhyInternCard(isDark: isDark),
                      const SizedBox(height: AppDimensions.spaceLG),

                      // ── Company & Location Details ─────────────────
                      _SectionHeader(
                        icon: Icons.business_rounded,
                        title: 'Company Information',
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      _CompanyInfoCard(isDark: isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Sticky Bottom CTA Bar ───────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _StickyCtaBar(
              internship: internship,
              onApply: () => _showApplyModal(context, internship),
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  void _showApplyModal(BuildContext context, InternshipModel internship) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InternshipApplicationSheet(internship: internship),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── SUBWIDGETS & SECTIONS ─────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════

/// Gradient Hero Header shown in SliverAppBar
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.internship});

  final InternshipModel internship;

  @override
  Widget build(BuildContext context) {
    final status = internship.status;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            Color(0xFF0F3E74),
            Color(0xFF0A2B52),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background geometric accent
          Positioned(
            right: -30,
            top: -20,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(12),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withAlpha(20),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.spaceMD,
              AppDimensions.spaceXXL + AppDimensions.spaceMD,
              AppDimensions.spaceMD,
              AppDimensions.spaceMD,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Domain Icon badge
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMD),
                        border: Border.all(color: Colors.white.withAlpha(45)),
                      ),
                      child: Icon(
                        internship.icon,
                        color: Colors.white,
                        size: AppDimensions.iconMD,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMD),

                    // Status pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spaceSM + 2,
                        vertical: AppDimensions.spaceXXS + 1,
                      ),
                      decoration: BoxDecoration(
                        color: status.color.withAlpha(50),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusCircle),
                        border: Border.all(color: status.color.withAlpha(120)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(status.icon, size: 12, color: status.color),
                          const SizedBox(width: 4),
                          Text(
                            status.label,
                            style: TextStyle(
                              fontSize: AppTextSizes.xs,
                              fontWeight: FontWeight.w700,
                              color: status.color,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (internship.mode != null) ...[
                      const SizedBox(width: AppDimensions.spaceXS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceSM,
                          vertical: AppDimensions.spaceXXS + 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusCircle),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(internship.mode!.icon,
                                size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              internship.mode!.label,
                              style: const TextStyle(
                                fontSize: AppTextSizes.xs,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceSM),

                // Title
                Text(
                  internship.title,
                  style: const TextStyle(
                    fontSize: AppTextSizes.heading,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spaceXXS),

                // Domain subtitle
                Text(
                  internship.domain,
                  style: TextStyle(
                    fontSize: AppTextSizes.sm,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(200),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick parameters strip showing Duration, Mode, Category, and Status
class _QuickInfoStrip extends StatelessWidget {
  const _QuickInfoStrip({
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
          // Duration
          Expanded(
            child: _ParamItem(
              icon: Icons.access_time_rounded,
              label: 'Duration',
              value: internship.duration.isNotEmpty
                  ? internship.duration
                  : 'Unspecified',
              iconColor: AppColors.accent,
              isDark: isDark,
            ),
          ),
          Container(
            height: 36,
            width: 1,
            color: border,
          ),

          // Work Mode
          Expanded(
            child: _ParamItem(
              icon: internship.mode?.icon ?? Icons.computer_rounded,
              label: 'Work Mode',
              value: internship.mode?.label ?? 'Not Specified',
              iconColor: AppColors.secondary,
              isDark: isDark,
            ),
          ),
          Container(
            height: 36,
            width: 1,
            color: border,
          ),

          // Category
          Expanded(
            child: _ParamItem(
              icon: Icons.category_rounded,
              label: 'Domain',
              value: internship.techCategory,
              iconColor: AppColors.primary,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParamItem extends StatelessWidget {
  const _ParamItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppTextSizes.xs,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: AppTextSizes.sm,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Section title with consistent icon prefix
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
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(22),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconSM + 2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSM),
        Text(
          title,
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Row item for responsibilities and learning outcomes
class _ListItemRow extends StatelessWidget {
  const _ListItemRow({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.isDark,
  });

  final IconData icon;
  final Color iconColor;
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.backgroundCard : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceSM),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(color: border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: AppDimensions.spaceMD),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: AppTextSizes.sm,
                  height: 1.5,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skill chip for required/emphasized skills
class _SkillChip extends StatelessWidget {
  const _SkillChip({
    required this.label,
    required this.isDark,
  });

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical: AppDimensions.spaceXS + 2,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundCard : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTextSizes.sm,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card with verified company pillars
class _WhyInternCard extends StatelessWidget {
  const _WhyInternCard({required this.isDark});

  final bool isDark;

  static const _pillars = [
    _Pillar(
      Icons.person_pin_rounded,
      'Industry Mentorship',
      'Learn directly from seasoned software engineers with active production experience.',
    ),
    _Pillar(
      Icons.code_rounded,
      'Live Client Deliverables',
      'Build and commit code to genuine deliverables instead of theoretical mock assignments.',
    ),
    _Pillar(
      Icons.verified_user_rounded,
      'Verifiable Certification',
      'Earn an official, verifiable internship certificate issued by CodeNova Tech Solutions.',
    ),
  ];

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
      child: Column(
        children: _pillars.asMap().entries.map((entry) {
          final isLast = entry.key == _pillars.length - 1;
          final p = entry.value;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spaceXS + 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(isDark ? 45 : 20),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSM),
                      ),
                      child: Icon(p.icon,
                          size: 18,
                          color: isDark ? AppColors.accent : AppColors.primary),
                    ),
                    const SizedBox(width: AppDimensions.spaceMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            style: const TextStyle(
                              fontSize: AppTextSizes.body,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.desc,
                            style: TextStyle(
                              fontSize: AppTextSizes.sm,
                              height: 1.4,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: AppDimensions.spaceMD,
                  color: border,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _Pillar {
  const _Pillar(this.icon, this.title, this.desc);
  final IconData icon;
  final String title;
  final String desc;
}

/// Official company contact card
class _CompanyInfoCard extends StatelessWidget {
  const _CompanyInfoCard({required this.isDark});

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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                child: const Center(
                  child: Text(
                    'CN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: const TextStyle(
                        fontSize: AppTextSizes.body,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      AppStrings.address,
                      style: TextStyle(
                        fontSize: AppTextSizes.xs,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Divider(height: 1, color: border),
          const SizedBox(height: AppDimensions.spaceMD),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => AppUtils.launchEmail(
                    AppStrings.email,
                    subject: 'Internship Enquiry',
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.email_outlined,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            AppStrings.email,
                            style: const TextStyle(
                              fontSize: AppTextSizes.xs,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSM),
              Expanded(
                child: InkWell(
                  onTap: () => AppUtils.launchPhone(AppStrings.phoneDialable),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone_outlined,
                            size: 16, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text(
                          AppStrings.phone,
                          style: TextStyle(
                            fontSize: AppTextSizes.xs,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sticky bottom CTA bar with responsive status handling
class _StickyCtaBar extends StatelessWidget {
  const _StickyCtaBar({
    required this.internship,
    required this.onApply,
    required this.isDark,
  });

  final InternshipModel internship;
  final VoidCallback onApply;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final status = internship.status;
    final isOpen = status == InternshipStatus.open;
    final isComingSoon = status == InternshipStatus.comingSoon;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.spaceMD,
        AppDimensions.spaceMD,
        AppDimensions.spaceMD,
        MediaQuery.of(context).padding.bottom + AppDimensions.spaceMD,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundCard : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        children: [
          // Secondary Call button
          IconButton.outlined(
            icon: const Icon(Icons.phone_rounded),
            tooltip: 'Call HR',
            onPressed: () => AppUtils.launchPhone(AppStrings.phoneDialable),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),

          // Primary Apply / Status button
          Expanded(
            child: AppButton(
              label: isOpen
                  ? 'Apply Now'
                  : (isComingSoon ? 'Express Interest' : 'Applications Closed'),
              icon: isOpen
                  ? Icons.arrow_forward_rounded
                  : (isComingSoon ? Icons.schedule_rounded : Icons.block_rounded),
              isFullWidth: true,
              onPressed: isOpen || isComingSoon ? onApply : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom Sheet for application submission / channels
class _InternshipApplicationSheet extends StatelessWidget {
  const _InternshipApplicationSheet({required this.internship});

  final InternshipModel internship;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor =
        isDark ? AppColors.backgroundCard : AppColors.surfaceLight;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.spaceLG,
        AppDimensions.spaceMD,
        AppDimensions.spaceLG,
        MediaQuery.of(context).padding.bottom + AppDimensions.spaceLG,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Icon(internship.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: AppDimensions.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apply for Position',
                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      internship.title,
                      style: tt.bodySmall?.copyWith(
                        color: isDark ? AppColors.accent : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Instructions
          Text(
            'To apply for this internship, submit your resume and details via email or call our team directly.',
            style: tt.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Direct Actions
          AppButton(
            label: 'Send Resume via Email',
            icon: Icons.email_rounded,
            isFullWidth: true,
            onPressed: () {
              Navigator.pop(context);
              AppUtils.launchEmail(
                AppStrings.email,
                subject: 'Internship Application – ${internship.title}',
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          AppButton.outline(
            label: 'Call CodeNova (${AppStrings.phone})',
            icon: Icons.phone_rounded,
            isFullWidth: true,
            onPressed: () {
              Navigator.pop(context);
              AppUtils.launchPhone(AppStrings.phoneDialable);
            },
          ),
        ],
      ),
    );
  }
}

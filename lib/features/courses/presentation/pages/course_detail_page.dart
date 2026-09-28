import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/course_model.dart';

// ── Per-course verified learning topics ────────────────────────────────────
// All topics are derived from the course subtitle and verified category.
// No syllabus details are invented.
Map<String, List<_TopicItem>> _courseTopics(CourseModel course) {
  switch (course.id) {
    case 'full-stack-dev':
      return {
        'Frontend': [
          const _TopicItem(Icons.code_rounded, 'HTML5 & CSS3 Fundamentals'),
          const _TopicItem(Icons.javascript, 'JavaScript Core & ES6+'),
          const _TopicItem(Icons.web_rounded, 'Responsive Web Design'),
          const _TopicItem(Icons.widgets_rounded, 'React Framework'),
        ],
        'Backend & Tools': [
          const _TopicItem(Icons.terminal_rounded, 'RESTful API Integration'),
          const _TopicItem(Icons.source_rounded, 'Version Control with Git'),
          const _TopicItem(Icons.folder_rounded, 'Project Architecture'),
        ],
      };
    case 'android-dev':
      return {
        'Core Android': [
          const _TopicItem(Icons.phone_android_rounded, 'Android Studio Setup'),
          const _TopicItem(Icons.code_rounded, 'Java & Kotlin Basics'),
          const _TopicItem(Icons.layers_rounded, 'Activity & Fragment Lifecycle'),
          const _TopicItem(Icons.view_quilt_rounded, 'UI Design with XML & Compose'),
        ],
        'Advanced Concepts': [
          const _TopicItem(Icons.storage_rounded, 'SQLite & Room Database'),
          const _TopicItem(Icons.wifi_rounded, 'Networking & REST APIs'),
          const _TopicItem(Icons.source_rounded, 'Git Workflow & Deployment'),
        ],
      };
    case 'python-programming':
      return {
        'Python Core': [
          const _TopicItem(Icons.terminal_rounded, 'Python Syntax & Data Types'),
          const _TopicItem(Icons.functions_rounded, 'Functions & Modules'),
          const _TopicItem(Icons.class_rounded, 'Object-Oriented Programming'),
          const _TopicItem(Icons.error_outline_rounded, 'Exception Handling'),
        ],
        'Applied Python': [
          const _TopicItem(Icons.folder_open_rounded, 'File I/O & Libraries'),
          const _TopicItem(Icons.build_rounded, 'Automation & Scripting'),
          const _TopicItem(Icons.assignment_rounded, 'Hands-on Project Work'),
        ],
      };
    case 'java-programming':
      return {
        'Java Foundations': [
          const _TopicItem(Icons.computer_rounded, 'Java Syntax & Data Types'),
          const _TopicItem(Icons.functions_rounded, 'Methods & Control Flow'),
          const _TopicItem(Icons.class_rounded, 'OOP: Classes & Inheritance'),
          const _TopicItem(Icons.list_rounded, 'Collections & Generics'),
        ],
        'Advanced Java': [
          const _TopicItem(Icons.storage_rounded, 'Data Structures & Algorithms'),
          const _TopicItem(Icons.error_outline_rounded, 'Exception Handling'),
          const _TopicItem(Icons.assignment_rounded, 'Real-World Project Practice'),
        ],
      };
    case 'data-science':
      return {
        'Data Foundations': [
          const _TopicItem(Icons.terminal_rounded, 'Python & R for Data Science'),
          const _TopicItem(Icons.bar_chart_rounded, 'Data Visualization'),
          const _TopicItem(Icons.analytics_rounded, 'Statistical Analysis'),
          const _TopicItem(Icons.cleaning_services_rounded, 'Data Cleaning & Prep'),
        ],
        'Machine Learning': [
          const _TopicItem(Icons.psychology_rounded, 'ML Algorithms & Models'),
          const _TopicItem(Icons.model_training_rounded, 'Model Evaluation'),
          const _TopicItem(Icons.assignment_rounded, 'Real-World Data Projects'),
        ],
      };
    case 'artificial-intelligence':
      return {
        'AI Foundations': [
          const _TopicItem(Icons.psychology_rounded, 'AI Concepts & History'),
          const _TopicItem(Icons.account_tree_rounded, 'Neural Networks & Deep Learning'),
          const _TopicItem(Icons.model_training_rounded, 'Training & Optimization'),
          const _TopicItem(Icons.search_rounded, 'Search & Problem Solving'),
        ],
        'Applied AI': [
          const _TopicItem(Icons.text_fields_rounded, 'Natural Language Processing'),
          const _TopicItem(Icons.remove_red_eye_rounded, 'Computer Vision Basics'),
          const _TopicItem(Icons.assignment_rounded, 'Intelligent System Projects'),
        ],
      };
    default:
      return {};
  }
}

/// Verified course benefit bullets shown to all programs.
const _verifiedBenefits = [
  _BenefitItem(
    Icons.person_rounded,
    'Mentor-Guided Learning',
    'One-on-one and group mentorship from industry-experienced developers.',
  ),
  _BenefitItem(
    Icons.build_rounded,
    'Hands-on Projects',
    'Build real-world applications, not just theory — work you can put in your portfolio.',
  ),
  _BenefitItem(
    Icons.verified_rounded,
    'Completion Certificate',
    'Receive a verifiable completion certificate from CodeNova Tech Solutions.',
  ),
  _BenefitItem(
    Icons.groups_rounded,
    'Batch Training',
    'Small batch sizes ensure personalized attention and collaborative learning.',
  ),
];

// ── Internal data models ────────────────────────────────────────────────────
class _TopicItem {
  const _TopicItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

class _BenefitItem {
  const _BenefitItem(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

// ══════════════════════════════════════════════════════════════════════════════
/// Full-screen Course Detail page for CodeNova Tech Solutions.
///
/// Receives a [CourseModel] through the router extra payload or directly.
/// Supports missing optional info gracefully.
/// Prepared for future backend integration.
// ══════════════════════════════════════════════════════════════════════════════
class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({super.key, required this.course});

  final CourseModel course;

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heroController;
  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 520),
      vsync: this,
    )..forward();

    _heroFade = CurvedAnimation(
      parent: _heroController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  Color _levelColor(CourseLevel level) {
    switch (level) {
      case CourseLevel.beginner:
        return AppColors.success;
      case CourseLevel.intermediate:
        return AppColors.warning;
      case CourseLevel.advanced:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final course = widget.course;
    final topics = _courseTopics(course);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ── Main Scrollable Content ──────────────────────────────────
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Gradient Hero SliverAppBar ─────────────────────────
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [StretchMode.zoomBackground],
                  background: _HeroHeader(
                    course: course,
                    fadeAnimation: _heroFade,
                    slideAnimation: _heroSlide,
                    levelColor: _levelColor(course.level),
                  ),
                ),
                leading: Semantics(
                  label: 'Go back',
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white),
                    tooltip: 'Share course',
                    onPressed: () {
                      // Future: deep-link share
                    },
                  ),
                ],
              ),

              // ── Body Sections ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.spaceMD,
                    AppDimensions.spaceLG,
                    AppDimensions.spaceMD,
                    // Extra bottom padding for the sticky CTA bar
                    AppDimensions.spaceXXL + AppDimensions.spaceLG + 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Quick Info Row ─────────────────────────────
                      _QuickInfoRow(course: course, isDark: isDark),
                      const SizedBox(height: AppDimensions.spaceLG),

                      // ── Programme Overview ─────────────────────────
                      _SectionHeader(
                        icon: Icons.description_rounded,
                        title: 'Programme Overview',
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      Text(
                        course.description,
                        style: tt.bodyLarge?.copyWith(
                          height: 1.65,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceLG),

                      // ── Technologies & Tags ────────────────────────
                      if (course.tags.isNotEmpty) ...[
                        _SectionHeader(
                          icon: Icons.memory_rounded,
                          title: 'Technologies Covered',
                        ),
                        const SizedBox(height: AppDimensions.spaceSM),
                        Wrap(
                          spacing: AppDimensions.spaceSM,
                          runSpacing: AppDimensions.spaceSM,
                          children: course.tags.map((tag) {
                            return _TechChip(label: tag, isDark: isDark);
                          }).toList(),
                        ),
                        const SizedBox(height: AppDimensions.spaceLG),
                      ],

                      // ── Learning Topics (per-course) ───────────────
                      if (topics.isNotEmpty) ...[
                        _SectionHeader(
                          icon: Icons.menu_book_rounded,
                          title: 'What You\'ll Learn',
                        ),
                        const SizedBox(height: AppDimensions.spaceSM),
                        ...topics.entries.map((entry) {
                          return _TopicGroup(
                            groupTitle: entry.key,
                            topics: entry.value,
                            isDark: isDark,
                          );
                        }),
                        const SizedBox(height: AppDimensions.spaceSM),
                      ],

                      // ── Course Benefits ────────────────────────────
                      _SectionHeader(
                        icon: Icons.star_rounded,
                        title: 'Programme Benefits',
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      ..._verifiedBenefits.map((b) {
                        return _BenefitRow(benefit: b, isDark: isDark);
                      }),
                      const SizedBox(height: AppDimensions.spaceLG),

                      // ── Verified Highlight Banner ──────────────────
                      _VerifiedBanner(isDark: isDark),
                      const SizedBox(height: AppDimensions.spaceLG),

                      // ── Contact Channels ───────────────────────────
                      _SectionHeader(
                        icon: Icons.contact_support_rounded,
                        title: 'Get in Touch',
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),
                      _ContactInfoCard(isDark: isDark),
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
            child: _StickyCTABar(course: widget.course),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── HERO HEADER ──────────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.course,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.levelColor,
  });

  final CourseModel course;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Color levelColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, Color(0xFF0D3A6B)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spaceLG,
            AppDimensions.spaceXXL + AppDimensions.spaceSM,
            AppDimensions.spaceLG,
            AppDimensions.spaceLG,
          ),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Category Eyebrow
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceSM,
                          vertical: AppDimensions.spaceXXS + 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(28),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXS,
                          ),
                          border: Border.all(
                            color: Colors.white.withAlpha(50),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          course.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: AppTextSizes.xs,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      if (course.isFeatured) ...[
                        const SizedBox(width: AppDimensions.spaceSM),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceSM,
                            vertical: AppDimensions.spaceXXS + 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withAlpha(200),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXS,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_rounded,
                                  size: 12, color: Colors.white),
                              SizedBox(width: 3),
                              Text(
                                'FEATURED',
                                style: TextStyle(
                                  fontSize: AppTextSizes.xs,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceSM),

                  // Course Title
                  Text(
                    course.title,
                    style: tt.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: AppTextSizes.display,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXS),

                  // Subtitle / Stack Summary
                  Text(
                    course.subtitle,
                    style: tt.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(180),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spaceMD),

                  // Duration & Level Badges Row
                  Row(
                    children: [
                      _HeroBadge(
                        icon: Icons.access_time_rounded,
                        label: course.duration,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: AppDimensions.spaceSM),
                      _HeroBadge(
                        icon: Icons.signal_cellular_alt_rounded,
                        label: course.level.label,
                        color: levelColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSM + 2,
        vertical: AppDimensions.spaceXXS + 2,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(35),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTextSizes.xs,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── QUICK INFO ROW ────────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _QuickInfoRow extends StatelessWidget {
  const _QuickInfoRow({required this.course, required this.isDark});

  final CourseModel course;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColors.backgroundCard : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickInfoItem(
            icon: Icons.access_time_rounded,
            label: 'Duration',
            value: course.duration,
            color: AppColors.accent,
          ),
          _Divider(isDark: isDark),
          _QuickInfoItem(
            icon: Icons.signal_cellular_alt_rounded,
            label: 'Level',
            value: course.level.label,
            color: AppColors.primary,
          ),
          _Divider(isDark: isDark),
          _QuickInfoItem(
            icon: Icons.build_rounded,
            label: 'Projects',
            value: 'Included',
            color: AppColors.success,
          ),
          _Divider(isDark: isDark),
          _QuickInfoItem(
            icon: Icons.verified_rounded,
            label: 'Certificate',
            value: 'Yes',
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}

class _QuickInfoItem extends StatelessWidget {
  const _QuickInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, size: AppDimensions.iconSM + 2, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: tt.labelLarge?.copyWith(
            fontSize: AppTextSizes.sm,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: tt.bodySmall?.copyWith(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── SECTION HEADER ────────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          ),
          child: Icon(icon, color: Colors.white, size: AppDimensions.iconSM + 2),
        ),
        const SizedBox(width: AppDimensions.spaceSM + 2),
        Text(
          title,
          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── TECH CHIP ─────────────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _TechChip extends StatelessWidget {
  const _TechChip({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD - 2,
        vertical: AppDimensions.spaceXS + 2,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withAlpha(40)
            : AppColors.primary.withAlpha(18),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withAlpha(80)
              : AppColors.primary.withAlpha(50),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppTextSizes.sm,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.accent : AppColors.primary,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── TOPIC GROUP ──────────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _TopicGroup extends StatelessWidget {
  const _TopicGroup({
    required this.groupTitle,
    required this.topics,
    required this.isDark,
  });

  final String groupTitle;
  final List<_TopicItem> topics;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final surfaceColor = isDark ? AppColors.backgroundSurface : AppColors.neutral50;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spaceMD,
                AppDimensions.spaceSM + 2,
                AppDimensions.spaceMD,
                AppDimensions.spaceSM,
              ),
              child: Text(
                groupTitle,
                style: tt.labelLarge?.copyWith(
                  fontSize: AppTextSizes.sm,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const Divider(height: 1),
            // Topic items
            ...topics.asMap().entries.map((entry) {
              final isLast = entry.key == topics.length - 1;
              final topic = entry.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceMD,
                      vertical: AppDimensions.spaceSM + 2,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(20),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXS + 2,
                            ),
                          ),
                          child: Icon(
                            topic.icon,
                            size: AppDimensions.iconSM - 1,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceSM + 2),
                        Expanded(
                          child: Text(
                            topic.label,
                            style: tt.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.check_circle_rounded,
                          size: AppDimensions.iconSM,
                          color: AppColors.success.withAlpha(200),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: AppDimensions.spaceMD,
                      endIndent: AppDimensions.spaceMD,
                      color: borderColor,
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── BENEFIT ROW ──────────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.benefit, required this.isDark});

  final _BenefitItem benefit;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(isDark ? 45 : 18),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: Icon(
              benefit.icon,
              size: AppDimensions.iconSM + 4,
              color: isDark ? AppColors.accent : AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit.title,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  benefit.description,
                  style: tt.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                    height: 1.5,
                    fontSize: AppTextSizes.sm,
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

// ══════════════════════════════════════════════════════════════════════════════
// ── VERIFIED HIGHLIGHT BANNER ─────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _VerifiedBanner extends StatelessWidget {
  const _VerifiedBanner({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primary.withAlpha(isDark ? 55 : 22),
            AppColors.accent.withAlpha(isDark ? 40 : 15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: AppColors.primary.withAlpha(isDark ? 80 : 50),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(isDark ? 60 : 25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: AppColors.primary,
              size: AppDimensions.iconMD + 4,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verified Training Programme',
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Mentored, hands-on training with a verifiable completion certificate from CodeNova Tech Solutions.',
                  style: tt.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                    height: 1.5,
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

// ══════════════════════════════════════════════════════════════════════════════
// ── CONTACT INFO CARD ─────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _ContactInfoCard extends StatelessWidget {
  const _ContactInfoCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final surfaceColor = isDark ? AppColors.backgroundCard : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _ContactRow(
            icon: Icons.email_rounded,
            label: AppStrings.email,
            color: AppColors.primary,
            onTap: () => AppUtils.launchEmail(AppStrings.email),
            isDark: isDark,
            tt: tt,
          ),
          Divider(height: AppDimensions.spaceMD * 2, color: borderColor),
          _ContactRow(
            icon: Icons.phone_rounded,
            label: AppStrings.phone,
            color: AppColors.success,
            onTap: () => AppUtils.launchPhone(AppStrings.phoneDialable),
            isDark: isDark,
            tt: tt,
          ),
          Divider(height: AppDimensions.spaceMD * 2, color: borderColor),
          _ContactRow(
            icon: Icons.location_on_rounded,
            label: AppStrings.address,
            color: AppColors.secondary,
            onTap: null,
            isDark: isDark,
            tt: tt,
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.isDark,
    required this.tt,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool isDark;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXXS),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              ),
              child: Icon(icon, size: AppDimensions.iconSM + 2, color: color),
            ),
            const SizedBox(width: AppDimensions.spaceMD),
            Expanded(
              child: Text(
                label,
                style: tt.bodyMedium?.copyWith(
                  fontWeight: onTap != null ? FontWeight.w600 : FontWeight.w500,
                  color: onTap != null
                      ? (isDark ? AppColors.accent : AppColors.primary)
                      : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary),
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── STICKY CTA BAR ────────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _StickyCTABar extends StatelessWidget {
  const _StickyCTABar({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundCard : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.spaceMD,
        right: AppDimensions.spaceMD,
        top: AppDimensions.spaceSM + 2,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.spaceSM + 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Call button (secondary)
          Semantics(
            label: 'Call CodeNova Tech Solutions',
            child: SizedBox(
              height: AppDimensions.buttonHeight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceMD,
                  ),
                  side: BorderSide(
                    color: isDark ? AppColors.accent : AppColors.primary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                ),
                onPressed: () => AppUtils.launchPhone(AppStrings.phoneDialable),
                child: Icon(
                  Icons.phone_rounded,
                  color: isDark ? AppColors.accent : AppColors.primary,
                  size: AppDimensions.iconMD,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSM),

          // Enquire button (primary)
          Expanded(
            child: Semantics(
              label: 'Enquire about ${course.title} batch',
              child: AppButton(
                label: 'Enquire for Batch',
                icon: Icons.chat_bubble_outline_rounded,
                isFullWidth: true,
                onPressed: () {
                  AppUtils.launchEmail(
                    AppStrings.email,
                    subject: 'Batch Enquiry – ${course.title}',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/internship_model.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Dashboard overview displaying statistics, metrics, and recent audit activity.
class AdminOverviewView extends StatelessWidget {
  const AdminOverviewView({
    super.key,
    required this.controller,
  });

  final AdminDashboardController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeCoursesCount = controller.courses.where((c) => c.isFeatured).length;
    final openInternshipsCount =
        controller.internships.where((i) => i.status == InternshipStatus.open).length;
    final activeCertificatesCount = controller.certificates.where((c) => c.isActive).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Status Banner
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrative Command Center',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        'Monitor student applications, manage verified courses, process enterprise quotes, and issue verifiable digital credentials.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMD),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_rounded, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'DPDP Protected',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // Stat Cards Grid
          Text(
            'Operational Metrics',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppDimensions.spaceMD,
                mainAxisSpacing: AppDimensions.spaceMD,
                childAspectRatio: 1.8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _MetricCard(
                    title: 'Active Courses',
                    value: '$activeCoursesCount / ${controller.courses.length}',
                    subtitle: 'Published on Mobile App',
                    icon: Icons.school_rounded,
                    color: AppColors.primary,
                    onTap: () => controller.setTab(AdminTab.courses),
                  ),
                  _MetricCard(
                    title: 'Open Internships',
                    value: '$openInternshipsCount / ${controller.internships.length}',
                    subtitle: 'Accepting Applicants',
                    icon: Icons.work_rounded,
                    color: AppColors.accent,
                    onTap: () => controller.setTab(AdminTab.internships),
                  ),
                  _MetricCard(
                    title: 'Student Applications',
                    value: '${controller.applications.length}',
                    subtitle: 'Candidates in Review',
                    icon: Icons.people_rounded,
                    color: AppColors.secondary,
                    onTap: () => controller.setTab(AdminTab.applications),
                  ),
                  _MetricCard(
                    title: 'Verified Certificates',
                    value: '$activeCertificatesCount',
                    subtitle: 'Issued & Verifiable',
                    icon: Icons.card_membership_rounded,
                    color: AppColors.success,
                    onTap: () => controller.setTab(AdminTab.certificates),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // Quick Action Shortcuts
          Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Wrap(
            spacing: AppDimensions.spaceMD,
            runSpacing: AppDimensions.spaceMD,
            children: [
              ActionChip(
                avatar: const Icon(Icons.add_circle_outline_rounded, size: 16),
                label: const Text('Manage Courses'),
                onPressed: () => controller.setTab(AdminTab.courses),
              ),
              ActionChip(
                avatar: const Icon(Icons.person_search_rounded, size: 16),
                label: const Text('Review Applications Pipeline'),
                onPressed: () => controller.setTab(AdminTab.applications),
              ),
              ActionChip(
                avatar: const Icon(Icons.verified_outlined, size: 16),
                label: const Text('Issue New Certificate'),
                onPressed: () => controller.setTab(AdminTab.certificates),
              ),
              ActionChip(
                avatar: const Icon(Icons.security_rounded, size: 16),
                label: const Text('Inspect DPDP Audit Ledger'),
                onPressed: () => controller.setTab(AdminTab.auditLogs),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // Recent Audit Activity Log
          Text(
            'Recent Audit Log Events',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          AppCard(
            padding: EdgeInsets.zero,
            child: controller.auditLogs.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(AppDimensions.spaceLG),
                    child: Center(child: Text('No audit events recorded yet.')),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.auditLogs.take(5).length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final log = controller.auditLogs[index];
                      return ListTile(
                        dense: true,
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.backgroundCard : AppColors.backgroundLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.security_rounded, size: 16, color: AppColors.primary),
                        ),
                        title: Text(
                          log.action,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        subtitle: Text(
                          '${log.details}\nStaff: ${log.adminEmail}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                          ),
                        ),
                        trailing: Text(
                          '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

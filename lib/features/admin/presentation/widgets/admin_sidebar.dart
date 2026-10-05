import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../controllers/admin_auth_controller.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Desktop/Tablet sidebar navigation for CodeNova Admin Portal.
class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.activeTab,
    required this.onSelectTab,
    required this.dashboardController,
  });

  final AdminTab activeTab;
  final ValueChanged<AdminTab> onSelectTab;
  final AdminDashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = AdminAuthController.instance;
    final currentAdmin = auth.currentAdmin;

    final navItems = [
      _NavItem(
        tab: AdminTab.overview,
        label: 'Dashboard Overview',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard_rounded,
      ),
      if (currentAdmin?.canManageCourses ?? true)
        _NavItem(
          tab: AdminTab.courses,
          label: 'Course Catalog',
          icon: Icons.school_outlined,
          activeIcon: Icons.school_rounded,
          badgeCount: dashboardController.courses.length,
        ),
      if (currentAdmin?.canManageInternships ?? true)
        _NavItem(
          tab: AdminTab.internships,
          label: 'Internship Openings',
          icon: Icons.work_outline_rounded,
          activeIcon: Icons.work_rounded,
          badgeCount: dashboardController.internships.length,
        ),
      if (currentAdmin?.canViewApplications ?? true)
        _NavItem(
          tab: AdminTab.applications,
          label: 'Applications Pipeline',
          icon: Icons.people_outline_rounded,
          activeIcon: Icons.people_rounded,
          badgeCount: dashboardController.applications.length,
          badgeColor: AppColors.accent,
        ),
      if (currentAdmin?.canManageQuotes ?? true)
        _NavItem(
          tab: AdminTab.quotes,
          label: 'Quotes & Inquiries',
          icon: Icons.request_quote_outlined,
          activeIcon: Icons.request_quote_rounded,
          badgeCount: dashboardController.quotes.length + dashboardController.enquiries.length,
        ),
      if (currentAdmin?.canManageCertificates ?? true)
        _NavItem(
          tab: AdminTab.certificates,
          label: 'Verified Certificates',
          icon: Icons.card_membership_outlined,
          activeIcon: Icons.card_membership_rounded,
          badgeCount: dashboardController.certificates.length,
          badgeColor: AppColors.secondary,
        ),
      if (currentAdmin?.canViewAuditLogs ?? true)
        _NavItem(
          tab: AdminTab.auditLogs,
          label: 'DPDP Audit Ledger',
          icon: Icons.security_outlined,
          activeIcon: Icons.security_rounded,
        ),
    ];

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundCard : AppColors.cardLight,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Column(
        children: [
          // Brand Header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceSM),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceSM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CodeNova',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Admin Portal',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Nav Items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spaceMD,
                horizontal: AppDimensions.spaceSM,
              ),
              itemCount: navItems.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = activeTab == item.tab;

                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppColors.primary.withValues(alpha: 0.12),
                    leading: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textMuted),
                      size: 20,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? AppColors.primary : null,
                        fontSize: 13,
                      ),
                    ),
                    trailing: item.badgeCount != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (item.badgeColor ?? AppColors.primary).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${item.badgeCount}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: item.badgeColor ?? AppColors.primary,
                              ),
                            ),
                          )
                        : null,
                    onTap: () => onSelectTab(item.tab),
                  ),
                );
              },
            ),
          ),

          // User & Session Footer
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      child: Text(
                        (currentAdmin?.fullName.characters.first ?? 'A').toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceSM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentAdmin?.fullName ?? 'Administrator',
                            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            currentAdmin?.role.displayName ?? 'Staff',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 16, color: AppColors.error),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(color: AppColors.error, fontSize: 12),
                    ),
                    onPressed: () async {
                      await auth.logout();
                    },
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

class _NavItem {
  const _NavItem({
    required this.tab,
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.badgeCount,
    this.badgeColor,
  });

  final AdminTab tab;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int? badgeCount;
  final Color? badgeColor;
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../controllers/admin_auth_controller.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../widgets/admin_applications_view.dart';
import '../widgets/admin_audit_log_view.dart';
import '../widgets/admin_certificates_view.dart';
import '../widgets/admin_courses_view.dart';
import '../widgets/admin_internships_view.dart';
import '../widgets/admin_overview_view.dart';
import '../widgets/admin_quotes_view.dart';
import '../widgets/admin_sidebar.dart';

/// Main responsive administrative portal page.
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({
    super.key,
    this.controller,
  });

  final AdminDashboardController? controller;

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late final AdminDashboardController _dashboardController;

  @override
  void initState() {
    super.initState();
    _dashboardController = widget.controller ?? AdminDashboardController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _dashboardController.dispose();
    }
    super.dispose();
  }

  Widget _buildActiveView(AdminTab tab) {
    switch (tab) {
      case AdminTab.overview:
        return AdminOverviewView(controller: _dashboardController);
      case AdminTab.courses:
        return AdminCoursesView(controller: _dashboardController);
      case AdminTab.internships:
        return AdminInternshipsView(controller: _dashboardController);
      case AdminTab.applications:
        return AdminApplicationsView(controller: _dashboardController);
      case AdminTab.quotes:
        return AdminQuotesView(controller: _dashboardController);
      case AdminTab.certificates:
        return AdminCertificatesView(controller: _dashboardController);
      case AdminTab.auditLogs:
        return AdminAuditLogView(controller: _dashboardController);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = AdminAuthController.instance;
    final currentAdmin = auth.currentAdmin;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 800;

    return ListenableBuilder(
      listenable: _dashboardController,
      builder: (context, _) {
        final activeTab = _dashboardController.activeTab;

        final sidebar = AdminSidebar(
          activeTab: activeTab,
          onSelectTab: (tab) {
            _dashboardController.setTab(tab);
            if (!isDesktop && Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          dashboardController: _dashboardController,
        );

        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
          drawer: isDesktop ? null : Drawer(child: sidebar),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: isDark ? AppColors.backgroundCard : AppColors.cardLight,
            title: Row(
              children: [
                Text(
                  activeTab.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: AppDimensions.spaceSM),
                if (currentAdmin != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                    ),
                    child: Text(
                      currentAdmin.role.displayName,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20),
                tooltip: 'Refresh Data',
                onPressed: () => _dashboardController.loadData(),
              ),
              TextButton.icon(
                icon: const Icon(Icons.smartphone_rounded, size: 16),
                label: const Text('Mobile App', style: TextStyle(fontSize: 12)),
                onPressed: () => context.go(AppStrings.routeHome),
              ),
              const SizedBox(width: AppDimensions.spaceSM),
            ],
          ),
          body: Row(
            children: [
              if (isDesktop) sidebar,
              Expanded(
                child: _dashboardController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildActiveView(activeTab),
              ),
            ],
          ),
        );
      },
    );
  }
}

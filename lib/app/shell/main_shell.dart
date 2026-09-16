import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/constants.dart';

/// Persistent shell that hosts the [NavigationBar] and page [child].
///
/// Responsibilities:
///   • Render the Material 3 [NavigationBar] at all times.
///   • Map GoRouter location → active tab index.
///   • Navigate via [GoRouter.go] on tab tap.
///   • Provide haptic feedback on each tab switch.
///   • Supply Semantics / tooltip labels for accessibility.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // ── Destination definitions ──────────────────────────────────
  static const List<_NavDestination> _destinations = [
    _NavDestination(
      label: AppStrings.navHome,
      tooltip: 'Go to Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      route: AppStrings.routeHome,
    ),
    _NavDestination(
      label: AppStrings.navExplore,
      tooltip: 'Explore courses',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      route: AppStrings.routeExplore,
    ),
    _NavDestination(
      label: AppStrings.navInternships,
      tooltip: 'Browse internships',
      icon: Icons.work_outline_rounded,
      activeIcon: Icons.work_rounded,
      route: AppStrings.routeInternships,
    ),
    _NavDestination(
      label: AppStrings.navServices,
      tooltip: 'Our services',
      icon: Icons.business_center_outlined,
      activeIcon: Icons.business_center_rounded,
      route: AppStrings.routeServices,
    ),
    _NavDestination(
      label: AppStrings.navProfile,
      tooltip: 'Your profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      route: AppStrings.routeProfile,
    ),
  ];

  int _currentIndex = 0;

  /// Maps a GoRouter URI string to the active tab index.
  ///
  /// Deep-link routes (/about, /courses, /contact) fall through to 0
  /// to avoid orphaned highlights – the Home tab stays selected.
  int _uriToIndex(String location) {
    if (location.startsWith(AppStrings.routeExplore) ||
        location.startsWith(AppStrings.routeCourses)) {
      return 1;
    }
    if (location.startsWith(AppStrings.routeInternships)) {
      return 2;
    }
    if (location.startsWith(AppStrings.routeServices)) {
      return 3;
    }
    if (location.startsWith(AppStrings.routeProfile) ||
        location.startsWith(AppStrings.routeContact) ||
        location.startsWith(AppStrings.routeAbout)) {
      return 4;
    }
    return 0; // Home
  }

  void _onDestinationSelected(int index) {
    if (index == _currentIndex) return;
    // Light haptic tap on every tab switch – standard Android UX
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
    context.go(_destinations[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    _currentIndex = _uriToIndex(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _AppNavigationBar(
        currentIndex: _currentIndex,
        destinations: _destinations,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}

// ── Navigation Bar ────────────────────────────────────────────────────────────

class _AppNavigationBar extends StatelessWidget {
  const _AppNavigationBar({
    required this.currentIndex,
    required this.destinations,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final List<_NavDestination> destinations;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundCard : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline,
            width: 1.0,
          ),
        ),
      ),
      child: NavigationBar(
        backgroundColor:
            isDark ? AppColors.backgroundCard : AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        indicatorColor: isDark
            ? AppColors.accent.withAlpha(35)
            : AppColors.primary.withAlpha(20),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        animationDuration: const Duration(milliseconds: 250),
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        destinations: destinations.map((d) {
          final activeColor = isDark ? AppColors.accent : AppColors.primary;
          final unselectedColor =
              isDark ? AppColors.neutral400 : AppColors.neutral600;

          return NavigationDestination(
            tooltip: d.tooltip,
            icon: Semantics(
              label: d.tooltip,
              excludeSemantics: false,
              child: Icon(
                d.icon,
                color: unselectedColor,
              ),
            ),
            selectedIcon: Semantics(
              label: '${d.tooltip}, selected',
              excludeSemantics: false,
              child: Icon(
                d.activeIcon,
                color: activeColor,
              ),
            ),
            label: d.label,
          );
        }).toList(),
      ),
    );
  }
}

// ── NavigationBar Theme extension ─────────────────────────────────────────────
// The NavigationBar widget reads its label style from NavigationBarThemeData.
// We override it here inline so existing AppTheme is not disturbed.

// ── Data Model ───────────────────────────────────────────────────────────────

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.tooltip,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });

  final String label;
  final String tooltip;
  final IconData icon;
  final IconData activeIcon;
  final String route;
}

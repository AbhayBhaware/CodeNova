import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/constants.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/courses/presentation/pages/courses_page.dart';
import '../../features/internships/presentation/pages/internships_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/contact/presentation/pages/contact_page.dart';
import '../shell/main_shell.dart';

/// Centralized GoRouter configuration.
///
/// Uses a [ShellRoute] so [MainShell] (with its [NavigationBar]) is
/// persistent across all top-level tab destinations.
///
/// Nav-tab routes:  /  /explore  /internships  /services  /profile
/// Deep-link routes (still accessible, no tab highlight):
///   /about  /courses  /contact
final GoRouter appRouter = GoRouter(
  initialLocation: AppStrings.routeHome,
  debugLogDiagnostics: false,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        // ── Tab destinations ─────────────────────────────────
        GoRoute(
          path: AppStrings.routeHome,
          pageBuilder: (context, state) =>
              _fade(state, const HomePage()),
        ),
        GoRoute(
          path: AppStrings.routeExplore,
          pageBuilder: (context, state) =>
              _fade(state, const ExplorePage()),
        ),
        GoRoute(
          path: AppStrings.routeInternships,
          pageBuilder: (context, state) =>
              _fade(state, const InternshipsPage()),
        ),
        GoRoute(
          path: AppStrings.routeServices,
          pageBuilder: (context, state) =>
              _fade(state, const ServicesPage()),
        ),
        GoRoute(
          path: AppStrings.routeProfile,
          pageBuilder: (context, state) =>
              _fade(state, const ProfilePage()),
        ),

        // ── Accessible deep-link routes ──────────────────────
        // These remain navigable (e.g., from Profile / Home CTAs)
        // but do not correspond to a bottom-nav tab.
        GoRoute(
          path: AppStrings.routeAbout,
          pageBuilder: (context, state) =>
              _fade(state, const AboutPage()),
        ),
        GoRoute(
          path: AppStrings.routeCourses,
          pageBuilder: (context, state) =>
              _fade(state, const CoursesPage()),
        ),
        GoRoute(
          path: AppStrings.routeContact,
          pageBuilder: (context, state) =>
              _fade(state, const ContactPage()),
        ),
      ],
    ),
  ],
);

/// Produces a [CustomTransitionPage] with a smooth fade animation.
CustomTransitionPage<void> _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    ),
    transitionDuration: const Duration(milliseconds: 220),
  );
}

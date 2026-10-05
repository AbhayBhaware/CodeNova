import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/constants.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/courses/presentation/pages/courses_page.dart';
import '../../features/courses/presentation/pages/course_detail_page.dart';
import '../../features/internships/presentation/pages/internships_page.dart';
import '../../features/internships/presentation/pages/internship_detail_page.dart';
import '../../features/internships/presentation/pages/internship_apply_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/services/presentation/pages/service_detail_page.dart';
import '../../features/services/presentation/pages/quote_request_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/contact/presentation/pages/contact_page.dart';
import '../../features/admin/presentation/controllers/admin_auth_controller.dart';
import '../../features/admin/presentation/pages/admin_login_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../models/course_model.dart';
import '../../models/internship_model.dart';
import '../../models/service_model.dart';
import '../shell/main_shell.dart';

/// Centralized GoRouter configuration.
///
/// Uses a [ShellRoute] so [MainShell] (with its [NavigationBar]) is
/// persistent across all top-level tab destinations.
///
/// Nav-tab routes:  /  /explore  /internships  /services  /profile
/// Deep-link routes (still accessible, no tab highlight):
///   /about  /courses  /contact
/// Isolated Admin Portal routes:
///   /admin/login  /admin/dashboard
final GoRouter appRouter = GoRouter(
  initialLocation: AppStrings.routeHome,
  debugLogDiagnostics: false,
  refreshListenable: AdminAuthController.instance,
  redirect: (context, state) {
    final isGoingToAdmin = state.matchedLocation.startsWith('/admin');
    final isAtLogin = state.matchedLocation == AppStrings.routeAdminLogin;
    final isAuthenticated = AdminAuthController.instance.isAuthenticated;

    if (isGoingToAdmin) {
      if (!isAuthenticated && !isAtLogin) {
        return AppStrings.routeAdminLogin;
      }
      if (isAuthenticated && isAtLogin) {
        return AppStrings.routeAdminDashboard;
      }
    }
    return null;
  },
  routes: [
    // ── Admin routes (isolated from mobile bottom nav shell) ────
    GoRoute(
      path: AppStrings.routeAdminLogin,
      pageBuilder: (context, state) =>
          _fade(state, const AdminLoginPage()),
    ),
    GoRoute(
      path: AppStrings.routeAdminDashboard,
      pageBuilder: (context, state) =>
          _fade(state, const AdminDashboardPage()),
    ),

    // ── Student / Public Mobile Shell ─────────────────────────
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
          path: AppStrings.routeCourseDetail,
          pageBuilder: (context, state) {
            // The CourseModel is passed via GoRouter `extra`.
            final course = state.extra as CourseModel?;
            if (course == null) {
              // Graceful fallback: return to courses listing.
              return _fade(state, const CoursesPage());
            }
            return _slide(state, CourseDetailPage(course: course));
          },
        ),
        GoRoute(
          path: AppStrings.routeInternshipDetail,
          pageBuilder: (context, state) {
            // The InternshipModel is passed via GoRouter `extra`.
            final internship = state.extra as InternshipModel?;
            if (internship == null) {
              // Graceful fallback: return to internships listing.
              return _fade(state, const InternshipsPage());
            }
            return _slide(state, InternshipDetailPage(internship: internship));
          },
        ),
        GoRoute(
          path: AppStrings.routeInternshipApply,
          pageBuilder: (context, state) {
            final internship = state.extra as InternshipModel?;
            return _slide(
              state,
              InternshipApplyPage(internship: internship),
            );
          },
        ),
        GoRoute(
          path: AppStrings.routeServiceDetail,
          pageBuilder: (context, state) {
            final service = state.extra as ServiceModel?;
            if (service == null) {
              return _fade(state, const ServicesPage());
            }
            return _slide(state, ServiceDetailPage(service: service));
          },
        ),
        GoRoute(
          path: AppStrings.routeQuoteRequest,
          pageBuilder: (context, state) {
            final service = state.extra as ServiceModel?;
            return _slide(
              state,
              QuoteRequestPage(initialService: service),
            );
          },
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

/// Produces a [CustomTransitionPage] with a slide-up animation (detail screens).
CustomTransitionPage<void> _slide(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      );
      return SlideTransition(position: slide, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

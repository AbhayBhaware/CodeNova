import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:codenova_app/app/app.dart';
import 'package:codenova_app/features/home/presentation/pages/home_page.dart';
import 'package:codenova_app/features/home/presentation/widgets/home_internship_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/home_services_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/hero_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/featured_courses_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/why_choose_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/home_testimonials_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/cta_banner_section.dart';
import 'package:codenova_app/features/internships/presentation/pages/internships_page.dart';
import 'package:codenova_app/features/services/presentation/pages/services_page.dart';

import 'package:codenova_app/app/routes/app_router.dart';
import 'package:codenova_app/core/constants/constants.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    appRouter.go(AppStrings.routeHome);
  });

  group('HomePage Integration Tests', () {
    testWidgets(
        'Renders streamlined Home Screen with only Internships and Services sections',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const CodeNovaApp());
      await tester.pumpAndSettle();

      // 1. Verify Header & Logo
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('CN'), findsOneWidget);
      expect(find.text('CodeNova'), findsWidgets);
      expect(find.byTooltip('Notifications'), findsOneWidget);

      // 2. Verify Section 1: Internships (exactly 2 domain internships + View All)
      expect(find.byType(HomeInternshipSection), findsOneWidget);
      expect(find.text('Internships'), findsWidgets);
      expect(find.text('Software Engineering Internship'), findsOneWidget);
      expect(find.text('Web Development Internship'), findsOneWidget);
      // 3rd internship must NOT be on home page
      expect(find.text('Python & AI Internship'), findsNothing);
      expect(find.text('View All Internships'), findsOneWidget);

      // Scroll down if needed
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // 3. Verify Section 2: Services (exactly 2 services + View All)
      expect(find.byType(HomeServicesSection), findsOneWidget);
      expect(find.text('Services'), findsWidgets);
      expect(find.text('Web Application Development'), findsOneWidget);
      expect(find.text('Mobile App Development'), findsOneWidget);
      // 3rd service must NOT be on home page
      expect(find.text('AI & Machine Learning'), findsNothing);
      expect(find.text('View All Services'), findsOneWidget);

      // 4. Verify Removed / Unwanted sections are NOT present on HomePage
      expect(find.byType(HeroSection), findsNothing);
      expect(find.byType(FeaturedCoursesSection), findsNothing);
      expect(find.byType(WhyChooseSection), findsNothing);
      expect(find.byType(HomeTestimonialsSection), findsNothing);
      expect(find.byType(CtaBannerSection), findsNothing);
    });

    testWidgets('Tapping View All Internships navigates to internships listing',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const CodeNovaApp());
      await tester.pumpAndSettle();

      final viewAllBtn = find.text('View All Internships');
      expect(viewAllBtn, findsOneWidget);

      await tester.ensureVisible(viewAllBtn);
      await tester.pumpAndSettle();

      await tester.tap(viewAllBtn);
      await tester.pumpAndSettle();

      // Should navigate to InternshipsPage
      expect(find.byType(InternshipsPage), findsOneWidget);
    });

    testWidgets('Tapping View All Services navigates to services listing',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const CodeNovaApp());
      await tester.pumpAndSettle();

      final viewAllServicesBtn = find.text('View All Services');
      expect(viewAllServicesBtn, findsOneWidget);

      await tester.ensureVisible(viewAllServicesBtn);
      await tester.pumpAndSettle();

      await tester.tap(viewAllServicesBtn);
      await tester.pumpAndSettle();

      // Should navigate to ServicesPage
      expect(find.byType(ServicesPage), findsOneWidget);
    });

    testWidgets('Tapping Notifications opens notifications bottom sheet',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const CodeNovaApp());
      await tester.pumpAndSettle();

      final notifButton = find.byTooltip('Notifications');
      expect(notifButton, findsOneWidget);

      await tester.tap(notifButton);
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Welcome to CodeNova Tech Solutions!'), findsOneWidget);

      // Dismiss
      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();
    });
  });
}


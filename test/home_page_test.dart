import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:codenova_app/app/app.dart';
import 'package:codenova_app/features/home/presentation/pages/home_page.dart';
import 'package:codenova_app/features/home/presentation/widgets/hero_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/featured_courses_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/home_internship_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/home_services_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/why_choose_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/home_testimonials_section.dart';
import 'package:codenova_app/features/home/presentation/widgets/cta_banner_section.dart';
import 'package:codenova_app/core/constants/constants.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('HomePage Integration Tests', () {
    testWidgets('Renders complete Home Screen with all verified sections',
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

      // 2. Verify Hero Section with verified title & stats
      expect(find.byType(HeroSection), findsOneWidget);
      expect(find.text(AppStrings.heroTitle), findsOneWidget);
      expect(find.text(AppStrings.statsStudentsValue), findsOneWidget);
      expect(find.text(AppStrings.statsPartnersValue), findsOneWidget);
      expect(find.text(AppStrings.heroCtaPrimary), findsOneWidget);

      // 3. Verify Courses Section
      expect(find.byType(FeaturedCoursesSection), findsOneWidget);
      expect(find.text('Full Stack Development'), findsOneWidget);
      expect(find.text('View Details'), findsWidgets);

      // 4. Verify Internship Section
      expect(find.byType(HomeInternshipSection), findsOneWidget);
      expect(find.text('Explore Internships'), findsWidgets);

      // Scroll down to view remaining sections in CustomScrollView
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
      await tester.pumpAndSettle();

      // 5. Verify Services Section
      expect(find.byType(HomeServicesSection), findsOneWidget);
      expect(find.text('Web Application Development'), findsOneWidget);

      // Scroll further down
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
      await tester.pumpAndSettle();

      // 6. Verify Benefits Section (verified claims)
      expect(find.byType(WhyChooseSection), findsOneWidget);
      expect(find.text('Expert Mentors'), findsOneWidget);

      // 7. Verify Testimonials Section (clearly marked placeholder)
      expect(find.byType(HomeTestimonialsSection), findsOneWidget);
      expect(find.text('Verified Student Reviews & Feedback'), findsOneWidget);

      // Scroll to bottom
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
      await tester.pumpAndSettle();

      // 8. Verify Contact CTA Section
      expect(find.byType(CtaBannerSection), findsOneWidget);
      expect(find.text('Enquire Now'), findsWidgets);
      expect(find.text('Call Support'), findsOneWidget);
    });

    testWidgets('Tapping View Details opens modal sheet with full course info',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const CodeNovaApp());
      await tester.pumpAndSettle();

      // Find first "View Details" button
      final viewDetailsFinder = find.text('View Details').first;
      expect(viewDetailsFinder, findsOneWidget);

      await tester.ensureVisible(viewDetailsFinder);
      await tester.pumpAndSettle();

      await tester.tap(viewDetailsFinder);
      await tester.pumpAndSettle();

      // Modal sheet should now be visible with syllabus and Enquire button
      expect(find.text('About this Program'), findsOneWidget);
      expect(find.text('Key Technologies & Topics'), findsOneWidget);
      expect(find.text('Enquire Now'), findsWidgets);
      expect(find.text('Close'), findsOneWidget);

      // Dismiss modal
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
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

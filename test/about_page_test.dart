import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/app/theme/app_theme.dart';
import 'package:codenova_app/core/constants/constants.dart';
import 'package:codenova_app/features/about/presentation/pages/about_page.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: child,
    );
  }

  group('AboutPage Integration & Rendering Tests', () {
    testWidgets('Renders all required sections and verified company claims',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableWidget(const AboutPage()));
      await tester.pumpAndSettle();

      // 1. Header & Branding
      expect(find.text('About CodeNova'), findsWidgets);
      expect(find.text(AppStrings.appName), findsWidgets);
      expect(find.text(AppStrings.appTagline), findsWidgets);
      expect(find.text(AppStrings.address), findsWidgets);

      // 2. About CodeNova Section & Core Values
      expect(find.text('Who We Are'), findsOneWidget);
      expect(find.text('OUR CORE VALUES'), findsOneWidget);
      expect(find.text('Innovation'), findsOneWidget);
      expect(find.text('Integrity'), findsOneWidget);
      expect(find.text('Continuous Learning'), findsOneWidget);
      expect(find.text('Customer Satisfaction'), findsOneWidget);

      // 3. Mission & Vision Section
      await tester.scrollUntilVisible(
        find.text('Mission & Vision'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Mission & Vision'), findsOneWidget);
      expect(find.text('Our Mission'), findsOneWidget);
      expect(find.text(AppStrings.mission), findsOneWidget);
      expect(find.text('Our Vision'), findsOneWidget);
      expect(find.text(AppStrings.vision), findsOneWidget);

      // Scroll down to reveal Services
      await tester.scrollUntilVisible(
        find.text('Core IT Services'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // 4. Core IT Services Section
      expect(find.text('Core IT Services'), findsOneWidget);
      expect(find.text('Web Application Development'), findsOneWidget);
      expect(find.text('Mobile App Development'), findsOneWidget);
      expect(find.text('Explore All Services'), findsOneWidget);

      // Scroll down to reveal Training Focus
      await tester.scrollUntilVisible(
        find.text(AppStrings.aboutTrainingTitle),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // 5. Training Focus & Pillars
      expect(find.text(AppStrings.aboutTrainingTitle), findsOneWidget);
      expect(find.text('Education & Mentorship'), findsOneWidget);
      expect(find.text('THE THREE PILLARS'), findsOneWidget);
      expect(find.text('Expert Mentors'), findsOneWidget);
      expect(find.text('Hands-on Projects'), findsOneWidget);
      expect(find.text('Verified Certificates'), findsOneWidget);
      expect(find.text('Browse Programs & Internships'), findsOneWidget);

      // Scroll to Contact Section
      await tester.scrollUntilVisible(
        find.text('Connect With Us'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // 6. Connect With Us & Contact CTA
      expect(find.text('Connect With Us'), findsOneWidget);
      expect(find.text(AppStrings.phone), findsOneWidget);
      expect(find.text(AppStrings.email), findsOneWidget);
      expect(find.text(AppStrings.website), findsOneWidget);
      expect(find.text('Enquire Now'), findsOneWidget);
    });

    testWidgets('Tapping Enquire Now opens contact enquiry modal bottom sheet',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestableWidget(const AboutPage()));
      await tester.pumpAndSettle();

      // Scroll to Contact CTA
      await tester.scrollUntilVisible(
        find.text('Enquire Now'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      final enquireButton = find.text('Enquire Now');
      expect(enquireButton, findsOneWidget);

      await tester.tap(enquireButton);
      await tester.pumpAndSettle();

      // Verify modal sheet is displayed
      expect(find.text('Contact CodeNova'), findsOneWidget);
      expect(find.text('Call Us Directly'), findsOneWidget);
      expect(find.text('Send an Email'), findsOneWidget);
      expect(find.text('Visit Official Website'), findsOneWidget);

      // Dismiss modal sheet
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Contact CodeNova'), findsNothing);
    });
  });
}


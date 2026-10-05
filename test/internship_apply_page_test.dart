import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:codenova_app/core/constants/constants.dart';
import 'package:codenova_app/models/internship_model.dart';
import 'package:codenova_app/features/internships/data/repositories/internship_application_repository.dart';
import 'package:codenova_app/features/internships/presentation/controllers/internship_apply_controller.dart';
import 'package:codenova_app/features/internships/presentation/pages/internship_apply_page.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> setupViewport(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Widget buildTestApp({
    InternshipModel? internship,
    InternshipApplyController? controller,
  }) {
    return MaterialApp(
      home: InternshipApplyPage(
        internship: internship,
        controller: controller,
      ),
    );
  }

  group('InternshipApplyPage Widget & Form Validation Tests', () {
    testWidgets('Renders all required fields, chips, notices, and submit CTA',
        (tester) async {
      await setupViewport(tester);

      await tester.pumpWidget(buildTestApp());
      await settle(tester);

      // AppBar
      expect(find.text('Internship Application'), findsOneWidget);

      // Development Mode Banner
      expect(find.textContaining('Development Preview'), findsOneWidget);

      // Section Headers
      expect(find.text('Personal Details'), findsOneWidget);
      expect(find.text('Academic & Technical Background'), findsOneWidget);
      expect(find.text('Portfolio & Additional Notes'), findsOneWidget);

      // Form Field Labels
      expect(find.text('Full Name *'), findsOneWidget);
      expect(find.text('Email Address *'), findsOneWidget);
      expect(find.text('Mobile Number *'), findsOneWidget);
      expect(find.text('College / University *'), findsOneWidget);
      expect(find.text('Course & Branch *'), findsOneWidget);
      expect(find.text('Preferred Technology / Domain *'), findsOneWidget);
      expect(find.text('Resume / Portfolio Link (Optional)'), findsOneWidget);
      expect(find.text('Additional Message / Notes (Optional)'), findsOneWidget);

      // Technology Suggestion Chips
      expect(find.text('Full Stack Development'), findsOneWidget);
      expect(find.text('Python & AI'), findsOneWidget);
      expect(find.text('Mobile / Flutter'), findsOneWidget);

      // Data Protection Card
      expect(find.textContaining('Data Protection'), findsOneWidget);

      // Submit Button
      expect(find.text('Submit Application'), findsOneWidget);
    });

    testWidgets('Submitting empty form triggers validation errors on required fields',
        (tester) async {
      await setupViewport(tester);

      await tester.pumpWidget(buildTestApp());
      await settle(tester);

      // Tap Submit Application without typing anything
      final submitButton = find.text('Submit Application');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await settle(tester);

      // Verify clear error messages for required fields
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email address'), findsOneWidget);
      expect(find.text('Please enter your mobile number'), findsOneWidget);
      expect(find.text('Please enter your college or institute name'), findsOneWidget);
      expect(
        find.text('Please enter your course and branch (e.g. B.Tech CSE, MCA)'),
        findsOneWidget,
      );
      expect(
        find.text('Please select or enter your preferred technology'),
        findsOneWidget,
      );
    });

    testWidgets('Validates email, phone, and optional resume link formats',
        (tester) async {
      await setupViewport(tester);

      await tester.pumpWidget(buildTestApp());
      await settle(tester);

      Future<void> enterField(String keyName, String text) async {
        final finder = find.byKey(Key(keyName));
        await tester.ensureVisible(finder);
        await tester.enterText(finder, text);
      }

      // Enter invalid data
      await enterField('input_email', 'not-an-email');
      await enterField('input_phone', '12345');
      await enterField('input_resume', 'bad-url');
      await settle(tester);

      final submitButton = find.text('Submit Application');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await settle(tester);

      expect(
        find.text('Please enter a valid email address (e.g. name@example.com)'),
        findsOneWidget,
      );
      expect(
        find.text('Please enter a valid 10-digit mobile number'),
        findsOneWidget,
      );
      expect(
        find.text('Please enter a valid link (e.g. https://drive.google.com/...)'),
        findsOneWidget,
      );
    });

    testWidgets('Tapping technology chip updates preferred technology input',
        (tester) async {
      await setupViewport(tester);

      await tester.pumpWidget(buildTestApp());
      await settle(tester);

      final chip = find.text('Python & AI');
      await tester.ensureVisible(chip);
      await tester.tap(chip);
      await settle(tester);

      expect(find.widgetWithText(TextFormField, 'Python & AI'), findsOneWidget);
    });

    testWidgets('Pre-populates role context and technology when passed an internship',
        (tester) async {
      await setupViewport(tester);

      final internship = MockData.internships.first;
      await tester.pumpWidget(buildTestApp(internship: internship));
      await settle(tester);

      // Context card
      expect(find.text('Applying for Position'), findsOneWidget);
      expect(find.text(internship.title), findsWidgets);

      // Pre-filled technology input
      expect(find.widgetWithText(TextFormField, internship.title), findsOneWidget);
    });

    testWidgets('Successful form submission renders SuccessView with reference ID',
        (tester) async {
      await setupViewport(tester);

      final controller = InternshipApplyController(
        repository: const MockInternshipApplicationRepository(delay: Duration.zero),
      );

      await tester.pumpWidget(buildTestApp(controller: controller));
      await settle(tester);

      Future<void> enterField(String keyName, String text) async {
        final finder = find.byKey(Key(keyName));
        await tester.ensureVisible(finder);
        await tester.enterText(finder, text);
      }

      // Fill in all valid fields
      await enterField('input_full_name', 'Aditi Deshmukh');
      await enterField('input_email', 'aditi.deshmukh@example.com');
      await enterField('input_phone', '9876543210');
      await enterField('input_college', 'Pune Institute of Computer Technology');
      await enterField('input_course', 'B.Tech Computer Science');
      await enterField('input_technology', 'Full Stack Development');
      await enterField(
        'input_resume',
        'https://drive.google.com/file/d/aditi_resume/view',
      );
      await enterField(
        'input_message',
        'Excited to contribute to live client deliverables.',
      );
      await settle(tester);

      final submitButton = find.text('Submit Application');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await settle(tester);

      // SuccessView expectations
      expect(find.text('Application Received'), findsOneWidget);
      expect(find.text('Development Preview Mode'), findsOneWidget);
      expect(find.text('Application Reference'), findsOneWidget);
      expect(find.textContaining('DEV-CN-'), findsOneWidget);
      expect(find.text('What Happens Next?'), findsOneWidget);
      expect(find.text('Done / Return to Internships'), findsOneWidget);
      expect(find.text('Also Send via Email to HR'), findsOneWidget);

      // Reset form via action
      await tester.tap(find.text('Submit Another Application'));
      await settle(tester);

      expect(find.text('Personal Details'), findsOneWidget);
      expect(find.text('Submit Application'), findsOneWidget);
    });

    testWidgets('Submission failure shows error banner with retry option',
        (tester) async {
      await setupViewport(tester);

      final controller = InternshipApplyController(
        repository: const MockInternshipApplicationRepository(
          delay: Duration.zero,
          simulateFailure: true,
          simulatedErrorMessage: 'Network timeout during application submission.',
        ),
      );

      await tester.pumpWidget(buildTestApp(controller: controller));
      await settle(tester);

      Future<void> enterField(String keyName, String text) async {
        final finder = find.byKey(Key(keyName));
        await tester.ensureVisible(finder);
        await tester.enterText(finder, text);
      }

      // Fill in all valid fields
      await enterField('input_full_name', 'Rahul Patil');
      await enterField('input_email', 'rahul.patil@example.com');
      await enterField('input_phone', '9123456780');
      await enterField('input_college', 'COEP Technological University');
      await enterField('input_course', 'B.Tech Information Technology');
      await enterField('input_technology', 'Python & AI');
      await settle(tester);

      final submitButton = find.text('Submit Application');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await settle(tester);

      // Verify Error banner renders
      expect(find.text('Submission Error'), findsOneWidget);
      expect(
        find.textContaining('Network timeout during application submission.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);

      // Verify entered text remains intact
      expect(find.widgetWithText(TextFormField, 'Rahul Patil'), findsOneWidget);
    });
  });
}

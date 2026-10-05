import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/app/theme/app_theme.dart';
import 'package:codenova_app/core/constants/app_strings.dart';
import 'package:codenova_app/features/contact/data/repositories/contact_repository.dart';
import 'package:codenova_app/features/contact/presentation/controllers/contact_controller.dart';
import 'package:codenova_app/features/contact/presentation/pages/contact_page.dart';
import 'package:codenova_app/core/widgets/widgets.dart';

Widget buildTestContactPage({ContactController? controller}) {
  return MaterialApp(
    theme: AppTheme.light,
    home: ContactPage(controller: controller),
  );
}

void main() {
  group('ContactPage Integration & Widget Tests', () {
    testWidgets('Renders all verified contact channels and headquarters banner', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestContactPage());
      await tester.pumpAndSettle();

      // App bar & Header banner
      expect(find.text('Contact Us'), findsOneWidget);
      expect(find.textContaining('VERIFIED CORPORATE DESK'), findsOneWidget);
      expect(find.text('We are here to assist your tech journey.'), findsOneWidget);

      // Verified direct channels
      expect(find.text('Direct Phone Support'), findsOneWidget);
      expect(find.text(AppStrings.phone), findsOneWidget);
      expect(find.text('Call Pune Desk'), findsOneWidget);

      expect(find.text('Official Enquiries Email'), findsOneWidget);
      expect(find.text(AppStrings.email), findsOneWidget);
      expect(find.text('Send Email'), findsOneWidget);

      expect(find.text('Registered Headquarters'), findsOneWidget);
      expect(find.text(AppStrings.address), findsOneWidget);
      expect(find.text('Open in Maps'), findsOneWidget);

      expect(find.text('Official Web Portal'), findsWidgets);
      expect(find.text('codenovatechsolutions.in'), findsWidgets);
      expect(find.text('Visit Website'), findsOneWidget);

      // Office Hours Card
      expect(find.text('Consultation Hours & Availability'), findsOneWidget);
      expect(find.text('9:30 AM – 6:30 PM IST'), findsOneWidget);
      expect(find.text('Monday – Saturday'), findsOneWidget);
      expect(find.textContaining('Response within'), findsOneWidget);

      // Shortcuts
      expect(find.text('Request a Project Quote'), findsOneWidget);
      expect(find.text('Internship Applications'), findsOneWidget);

      // Enquiry Form section header
      expect(find.text('Send an Enquiry'), findsOneWidget);
    });

    testWidgets('Validates required fields and shows clear error messages', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = ContactController(
        repository: const MockContactRepository(delay: Duration.zero),
      );

      await tester.pumpWidget(buildTestContactPage(controller: controller));
      await tester.pumpAndSettle();

      final submitBtn = find.widgetWithText(AppButton, 'Send Enquiry Message');
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Clear required validation errors
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email address'), findsOneWidget);
      expect(find.text('Please enter your enquiry message'), findsOneWidget);

      // Enter invalid email & short message
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Rohit Deshmukh');
      await tester.enterText(textFields.at(1), 'invalid-email');
      await tester.enterText(textFields.at(3), 'Too brief');
      await tester.pumpAndSettle();

      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(
        find.text('Please enter a valid email address (e.g. name@domain.com)'),
        findsOneWidget,
      );
      expect(
        find.text('Please provide more details (minimum 15 characters)'),
        findsOneWidget,
      );
    });

    testWidgets('Successful submission shows reference ID and allows reset', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = ContactController(
        repository: const MockContactRepository(delay: Duration.zero),
      );

      await tester.pumpWidget(buildTestContactPage(controller: controller));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Priya Sharma');
      await tester.enterText(textFields.at(1), 'priya.sharma@example.com');
      await tester.enterText(textFields.at(2), '+91 9123456780');
      await tester.enterText(
        textFields.at(3),
        'I would like to inquire about the syllabus and upcoming schedule for the Data Science training.',
      );
      await tester.pumpAndSettle();

      final submitBtn = find.widgetWithText(AppButton, 'Send Enquiry Message');
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Verify success card
      expect(find.text('Enquiry Transmitted'), findsOneWidget);
      expect(find.text('ENQUIRY REFERENCE ID'), findsOneWidget);
      expect(find.textContaining('DEV-ENQ-'), findsOneWidget);
      expect(find.text('Enquiry Summary'), findsOneWidget);
      expect(find.text('priya.sharma@example.com'), findsOneWidget);
      expect(find.text('+91 9123456780'), findsOneWidget);
      expect(find.text('Send Another Enquiry'), findsOneWidget);

      // Reset form
      final resetBtn = find.text('Send Another Enquiry');
      await tester.ensureVisible(resetBtn);
      await tester.tap(resetBtn);
      await tester.pumpAndSettle();

      expect(find.text('Send Enquiry Message'), findsOneWidget);
      expect(find.text('Enquiry Transmitted'), findsNothing);
    });

    testWidgets('Submission failure displays error banner and preserves form inputs', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = ContactController(
        repository: const MockContactRepository(
          delay: Duration.zero,
          simulateFailure: true,
          simulatedErrorMessage: 'Server unreachable. Please verify network.',
        ),
      );

      await tester.pumpWidget(buildTestContactPage(controller: controller));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Sneha Kulkarni');
      await tester.enterText(textFields.at(1), 'sneha@example.org');
      await tester.enterText(
        textFields.at(3),
        'Inquiry regarding offline batch schedule in Pune for Android development.',
      );
      await tester.pumpAndSettle();

      final submitBtn = find.widgetWithText(AppButton, 'Send Enquiry Message');
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Failure banner checks
      expect(find.text('Submission Encountered An Issue'), findsOneWidget);
      expect(find.textContaining('Server unreachable'), findsOneWidget);
      expect(find.text('Retry Submission'), findsOneWidget);

      // Form inputs must remain preserved
      expect(find.text('Sneha Kulkarni'), findsOneWidget);
      expect(find.text('sneha@example.org'), findsOneWidget);
    });

    testWidgets('Tapping copy button copies text and displays feedback', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          return null;
        },
      );

      await tester.pumpWidget(buildTestContactPage());
      await tester.pumpAndSettle();

      // Find copy phone button
      final copyPhoneBtn = find.byTooltip('Copy phone number');
      expect(copyPhoneBtn, findsOneWidget);
      await tester.tap(copyPhoneBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // SnackBar feedback
      expect(find.textContaining('Phone number copied'), findsOneWidget);
    });
  });
}

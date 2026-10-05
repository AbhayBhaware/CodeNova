import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/core/widgets/widgets.dart';
import 'package:codenova_app/models/service_model.dart';
import 'package:codenova_app/features/services/data/repositories/quote_repository.dart';
import 'package:codenova_app/features/services/presentation/controllers/quote_controller.dart';
import 'package:codenova_app/features/services/presentation/pages/quote_request_page.dart';

void main() {
  const sampleService = ServiceModel(
    id: 'mobile-development',
    title: 'Mobile App Development',
    category: 'Mobile',
    description: 'Native Android and cross-platform apps.',
    icon: Icons.phone_android_rounded,
    tags: ['Flutter', 'Android', 'iOS'],
  );

  Widget buildTestPage({
    ServiceModel? initialService,
    QuoteController? controller,
  }) {
    return MaterialApp(
      home: QuoteRequestPage(
        initialService: initialService,
        controller: controller,
      ),
    );
  }

  group('QuoteRequestPage Widget & Form Validation Tests', () {
    testWidgets('Renders all required and optional form fields and headers', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = QuoteController(
        repository: const MockQuoteRepository(delay: Duration.zero),
      );

      await tester.pumpWidget(buildTestPage(controller: controller));
      await tester.pumpAndSettle();

      expect(find.text('Request a Quote'), findsOneWidget);
      expect(find.text('Tailored Project Proposals'), findsOneWidget);
      expect(find.text('Contact Information'), findsOneWidget);
      expect(find.text('Project Scope'), findsOneWidget);
      expect(find.text('Budget & Communication Preferences'), findsOneWidget);

      // Labels & inputs
      expect(find.text('Full Name *'), findsOneWidget);
      expect(find.text('Work Email Address *'), findsOneWidget);
      expect(find.text('Company Name (Optional)'), findsOneWidget);
      expect(find.text('Project Type *'), findsOneWidget);
      expect(find.text('Project Description & Objectives *'), findsOneWidget);
      expect(find.text('Budget Range (Optional)'), findsOneWidget);
      expect(find.text('Preferred Contact Method *'), findsOneWidget);

      // Contact options
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Call'), findsOneWidget);
      expect(find.text('WhatsApp'), findsOneWidget);

      // Submit CTA
      final submitButton = find.widgetWithText(AppButton, 'Submit Quote Request');
      await tester.ensureVisible(submitButton);
      expect(submitButton, findsOneWidget);
    });

    testWidgets('Pre-populates project type from initialService', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = QuoteController(
        repository: const MockQuoteRepository(delay: Duration.zero),
      );

      await tester.pumpWidget(
        buildTestPage(
          initialService: sampleService,
          controller: controller,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mobile App Development'), findsOneWidget);
    });

    testWidgets('Validates required fields and shows clear error messages', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = QuoteController(
        repository: const MockQuoteRepository(delay: Duration.zero),
      );

      await tester.pumpWidget(buildTestPage(controller: controller));
      await tester.pumpAndSettle();

      // Tap submit with empty form
      final submitButton = find.widgetWithText(AppButton, 'Submit Quote Request');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify clear required field error messages
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email address'), findsOneWidget);
      expect(find.text('Please select a project type'), findsOneWidget);
      expect(find.text('Please describe your project requirements'), findsOneWidget);

      // Enter invalid email & short description
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.enterText(textFields.at(1), 'notanemail');
      await tester.enterText(textFields.at(3), 'Too short');
      await tester.pumpAndSettle();

      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Please enter a valid email address (e.g. name@company.com)'),
        findsOneWidget,
      );
      expect(
        find.text('Please provide more details (minimum 15 characters)'),
        findsOneWidget,
      );
    });

    testWidgets('Tapping contact method chip updates selected method', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = QuoteController(
        repository: const MockQuoteRepository(delay: Duration.zero),
      );

      await tester.pumpWidget(buildTestPage(controller: controller));
      await tester.pumpAndSettle();

      // Tap on WhatsApp
      await tester.tap(find.text('WhatsApp'));
      await tester.pumpAndSettle();

      // Tap on Phone Call
      await tester.tap(find.text('Phone Call'));
      await tester.pumpAndSettle();

      expect(find.text('Phone Call'), findsOneWidget);
    });

    testWidgets('Successful submission renders QuoteSuccessView with reference ID', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = QuoteController(
        repository: const MockQuoteRepository(delay: Duration.zero),
      );

      await tester.pumpWidget(
        buildTestPage(
          initialService: sampleService,
          controller: controller,
        ),
      );
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Sarah Connor');
      await tester.enterText(textFields.at(1), 'sarah@skynet-solutions.com');
      await tester.enterText(textFields.at(2), 'Cyberdyne Systems');
      await tester.enterText(
        textFields.at(3),
        'Cross-platform Flutter application for enterprise automated sensor monitoring.',
      );
      await tester.pumpAndSettle();

      // Submit form
      final submitButton = find.widgetWithText(AppButton, 'Submit Quote Request');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify success screen
      expect(find.text('Quote Request Received'), findsOneWidget);
      expect(find.text('YOUR ENQUIRY REFERENCE ID'), findsOneWidget);
      expect(find.textContaining('DEV-QUOTE-'), findsOneWidget);
      expect(find.text('Enquiry Summary'), findsOneWidget);
      expect(find.text('sarah@skynet-solutions.com'), findsOneWidget);
      expect(find.text('Cyberdyne Systems'), findsOneWidget);
      expect(find.text('Back to IT Services'), findsOneWidget);

      // Tap Submit Another Quote Request to reset
      final resetBtn = find.text('Submit Another Quote Request');
      await tester.ensureVisible(resetBtn);
      await tester.tap(resetBtn);
      await tester.pumpAndSettle();

      expect(find.text('Tailored Project Proposals'), findsOneWidget);
      expect(find.text('Submit Quote Request'), findsOneWidget);
    });

    testWidgets('Submission failure displays error banner and preserves form inputs', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = QuoteController(
        repository: const MockQuoteRepository(
          delay: Duration.zero,
          simulateFailure: true,
          simulatedErrorMessage: 'Network gateway connectivity timeout.',
        ),
      );

      await tester.pumpWidget(
        buildTestPage(
          initialService: sampleService,
          controller: controller,
        ),
      );
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Robert Paulson');
      await tester.enterText(textFields.at(1), 'robert@enterprise.com');
      await tester.enterText(
        textFields.at(3),
        'Custom web application migration to modern microservices.',
      );
      await tester.pumpAndSettle();

      final submitButton = find.widgetWithText(AppButton, 'Submit Quote Request');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Failure banner checks
      expect(find.text('Submission Encountered An Issue'), findsOneWidget);
      expect(find.textContaining('Network gateway connectivity timeout'), findsOneWidget);
      expect(find.text('Retry Submission'), findsOneWidget);

      // Form inputs must remain preserved
      expect(find.text('Robert Paulson'), findsOneWidget);
      expect(find.text('robert@enterprise.com'), findsOneWidget);
    });
  });
}

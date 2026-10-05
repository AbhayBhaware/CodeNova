import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/core/constants/constants.dart';
import 'package:codenova_app/core/widgets/widgets.dart';
import 'package:codenova_app/models/service_model.dart';
import 'package:codenova_app/features/services/presentation/pages/service_detail_page.dart';
import 'package:codenova_app/features/services/presentation/widgets/quote_request_sheet.dart';
import 'package:codenova_app/features/services/presentation/widgets/service_card.dart';

void main() {
  const testService = ServiceModel(
    id: 'web-development',
    title: 'Web Application Development',
    category: 'Web',
    description:
        'Modern, scalable web applications and digital platforms tailored to business needs.',
    icon: Icons.web_rounded,
    tags: ['React', 'Next.js', 'Node.js', 'Full Stack'],
    features: [
      'Responsive mobile-first user interfaces engineered for speed',
      'Scalable backend RESTful & GraphQL microservice APIs',
      'Secure authentication, role-based access, and payment gateways',
    ],
    deliverables: [
      'Production-ready, tested web application codebase',
      'Fully documented REST / GraphQL API endpoints',
      'Automated deployment scripts and CI/CD setup',
    ],
  );

  group('ServiceDetailPage Widget Tests', () {
    Widget buildDetailPage({ServiceModel service = testService}) {
      return MaterialApp(
        home: ServiceDetailPage(service: service),
      );
    }

    testWidgets('Renders all verified fields, sections, features, and deliverables', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildDetailPage());
      await tester.pumpAndSettle();

      // Hero header checks
      expect(find.text('Web Application Development'), findsOneWidget);
      expect(find.text('WEB'), findsOneWidget);

      // Quick Info Strip
      expect(find.text('Domain'), findsOneWidget);
      expect(find.text('Delivery Model'), findsOneWidget);
      expect(find.text('Assurance'), findsOneWidget);
      expect(find.text('Agile Sprints'), findsOneWidget);
      expect(find.text('NDA & SLA'), findsOneWidget);

      // Section titles
      expect(find.text('Service Overview'), findsOneWidget);
      expect(find.text('Technical Capabilities'), findsOneWidget);
      expect(find.text('Project Deliverables'), findsOneWidget);
      expect(find.text('Technologies & Frameworks'), findsOneWidget);
      expect(find.text('Our Engineering Process'), findsOneWidget);

      // Verified features
      expect(
        find.text('Responsive mobile-first user interfaces engineered for speed'),
        findsOneWidget,
      );
      expect(
        find.text('Scalable backend RESTful & GraphQL microservice APIs'),
        findsOneWidget,
      );

      // Verified deliverables
      expect(
        find.text('Production-ready, tested web application codebase'),
        findsOneWidget,
      );

      // Tech tags
      expect(find.text('React'), findsOneWidget);
      expect(find.text('Next.js'), findsOneWidget);

      // Engineering process steps
      expect(find.text('Discovery & Technical Scoping'), findsOneWidget);
      expect(find.text('UI/UX Prototyping & Sprint Plan'), findsOneWidget);
      expect(find.text('Iterative Engineering & QA'), findsOneWidget);
      expect(find.text('Production Deployment & SLA'), findsOneWidget);

      // Contact Info Card
      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.text(AppStrings.phone), findsOneWidget);
      expect(find.text(AppStrings.email), findsOneWidget);

      // Sticky CTA bar
      expect(find.text('Request a Quote'), findsOneWidget);
      expect(find.byIcon(Icons.phone_in_talk_rounded), findsOneWidget);
    });

    testWidgets('Tapping Request a Quote in sticky bar opens QuoteRequestSheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildDetailPage());
      await tester.pumpAndSettle();

      // Find the sticky CTA button
      final quoteButton = find.widgetWithText(AppGradientButton, 'Request a Quote').first;
      await tester.tap(quoteButton);
      await tester.pumpAndSettle();

      expect(find.byType(QuoteRequestSheet), findsOneWidget);
      expect(find.text('Request a Project Quote'), findsOneWidget);
    });

    testWidgets('QuoteRequestSheet form validation and successful submission', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuoteRequestSheet(initialService: testService),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Request a Project Quote'), findsOneWidget);

      // Tap submit with empty fields to trigger validation
      final submitButton = find.widgetWithText(AppGradientButton, 'Submit Quote Request');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name or company name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your phone number'), findsOneWidget);
      expect(find.text('Please provide a brief project overview'), findsOneWidget);

      // Enter valid fields
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'CodeNova Partner Enterprise');
      await tester.enterText(textFields.at(1), 'contact@enterprise.com');
      await tester.enterText(textFields.at(2), '9876543210');
      await tester.enterText(textFields.at(3), 'Need custom enterprise web portal built with Flutter.');
      await tester.pumpAndSettle();

      // Tap submit
      await tester.tap(submitButton);
      await tester.pump(); // Start submission delay
      await tester.pump(const Duration(milliseconds: 700)); // Finish delay
      await tester.pumpAndSettle();

      // Verify success screen
      expect(find.text('Requirements Logged Successfully'), findsOneWidget);
      expect(find.text('Quote Request Received'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });
  });

  group('ServiceCard Standalone Widget Tests', () {
    testWidgets('ServiceCard renders domain icon, category, title, tags, and View Details', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServiceCard(
              service: testService,
              onViewDetails: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Web Application Development'), findsOneWidget);
      expect(find.text('Web'), findsOneWidget);
      expect(find.text('View Details'), findsOneWidget);

      await tester.tap(find.text('View Details'));
      expect(tapped, isTrue);
    });
  });
}

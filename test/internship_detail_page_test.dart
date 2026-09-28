import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:codenova_app/core/constants/constants.dart';
import 'package:codenova_app/models/internship_model.dart';
import 'package:codenova_app/features/internships/presentation/pages/internship_detail_page.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget buildTestApp(InternshipModel internship) {
    return MaterialApp(
      home: InternshipDetailPage(internship: internship),
    );
  }

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

  group('InternshipDetailPage Widget Tests', () {
    testWidgets('Renders all verified fields, sections, and sticky CTA',
        (tester) async {
      await setupViewport(tester);

      final internship = MockData.internships.first; // Software Engineering Internship
      await tester.pumpWidget(buildTestApp(internship));
      await settle(tester);

      // Hero / Header
      expect(find.text(internship.title), findsWidgets);
      expect(find.text(internship.domain), findsWidgets);
      expect(find.text('Now Hiring'), findsWidgets);

      // Quick Info Strip
      expect(find.text('Duration'), findsOneWidget);
      expect(find.text('3 – 6 Months'), findsOneWidget);
      expect(find.text('Work Mode'), findsOneWidget);
      expect(find.text('Hybrid'), findsWidgets);
      expect(find.text('Domain'), findsOneWidget);
      expect(find.text('Full Stack'), findsWidgets);

      // Overview Section
      expect(find.text('Internship Overview'), findsOneWidget);
      expect(find.text(internship.description), findsOneWidget);

      // Responsibilities Section
      expect(find.text('Key Responsibilities'), findsOneWidget);
      for (final r in internship.responsibilities) {
        expect(find.text(r), findsOneWidget);
      }

      // Required Skills Section
      expect(find.text('Required & Emphasized Skills'), findsOneWidget);
      for (final s in internship.skills) {
        expect(find.text(s), findsWidgets);
      }

      // Learning Outcomes Section
      expect(find.text('Learning Outcomes'), findsOneWidget);
      for (final outcome in internship.learningOutcomes) {
        expect(find.text(outcome), findsOneWidget);
      }

      // Why Intern Section
      expect(find.text('Why Intern at CodeNova'), findsOneWidget);
      expect(find.text('Industry Mentorship'), findsOneWidget);
      expect(find.text('Live Client Deliverables'), findsOneWidget);
      expect(find.text('Verifiable Certification'), findsOneWidget);

      // Company Info Section
      expect(find.text('Company Information'), findsOneWidget);
      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.text(AppStrings.address), findsOneWidget);
      expect(find.text(AppStrings.phone), findsOneWidget);
      expect(find.text(AppStrings.email), findsOneWidget);

      // Sticky CTA Bar
      expect(find.text('Apply Now'), findsOneWidget);
      expect(find.byIcon(Icons.phone_rounded), findsWidgets);
    });

    testWidgets('Gracefully handles missing optional fields and null mode',
        (tester) async {
      await setupViewport(tester);

      const minimalInternship = InternshipModel(
        id: 'minimal-internship',
        title: 'Basic QA Internship',
        domain: 'Quality Assurance',
        duration: '',
        description: '',
        skills: [],
        responsibilities: [],
        learningOutcomes: [],
        mode: null,
        status: InternshipStatus.open,
        techCategory: 'Testing',
      );

      await tester.pumpWidget(buildTestApp(minimalInternship));
      await settle(tester);

      // Title & Domain
      expect(find.text('Basic QA Internship'), findsWidgets);
      expect(find.text('Quality Assurance'), findsWidgets);

      // Fallbacks
      expect(find.text('Unspecified'), findsOneWidget); // Empty duration fallback
      expect(find.text('Not Specified'), findsOneWidget); // Null mode fallback
      expect(
        find.text('No specific overview provided for this position.'),
        findsOneWidget,
      );

      // Optional sections should be omitted
      expect(find.text('Key Responsibilities'), findsNothing);
      expect(find.text('Required & Emphasized Skills'), findsNothing);
      expect(find.text('Learning Outcomes'), findsNothing);

      // Static sections still render
      expect(find.text('Why Intern at CodeNova'), findsOneWidget);
      expect(find.text('Company Information'), findsOneWidget);
      expect(find.text('Apply Now'), findsOneWidget);
    });

    testWidgets('Express Interest state for coming soon internships',
        (tester) async {
      await setupViewport(tester);

      const comingSoonInternship = InternshipModel(
        id: 'upcoming-cybersecurity',
        title: 'Cybersecurity Internship',
        domain: 'Information Security',
        duration: '2 Months',
        description: 'Hands-on network security analysis and testing.',
        status: InternshipStatus.comingSoon,
        techCategory: 'Security',
      );

      await tester.pumpWidget(buildTestApp(comingSoonInternship));
      await settle(tester);

      expect(find.text('Coming Soon'), findsWidgets);
      expect(find.text('Express Interest'), findsOneWidget);
    });

    testWidgets('Disabled CTA for closed internships', (tester) async {
      await setupViewport(tester);

      const closedInternship = InternshipModel(
        id: 'closed-role',
        title: 'DevOps Engineering',
        domain: 'Cloud Operations',
        duration: '3 Months',
        description: 'Cloud deployment pipeline management.',
        status: InternshipStatus.closed,
        techCategory: 'DevOps',
      );

      await tester.pumpWidget(buildTestApp(closedInternship));
      await settle(tester);

      expect(find.text('Closed'), findsWidgets);
      expect(find.text('Applications Closed'), findsOneWidget);
    });

    testWidgets('Tapping Apply Now opens application bottom sheet',
        (tester) async {
      await setupViewport(tester);

      final internship = MockData.internships.first;
      await tester.pumpWidget(buildTestApp(internship));
      await settle(tester);

      final applyButton = find.text('Apply Now');
      await tester.tap(applyButton);
      await settle(tester);

      // Bottom sheet contents
      expect(find.text('Apply for Position'), findsOneWidget);
      expect(find.text('Send Resume via Email'), findsOneWidget);
      expect(find.textContaining('Call CodeNova'), findsOneWidget);

      // Close modal
      final closeButton = find.byIcon(Icons.close_rounded);
      await tester.tap(closeButton);
      await settle(tester);

      expect(find.text('Apply for Position'), findsNothing);
    });

    testWidgets('Tapping share button triggers SnackBar confirmation',
        (tester) async {
      await setupViewport(tester);

      final internship = MockData.internships.first;
      await tester.pumpWidget(buildTestApp(internship));
      await settle(tester);

      final shareButton = find.byIcon(Icons.share_rounded);
      await tester.tap(shareButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Sharing ${internship.title}'), findsOneWidget);
    });

    testWidgets('Back button pops page cleanly', (tester) async {
      await setupViewport(tester);

      final internship = MockData.internships.first;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            InternshipDetailPage(internship: internship),
                      ),
                    );
                  },
                  child: const Text('Open Details'),
                ),
              ),
            ),
          ),
        ),
      );
      await settle(tester);

      // Push detail page
      await tester.tap(find.text('Open Details'));
      await settle(tester);
      expect(find.byType(InternshipDetailPage), findsOneWidget);

      // Pop back
      final backButton = find.byIcon(Icons.arrow_back_rounded);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(InternshipDetailPage), findsNothing);
      expect(find.text('Open Details'), findsOneWidget);
    });
  });
}

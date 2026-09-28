import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:codenova_app/models/internship_model.dart';
import 'package:codenova_app/features/internships/data/repositories/internships_repository.dart';
import 'package:codenova_app/features/internships/presentation/controllers/internships_controller.dart';
import 'package:codenova_app/features/internships/presentation/pages/internships_page.dart';
import 'package:codenova_app/features/internships/presentation/pages/internship_detail_page.dart';
import 'package:codenova_app/features/internships/presentation/widgets/internships_widgets.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  // ── Model Unit Tests ─────────────────────────────────────────────────────
  group('InternshipModel Unit Tests', () {
    test('InternshipModel serialization roundtrip', () {
      const model = InternshipModel(
        id: 'test-internship',
        title: 'Test Engineering Internship',
        domain: 'Full Stack Testing',
        duration: '3 Months',
        description: 'A comprehensive internship for testing.',
        skills: ['Flutter', 'Testing', 'Git'],
        status: InternshipStatus.open,
        techCategory: 'Full Stack',
      );

      final json = model.toJson();
      expect(json['id'], 'test-internship');
      expect(json['duration'], '3 Months');
      expect(json['status'], 'open');
      expect(json['techCategory'], 'Full Stack');
      expect(json['mode'], isNull);

      final reconstructed = InternshipModel.fromJson(json);
      expect(reconstructed.id, model.id);
      expect(reconstructed.title, model.title);
      expect(reconstructed.duration, '3 Months');
      expect(reconstructed.status, InternshipStatus.open);
      expect(reconstructed.techCategory, 'Full Stack');
      expect(reconstructed.mode, isNull);
    });

    test('InternshipStatus parsing handles all cases', () {
      expect(InternshipStatus.fromString('open'), InternshipStatus.open);
      expect(InternshipStatus.fromString('closed'), InternshipStatus.closed);
      expect(InternshipStatus.fromString('comingsoon'), InternshipStatus.comingSoon);
      expect(InternshipStatus.fromString('coming_soon'), InternshipStatus.comingSoon);
      expect(InternshipStatus.fromString(null), InternshipStatus.open);
      expect(InternshipStatus.fromString('unknown'), InternshipStatus.open);
    });

    test('InternshipMode parsing handles all cases', () {
      expect(InternshipMode.fromString('offline'), InternshipMode.offline);
      expect(InternshipMode.fromString('online'), InternshipMode.online);
      expect(InternshipMode.fromString('hybrid'), InternshipMode.hybrid);
      expect(InternshipMode.fromString(null), isNull);
      expect(InternshipMode.fromString('unknown'), isNull);
    });

    test('isOpen getter reflects open status', () {
      const open = InternshipModel(
        id: 'a',
        title: 'A',
        domain: 'D',
        duration: '3 Months',
        description: 'Desc',
        skills: [],
        status: InternshipStatus.open,
      );
      const closed = InternshipModel(
        id: 'b',
        title: 'B',
        domain: 'D',
        duration: '3 Months',
        description: 'Desc',
        skills: [],
        status: InternshipStatus.closed,
      );
      expect(open.isOpen, isTrue);
      expect(closed.isOpen, isFalse);
    });

    test('copyWith creates modified copy', () {
      const model = InternshipModel(
        id: 'original',
        title: 'Original',
        domain: 'Domain',
        duration: '3 Months',
        description: 'Description',
        skills: ['Python'],
        status: InternshipStatus.open,
      );
      final copy = model.copyWith(
        status: InternshipStatus.closed,
        title: 'Updated',
      );
      expect(copy.id, 'original');
      expect(copy.title, 'Updated');
      expect(copy.status, InternshipStatus.closed);
      expect(copy.duration, '3 Months');
    });
  });

  // ── Controller Unit Tests ────────────────────────────────────────────────
  group('InternshipsController Unit Tests', () {
    test('Loads 3 verified internships from mock data', () async {
      final controller = InternshipsController(
        repository: const MockInternshipsRepository(delay: Duration.zero),
      );
      expect(controller.status, InternshipsStatus.initial);
      await controller.loadInternships();
      expect(controller.status, InternshipsStatus.success);
      expect(controller.totalCount, 3);
      expect(controller.filteredCount, 3);
    });

    test('Search filters by title and skills', () async {
      final controller = InternshipsController(
        repository: const MockInternshipsRepository(delay: Duration.zero),
      );
      await controller.loadInternships();
      controller.search('Python');
      expect(controller.filteredCount, 1);
      expect(controller.internships.first.id, 'python-ai-internship');
    });

    test('Category filter works correctly', () async {
      final controller = InternshipsController(
        repository: const MockInternshipsRepository(delay: Duration.zero),
      );
      await controller.loadInternships();
      controller.setCategory('Data & AI');
      expect(controller.filteredCount, 1);
      expect(controller.internships.first.techCategory, 'Data & AI');
    });

    test('clearFilters restores full list', () async {
      final controller = InternshipsController(
        repository: const MockInternshipsRepository(delay: Duration.zero),
      );
      await controller.loadInternships();
      controller.search('Python');
      expect(controller.filteredCount, 1);
      controller.clearFilters();
      expect(controller.filteredCount, 3);
      expect(controller.hasActiveFilters, isFalse);
    });

    test('Error state on simulated failure', () async {
      final controller = InternshipsController(
        repository: const MockInternshipsRepository(
          delay: Duration.zero,
          simulateFailure: true,
        ),
      );
      await controller.loadInternships();
      expect(controller.status, InternshipsStatus.error);
      expect(controller.errorMessage, isNotNull);
    });

    test('openCount returns correct count', () async {
      final controller = InternshipsController(
        repository: const MockInternshipsRepository(delay: Duration.zero),
      );
      await controller.loadInternships();
      // All 3 mock internships are open
      expect(controller.openCount, 3);
    });
  });

  // ── Widget Integration Tests ─────────────────────────────────────────────
  group('InternshipsPage Widget Integration Tests', () {
    Widget buildTestApp({InternshipsController? controller}) {
      return MaterialApp(
        home: InternshipsPage(controller: controller),
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

    testWidgets('Renders apply banner, search bar, and internship cards',
        (tester) async {
      await setupViewport(tester);

      final controller = InternshipsController(
        repository: const MockInternshipsRepository(delay: Duration.zero),
      );
      await controller.loadInternships();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await settle(tester);

      // AppBar
      expect(find.text('Internships'), findsOneWidget);

      // Apply banner
      expect(find.byType(InternshipApplyBanner), findsOneWidget);
      expect(find.text('Start Your IT Career'), findsOneWidget);

      // Cards
      expect(find.byType(InternshipCard), findsWidgets);
      expect(find.text('Software Engineering Internship'), findsOneWidget);
      expect(find.text('Web Development Internship'), findsOneWidget);
      expect(find.text('Python & AI Internship'), findsOneWidget);
    });

    testWidgets('Search filters internship list dynamically', (tester) async {
      await setupViewport(tester);

      final controller = InternshipsController(
        repository: const MockInternshipsRepository(delay: Duration.zero),
      );
      await controller.loadInternships();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await settle(tester);

      await tester.enterText(find.byType(TextField), 'Python');
      await settle(tester);

      expect(find.text('Python & AI Internship'), findsOneWidget);
      expect(find.text('Web Development Internship'), findsNothing);
      expect(find.text('Clear filters'), findsOneWidget);
    });

    testWidgets('Empty state renders with Reset Filters button',
        (tester) async {
      await setupViewport(tester);

      final controller = InternshipsController(
        repository: const MockInternshipsRepository(delay: Duration.zero),
      );
      await controller.loadInternships();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await settle(tester);

      await tester.enterText(find.byType(TextField), 'QuantumBanana999');
      await settle(tester);

      expect(find.byType(InternshipEmptyState), findsOneWidget);
      expect(find.text('No Internships Found'), findsOneWidget);
      expect(find.text('Reset Filters'), findsOneWidget);

      await tester.tap(find.text('Reset Filters'));
      await settle(tester);

      expect(find.byType(InternshipEmptyState), findsNothing);
      expect(find.byType(InternshipCard), findsWidgets);
    });

    testWidgets('Error state renders with Try Again button', (tester) async {
      await setupViewport(tester);

      final controller = InternshipsController(
        repository: const MockInternshipsRepository(
          delay: Duration.zero,
          simulateFailure: true,
        ),
      );
      await controller.loadInternships();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await settle(tester);

      expect(find.byType(InternshipErrorState), findsOneWidget);
      expect(find.text('Unable to Load Internships'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('Tapping View Details opens InternshipDetailPage',
        (tester) async {
      await setupViewport(tester);

      final controller = InternshipsController(
        repository: const MockInternshipsRepository(delay: Duration.zero),
      );
      await controller.loadInternships();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await settle(tester);

      final viewDetailsButton = find.text('View Details').first;
      await tester.ensureVisible(viewDetailsButton);
      await tester.tap(viewDetailsButton);
      await settle(tester);

      expect(find.byType(InternshipDetailPage), findsOneWidget);
      expect(find.text('Internship Overview'), findsOneWidget);
      expect(find.text('Why Intern at CodeNova'), findsOneWidget);
      expect(find.text('Apply Now'), findsOneWidget);

      // Back navigation
      final backButton = find.byIcon(Icons.arrow_back_rounded);
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.byType(InternshipDetailPage), findsNothing);
      expect(find.byType(InternshipsPage), findsOneWidget);
    });

    testWidgets(
        'Unavailable / closed internship renders status and closed notice in details',
        (tester) async {
      await setupViewport(tester);

      const closedInternship = InternshipModel(
        id: 'closed-role',
        title: 'Cloud DevOps Internship',
        domain: 'Infrastructure & CI/CD',
        duration: '3 Months',
        description: 'Work with cloud infrastructure and automation pipelines.',
        skills: ['AWS', 'Docker', 'CI/CD'],
        status: InternshipStatus.closed,
        techCategory: 'Cloud',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: InternshipCard(internship: closedInternship),
            ),
          ),
        ),
      );
      await settle(tester);

      expect(find.text('Closed'), findsOneWidget);
      expect(find.text('Cloud DevOps Internship'), findsOneWidget);

      final viewDetailsButton = find.text('View Details');
      await tester.ensureVisible(viewDetailsButton);
      await tester.tap(viewDetailsButton);
      await settle(tester);

      expect(find.byType(InternshipDetailPage), findsOneWidget);
      expect(
        find.text('Applications Closed'),
        findsOneWidget,
      );
    });
  });
}


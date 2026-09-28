import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:codenova_app/models/course_model.dart';
import 'package:codenova_app/features/courses/data/repositories/courses_repository.dart';
import 'package:codenova_app/features/courses/presentation/controllers/courses_controller.dart';
import 'package:codenova_app/features/courses/presentation/pages/courses_page.dart';
import 'package:codenova_app/features/courses/presentation/pages/course_detail_page.dart';
import 'package:codenova_app/features/courses/presentation/widgets/courses_widgets.dart';

void main() {
  group('CourseModel Unit & Serialization Tests', () {
    test('CourseModel serialization toJson and fromJson roundtrip', () {
      const course = CourseModel(
        id: 'test-course',
        title: 'Test Engineering',
        subtitle: 'Flutter · Dart · Unit Testing',
        description: 'Comprehensive software testing and architecture.',
        duration: '1 Month',
        level: CourseLevel.intermediate,
        tags: ['Flutter', 'Testing'],
        icon: Icons.code_rounded,
        category: 'Mobile Development',
        isFeatured: true,
      );

      final json = course.toJson();
      expect(json['id'], 'test-course');
      expect(json['duration'], '1 Month');
      expect(json['category'], 'Mobile Development');
      expect(json['level'], 'intermediate');

      final reconstructed = CourseModel.fromJson(json);
      expect(reconstructed.id, course.id);
      expect(reconstructed.title, course.title);
      expect(reconstructed.duration, '1 Month');
      expect(reconstructed.level, CourseLevel.intermediate);
      expect(reconstructed.category, 'Mobile Development');
    });

    test('CourseLevel parsing handles null and case-insensitive strings', () {
      expect(CourseLevel.fromString('beginner'), CourseLevel.beginner);
      expect(CourseLevel.fromString('INTERMEDIATE'), CourseLevel.intermediate);
      expect(CourseLevel.fromString('advanced'), CourseLevel.advanced);
      expect(CourseLevel.fromString(null), CourseLevel.beginner);
      expect(CourseLevel.fromString('unknown'), CourseLevel.beginner);
    });
  });

  group('CoursesController Unit Tests', () {
    test('Initial loading and success state with verified courses', () async {
      final controller = CoursesController(
        repository: const MockCoursesRepository(delay: Duration.zero),
      );

      expect(controller.status, CoursesStatus.initial);
      await controller.loadCourses();

      expect(controller.status, CoursesStatus.success);
      expect(controller.totalCount, 6);
      expect(controller.filteredCount, 6);
      expect(controller.courses.every((c) => c.duration == '1 Month'), isTrue);
    });

    test('Category filtering narrows course list', () async {
      final controller = CoursesController(
        repository: const MockCoursesRepository(delay: Duration.zero),
      );
      await controller.loadCourses();

      controller.setCategory('Web Development');
      expect(controller.filteredCount, 1);
      expect(controller.courses.first.title, 'Full Stack Development');

      controller.setCategory('Programming');
      expect(controller.filteredCount, 2);

      controller.setCategory('All');
      expect(controller.filteredCount, 6);
    });

    test('Search query filters across title, description, and tags', () async {
      final controller = CoursesController(
        repository: const MockCoursesRepository(delay: Duration.zero),
      );
      await controller.loadCourses();

      controller.search('Android');
      expect(controller.filteredCount, 1);
      expect(controller.courses.first.title, 'Android Development');

      controller.search('Python');
      // Should match Python Programming and Data Science (which tags Python)
      expect(controller.filteredCount, 2);

      controller.search('NonExistentKeywordXYZ');
      expect(controller.status, CoursesStatus.empty);
      expect(controller.filteredCount, 0);

      controller.clearFilters();
      expect(controller.status, CoursesStatus.success);
      expect(controller.filteredCount, 6);
    });

    test('Error handling and retry functionality', () async {
      final controller = CoursesController(
        repository: const MockCoursesRepository(
          delay: Duration.zero,
          simulateFailure: true,
        ),
      );

      await controller.loadCourses();
      expect(controller.status, CoursesStatus.error);
      expect(controller.errorMessage, isNotNull);
    });
  });

  group('CoursesPage Widget Integration Tests', () {
    // Uses a GoRouter so CourseCard.push() works without a runtime assertion.
    Widget buildTestApp({CoursesController? controller}) {
      final router = GoRouter(
        initialLocation: '/courses',
        routes: [
          GoRoute(
            path: '/courses',
            builder: (context, state) => CoursesPage(controller: controller),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final course = state.extra as CourseModel?;
                  return CourseDetailPage(
                    course: course ??
                        const CourseModel(
                          id: 'fallback',
                          title: 'Fallback',
                          subtitle: '',
                          description: '',
                          duration: '1 Month',
                          level: CourseLevel.beginner,
                          tags: [],
                          icon: Icons.school_rounded,
                        ),
                  );
                },
              ),
            ],
          ),
        ],
      );
      return MaterialApp.router(routerConfig: router);
    }

    testWidgets('Renders header, search bar, filter chips, and all course cards',
        (tester) async {
      final controller = CoursesController(
        repository: const MockCoursesRepository(delay: Duration.zero),
      );
      await controller.loadCourses();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      // Screen Header
      expect(find.text('Training Programmes'), findsOneWidget);
      expect(
        find.text(
          'Industry-focused 1-month technical training designed to make you job-ready.',
        ),
        findsOneWidget,
      );

      // Search bar
      expect(find.byType(CourseSearchBar), findsOneWidget);

      // Category filter chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Web Development'), findsWidgets);
      expect(find.text('Mobile Development'), findsWidgets);
      expect(find.text('Programming'), findsWidgets);
      expect(find.text('Data & AI'), findsWidgets);

      // Result count bar
      expect(find.text('6 available programmes'), findsOneWidget);

      // Course cards
      expect(find.byType(CourseCard), findsWidgets);
      expect(find.text('Full Stack Development'), findsOneWidget);
      expect(find.text('Android Development'), findsOneWidget);

      // Verified 1 Month duration badges
      expect(find.text('1 Month'), findsWidgets);
    });

    testWidgets('Searching dynamically filters courses in the list',
        (tester) async {
      final controller = CoursesController(
        repository: const MockCoursesRepository(delay: Duration.zero),
      );
      await controller.loadCourses();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      // Enter search term
      await tester.enterText(find.byType(TextField), 'Android');
      await tester.pumpAndSettle();

      expect(find.text('Android Development'), findsOneWidget);
      expect(find.text('Full Stack Development'), findsNothing);
      expect(find.textContaining('1 of 6 programme'), findsOneWidget);
      expect(find.text('Clear filters'), findsOneWidget);

      // Tap clear filters
      await tester.tap(find.text('Clear filters'));
      await tester.pumpAndSettle();

      expect(find.text('Full Stack Development'), findsOneWidget);
      expect(find.text('Android Development'), findsOneWidget);
    });

    testWidgets('Empty state renders with Reset Filters button',
        (tester) async {
      final controller = CoursesController(
        repository: const MockCoursesRepository(delay: Duration.zero),
      );
      await controller.loadCourses();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      // Search for non-existent keyword
      await tester.enterText(find.byType(TextField), 'QuantumComputing999');
      await tester.pumpAndSettle();

      expect(find.byType(CourseEmptyState), findsOneWidget);
      expect(find.text('No Programmes Found'), findsOneWidget);
      expect(find.text('Reset Filters'), findsOneWidget);

      // Tap Reset Filters
      await tester.tap(find.text('Reset Filters'));
      await tester.pumpAndSettle();

      expect(find.byType(CourseEmptyState), findsNothing);
      expect(find.byType(CourseCard), findsWidgets);
    });

    testWidgets('Error state renders with Try Again button', (tester) async {
      final controller = CoursesController(
        repository: const MockCoursesRepository(
          delay: Duration.zero,
          simulateFailure: true,
        ),
      );
      await controller.loadCourses();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      expect(find.byType(CourseErrorState), findsOneWidget);
      expect(find.text('Unable to Load Courses'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('Tapping View Details navigates to CourseDetailPage',
        (tester) async {
      final controller = CoursesController(
        repository: const MockCoursesRepository(delay: Duration.zero),
      );
      await controller.loadCourses();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      // Tap first "View Details" button
      final viewDetailsButton = find.text('View Details').first;
      await tester.ensureVisible(viewDetailsButton);
      await tester.tap(viewDetailsButton);
      await tester.pumpAndSettle();

      // Verify navigation reached CourseDetailPage
      expect(find.byType(CourseDetailPage), findsOneWidget);
      // Verify key detail page sections are visible
      expect(find.text('Programme Overview'), findsOneWidget);
      expect(find.text('Enquire for Batch'), findsOneWidget);

      // Navigate back
      final backButton = find.byIcon(Icons.arrow_back_rounded);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(CourseDetailPage), findsNothing);
      expect(find.byType(CoursesPage), findsOneWidget);
    });
  });
}

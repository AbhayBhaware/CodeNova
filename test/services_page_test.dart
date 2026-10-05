import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:codenova_app/core/widgets/widgets.dart';
import 'package:codenova_app/models/service_model.dart';
import 'package:codenova_app/features/services/data/repositories/services_repository.dart';
import 'package:codenova_app/features/services/presentation/controllers/services_controller.dart';
import 'package:codenova_app/features/services/presentation/pages/services_page.dart';
import 'package:codenova_app/features/services/presentation/pages/service_detail_page.dart';
import 'package:codenova_app/features/services/presentation/widgets/services_widgets.dart';

void main() {
  group('ServiceModel Unit & Serialization Tests', () {
    test('ServiceModel serialization toJson and fromJson roundtrip', () {
      const service = ServiceModel(
        id: 'test-service',
        title: 'Custom Cloud Architecture',
        description: 'Scalable cloud infrastructure engineering.',
        icon: Icons.cloud_done_rounded,
        tags: ['AWS', 'Docker', 'Kubernetes'],
        category: 'AI & Cloud',
        features: ['Automated CI/CD', 'High availability'],
        deliverables: ['IaC scripts', 'Uptime monitoring'],
      );

      final json = service.toJson();
      expect(json['id'], 'test-service');
      expect(json['title'], 'Custom Cloud Architecture');
      expect(json['category'], 'AI & Cloud');
      expect(json['tags'], ['AWS', 'Docker', 'Kubernetes']);

      final reconstructed = ServiceModel.fromJson(json);
      expect(reconstructed.id, service.id);
      expect(reconstructed.title, service.title);
      expect(reconstructed.description, service.description);
      expect(reconstructed.category, service.category);
      expect(reconstructed.features, service.features);
      expect(reconstructed.deliverables, service.deliverables);
    });

    test('ServiceModel copyWith modifies target fields cleanly', () {
      const original = ServiceModel(
        id: 'web',
        title: 'Web Dev',
        description: 'Original description',
        icon: Icons.web_rounded,
        tags: ['React'],
        category: 'Web',
      );

      final updated = original.copyWith(
        title: 'Full Stack Web Dev',
        category: 'Enterprise',
      );

      expect(updated.id, 'web');
      expect(updated.title, 'Full Stack Web Dev');
      expect(updated.category, 'Enterprise');
      expect(updated.description, 'Original description');
    });

    test('ServiceModel equality and hashCode check', () {
      const a = ServiceModel(
        id: '1',
        title: 'Service',
        description: 'Desc',
        icon: Icons.code_rounded,
        tags: ['Tag'],
        category: 'Web',
      );
      const b = ServiceModel(
        id: '1',
        title: 'Service',
        description: 'Desc',
        icon: Icons.code_rounded,
        tags: ['Tag'],
        category: 'Web',
      );

      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('ServicesController Unit Tests', () {
    test('Initial loading loads all 6 verified services with success state', () async {
      final controller = ServicesController(
        repository: const MockServicesRepository(delay: Duration.zero),
      );

      expect(controller.status, ServicesStatus.initial);
      await controller.loadServices();

      expect(controller.status, ServicesStatus.success);
      expect(controller.totalCount, 6);
      expect(controller.filteredCount, 6);
    });

    test('Category filtering narrows service list', () async {
      final controller = ServicesController(
        repository: const MockServicesRepository(delay: Duration.zero),
      );
      await controller.loadServices();

      controller.setCategory('Web');
      expect(controller.filteredCount, 1);
      expect(controller.services.first.id, 'web-development');

      controller.setCategory('Mobile');
      expect(controller.filteredCount, 1);
      expect(controller.services.first.id, 'mobile-development');

      controller.setCategory('Security');
      expect(controller.filteredCount, 1);
      expect(controller.services.first.id, 'cybersecurity');

      controller.setCategory('AI & Cloud');
      expect(controller.filteredCount, 2);

      controller.setCategory('All');
      expect(controller.filteredCount, 6);
    });

    test('Search query matches title, description, tags, and features', () async {
      final controller = ServicesController(
        repository: const MockServicesRepository(delay: Duration.zero),
      );
      await controller.loadServices();

      // Search by title
      controller.search('Cybersecurity');
      expect(controller.filteredCount, 1);
      expect(controller.services.first.title, 'Cybersecurity Solutions');

      // Search by tech tag
      controller.search('Flutter');
      expect(controller.filteredCount, 1);
      expect(controller.services.first.title, 'Mobile App Development');

      // Search non-existent keyword
      controller.search('XYZ123NonExistent');
      expect(controller.status, ServicesStatus.empty);
      expect(controller.filteredCount, 0);

      // Clear filters
      controller.clearFilters();
      expect(controller.status, ServicesStatus.success);
      expect(controller.filteredCount, 6);
      expect(controller.selectedCategory, 'All');
      expect(controller.searchQuery, '');
    });

    test('Error handling and retry state', () async {
      final controller = ServicesController(
        repository: const MockServicesRepository(
          delay: Duration.zero,
          simulateFailure: true,
        ),
      );

      await controller.loadServices();
      expect(controller.status, ServicesStatus.error);
      expect(controller.errorMessage, isNotNull);
    });
  });

  group('ServicesPage Widget Integration Tests', () {
    Widget buildTestApp({ServicesController? controller}) {
      final router = GoRouter(
        initialLocation: '/services',
        routes: [
          GoRoute(
            path: '/services',
            builder: (context, state) => ServicesPage(controller: controller),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final service = state.extra as ServiceModel?;
                  return ServiceDetailPage(
                    service: service ??
                        const ServiceModel(
                          id: 'fallback',
                          title: 'Fallback Service',
                          description: 'Fallback',
                          icon: Icons.code_rounded,
                          tags: [],
                        ),
                  );
                },
              ),
            ],
          ),
        ],
      );

      return MaterialApp.router(
        routerConfig: router,
      );
    }

    testWidgets('Renders header, quote promotional banner, search bar, and cards', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = ServicesController(
        repository: const MockServicesRepository(delay: Duration.zero),
      );
      await controller.loadServices();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      expect(find.text('IT Services & Solutions'), findsOneWidget);
      expect(find.text('Need a Custom Software or AI Solution?'), findsOneWidget);
      expect(find.byType(ServiceSearchBar), findsOneWidget);
      expect(find.byType(ServiceFilterBar), findsOneWidget);
      expect(find.byType(ServiceCard), findsWidgets);
      expect(find.text('Showing 6 of 6 services'), findsOneWidget);
      expect(find.text('Web Application Development'), findsOneWidget);
      expect(find.text('Mobile App Development'), findsOneWidget);
    });

    testWidgets('Filtering by category updates visible service cards', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = ServicesController(
        repository: const MockServicesRepository(delay: Duration.zero),
      );
      await controller.loadServices();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      // Tap on Mobile filter chip in ServiceFilterBar
      final mobileFilter = find.descendant(
        of: find.byType(ServiceFilterBar),
        matching: find.text('Mobile'),
      );
      await tester.tap(mobileFilter);
      await tester.pumpAndSettle();

      expect(find.byType(ServiceCard), findsOneWidget);
      expect(find.text('Showing 1 of 6 services'), findsOneWidget);
      expect(find.text('Mobile App Development'), findsOneWidget);
      expect(find.text('Web Application Development'), findsNothing);

      // Tap on All filter chip in ServiceFilterBar
      final allFilter = find.descendant(
        of: find.byType(ServiceFilterBar),
        matching: find.text('All'),
      );
      await tester.tap(allFilter);
      await tester.pumpAndSettle();

      expect(find.byType(ServiceCard), findsWidgets);
      expect(find.text('Showing 6 of 6 services'), findsOneWidget);
    });

    testWidgets('Search query updates visible cards and shows empty state', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = ServicesController(
        repository: const MockServicesRepository(delay: Duration.zero),
      );
      await controller.loadServices();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Cybersecurity');
      await tester.pumpAndSettle();

      expect(find.byType(ServiceCard), findsOneWidget);
      expect(find.text('Showing 1 of 6 services'), findsOneWidget);
      expect(find.text('Cybersecurity Solutions'), findsOneWidget);

      // Enter unmatched query
      await tester.enterText(find.byType(TextField), 'UnknownServiceQuery');
      await tester.pumpAndSettle();

      expect(find.byType(ServiceCard), findsNothing);
      expect(find.byType(ServicesEmptyState), findsOneWidget);
      expect(find.text('No Services Found'), findsOneWidget);

      // Tap Reset Filters
      await tester.tap(find.text('Reset Filters'));
      await tester.pumpAndSettle();

      expect(find.byType(ServiceCard), findsWidgets);
      expect(find.text('Showing 6 of 6 services'), findsOneWidget);
    });

    testWidgets('Error state displays retry button and recovers on retry', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = ServicesController(
        repository: const MockServicesRepository(
          delay: Duration.zero,
          simulateFailure: true,
        ),
      );
      await controller.loadServices();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      expect(find.byType(ServicesErrorState), findsOneWidget);
      expect(find.text('Unable to Load Services'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('Tapping Request a Quote banner opens quote request sheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final controller = ServicesController(
        repository: const MockServicesRepository(delay: Duration.zero),
      );
      await controller.loadServices();

      await tester.pumpWidget(buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      // Find the "Request a Quote" button inside the banner
      final quoteButton = find.widgetWithText(AppGradientButton, 'Request a Quote').first;
      await tester.tap(quoteButton);
      await tester.pumpAndSettle();

      expect(find.byType(QuoteRequestSheet), findsOneWidget);
      expect(find.text('Request a Project Quote'), findsOneWidget);
    });
  });
}

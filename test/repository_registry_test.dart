import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/core/config/app_config.dart';
import 'package:codenova_app/core/di/repository_registry.dart';
import 'package:codenova_app/features/courses/data/repositories/courses_repository.dart';
import 'package:codenova_app/features/courses/data/repositories/http_courses_repository.dart';
import 'package:codenova_app/features/internships/data/repositories/internships_repository.dart';
import 'package:codenova_app/features/internships/data/repositories/http_internships_repository.dart';
import 'package:codenova_app/features/services/data/repositories/services_repository.dart';
import 'package:codenova_app/features/services/data/repositories/http_services_repository.dart';
import 'package:codenova_app/features/internships/data/repositories/internship_application_repository.dart';
import 'package:codenova_app/features/internships/data/repositories/http_internship_application_repository.dart';
import 'package:codenova_app/features/services/data/repositories/quote_repository.dart';
import 'package:codenova_app/features/services/data/repositories/http_quote_repository.dart';
import 'package:codenova_app/features/contact/data/repositories/contact_repository.dart';
import 'package:codenova_app/features/contact/data/repositories/http_contact_repository.dart';

void main() {
  group('RepositoryRegistry & AppConfig Tests', () {
    test('AppConfig defaults to mock mode safely', () {
      final config = AppConfig.fromEnvironment();
      expect(config.isMock, isTrue);
      expect(config.baseUrl, isEmpty);
      expect(config.apiKey, isEmpty);
    });

    test('RepositoryRegistry instantiates mock repositories when isMock is true', () {
      final registry = RepositoryRegistry(
        config: const AppConfig(environment: AppEnvironment.mock),
      );

      expect(registry.coursesRepository, isA<MockCoursesRepository>());
      expect(registry.internshipsRepository, isA<MockInternshipsRepository>());
      expect(registry.servicesRepository, isA<MockServicesRepository>());
      expect(registry.internshipApplicationRepository, isA<MockInternshipApplicationRepository>());
      expect(registry.quoteRepository, isA<MockQuoteRepository>());
      expect(registry.contactRepository, isA<MockContactRepository>());
    });

    test('RepositoryRegistry instantiates HTTP repositories when isMock is false', () {
      final registry = RepositoryRegistry(
        config: const AppConfig(
          environment: AppEnvironment.production,
          baseUrl: 'https://api.codenovatechsolutions.in/v1',
          apiKey: 'client_key_123',
        ),
      );

      expect(registry.coursesRepository, isA<HttpCoursesRepository>());
      expect(registry.internshipsRepository, isA<HttpInternshipsRepository>());
      expect(registry.servicesRepository, isA<HttpServicesRepository>());
      expect(registry.internshipApplicationRepository, isA<HttpInternshipApplicationRepository>());
      expect(registry.quoteRepository, isA<HttpQuoteRepository>());
      expect(registry.contactRepository, isA<HttpContactRepository>());
    });

    test('RepositoryRegistry respects injected repository instances', () {
      const customMock = MockCoursesRepository(delay: Duration.zero);
      final registry = RepositoryRegistry(
        coursesRepo: customMock,
      );

      expect(registry.coursesRepository, equals(customMock));
    });
  });
}

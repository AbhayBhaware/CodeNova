import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:codenova_app/core/config/app_config.dart';
import 'package:codenova_app/core/network/api_client.dart';
import 'package:codenova_app/models/models.dart';
import 'package:codenova_app/features/courses/data/repositories/courses_repository.dart';
import 'package:codenova_app/features/courses/data/repositories/http_courses_repository.dart';
import 'package:codenova_app/features/internships/data/repositories/http_internships_repository.dart';
import 'package:codenova_app/features/services/data/repositories/http_services_repository.dart';
import 'package:codenova_app/features/internships/data/repositories/http_internship_application_repository.dart';
import 'package:codenova_app/features/services/data/repositories/http_quote_repository.dart';
import 'package:codenova_app/features/contact/data/repositories/http_contact_repository.dart';

void main() {
  group('HTTP Repositories Unit & Integration Tests', () {
    const config = AppConfig(
      environment: AppEnvironment.development,
      baseUrl: 'https://api.codenovatechsolutions.in/v1',
    );

    test('HttpCoursesRepository parses course list and course by id', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/courses')) {
          return http.Response(
            jsonEncode([
              {
                'id': 'full-stack-dev',
                'title': 'Full Stack Development',
                'subtitle': 'HTML · CSS · React',
                'description': 'Master full stack web development.',
                'duration': '1 Month',
                'level': 'beginner',
                'tags': ['React', 'Node'],
                'category': 'Web Development',
                'isFeatured': true,
              }
            ]),
            200,
          );
        } else if (request.url.path.endsWith('/courses/full-stack-dev')) {
          return http.Response(
            jsonEncode({
              'id': 'full-stack-dev',
              'title': 'Full Stack Development',
              'subtitle': 'HTML · CSS · React',
              'description': 'Master full stack web development.',
              'duration': '1 Month',
              'level': 'beginner',
              'tags': ['React'],
              'category': 'Web Development',
              'isFeatured': true,
            }),
            200,
          );
        }
        return http.Response('Not found', 404);
      });

      final repo = HttpCoursesRepository(
        apiClient: ApiClient(httpClient: mockClient, config: config),
      );

      final courses = await repo.getCourses();
      expect(courses.length, 1);
      expect(courses.first.title, 'Full Stack Development');

      final single = await repo.getCourseById('full-stack-dev');
      expect(single, isNotNull);
      expect(single!.id, 'full-stack-dev');
    });

    test('HttpCoursesRepository falls back to mock repository when network fails', () async {
      final mockClient = MockClient((request) async {
        throw http.ClientException('Gateway timeout');
      });

      final repo = HttpCoursesRepository(
        apiClient: ApiClient(httpClient: mockClient, config: config),
        fallbackMock: const MockCoursesRepository(delay: Duration.zero),
      );

      final courses = await repo.getCourses();
      expect(courses.isNotEmpty, isTrue);
      expect(courses.any((c) => c.id == 'full-stack-dev'), isTrue);
    });

    test('HttpInternshipsRepository parses internship list and handles fallback', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {
              'id': 'flutter-internship',
              'title': 'Flutter App Development Internship',
              'overview': 'Real-world mobile apps',
              'responsibilities': ['Build UI components'],
              'skills': ['Dart', 'Flutter'],
              'technologies': ['Flutter'],
              'duration': '1 Month',
              'mode': 'offline',
              'status': 'open',
            }
          ]),
          200,
        );
      });

      final repo = HttpInternshipsRepository(
        apiClient: ApiClient(httpClient: mockClient, config: config),
      );

      final internships = await repo.fetchInternships();
      expect(internships.length, 1);
      expect(internships.first.id, 'flutter-internship');
      expect(internships.first.mode, InternshipMode.offline);
    });

    test('HttpServicesRepository parses IT services list', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {
              'id': 'custom-software',
              'title': 'Custom Software Development',
              'category': 'Enterprise Solutions',
              'shortDescription': 'Tailored software',
              'detailedDescription': 'Enterprise grade applications',
              'features': ['Scalable', 'Modular'],
              'deliverables': ['Source code'],
              'technologies': ['Flutter', 'Node.js'],
              'isFeatured': true,
            }
          ]),
          200,
        );
      });

      final repo = HttpServicesRepository(
        apiClient: ApiClient(httpClient: mockClient, config: config),
      );

      final services = await repo.fetchServices();
      expect(services.length, 1);
      expect(services.first.id, 'custom-software');
    });

    test('HttpInternshipApplicationRepository submits application and returns confirmed result', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        return http.Response(
          jsonEncode({
            'referenceId': 'CN-2026-8819',
            'message': 'Application recorded',
          }),
          201,
        );
      });

      final repo = HttpInternshipApplicationRepository(
        apiClient: ApiClient(httpClient: mockClient, config: config),
      );

      const app = InternshipApplicationModel(
        fullName: 'Devendra Patil',
        email: 'devendra@pune.ac.in',
        phone: '9876543210',
        collegeName: 'Pune University',
        courseBranch: 'BE IT',
        preferredTechnology: 'Flutter',
      );

      final result = await repo.submitApplication(app);
      expect(result.isSuccess, isTrue);
      expect(result.isMock, isFalse);
      expect(result.referenceId, 'CN-2026-8819');
    });

    test('HttpQuoteRepository submits project quote and returns confirmed result', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        return http.Response(
          jsonEncode({
            'referenceId': 'CN-QUOTE-5544',
            'message': 'Proposal enquiry recorded',
          }),
          201,
        );
      });

      final repo = HttpQuoteRepository(
        apiClient: ApiClient(httpClient: mockClient, config: config),
      );

      const quote = QuoteRequestModel(
        fullName: 'Ananya Roy',
        email: 'ananya@business.com',
        projectType: 'Web Development',
        projectDescription: 'Enterprise portal for customer analytics and reporting.',
        preferredContactMethod: 'Email',
      );

      final result = await repo.submitQuote(quote);
      expect(result.isSuccess, isTrue);
      expect(result.isMock, isFalse);
      expect(result.referenceId, 'CN-QUOTE-5544');
    });

    test('HttpContactRepository submits enquiry and returns confirmed result', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        return http.Response(
          jsonEncode({
            'referenceId': 'CN-ENQ-9912',
          }),
          201,
        );
      });

      final repo = HttpContactRepository(
        apiClient: ApiClient(httpClient: mockClient, config: config),
      );

      final enquiry = ContactEnquiryModel(
        fullName: 'Sameer Khan',
        email: 'sameer@gmail.com',
        category: 'General Question',
        message: 'Inquiring about syllabus updates for 2026 batches.',
        submittedAt: DateTime.now(),
      );

      final result = await repo.submitEnquiry(enquiry);
      expect(result.isMock, isFalse);
      expect(result.referenceId, 'CN-ENQ-9912');
    });
  });
}

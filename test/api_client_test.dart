import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:codenova_app/core/config/app_config.dart';
import 'package:codenova_app/core/network/api_client.dart';
import 'package:codenova_app/core/network/api_exceptions.dart';

void main() {
  group('ApiClient Unit Tests', () {
    const testBaseUrl = 'https://api.codenovatechsolutions.in/v1';
    const testApiKey = 'test_pub_client_key_12345';
    const testConfig = AppConfig(
      environment: AppEnvironment.development,
      baseUrl: testBaseUrl,
      apiKey: testApiKey,
      timeoutSeconds: 2,
    );

    test('GET request executes successfully and decodes JSON map', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), '$testBaseUrl/courses?category=Web');
        expect(request.headers['Accept'], 'application/json');
        expect(request.headers['X-Client-Key'], testApiKey);
        expect(request.headers['apikey'], testApiKey);

        return http.Response(
          jsonEncode({
            'success': true,
            'data': [{'id': 'full-stack-dev', 'title': 'Full Stack'}]
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final apiClient = ApiClient(httpClient: mockClient, config: testConfig);
      final result = await apiClient.get('/courses', queryParams: {'category': 'Web'});

      expect(result, isA<Map<String, dynamic>>());
      expect(result['success'], isTrue);
      expect(result['data'][0]['id'], 'full-stack-dev');
    });

    test('POST request sends serialized body and returns 201 Created', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.toString(), '$testBaseUrl/internships/apply');
        expect(request.headers['Content-Type'], 'application/json');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['fullName'], 'Rahul Sharma');

        return http.Response(
          jsonEncode({
            'success': true,
            'referenceId': 'CN-APP-7812',
            'message': 'Received'
          }),
          201,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final apiClient = ApiClient(httpClient: mockClient, config: testConfig);
      final result = await apiClient.post(
        '/internships/apply',
        body: {'fullName': 'Rahul Sharma'},
      );

      expect(result['referenceId'], 'CN-APP-7812');
    });

    test('Translates 400 Bad Request into ValidationApiException with details', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'Invalid payload',
            'details': {'email': 'Invalid email format'}
          }),
          400,
          headers: {'content-type': 'application/json'},
        );
      });

      final apiClient = ApiClient(httpClient: mockClient, config: testConfig);

      expect(
        () => apiClient.post('/enquiries', body: {}),
        throwsA(
          isA<ValidationApiException>()
              .having((e) => e.statusCode, 'statusCode', 400)
              .having((e) => e.message, 'message', 'Invalid payload')
              .having((e) => e.fieldErrors['email'], 'details.email', 'Invalid email format'),
        ),
      );
    });

    test('Translates 404 into NotFoundApiException', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"error": "Course not found"}', 404);
      });

      final apiClient = ApiClient(httpClient: mockClient, config: testConfig);

      expect(
        () => apiClient.get('/courses/unknown-id'),
        throwsA(isA<NotFoundApiException>()),
      );
    });

    test('Translates 429 into RateLimitApiException', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"error": "Too many submissions"}', 429);
      });

      final apiClient = ApiClient(httpClient: mockClient, config: testConfig);

      expect(
        () => apiClient.post('/quotes/request', body: {}),
        throwsA(isA<RateLimitApiException>()),
      );
    });

    test('Translates 500 into ServerApiException with user-friendly message', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"error": "Database error"}', 500);
      });

      final apiClient = ApiClient(httpClient: mockClient, config: testConfig);

      expect(
        () => apiClient.get('/services'),
        throwsA(
          isA<ServerApiException>()
              .having((e) => e.statusCode, 'statusCode', 500)
              .having(
                (e) => e.userFriendlyMessage,
                'userFriendlyMessage',
                contains('temporary server difficulties'),
              ),
        ),
      );
    });

    test('Translates ClientException into NetworkException', () async {
      final mockClient = MockClient((request) async {
        throw http.ClientException('Failed to connect to host');
      });

      final apiClient = ApiClient(httpClient: mockClient, config: testConfig);

      expect(
        () => apiClient.get('/courses'),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.userFriendlyMessage,
            'userFriendlyMessage',
            contains('Unable to connect to the server'),
          ),
        ),
      );
    });
  });
}

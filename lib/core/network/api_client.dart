import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'api_exceptions.dart';

/// HTTP Client abstraction responsible for executing network requests,
/// injecting authentication/gateway headers, handling timeouts, and
/// mapping status codes to strongly typed [ApiException] instances.
class ApiClient {
  ApiClient({
    http.Client? httpClient,
    AppConfig? config,
  })  : _httpClient = httpClient ?? http.Client(),
        _config = config ?? AppConfig.fromEnvironment();

  final http.Client _httpClient;
  final AppConfig _config;

  AppConfig get config => _config;

  /// Default headers sent with every request.
  Map<String, String> get _defaultHeaders {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_config.apiKey.isNotEmpty) {
      headers['X-Client-Key'] = _config.apiKey;
      headers['apikey'] = _config.apiKey; // PostgREST / Supabase compatible
    }
    return headers;
  }

  /// Resolves an endpoint path against the configured [baseUrl].
  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final cleanBase = _config.baseUrl.endsWith('/')
        ? _config.baseUrl.substring(0, _config.baseUrl.length - 1)
        : _config.baseUrl;
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final fullUrl = '$cleanBase$cleanEndpoint';

    final uri = Uri.parse(fullUrl);
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  /// Executes an HTTP GET request to [endpoint].
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    final mergedHeaders = {..._defaultHeaders, ...?headers};

    try {
      final response = await _httpClient
          .get(uri, headers: mergedHeaders)
          .timeout(_config.timeoutDuration);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutApiException();
    }
  }

  /// Executes an HTTP POST request to [endpoint] with JSON-encoded [body].
  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(endpoint);
    final mergedHeaders = {..._defaultHeaders, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await _httpClient
          .post(uri, headers: mergedHeaders, body: encodedBody)
          .timeout(_config.timeoutDuration);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutApiException();
    }
  }

  /// Processes the raw HTTP [response] and translates status codes.
  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;

    // Decode response body safely
    dynamic decodedBody;
    if (response.body.isNotEmpty) {
      try {
        decodedBody = jsonDecode(response.body);
      } catch (_) {
        try {
          decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
        } catch (_) {
          decodedBody = response.body;
        }
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decodedBody;
    }

    // Extract message from standard JSON error structures
    String errorMessage = 'Request failed with status $statusCode';
    Map<String, dynamic> fieldErrors = {};

    if (decodedBody is Map<String, dynamic>) {
      if (decodedBody.containsKey('message')) {
        errorMessage = decodedBody['message'].toString();
      } else if (decodedBody.containsKey('error')) {
        errorMessage = decodedBody['error'].toString();
      }

      if (decodedBody.containsKey('details') && decodedBody['details'] is Map) {
        fieldErrors = Map<String, dynamic>.from(decodedBody['details'] as Map);
      }
    }

    if (statusCode == 400 || statusCode == 422) {
      throw ValidationApiException(
        errorMessage,
        statusCode: statusCode,
        fieldErrors: fieldErrors,
      );
    } else if (statusCode == 401 || statusCode == 403) {
      throw UnauthorizedApiException(errorMessage, statusCode);
    } else if (statusCode == 404) {
      throw NotFoundApiException(errorMessage);
    } else if (statusCode == 429) {
      throw RateLimitApiException(errorMessage);
    } else if (statusCode >= 500) {
      throw ServerApiException(errorMessage, statusCode);
    }

    throw ServerApiException(errorMessage, statusCode);
  }

  /// Disposes internal resources.
  void close() {
    _httpClient.close();
  }
}

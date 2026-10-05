/// Base class for all API and networking exceptions.
abstract class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  /// User-friendly presentation message suitable for UI display.
  String get userFriendlyMessage => message;

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

/// Thrown when the device has no internet access or DNS resolution fails.
class NetworkException extends ApiException {
  const NetworkException([
    super.message = 'No internet connection. Please verify your network and try again.',
  ]);

  @override
  String get userFriendlyMessage =>
      'Unable to connect to the server. Please check your internet connectivity.';
}

/// Thrown when a network request exceeds the configured timeout duration.
class TimeoutApiException extends ApiException {
  const TimeoutApiException([
    super.message = 'The server took too long to respond. Please try again.',
  ]);

  @override
  String get userFriendlyMessage =>
      'Request timed out. Please check your connection speed and retry.';
}

/// Thrown when the server responds with a 400 or 422 Bad Request / Validation error.
class ValidationApiException extends ApiException {
  const ValidationApiException(
    super.message, {
    super.statusCode = 400,
    this.fieldErrors = const {},
  });

  /// Map of field names to specific validation error messages.
  final Map<String, dynamic> fieldErrors;

  @override
  String get userFriendlyMessage => message;
}

/// Thrown when a requested resource is not found (HTTP 404).
class NotFoundApiException extends ApiException {
  const NotFoundApiException([
    super.message = 'Requested resource not found.',
  ]) : super(statusCode: 404);
}

/// Thrown when the client exceeds API rate limits (HTTP 429).
class RateLimitApiException extends ApiException {
  const RateLimitApiException([
    super.message = 'Too many requests. Please wait a moment before trying again.',
  ]) : super(statusCode: 429);
}

/// Thrown when the server encounters an internal error (HTTP 500..599).
class ServerApiException extends ApiException {
  const ServerApiException([
    super.message = 'Internal server error. Please try again later.',
    int? statusCode = 500,
  ]) : super(statusCode: statusCode);

  @override
  String get userFriendlyMessage =>
      'We are experiencing temporary server difficulties. Please try again shortly or contact our Pune desk.';
}

/// Thrown when authentication or permission fails (HTTP 401 / 403).
class UnauthorizedApiException extends ApiException {
  const UnauthorizedApiException([
    super.message = 'Unauthorized or forbidden action.',
    int? statusCode = 401,
  ]) : super(statusCode: statusCode);
}

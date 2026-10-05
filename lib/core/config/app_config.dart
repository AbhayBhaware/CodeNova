import 'package:flutter/foundation.dart';

/// Supported runtime environments for the CodeNova mobile application.
enum AppEnvironment {
  mock,
  development,
  staging,
  production;

  static AppEnvironment fromString(String value) {
    switch (value.toLowerCase()) {
      case 'development':
      case 'dev':
        return AppEnvironment.development;
      case 'staging':
      case 'stage':
        return AppEnvironment.staging;
      case 'production':
      case 'prod':
        return AppEnvironment.production;
      case 'mock':
      default:
        return AppEnvironment.mock;
    }
  }
}

/// Centralized configuration for API endpoints, environments, and transport security.
///
/// In accordance with security guidelines:
/// - No credentials or API keys are hardcoded in source code.
/// - Configuration is supplied at build time via `--dart-define` flags.
///   Example:
///     flutter run --dart-define=APP_ENV=development --dart-define=API_BASE_URL=https://api.codenovatechsolutions.in/v1
@immutable
class AppConfig {
  const AppConfig({
    this.environment = AppEnvironment.mock,
    this.baseUrl = '',
    this.apiKey = '',
    this.timeoutSeconds = 15,
  });

  /// The active runtime environment. Defaults to [AppEnvironment.mock]
  /// to ensure safe local operation without external dependencies.
  final AppEnvironment environment;

  /// Root URL for the backend REST API (e.g. 'https://api.codenovatechsolutions.in/v1').
  final String baseUrl;

  /// Optional public publishable API client key used for gateway identification and rate limiting.
  /// Never store server secrets or database credentials here.
  final String apiKey;

  /// Network timeout duration in seconds.
  final int timeoutSeconds;

  /// Returns true if the application should use local mock data repositories.
  bool get isMock => environment == AppEnvironment.mock || baseUrl.isEmpty;

  /// Returns true if running in live production mode.
  bool get isProduction => environment == AppEnvironment.production;

  /// Duration converted from [timeoutSeconds].
  Duration get timeoutDuration => Duration(seconds: timeoutSeconds);

  /// Factory creating an [AppConfig] from compile-time environment variables.
  factory AppConfig.fromEnvironment() {
    const envString = String.fromEnvironment('APP_ENV', defaultValue: 'mock');
    const urlString = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    const keyString = String.fromEnvironment('API_KEY', defaultValue: '');
    const timeoutInt = int.fromEnvironment('API_TIMEOUT_SECONDS', defaultValue: 15);

    return AppConfig(
      environment: AppEnvironment.fromString(envString),
      baseUrl: urlString,
      apiKey: keyString,
      timeoutSeconds: timeoutInt,
    );
  }

  AppConfig copyWith({
    AppEnvironment? environment,
    String? baseUrl,
    String? apiKey,
    int? timeoutSeconds,
  }) {
    return AppConfig(
      environment: environment ?? this.environment,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
    );
  }
}

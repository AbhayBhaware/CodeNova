import '../config/app_config.dart';
import '../network/api_client.dart';
import '../../features/courses/data/repositories/courses_repository.dart';
import '../../features/courses/data/repositories/http_courses_repository.dart';
import '../../features/internships/data/repositories/internships_repository.dart';
import '../../features/internships/data/repositories/http_internships_repository.dart';
import '../../features/internships/data/repositories/internship_application_repository.dart';
import '../../features/internships/data/repositories/http_internship_application_repository.dart';
import '../../features/services/data/repositories/services_repository.dart';
import '../../features/services/data/repositories/http_services_repository.dart';
import '../../features/services/data/repositories/quote_repository.dart';
import '../../features/services/data/repositories/http_quote_repository.dart';
import '../../features/contact/data/repositories/contact_repository.dart';
import '../../features/contact/data/repositories/http_contact_repository.dart';

/// Centralized registry providing repository instances based on the active [AppConfig].
///
/// Ensures clean dependency inversion:
/// - In [AppEnvironment.mock] (default): Uses verified in-memory mock repositories.
/// - In [AppEnvironment.development], [AppEnvironment.staging], or [AppEnvironment.production]:
///   Switches dynamically to live [Http*Repository] implementations using [ApiClient].
class RepositoryRegistry {
  RepositoryRegistry({
    AppConfig? config,
    ApiClient? apiClient,
    CoursesRepository? coursesRepo,
    InternshipsRepository? internshipsRepo,
    ServicesRepository? servicesRepo,
    InternshipApplicationRepository? applicationRepo,
    QuoteRepository? quoteRepo,
    ContactRepository? contactRepo,
  })  : _config = config ?? AppConfig.fromEnvironment(),
        _apiClient = apiClient ??
            ApiClient(config: config ?? AppConfig.fromEnvironment()),
        _coursesRepository = coursesRepo,
        _internshipsRepository = internshipsRepo,
        _servicesRepository = servicesRepo,
        _applicationRepository = applicationRepo,
        _quoteRepository = quoteRepo,
        _contactRepository = contactRepo;

  final AppConfig _config;
  final ApiClient _apiClient;

  CoursesRepository? _coursesRepository;
  InternshipsRepository? _internshipsRepository;
  ServicesRepository? _servicesRepository;
  InternshipApplicationRepository? _applicationRepository;
  QuoteRepository? _quoteRepository;
  ContactRepository? _contactRepository;

  static RepositoryRegistry _instance = RepositoryRegistry();

  /// The active global repository registry instance.
  static RepositoryRegistry get instance => _instance;

  /// Sets or overrides the active repository registry (useful for testing).
  static void setInstance(RepositoryRegistry registry) {
    _instance = registry;
  }

  /// Active configuration.
  AppConfig get config => _config;

  /// Active API client.
  ApiClient get apiClient => _apiClient;

  /// Returns the configured [CoursesRepository].
  CoursesRepository get coursesRepository {
    if (_coursesRepository != null) return _coursesRepository!;
    if (_config.isMock) {
      _coursesRepository = const MockCoursesRepository();
    } else {
      _coursesRepository = HttpCoursesRepository(
        apiClient: _apiClient,
        fallbackMock: const MockCoursesRepository(),
      );
    }
    return _coursesRepository!;
  }

  /// Returns the configured [InternshipsRepository].
  InternshipsRepository get internshipsRepository {
    if (_internshipsRepository != null) return _internshipsRepository!;
    if (_config.isMock) {
      _internshipsRepository = const MockInternshipsRepository();
    } else {
      _internshipsRepository = HttpInternshipsRepository(
        apiClient: _apiClient,
        fallbackMock: const MockInternshipsRepository(),
      );
    }
    return _internshipsRepository!;
  }

  /// Returns the configured [ServicesRepository].
  ServicesRepository get servicesRepository {
    if (_servicesRepository != null) return _servicesRepository!;
    if (_config.isMock) {
      _servicesRepository = const MockServicesRepository();
    } else {
      _servicesRepository = HttpServicesRepository(
        apiClient: _apiClient,
        fallbackMock: const MockServicesRepository(),
      );
    }
    return _servicesRepository!;
  }

  /// Returns the configured [InternshipApplicationRepository].
  InternshipApplicationRepository get internshipApplicationRepository {
    if (_applicationRepository != null) return _applicationRepository!;
    if (_config.isMock) {
      _applicationRepository = const MockInternshipApplicationRepository();
    } else {
      _applicationRepository = HttpInternshipApplicationRepository(
        apiClient: _apiClient,
      );
    }
    return _applicationRepository!;
  }

  /// Returns the configured [QuoteRepository].
  QuoteRepository get quoteRepository {
    if (_quoteRepository != null) return _quoteRepository!;
    if (_config.isMock) {
      _quoteRepository = const MockQuoteRepository();
    } else {
      _quoteRepository = HttpQuoteRepository(
        apiClient: _apiClient,
      );
    }
    return _quoteRepository!;
  }

  /// Returns the configured [ContactRepository].
  ContactRepository get contactRepository {
    if (_contactRepository != null) return _contactRepository!;
    if (_config.isMock) {
      _contactRepository = const MockContactRepository();
    } else {
      _contactRepository = HttpContactRepository(
        apiClient: _apiClient,
      );
    }
    return _contactRepository!;
  }
}

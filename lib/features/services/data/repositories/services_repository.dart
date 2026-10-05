import '../../../../core/constants/mock_data.dart';
import '../../../../models/service_model.dart';

/// Abstract contract for fetching IT services from a data source.
abstract interface class ServicesRepository {
  Future<List<ServiceModel>> fetchServices();
}

/// Mock repository implementation returning verified company services.
class MockServicesRepository implements ServicesRepository {
  const MockServicesRepository({
    this.delay = const Duration(milliseconds: 400),
    this.simulateFailure = false,
  });

  final Duration delay;
  final bool simulateFailure;

  @override
  Future<List<ServiceModel>> fetchServices() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    if (simulateFailure) {
      throw Exception(
        'Unable to load IT services catalog. Please verify your network and try again.',
      );
    }

    return List.unmodifiable(MockData.services);
  }
}

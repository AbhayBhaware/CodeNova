import '../../../../core/network/api_client.dart';
import '../../../../models/service_model.dart';
import 'services_repository.dart';

/// Production HTTP implementation of [ServicesRepository].
/// Communicates with CodeNova's backend REST API to retrieve enterprise IT service catalog.
class HttpServicesRepository implements ServicesRepository {
  const HttpServicesRepository({
    required this.apiClient,
    this.fallbackMock,
  });

  final ApiClient apiClient;
  final ServicesRepository? fallbackMock;

  @override
  Future<List<ServiceModel>> fetchServices() async {
    try {
      final response = await apiClient.get('/services');
      if (response is List) {
        return response
            .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response is Map<String, dynamic> && response['data'] is List) {
        final list = response['data'] as List;
        return list
            .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Unexpected response format for IT services catalog.');
    } catch (e) {
      if (fallbackMock != null) {
        return fallbackMock!.fetchServices();
      }
      rethrow;
    }
  }
}

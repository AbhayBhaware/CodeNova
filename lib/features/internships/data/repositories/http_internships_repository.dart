import '../../../../core/network/api_client.dart';
import '../../../../models/internship_model.dart';
import 'internships_repository.dart';

/// Production HTTP implementation of [InternshipsRepository].
/// Communicates with CodeNova's backend REST API to retrieve open internship postings.
class HttpInternshipsRepository implements InternshipsRepository {
  const HttpInternshipsRepository({
    required this.apiClient,
    this.fallbackMock,
  });

  final ApiClient apiClient;
  final InternshipsRepository? fallbackMock;

  @override
  Future<List<InternshipModel>> fetchInternships() async {
    try {
      final response = await apiClient.get('/internships');
      if (response is List) {
        return response
            .map((item) => InternshipModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response is Map<String, dynamic> && response['data'] is List) {
        final list = response['data'] as List;
        return list
            .map((item) => InternshipModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Unexpected response format for internship listings.');
    } catch (e) {
      if (fallbackMock != null) {
        return fallbackMock!.fetchInternships();
      }
      rethrow;
    }
  }
}

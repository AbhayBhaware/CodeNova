import '../../../../core/network/api_client.dart';
import '../../../../models/contact_enquiry_model.dart';
import 'contact_repository.dart';

/// Production HTTP implementation of [ContactRepository].
/// Transmits contact enquiries to CodeNova's backend.
class HttpContactRepository implements ContactRepository {
  const HttpContactRepository({
    required this.apiClient,
  });

  final ApiClient apiClient;

  @override
  Future<ContactSubmissionResult> submitEnquiry(ContactEnquiryModel enquiry) async {
    final response = await apiClient.post(
      '/enquiries',
      body: enquiry.toJson(),
    );

    if (response is Map<String, dynamic>) {
      final refId = response['referenceId']?.toString() ??
          'CN-ENQ-${DateTime.now().millisecondsSinceEpoch % 100000}';

      return ContactSubmissionResult(
        referenceId: refId,
        enquiry: enquiry,
        isMock: false,
        timestamp: DateTime.now(),
      );
    }

    throw Exception('Unexpected response from contact enquiry gateway.');
  }
}

import '../../../../core/network/api_client.dart';
import '../../../../models/internship_application_model.dart';
import 'internship_application_repository.dart';

/// Production HTTP implementation of [InternshipApplicationRepository].
/// Transmits student internship applications to CodeNova's backend.
class HttpInternshipApplicationRepository
    implements InternshipApplicationRepository {
  const HttpInternshipApplicationRepository({
    required this.apiClient,
  });

  final ApiClient apiClient;

  @override
  Future<ApplicationSubmissionResult> submitApplication(
    InternshipApplicationModel application,
  ) async {
    final response = await apiClient.post(
      '/internships/apply',
      body: application.toJson(),
    );

    if (response is Map<String, dynamic>) {
      final refId = response['referenceId']?.toString() ??
          'CN-APP-${DateTime.now().millisecondsSinceEpoch % 100000}';
      final message = response['message']?.toString() ??
          'Your application has been received and logged in our system.';

      return ApplicationSubmissionResult(
        isSuccess: true,
        referenceId: refId,
        message: message,
        isMock: false,
        submittedAt: DateTime.now(),
        internshipTitle: application.internshipTitle,
        applicantName: application.fullName,
      );
    }

    throw Exception('Unexpected response from internship application gateway.');
  }
}

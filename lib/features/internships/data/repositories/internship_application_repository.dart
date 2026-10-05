import '../../../../models/internship_application_model.dart';

/// Result envelope returned by [InternshipApplicationRepository].
class ApplicationSubmissionResult {
  const ApplicationSubmissionResult({
    required this.isSuccess,
    required this.referenceId,
    required this.message,
    required this.isMock,
    required this.submittedAt,
    this.internshipTitle,
    this.applicantName,
  });

  /// Whether the submission completed successfully.
  final bool isSuccess;

  /// Tracking / verification reference ID.
  final String referenceId;

  /// User-facing message detailing the submission status.
  final String message;

  /// Explicit flag denoting whether this was simulated in development mode.
  /// Prevents false claims of production backend persistence.
  final bool isMock;

  /// Timestamp of the confirmed submission.
  final DateTime submittedAt;

  /// Title of internship applied to (if provided).
  final String? internshipTitle;

  /// Applicant name for personalized confirmation.
  final String? applicantName;
}

/// Abstract contract for internship application submission.
///
/// Designed to decouple the UI from backend transport (REST / GraphQL).
abstract interface class InternshipApplicationRepository {
  Future<ApplicationSubmissionResult> submitApplication(
    InternshipApplicationModel application,
  );
}

/// Mock repository implementation for development & testing.
///
/// Clearly flags all responses as [isMock: true] with reference codes
/// prefixed with DEV-CN- to adhere strictly to the zero-hallucination requirement.
class MockInternshipApplicationRepository
    implements InternshipApplicationRepository {
  const MockInternshipApplicationRepository({
    this.delay = const Duration(milliseconds: 650),
    this.simulateFailure = false,
    this.simulatedErrorMessage,
  });

  final Duration delay;
  final bool simulateFailure;
  final String? simulatedErrorMessage;

  @override
  Future<ApplicationSubmissionResult> submitApplication(
    InternshipApplicationModel application,
  ) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    if (simulateFailure) {
      throw Exception(
        simulatedErrorMessage ??
            'Unable to submit application due to a simulated network error. '
            'Please verify your connection and try again.',
      );
    }

    // Generate readable development reference code
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final shortId = timestamp.substring(timestamp.length - 6);
    final ref = 'DEV-CN-$shortId';

    return ApplicationSubmissionResult(
      isSuccess: true,
      referenceId: ref,
      message: 'Application recorded in Development Mode. '
          'Real production submissions will be securely delivered to CodeNova HR once live API integration is active.',
      isMock: true,
      submittedAt: DateTime.now(),
      internshipTitle: application.internshipTitle,
      applicantName: application.fullName,
    );
  }
}

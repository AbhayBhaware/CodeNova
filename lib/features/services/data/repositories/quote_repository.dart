import 'dart:math';
import '../../../../models/quote_request_model.dart';

/// Result envelope returned by [QuoteRepository] upon quote enquiry submission.
class QuoteSubmissionResult {
  const QuoteSubmissionResult({
    required this.isSuccess,
    required this.referenceId,
    required this.message,
    required this.isMock,
    required this.submittedAt,
    required this.quoteRequest,
  });

  /// Whether the quote request was successfully processed and logged.
  final bool isSuccess;

  /// Unique tracking reference ID (e.g., `DEV-QUOTE-74829`).
  final String referenceId;

  /// User-facing descriptive outcome message.
  final String message;

  /// Explicit flag denoting whether this submission was handled in mock/development mode.
  /// Prevents misleading claims of live production database persistence.
  final bool isMock;

  /// Timestamp of the confirmed submission.
  final DateTime submittedAt;

  /// The original request model payload.
  final QuoteRequestModel quoteRequest;
}

/// Abstract contract for business project quote submission.
///
/// Prepares the application for live REST / GraphQL backend API integration.
abstract interface class QuoteRepository {
  Future<QuoteSubmissionResult> submitQuote(QuoteRequestModel request);
}

/// Mock repository implementation used for local development and UI testing.
///
/// Features configurable latency and failure simulation. All successful results
/// are clearly flagged as [isMock: true] with reference codes prefixed with `DEV-QUOTE-`.
class MockQuoteRepository implements QuoteRepository {
  const MockQuoteRepository({
    this.delay = const Duration(milliseconds: 600),
    this.simulateFailure = false,
    this.simulatedErrorMessage,
  });

  final Duration delay;
  final bool simulateFailure;
  final String? simulatedErrorMessage;

  @override
  Future<QuoteSubmissionResult> submitQuote(QuoteRequestModel request) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    if (simulateFailure) {
      throw Exception(
        simulatedErrorMessage ??
            'Unable to transmit your quote request. Please verify your connection or contact our Pune desk directly.',
      );
    }

    final randomId = (10000 + Random().nextInt(90000)).toString();
    final referenceId = 'DEV-QUOTE-$randomId';

    return QuoteSubmissionResult(
      isSuccess: true,
      referenceId: referenceId,
      message:
          'Thank you, ${request.fullName}. Your project quote request for ${request.projectType} has been recorded locally.',
      isMock: true,
      submittedAt: DateTime.now(),
      quoteRequest: request,
    );
  }
}

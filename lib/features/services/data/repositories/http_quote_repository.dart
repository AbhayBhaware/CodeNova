import '../../../../core/network/api_client.dart';
import '../../../../models/quote_request_model.dart';
import 'quote_repository.dart';

/// Production HTTP implementation of [QuoteRepository].
/// Transmits enterprise project quote requests to CodeNova's backend.
class HttpQuoteRepository implements QuoteRepository {
  const HttpQuoteRepository({
    required this.apiClient,
  });

  final ApiClient apiClient;

  @override
  Future<QuoteSubmissionResult> submitQuote(QuoteRequestModel request) async {
    final response = await apiClient.post(
      '/quotes/request',
      body: request.toJson(),
    );

    if (response is Map<String, dynamic>) {
      final refId = response['referenceId']?.toString() ??
          'CN-QUOTE-${DateTime.now().millisecondsSinceEpoch % 100000}';
      final message = response['message']?.toString() ??
          'Your quote request has been received and forwarded to our solutions architect.';

      return QuoteSubmissionResult(
        isSuccess: true,
        referenceId: refId,
        message: message,
        isMock: false,
        submittedAt: DateTime.now(),
        quoteRequest: request,
      );
    }

    throw Exception('Unexpected response from quote request gateway.');
  }
}

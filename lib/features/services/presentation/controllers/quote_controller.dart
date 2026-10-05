import 'package:flutter/foundation.dart';
import '../../../../core/di/repository_registry.dart';
import '../../../../models/quote_request_model.dart';
import '../../data/repositories/quote_repository.dart';

/// Lifecycle status of the quote request submission.
enum QuoteSubmissionStatus {
  /// Form is ready for user input.
  idle,

  /// Submission is currently in-flight across the repository.
  submitting,

  /// Submission succeeded and confirmed with reference ID.
  success,

  /// Submission encountered a network or server failure.
  failure,
}

/// Controller managing state, submission, and feedback for project quote enquiries.
class QuoteController extends ChangeNotifier {
  QuoteController({
    QuoteRepository? repository,
  }) : _repository = repository ?? RepositoryRegistry.instance.quoteRepository;

  final QuoteRepository _repository;

  QuoteSubmissionStatus _status = QuoteSubmissionStatus.idle;
  QuoteSubmissionResult? _submissionResult;
  String? _errorMessage;

  // ── Public Getters ──────────────────────────────────────────────────────────

  QuoteSubmissionStatus get status => _status;
  QuoteSubmissionResult? get submissionResult => _submissionResult;
  String? get errorMessage => _errorMessage;

  bool get isIdle => _status == QuoteSubmissionStatus.idle;
  bool get isSubmitting => _status == QuoteSubmissionStatus.submitting;
  bool get isSuccess => _status == QuoteSubmissionStatus.success;
  bool get isFailure => _status == QuoteSubmissionStatus.failure;

  // ── Submission Actions ──────────────────────────────────────────────────────

  /// Dispatches the [request] model to the repository.
  Future<bool> submitQuote(QuoteRequestModel request) async {
    if (_status == QuoteSubmissionStatus.submitting) return false;

    _status = QuoteSubmissionStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.submitQuote(request);
      _submissionResult = result;
      _status = QuoteSubmissionStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = QuoteSubmissionStatus.failure;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Resets the controller back to [QuoteSubmissionStatus.idle] for a new enquiry.
  void reset() {
    _status = QuoteSubmissionStatus.idle;
    _submissionResult = null;
    _errorMessage = null;
    notifyListeners();
  }
}

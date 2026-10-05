import 'package:flutter/foundation.dart';
import '../../../../models/internship_application_model.dart';
import '../../data/repositories/internship_application_repository.dart';

/// State of the internship application submission lifecycle.
enum InternshipApplyStatus {
  /// Initial form state ready for user input.
  idle,

  /// Asynchronous submission in progress.
  submitting,

  /// Confirmed application submission with reference details.
  success,

  /// Submission failure or network exception.
  error,
}

/// Controller managing internship application submission logic and state.
class InternshipApplyController extends ChangeNotifier {
  InternshipApplyController({
    InternshipApplicationRepository? repository,
  }) : _repository =
            repository ?? const MockInternshipApplicationRepository();

  final InternshipApplicationRepository _repository;

  InternshipApplyStatus _status = InternshipApplyStatus.idle;
  ApplicationSubmissionResult? _result;
  String? _errorMessage;

  // ── Public Getters ──────────────────────────────────────────────────────────

  InternshipApplyStatus get status => _status;
  ApplicationSubmissionResult? get result => _result;
  String? get errorMessage => _errorMessage;

  bool get isSubmitting => _status == InternshipApplyStatus.submitting;
  bool get isSuccess => _status == InternshipApplyStatus.success;
  bool get hasError => _status == InternshipApplyStatus.error;

  // ── Actions ─────────────────────────────────────────────────────────────────

  /// Submits the validated [application] model to the repository.
  Future<bool> submitApplication(InternshipApplicationModel application) async {
    if (_status == InternshipApplyStatus.submitting) return false;

    _status = InternshipApplyStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.submitApplication(application);
      _result = res;
      _status = InternshipApplyStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = InternshipApplyStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Clears any errors and resets the controller to [InternshipApplyStatus.idle].
  void reset() {
    _status = InternshipApplyStatus.idle;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }
}

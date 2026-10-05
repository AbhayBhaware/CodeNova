import 'package:flutter/foundation.dart';
import '../../../../core/di/repository_registry.dart';
import '../../../../models/contact_enquiry_model.dart';
import '../../data/repositories/contact_repository.dart';

/// Status of the contact enquiry submission lifecycle.
enum ContactSubmissionStatus {
  idle,
  submitting,
  success,
  failure,
}

/// Controller managing state and lifecycle for the Contact Enquiry form.
class ContactController extends ChangeNotifier {
  ContactController({ContactRepository? repository})
      : _repository = repository ?? RepositoryRegistry.instance.contactRepository;

  final ContactRepository _repository;

  ContactSubmissionStatus _status = ContactSubmissionStatus.idle;
  ContactSubmissionResult? _submissionResult;
  String? _errorMessage;

  ContactSubmissionStatus get status => _status;
  ContactSubmissionResult? get submissionResult => _submissionResult;
  String? get errorMessage => _errorMessage;

  bool get isIdle => _status == ContactSubmissionStatus.idle;
  bool get isSubmitting => _status == ContactSubmissionStatus.submitting;
  bool get isSuccess => _status == ContactSubmissionStatus.success;
  bool get isFailure => _status == ContactSubmissionStatus.failure;

  /// Submits the enquiry to the repository and updates state accordingly.
  Future<bool> submitEnquiry(ContactEnquiryModel enquiry) async {
    _status = ContactSubmissionStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.submitEnquiry(enquiry);
      _submissionResult = result;
      _status = ContactSubmissionStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = ContactSubmissionStatus.failure;
      notifyListeners();
      return false;
    }
  }

  /// Resets the form controller back to idle.
  void reset() {
    _status = ContactSubmissionStatus.idle;
    _submissionResult = null;
    _errorMessage = null;
    notifyListeners();
  }
}

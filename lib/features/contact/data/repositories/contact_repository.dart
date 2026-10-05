import 'dart:math';
import '../../../../models/contact_enquiry_model.dart';

/// Abstract contract for Contact Enquiry operations.
/// Ready for direct REST/GraphQL backend implementation.
abstract class ContactRepository {
  Future<ContactSubmissionResult> submitEnquiry(ContactEnquiryModel enquiry);
}

/// Mock implementation of [ContactRepository] with latency simulation and error handling.
/// Generates honest local reference IDs (`DEV-ENQ-XXXX`) without claiming false backend confirmation.
class MockContactRepository implements ContactRepository {
  const MockContactRepository({
    this.delay = const Duration(milliseconds: 650),
    this.simulateFailure = false,
    this.simulatedErrorMessage,
  });

  final Duration delay;
  final bool simulateFailure;
  final String? simulatedErrorMessage;

  @override
  Future<ContactSubmissionResult> submitEnquiry(ContactEnquiryModel enquiry) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    if (simulateFailure) {
      throw Exception(
        simulatedErrorMessage ??
            'Unable to transmit enquiry to the server. Please check your connectivity or reach out directly via phone.',
      );
    }

    final randSuffix = 1000 + Random().nextInt(9000);
    final referenceId = 'DEV-ENQ-$randSuffix';

    return ContactSubmissionResult(
      referenceId: referenceId,
      enquiry: enquiry,
      isMock: true,
      timestamp: DateTime.now(),
    );
  }
}

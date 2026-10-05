import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/models/contact_enquiry_model.dart';
import 'package:codenova_app/features/contact/data/repositories/contact_repository.dart';
import 'package:codenova_app/features/contact/presentation/controllers/contact_controller.dart';

void main() {
  group('ContactEnquiryModel Unit & Serialization Tests', () {
    final sampleTimestamp = DateTime(2026, 10, 5, 14, 30);
    final sampleEnquiry = ContactEnquiryModel(
      fullName: 'Vikram Joshi',
      email: 'vikram.joshi@example.com',
      phone: '+91 9876543210',
      category: 'Course Admission',
      message: 'Interested in the Android Development course with Kotlin.',
      submittedAt: sampleTimestamp,
    );

    test('toJson and fromJson roundtrip preserves all fields', () {
      final json = sampleEnquiry.toJson();
      expect(json['fullName'], 'Vikram Joshi');
      expect(json['email'], 'vikram.joshi@example.com');
      expect(json['phone'], '+91 9876543210');
      expect(json['category'], 'Course Admission');
      expect(json['message'], 'Interested in the Android Development course with Kotlin.');
      expect(json['submittedAt'], sampleTimestamp.toIso8601String());

      final parsed = ContactEnquiryModel.fromJson(json);
      expect(parsed, equals(sampleEnquiry));
    });

    test('copyWith cleanly updates target fields', () {
      final updated = sampleEnquiry.copyWith(
        category: 'Internship Opportunities',
        phone: '+91 8087480411',
      );
      expect(updated.category, 'Internship Opportunities');
      expect(updated.phone, '+91 8087480411');
      expect(updated.fullName, sampleEnquiry.fullName);
      expect(updated.email, sampleEnquiry.email);
    });

    test('equality and hashCode verification', () {
      final clone = ContactEnquiryModel(
        fullName: 'Vikram Joshi',
        email: 'vikram.joshi@example.com',
        phone: '+91 9876543210',
        category: 'Course Admission',
        message: 'Interested in the Android Development course with Kotlin.',
        submittedAt: sampleTimestamp,
      );
      expect(sampleEnquiry, equals(clone));
      expect(sampleEnquiry.hashCode, equals(clone.hashCode));
    });
  });

  group('ContactController & MockContactRepository Unit Tests', () {
    final sampleEnquiry = ContactEnquiryModel(
      fullName: 'Aarav Patel',
      email: 'aarav.patel@techfirm.com',
      category: 'IT Services & Solutions',
      message: 'Inquiring about enterprise web development and microservice architecture consulting.',
      submittedAt: DateTime.now(),
    );

    test('Initial controller state is idle', () {
      final controller = ContactController();
      expect(controller.isIdle, isTrue);
      expect(controller.isSubmitting, isFalse);
      expect(controller.isSuccess, isFalse);
      expect(controller.isFailure, isFalse);
      expect(controller.submissionResult, isNull);
      expect(controller.errorMessage, isNull);
    });

    test('Successful submission updates status to success with mock reference ID', () async {
      final repository = const MockContactRepository(delay: Duration.zero);
      final controller = ContactController(repository: repository);

      final success = await controller.submitEnquiry(sampleEnquiry);

      expect(success, isTrue);
      expect(controller.isSuccess, isTrue);
      expect(controller.isSubmitting, isFalse);
      expect(controller.submissionResult, isNotNull);
      expect(controller.submissionResult!.isMock, isTrue);
      expect(controller.submissionResult!.referenceId, startsWith('DEV-ENQ-'));
      expect(controller.submissionResult!.enquiry.fullName, 'Aarav Patel');
      expect(controller.errorMessage, isNull);
    });

    test('Failed submission updates status to failure and captures error message', () async {
      final repository = const MockContactRepository(
        delay: Duration.zero,
        simulateFailure: true,
        simulatedErrorMessage: 'Network gateway connectivity failure.',
      );
      final controller = ContactController(repository: repository);

      final success = await controller.submitEnquiry(sampleEnquiry);

      expect(success, isFalse);
      expect(controller.isFailure, isTrue);
      expect(controller.isSuccess, isFalse);
      expect(controller.errorMessage, 'Network gateway connectivity failure.');
      expect(controller.submissionResult, isNull);
    });

    test('Reset restores controller back to idle and clears state', () async {
      final repository = const MockContactRepository(delay: Duration.zero);
      final controller = ContactController(repository: repository);

      await controller.submitEnquiry(sampleEnquiry);
      expect(controller.isSuccess, isTrue);

      controller.reset();
      expect(controller.isIdle, isTrue);
      expect(controller.submissionResult, isNull);
      expect(controller.errorMessage, isNull);
    });
  });
}

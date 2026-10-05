import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/models/quote_request_model.dart';
import 'package:codenova_app/features/services/data/repositories/quote_repository.dart';
import 'package:codenova_app/features/services/presentation/controllers/quote_controller.dart';

void main() {
  group('QuoteRequestModel Unit & Serialization Tests', () {
    test('QuoteRequestModel serialization toJson and fromJson roundtrip', () {
      final request = QuoteRequestModel(
        fullName: 'Jane Doe',
        email: 'jane@enterprise.com',
        companyName: 'Enterprise AI Corp',
        projectType: 'AI & Machine Learning',
        projectDescription: 'Custom automated NLP customer intelligence engine.',
        budgetRange: '₹1,50,000 - ₹5,00,000 (\$1,800 - \$6,000)',
        preferredContactMethod: 'Email',
        serviceId: 'ai-solutions',
        submittedAt: DateTime.utc(2026, 10, 5, 12, 0),
      );

      final json = request.toJson();
      expect(json['fullName'], 'Jane Doe');
      expect(json['email'], 'jane@enterprise.com');
      expect(json['companyName'], 'Enterprise AI Corp');
      expect(json['projectType'], 'AI & Machine Learning');
      expect(json['preferredContactMethod'], 'Email');

      final reconstructed = QuoteRequestModel.fromJson(json);
      expect(reconstructed.fullName, request.fullName);
      expect(reconstructed.email, request.email);
      expect(reconstructed.companyName, request.companyName);
      expect(reconstructed.projectType, request.projectType);
      expect(reconstructed.projectDescription, request.projectDescription);
      expect(reconstructed.budgetRange, request.budgetRange);
      expect(reconstructed.preferredContactMethod, request.preferredContactMethod);
      expect(reconstructed.serviceId, request.serviceId);
    });

    test('QuoteRequestModel copyWith cleanly updates target fields', () {
      const original = QuoteRequestModel(
        fullName: 'John',
        email: 'john@mail.com',
        projectType: 'Web',
        projectDescription: 'Description with sufficient length.',
        preferredContactMethod: 'Email',
      );

      final updated = original.copyWith(
        fullName: 'Johnathan',
        budgetRange: 'Under ₹50,000',
      );

      expect(updated.fullName, 'Johnathan');
      expect(updated.budgetRange, 'Under ₹50,000');
      expect(updated.email, 'john@mail.com');
      expect(updated.projectType, 'Web');
    });

    test('QuoteRequestModel equality and hashCode verification', () {
      const a = QuoteRequestModel(
        fullName: 'Same Name',
        email: 'same@mail.com',
        projectType: 'Mobile',
        projectDescription: 'Mobile app development for Android.',
        preferredContactMethod: 'WhatsApp',
      );
      const b = QuoteRequestModel(
        fullName: 'Same Name',
        email: 'same@mail.com',
        projectType: 'Mobile',
        projectDescription: 'Mobile app development for Android.',
        preferredContactMethod: 'WhatsApp',
      );

      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('QuoteController & MockQuoteRepository Unit Tests', () {
    const validRequest = QuoteRequestModel(
      fullName: 'Alice Smith',
      email: 'alice@company.org',
      projectType: 'Custom Software Development',
      projectDescription: 'Enterprise ERP workflow automation system with role permissions.',
      preferredContactMethod: 'Phone Call',
    );

    test('Initial controller state is idle', () {
      final controller = QuoteController(
        repository: const MockQuoteRepository(delay: Duration.zero),
      );

      expect(controller.status, QuoteSubmissionStatus.idle);
      expect(controller.isIdle, isTrue);
      expect(controller.isSubmitting, isFalse);
      expect(controller.isSuccess, isFalse);
      expect(controller.isFailure, isFalse);
      expect(controller.submissionResult, isNull);
      expect(controller.errorMessage, isNull);
    });

    test('Successful submission updates status to success with mock reference ID', () async {
      final controller = QuoteController(
        repository: const MockQuoteRepository(delay: Duration.zero),
      );

      final success = await controller.submitQuote(validRequest);

      expect(success, isTrue);
      expect(controller.status, QuoteSubmissionStatus.success);
      expect(controller.isSuccess, isTrue);
      expect(controller.submissionResult, isNotNull);
      expect(controller.submissionResult!.isSuccess, isTrue);
      expect(controller.submissionResult!.isMock, isTrue);
      expect(controller.submissionResult!.referenceId.startsWith('DEV-QUOTE-'), isTrue);
      expect(controller.submissionResult!.quoteRequest.fullName, 'Alice Smith');
    });

    test('Failed submission updates status to failure and captures error message', () async {
      final controller = QuoteController(
        repository: const MockQuoteRepository(
          delay: Duration.zero,
          simulateFailure: true,
          simulatedErrorMessage: 'Custom network timeout error.',
        ),
      );

      final success = await controller.submitQuote(validRequest);

      expect(success, isFalse);
      expect(controller.status, QuoteSubmissionStatus.failure);
      expect(controller.isFailure, isTrue);
      expect(controller.errorMessage, contains('Custom network timeout error'));
      expect(controller.submissionResult, isNull);
    });

    test('Reset restores controller back to idle and clears state', () async {
      final controller = QuoteController(
        repository: const MockQuoteRepository(delay: Duration.zero),
      );

      await controller.submitQuote(validRequest);
      expect(controller.isSuccess, isTrue);

      controller.reset();
      expect(controller.status, QuoteSubmissionStatus.idle);
      expect(controller.isIdle, isTrue);
      expect(controller.submissionResult, isNull);
      expect(controller.errorMessage, isNull);
    });
  });
}

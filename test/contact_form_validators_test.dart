import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/features/contact/presentation/utils/contact_form_validators.dart';

void main() {
  group('ContactFormValidators Unit Tests', () {
    group('validateFullName', () {
      test('Returns error when null or empty', () {
        expect(
          ContactFormValidators.validateFullName(null),
          'Please enter your full name',
        );
        expect(
          ContactFormValidators.validateFullName(''),
          'Please enter your full name',
        );
        expect(
          ContactFormValidators.validateFullName('   '),
          'Please enter your full name',
        );
      });

      test('Returns error when shorter than 2 characters', () {
        expect(
          ContactFormValidators.validateFullName('A'),
          'Name must be at least 2 characters',
        );
      });

      test('Returns error when exceeding 70 characters', () {
        final longName = 'A' * 71;
        expect(
          ContactFormValidators.validateFullName(longName),
          'Name cannot exceed 70 characters',
        );
      });

      test('Returns error when containing numbers or disallowed symbols', () {
        expect(
          ContactFormValidators.validateFullName('John123'),
          'Please enter a valid name (letters only)',
        );
        expect(
          ContactFormValidators.validateFullName('Sarah @Connor'),
          'Please enter a valid name (letters only)',
        );
      });

      test('Returns null for valid professional names', () {
        expect(ContactFormValidators.validateFullName('John Doe'), isNull);
        expect(ContactFormValidators.validateFullName('O\'Connor'), isNull);
        expect(ContactFormValidators.validateFullName('Mary-Jane Watson'), isNull);
        expect(ContactFormValidators.validateFullName('Dr. B. R. Ambedkar'), isNull);
      });
    });

    group('validateEmail', () {
      test('Returns error when null or empty', () {
        expect(
          ContactFormValidators.validateEmail(null),
          'Please enter your email address',
        );
        expect(
          ContactFormValidators.validateEmail(''),
          'Please enter your email address',
        );
        expect(
          ContactFormValidators.validateEmail('   '),
          'Please enter your email address',
        );
      });

      test('Returns error for malformed email addresses', () {
        expect(
          ContactFormValidators.validateEmail('notanemail'),
          'Please enter a valid email address (e.g. name@domain.com)',
        );
        expect(
          ContactFormValidators.validateEmail('missing@domain'),
          'Please enter a valid email address (e.g. name@domain.com)',
        );
        expect(
          ContactFormValidators.validateEmail('@nodomain.com'),
          'Please enter a valid email address (e.g. name@domain.com)',
        );
      });

      test('Returns null for valid emails', () {
        expect(ContactFormValidators.validateEmail('user@codenovatechsolutions.in'), isNull);
        expect(ContactFormValidators.validateEmail('student.learn@gmail.com'), isNull);
        expect(ContactFormValidators.validateEmail('contact+dev@company.co.in'), isNull);
      });
    });

    group('validatePhone', () {
      test('Returns null when empty (optional field)', () {
        expect(ContactFormValidators.validatePhone(null), isNull);
        expect(ContactFormValidators.validatePhone(''), isNull);
        expect(ContactFormValidators.validatePhone('   '), isNull);
      });

      test('Returns error for invalid telephone numbers', () {
        expect(
          ContactFormValidators.validatePhone('12345'),
          'Please enter a valid contact phone number',
        );
        expect(
          ContactFormValidators.validatePhone('phone1234567'),
          'Please enter a valid contact phone number',
        );
      });

      test('Returns null for valid Indian and international numbers', () {
        expect(ContactFormValidators.validatePhone('9876543210'), isNull);
        expect(ContactFormValidators.validatePhone('+91 8087480411'), isNull);
        expect(ContactFormValidators.validatePhone('+91-8087480411'), isNull);
        expect(ContactFormValidators.validatePhone('+1 415 555 2671'), isNull);
      });
    });

    group('validateCategory', () {
      test('Returns error when null or empty', () {
        expect(
          ContactFormValidators.validateCategory(null),
          'Please select an enquiry category',
        );
        expect(
          ContactFormValidators.validateCategory(''),
          'Please select an enquiry category',
        );
      });

      test('Returns null for selected category', () {
        expect(ContactFormValidators.validateCategory('General Question'), isNull);
        expect(ContactFormValidators.validateCategory('Course Admission'), isNull);
        expect(ContactFormValidators.validateCategory('Internship Opportunities'), isNull);
      });
    });

    group('validateMessage', () {
      test('Returns error when null or empty', () {
        expect(
          ContactFormValidators.validateMessage(null),
          'Please enter your enquiry message',
        );
        expect(
          ContactFormValidators.validateMessage(''),
          'Please enter your enquiry message',
        );
        expect(
          ContactFormValidators.validateMessage('   '),
          'Please enter your enquiry message',
        );
      });

      test('Returns error when shorter than 15 characters', () {
        expect(
          ContactFormValidators.validateMessage('Too short'),
          'Please provide more details (minimum 15 characters)',
        );
      });

      test('Returns error when exceeding 1500 characters', () {
        final longMsg = 'M' * 1501;
        expect(
          ContactFormValidators.validateMessage(longMsg),
          'Message cannot exceed 1500 characters',
        );
      });

      test('Returns null for clear, detailed messages', () {
        expect(
          ContactFormValidators.validateMessage(
            'I would like to inquire about the upcoming batch for Full Stack Development starting next month.',
          ),
          isNull,
        );
      });
    });
  });
}

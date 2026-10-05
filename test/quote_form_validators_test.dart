import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/features/services/presentation/utils/quote_form_validators.dart';

void main() {
  group('QuoteFormValidators Unit Tests', () {
    group('validateFullName', () {
      test('Returns error when null or empty', () {
        expect(QuoteFormValidators.validateFullName(null), 'Please enter your full name');
        expect(QuoteFormValidators.validateFullName(''), 'Please enter your full name');
        expect(QuoteFormValidators.validateFullName('   '), 'Please enter your full name');
      });

      test('Returns error when shorter than 2 characters', () {
        expect(
          QuoteFormValidators.validateFullName('A'),
          'Name must be at least 2 characters',
        );
      });

      test('Returns error when exceeding 70 characters', () {
        final longName = 'A' * 71;
        expect(
          QuoteFormValidators.validateFullName(longName),
          'Name must not exceed 70 characters',
        );
      });

      test('Returns error when containing numbers or disallowed symbols', () {
        expect(
          QuoteFormValidators.validateFullName('John Doe 123'),
          'Name must contain only letters, spaces, dots, or hyphens',
        );
        expect(
          QuoteFormValidators.validateFullName('Alex@Dev'),
          'Name must contain only letters, spaces, dots, or hyphens',
        );
      });

      test('Returns null for valid professional names', () {
        expect(QuoteFormValidators.validateFullName('John Doe'), isNull);
        expect(QuoteFormValidators.validateFullName('Dr. Sarah Connor'), isNull);
        expect(QuoteFormValidators.validateFullName('Jean-Luc Picard'), isNull);
        expect(QuoteFormValidators.validateFullName("O'Connor"), isNull);
      });
    });

    group('validateEmail', () {
      test('Returns error when null or empty', () {
        expect(QuoteFormValidators.validateEmail(null), 'Please enter your email address');
        expect(QuoteFormValidators.validateEmail(''), 'Please enter your email address');
        expect(QuoteFormValidators.validateEmail('   '), 'Please enter your email address');
      });

      test('Returns error for malformed email addresses', () {
        expect(
          QuoteFormValidators.validateEmail('notanemail'),
          'Please enter a valid email address (e.g. name@company.com)',
        );
        expect(
          QuoteFormValidators.validateEmail('missing@dot'),
          'Please enter a valid email address (e.g. name@company.com)',
        );
        expect(
          QuoteFormValidators.validateEmail('@nodomain.com'),
          'Please enter a valid email address (e.g. name@company.com)',
        );
      });

      test('Returns null for valid emails', () {
        expect(QuoteFormValidators.validateEmail('contact@enterprise.com'), isNull);
        expect(QuoteFormValidators.validateEmail('john.doe@startup.io'), isNull);
        expect(QuoteFormValidators.validateEmail('developer+team@codenova.in'), isNull);
      });
    });

    group('validateCompanyName', () {
      test('Returns null when empty (optional field)', () {
        expect(QuoteFormValidators.validateCompanyName(null), isNull);
        expect(QuoteFormValidators.validateCompanyName(''), isNull);
        expect(QuoteFormValidators.validateCompanyName('   '), isNull);
      });

      test('Returns error when exceeding 100 characters', () {
        final longCompany = 'C' * 101;
        expect(
          QuoteFormValidators.validateCompanyName(longCompany),
          'Company name must not exceed 100 characters',
        );
      });

      test('Returns null for valid company names', () {
        expect(QuoteFormValidators.validateCompanyName('Acme Corp Ltd.'), isNull);
        expect(QuoteFormValidators.validateCompanyName('TechNova Innovations'), isNull);
      });
    });

    group('validateProjectType', () {
      test('Returns error when null or empty', () {
        expect(QuoteFormValidators.validateProjectType(null), 'Please select a project type');
        expect(QuoteFormValidators.validateProjectType(''), 'Please select a project type');
      });

      test('Returns null for selected project type', () {
        expect(QuoteFormValidators.validateProjectType('Web Application Development'), isNull);
        expect(QuoteFormValidators.validateProjectType('Mobile App Development'), isNull);
      });
    });

    group('validateProjectDescription', () {
      test('Returns error when null or empty', () {
        expect(
          QuoteFormValidators.validateProjectDescription(null),
          'Please describe your project requirements',
        );
        expect(
          QuoteFormValidators.validateProjectDescription(''),
          'Please describe your project requirements',
        );
      });

      test('Returns error when shorter than 15 characters', () {
        expect(
          QuoteFormValidators.validateProjectDescription('Too short'),
          'Please provide more details (minimum 15 characters)',
        );
      });

      test('Returns null for meaningful scope descriptions', () {
        expect(
          QuoteFormValidators.validateProjectDescription(
            'Need a scalable cross-platform mobile application built with Flutter.',
          ),
          isNull,
        );
      });
    });

    group('validatePreferredContactMethod', () {
      test('Returns error when null or empty', () {
        expect(
          QuoteFormValidators.validatePreferredContactMethod(null),
          'Please select a preferred contact method',
        );
        expect(
          QuoteFormValidators.validatePreferredContactMethod(''),
          'Please select a preferred contact method',
        );
      });

      test('Returns null for valid contact methods', () {
        expect(QuoteFormValidators.validatePreferredContactMethod('Email'), isNull);
        expect(QuoteFormValidators.validatePreferredContactMethod('Phone Call'), isNull);
        expect(QuoteFormValidators.validatePreferredContactMethod('WhatsApp'), isNull);
      });
    });
  });
}

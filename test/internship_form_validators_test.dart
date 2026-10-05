import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/features/internships/presentation/utils/internship_form_validators.dart';

void main() {
  group('InternshipFormValidators Unit Tests', () {
    // ── Full Name Validation ─────────────────────────────────────────────────
    group('validateFullName', () {
      test('Returns error when null or empty', () {
        expect(
          InternshipFormValidators.validateFullName(null),
          'Please enter your full name',
        );
        expect(
          InternshipFormValidators.validateFullName(''),
          'Please enter your full name',
        );
        expect(
          InternshipFormValidators.validateFullName('   '),
          'Please enter your full name',
        );
      });

      test('Returns error when shorter than 2 characters', () {
        expect(
          InternshipFormValidators.validateFullName('A'),
          'Full name must be at least 2 characters',
        );
      });

      test('Returns error when containing numbers or special symbols', () {
        expect(
          InternshipFormValidators.validateFullName('John123'),
          'Name should contain letters only',
        );
        expect(
          InternshipFormValidators.validateFullName('Jane@Doe'),
          'Name should contain letters only',
        );
      });

      test('Accepts valid names with spaces, periods, and hyphens', () {
        expect(InternshipFormValidators.validateFullName('John Doe'), isNull);
        expect(InternshipFormValidators.validateFullName("Sarah O'Connor"), isNull);
        expect(InternshipFormValidators.validateFullName('Mary-Jane Watson'), isNull);
        expect(InternshipFormValidators.validateFullName('Dr. Rajesh Sharma'), isNull);
      });
    });

    // ── Email Validation ─────────────────────────────────────────────────────
    group('validateEmail', () {
      test('Returns error when null or empty', () {
        expect(
          InternshipFormValidators.validateEmail(null),
          'Please enter your email address',
        );
        expect(
          InternshipFormValidators.validateEmail(''),
          'Please enter your email address',
        );
        expect(
          InternshipFormValidators.validateEmail('   '),
          'Please enter your email address',
        );
      });

      test('Returns error on malformed email formats', () {
        const invalidEmails = [
          'plainaddress',
          r'#@%^%#$@#$@#.com',
          '@example.com',
          'Joe Smith <email@example.com>',
          'email.example.com',
          'email@example@example.com',
          'email@example',
          'email@111.222.333.44444',
          'email@example..com',
        ];

        for (final email in invalidEmails) {
          expect(
            InternshipFormValidators.validateEmail(email),
            'Please enter a valid email address (e.g. name@example.com)',
            reason: 'Failed for $email',
          );
        }
      });

      test('Accepts valid email formats', () {
        const validEmails = [
          'candidate@example.com',
          'john.doe@college.edu.in',
          'applicant+intern@codenovatechsolutions.in',
          'student_2026@university.ac.in',
        ];

        for (final email in validEmails) {
          expect(
            InternshipFormValidators.validateEmail(email),
            isNull,
            reason: 'Should be valid for $email',
          );
        }
      });
    });

    // ── Phone Number Validation ──────────────────────────────────────────────
    group('validatePhone', () {
      test('Returns error when null or empty', () {
        expect(
          InternshipFormValidators.validatePhone(null),
          'Please enter your mobile number',
        );
        expect(
          InternshipFormValidators.validatePhone(''),
          'Please enter your mobile number',
        );
      });

      test('Returns error on invalid length or invalid prefix', () {
        expect(
          InternshipFormValidators.validatePhone('12345'),
          'Please enter a valid 10-digit mobile number',
        );
        expect(
          InternshipFormValidators.validatePhone('0123456789'),
          'Please enter a valid 10-digit mobile number',
        );
        expect(
          InternshipFormValidators.validatePhone('5555555555'),
          'Please enter a valid 10-digit mobile number',
        );
        expect(
          InternshipFormValidators.validatePhone('987654321012345'),
          'Please enter a valid 10-digit mobile number',
        );
      });

      test('Accepts valid 10-digit mobile numbers with or without +91 prefix', () {
        expect(InternshipFormValidators.validatePhone('9876543210'), isNull);
        expect(InternshipFormValidators.validatePhone('8123456789'), isNull);
        expect(InternshipFormValidators.validatePhone('7000000000'), isNull);
        expect(InternshipFormValidators.validatePhone('6999999999'), isNull);
        expect(InternshipFormValidators.validatePhone('+919876543210'), isNull);
        expect(InternshipFormValidators.validatePhone('+91 9876543210'), isNull);
        expect(InternshipFormValidators.validatePhone('98765-43210'), isNull);
      });
    });

    // ── College Name Validation ──────────────────────────────────────────────
    group('validateCollegeName', () {
      test('Returns error when null or empty', () {
        expect(
          InternshipFormValidators.validateCollegeName(null),
          'Please enter your college or institute name',
        );
        expect(
          InternshipFormValidators.validateCollegeName('   '),
          'Please enter your college or institute name',
        );
      });

      test('Returns error when shorter than 3 characters', () {
        expect(
          InternshipFormValidators.validateCollegeName('AB'),
          'College name must be at least 3 characters',
        );
      });

      test('Accepts valid college names', () {
        expect(
          InternshipFormValidators.validateCollegeName(
            'Pune Institute of Computer Technology',
          ),
          isNull,
        );
        expect(InternshipFormValidators.validateCollegeName('IIT Bombay'), isNull);
      });
    });

    // ── Course & Branch Validation ───────────────────────────────────────────
    group('validateCourseBranch', () {
      test('Returns error when null or empty', () {
        expect(
          InternshipFormValidators.validateCourseBranch(null),
          'Please enter your course and branch (e.g. B.Tech CSE, MCA)',
        );
        expect(
          InternshipFormValidators.validateCourseBranch(''),
          'Please enter your course and branch (e.g. B.Tech CSE, MCA)',
        );
      });

      test('Accepts valid course branches', () {
        expect(
          InternshipFormValidators.validateCourseBranch('B.Tech CSE'),
          isNull,
        );
        expect(InternshipFormValidators.validateCourseBranch('MCA'), isNull);
        expect(
          InternshipFormValidators.validateCourseBranch('B.Sc Computer Science'),
          isNull,
        );
      });
    });

    // ── Preferred Technology Validation ──────────────────────────────────────
    group('validatePreferredTechnology', () {
      test('Returns error when null or empty', () {
        expect(
          InternshipFormValidators.validatePreferredTechnology(null),
          'Please select or enter your preferred technology',
        );
        expect(
          InternshipFormValidators.validatePreferredTechnology('   '),
          'Please select or enter your preferred technology',
        );
      });

      test('Accepts valid technology domains', () {
        expect(
          InternshipFormValidators.validatePreferredTechnology('Flutter'),
          isNull,
        );
        expect(
          InternshipFormValidators.validatePreferredTechnology(
            'Full Stack Development',
          ),
          isNull,
        );
        expect(
          InternshipFormValidators.validatePreferredTechnology('Python & AI'),
          isNull,
        );
      });
    });

    // ── Optional Additional Message Validation ───────────────────────────────
    group('validateAdditionalMessage', () {
      test('Accepts null and empty strings as valid optional input', () {
        expect(InternshipFormValidators.validateAdditionalMessage(null), isNull);
        expect(InternshipFormValidators.validateAdditionalMessage(''), isNull);
        expect(
          InternshipFormValidators.validateAdditionalMessage('   '),
          isNull,
        );
      });

      test('Rejects messages exceeding 500 characters', () {
        final longMessage = 'A' * 501;
        expect(
          InternshipFormValidators.validateAdditionalMessage(longMessage),
          'Additional message must not exceed 500 characters',
        );
      });

      test('Accepts valid messages within limit', () {
        final validMessage = 'A' * 300;
        expect(
          InternshipFormValidators.validateAdditionalMessage(validMessage),
          isNull,
        );
      });
    });

    // ── Optional Resume Link Validation ──────────────────────────────────────
    group('validateResumeUrl', () {
      test('Accepts null and empty strings as valid optional input', () {
        expect(InternshipFormValidators.validateResumeUrl(null), isNull);
        expect(InternshipFormValidators.validateResumeUrl(''), isNull);
        expect(InternshipFormValidators.validateResumeUrl('   '), isNull);
      });

      test('Returns error on invalid URL formats', () {
        expect(
          InternshipFormValidators.validateResumeUrl('not-a-valid-url'),
          'Please enter a valid link (e.g. https://drive.google.com/...)',
        );
      });

      test('Accepts valid http and https web links', () {
        expect(
          InternshipFormValidators.validateResumeUrl(
            'https://drive.google.com/file/d/12345/view',
          ),
          isNull,
        );
        expect(
          InternshipFormValidators.validateResumeUrl(
            'https://github.com/developer-candidate',
          ),
          isNull,
        );
        expect(
          InternshipFormValidators.validateResumeUrl(
            'https://linkedin.com/in/candidate',
          ),
          isNull,
        );
      });
    });
  });
}

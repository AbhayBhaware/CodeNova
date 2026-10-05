/// Pure validation utilities for the CodeNova Internship Application Form.
///
/// Encapsulates all field validation rules with clear, actionable error messages.
abstract final class InternshipFormValidators {
  InternshipFormValidators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+([.-][a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'^(?:\+91[\-\s]?)?[6-9]\d{9}$',
  );

  static final RegExp _nameRegExp = RegExp(
    r"^[a-zA-Z\s.'-]+$",
  );

  static final RegExp _urlRegExp = RegExp(
    r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    caseSensitive: false,
  );

  /// Validates candidate's full name.
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (trimmed.length > 70) {
      return 'Full name must not exceed 70 characters';
    }
    if (!_nameRegExp.hasMatch(trimmed)) {
      return 'Name should contain letters only';
    }
    return null;
  }

  /// Validates candidate's email address.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid email address (e.g. name@example.com)';
    }
    return null;
  }

  /// Validates candidate's mobile number (Indian 10-digit standard or +91 format).
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }
    final cleaned = value.trim().replaceAll(RegExp(r'[\s\-]'), '');
    if (!_phoneRegExp.hasMatch(cleaned)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  /// Validates college or university name.
  static String? validateCollegeName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your college or institute name';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'College name must be at least 3 characters';
    }
    return null;
  }

  /// Validates course and branch (e.g. B.Tech Computer Science, MCA).
  static String? validateCourseBranch(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your course and branch (e.g. B.Tech CSE, MCA)';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Course / branch must be at least 2 characters';
    }
    return null;
  }

  /// Validates preferred technology domain selection.
  static String? validatePreferredTechnology(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select or enter your preferred technology';
    }
    return null;
  }

  /// Validates optional additional message.
  static String? validateAdditionalMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }
    if (value.trim().length > 500) {
      return 'Additional message must not exceed 500 characters';
    }
    return null;
  }

  /// Validates optional resume or portfolio link.
  static String? validateResumeUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }
    final trimmed = value.trim();
    if (!_urlRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid link (e.g. https://drive.google.com/...)';
    }
    return null;
  }
}

/// Centralized, reusable validators for the Request a Quote business enquiry form.
///
/// Follows clear, accessible error messaging guidelines and prevents false
/// validation errors while enforcing appropriate data format standards.
abstract final class QuoteFormValidators {
  QuoteFormValidators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp _nameRegExp = RegExp(
    r"^[a-zA-Z\s\.\-']{2,}$",
  );

  /// Validates client / representative full name.
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (trimmed.length > 70) {
      return 'Name must not exceed 70 characters';
    }
    if (!_nameRegExp.hasMatch(trimmed)) {
      return 'Name must contain only letters, spaces, dots, or hyphens';
    }
    return null;
  }

  /// Validates client business / work email address.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed) || !trimmed.contains('.')) {
      return 'Please enter a valid email address (e.g. name@company.com)';
    }
    return null;
  }

  /// Validates optional company name.
  static String? validateCompanyName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }
    final trimmed = value.trim();
    if (trimmed.length > 100) {
      return 'Company name must not exceed 100 characters';
    }
    return null;
  }

  /// Validates project category / type.
  static String? validateProjectType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a project type';
    }
    return null;
  }

  /// Validates project scope description (minimum 15 characters).
  static String? validateProjectDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please describe your project requirements';
    }
    final trimmed = value.trim();
    if (trimmed.length < 15) {
      return 'Please provide more details (minimum 15 characters)';
    }
    if (trimmed.length > 2500) {
      return 'Description must not exceed 2500 characters';
    }
    return null;
  }

  /// Validates optional budget range tier.
  static String? validateBudgetRange(String? value) {
    return null; // Optional field
  }

  /// Validates preferred contact channel.
  static String? validatePreferredContactMethod(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a preferred contact method';
    }
    return null;
  }
}

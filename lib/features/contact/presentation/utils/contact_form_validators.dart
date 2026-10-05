/// Centralized validators for the Contact Us enquiry form.
abstract final class ContactFormValidators {
  ContactFormValidators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _nameRegex = RegExp(
    r"^[a-zA-Z\s\.\'-]+$",
  );

  static final RegExp _phoneRegex = RegExp(
    r'^\+?[0-9]{7,15}$',
  );

  /// Validates the full name field (required).
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (trimmed.length > 70) {
      return 'Name cannot exceed 70 characters';
    }
    if (!_nameRegex.hasMatch(trimmed)) {
      return 'Please enter a valid name (letters only)';
    }
    return null;
  }

  /// Validates email address (required).
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    final trimmed = value.trim();
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address (e.g. name@domain.com)';
    }
    return null;
  }

  /// Validates telephone/mobile number (optional).
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }
    final sanitized = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!_phoneRegex.hasMatch(sanitized)) {
      return 'Please enter a valid contact phone number';
    }
    return null;
  }

  /// Validates enquiry category selection (required).
  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select an enquiry category';
    }
    return null;
  }

  /// Validates enquiry message (required).
  static String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your enquiry message';
    }
    final trimmed = value.trim();
    if (trimmed.length < 15) {
      return 'Please provide more details (minimum 15 characters)';
    }
    if (trimmed.length > 1500) {
      return 'Message cannot exceed 1500 characters';
    }
    return null;
  }
}

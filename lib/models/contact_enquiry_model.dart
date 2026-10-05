/// Model representing a general contact enquiry submitted through the CodeNova app.
class ContactEnquiryModel {
  const ContactEnquiryModel({
    required this.fullName,
    required this.email,
    this.phone,
    required this.category,
    required this.message,
    required this.submittedAt,
  });

  /// The submitter's full name.
  final String fullName;

  /// Official contact email.
  final String email;

  /// Optional telephone or mobile number.
  final String? phone;

  /// Selected enquiry category (e.g. Course Admission, Internship, IT Services, General).
  final String category;

  /// Message describing the request or question.
  final String message;

  /// Timestamp when the enquiry was submitted.
  final DateTime submittedAt;

  ContactEnquiryModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? category,
    String? message,
    DateTime? submittedAt,
  }) {
    return ContactEnquiryModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      category: category ?? this.category,
      message: message ?? this.message,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
      'category': category,
      'message': message,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory ContactEnquiryModel.fromJson(Map<String, dynamic> json) {
    return ContactEnquiryModel(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      category: json['category'] as String? ?? 'General Question',
      message: json['message'] as String? ?? '',
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactEnquiryModel &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName &&
          email == other.email &&
          phone == other.phone &&
          category == other.category &&
          message == other.message &&
          submittedAt == other.submittedAt;

  @override
  int get hashCode => Object.hash(
        fullName,
        email,
        phone,
        category,
        message,
        submittedAt,
      );
}

/// Result returned from contact enquiry submission.
class ContactSubmissionResult {
  const ContactSubmissionResult({
    required this.referenceId,
    required this.enquiry,
    required this.isMock,
    required this.timestamp,
  });

  /// Generated tracking reference ID (e.g. DEV-ENQ-9481).
  final String referenceId;

  /// The enquiry data that was submitted.
  final ContactEnquiryModel enquiry;

  /// Whether this was processed in mock development mode.
  final bool isMock;

  /// Timestamp of confirmation.
  final DateTime timestamp;
}

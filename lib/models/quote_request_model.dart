import 'package:flutter/foundation.dart';

/// Data model representing a project quote request submitted by a prospective client.
///
/// Designed for full serializability with REST / GraphQL backend endpoints
/// (e.g. `POST /api/v1/quotes/request`).
///
/// Complies with data minimization: collects only details necessary for
/// project evaluation and avoids storing sensitive client data insecurely.
@immutable
class QuoteRequestModel {
  const QuoteRequestModel({
    required this.fullName,
    required this.email,
    required this.projectType,
    required this.projectDescription,
    required this.preferredContactMethod,
    this.companyName,
    this.budgetRange,
    this.serviceId,
    this.submittedAt,
  });

  /// Client or representative's full name.
  final String fullName;

  /// Business or personal email address for proposals and correspondence.
  final String email;

  /// Optional company or startup name.
  final String? companyName;

  /// Category / domain of the project (e.g. 'Web Application Development', 'Mobile App Development').
  final String projectType;

  /// Detailed scope, objectives, requirements, and deliverables description.
  final String projectDescription;

  /// Optional financial allocation or expected budget tier.
  final String? budgetRange;

  /// Preferred communication channel (e.g. 'Email', 'Phone Call', 'WhatsApp').
  final String preferredContactMethod;

  /// Optional identifier linking back to a specific service catalog item.
  final String? serviceId;

  /// Timestamp when the request was initiated.
  final DateTime? submittedAt;

  QuoteRequestModel copyWith({
    String? fullName,
    String? email,
    String? companyName,
    String? projectType,
    String? projectDescription,
    String? budgetRange,
    String? preferredContactMethod,
    String? serviceId,
    DateTime? submittedAt,
  }) {
    return QuoteRequestModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      projectType: projectType ?? this.projectType,
      projectDescription: projectDescription ?? this.projectDescription,
      budgetRange: budgetRange ?? this.budgetRange,
      preferredContactMethod:
          preferredContactMethod ?? this.preferredContactMethod,
      serviceId: serviceId ?? this.serviceId,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        if (companyName != null && companyName!.isNotEmpty)
          'companyName': companyName,
        'projectType': projectType,
        'projectDescription': projectDescription,
        if (budgetRange != null && budgetRange!.isNotEmpty)
          'budgetRange': budgetRange,
        'preferredContactMethod': preferredContactMethod,
        if (serviceId != null) 'serviceId': serviceId,
        'submittedAt':
            (submittedAt ?? DateTime.now()).toUtc().toIso8601String(),
      };

  factory QuoteRequestModel.fromJson(Map<String, dynamic> json) {
    return QuoteRequestModel(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      companyName: json['companyName'] as String?,
      projectType: json['projectType'] as String? ?? '',
      projectDescription: json['projectDescription'] as String? ?? '',
      budgetRange: json['budgetRange'] as String?,
      preferredContactMethod:
          json['preferredContactMethod'] as String? ?? 'Email',
      serviceId: json['serviceId'] as String?,
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'] as String)
          : null,
    );
  }

  @override
  String toString() =>
      'QuoteRequestModel(fullName: $fullName, email: $email, projectType: $projectType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuoteRequestModel &&
        other.fullName == fullName &&
        other.email == email &&
        other.companyName == companyName &&
        other.projectType == projectType &&
        other.projectDescription == projectDescription &&
        other.budgetRange == budgetRange &&
        other.preferredContactMethod == preferredContactMethod &&
        other.serviceId == serviceId;
  }

  @override
  int get hashCode => Object.hash(
        fullName,
        email,
        companyName,
        projectType,
        projectDescription,
        budgetRange,
        preferredContactMethod,
        serviceId,
      );
}

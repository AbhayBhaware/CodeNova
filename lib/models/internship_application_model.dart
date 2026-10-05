import 'package:flutter/foundation.dart';

/// Model representing an internship application submitted by a candidate.
///
/// Designed for full serializability with REST API backend endpoints
/// (e.g. POST /api/v1/internships/apply).
///
/// Complies with data minimization: collects only details relevant to
/// technical evaluation and avoids unnecessary or sensitive personal data.
@immutable
class InternshipApplicationModel {
  const InternshipApplicationModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.collegeName,
    required this.courseBranch,
    required this.preferredTechnology,
    this.internshipId,
    this.internshipTitle,
    this.additionalMessage,
    this.resumeUrl,
    this.submittedAt,
  });

  /// Candidate's full name.
  final String fullName;

  /// Candidate's verified contact email address.
  final String email;

  /// Candidate's mobile phone number.
  final String phone;

  /// Current or graduated college / university / institute.
  final String collegeName;

  /// Academic qualification and discipline (e.g. B.Tech Computer Science, MCA).
  final String courseBranch;

  /// Primary technical specialization or domain of interest.
  final String preferredTechnology;

  /// Optional specific internship ID if applying from a listing.
  final String? internshipId;

  /// Optional specific internship title for contextual reference.
  final String? internshipTitle;

  /// Optional candidate remarks, projects, or questions.
  final String? additionalMessage;

  /// Optional link to candidate's resume / portfolio (Google Drive, GitHub, etc.)
  /// Used until dedicated multipart cloud file storage is enabled on the backend.
  final String? resumeUrl;

  /// Timestamp when application was initiated / submitted.
  final DateTime? submittedAt;

  InternshipApplicationModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? collegeName,
    String? courseBranch,
    String? preferredTechnology,
    String? internshipId,
    String? internshipTitle,
    String? additionalMessage,
    String? resumeUrl,
    DateTime? submittedAt,
  }) {
    return InternshipApplicationModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      collegeName: collegeName ?? this.collegeName,
      courseBranch: courseBranch ?? this.courseBranch,
      preferredTechnology: preferredTechnology ?? this.preferredTechnology,
      internshipId: internshipId ?? this.internshipId,
      internshipTitle: internshipTitle ?? this.internshipTitle,
      additionalMessage: additionalMessage ?? this.additionalMessage,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName.trim(),
        'email': email.trim().toLowerCase(),
        'phone': phone.trim(),
        'collegeName': collegeName.trim(),
        'courseBranch': courseBranch.trim(),
        'preferredTechnology': preferredTechnology.trim(),
        if (internshipId != null) 'internshipId': internshipId,
        if (internshipTitle != null) 'internshipTitle': internshipTitle,
        if (additionalMessage != null && additionalMessage!.trim().isNotEmpty)
          'additionalMessage': additionalMessage!.trim(),
        if (resumeUrl != null && resumeUrl!.trim().isNotEmpty)
          'resumeUrl': resumeUrl!.trim(),
        'submittedAt': (submittedAt ?? DateTime.now()).toIso8601String(),
      };

  factory InternshipApplicationModel.fromJson(Map<String, dynamic> json) {
    return InternshipApplicationModel(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      collegeName: json['collegeName'] as String? ?? '',
      courseBranch: json['courseBranch'] as String? ?? '',
      preferredTechnology: json['preferredTechnology'] as String? ?? '',
      internshipId: json['internshipId'] as String?,
      internshipTitle: json['internshipTitle'] as String?,
      additionalMessage: json['additionalMessage'] as String?,
      resumeUrl: json['resumeUrl'] as String?,
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InternshipApplicationModel &&
        other.fullName == fullName &&
        other.email == email &&
        other.phone == phone &&
        other.collegeName == collegeName &&
        other.courseBranch == courseBranch &&
        other.preferredTechnology == preferredTechnology &&
        other.internshipId == internshipId &&
        other.internshipTitle == internshipTitle &&
        other.additionalMessage == additionalMessage &&
        other.resumeUrl == resumeUrl;
  }

  @override
  int get hashCode => Object.hash(
        fullName,
        email,
        phone,
        collegeName,
        courseBranch,
        preferredTechnology,
        internshipId,
        internshipTitle,
        additionalMessage,
        resumeUrl,
      );
}

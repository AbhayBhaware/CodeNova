/// Type of credential issued by CodeNova Tech Solutions.
enum CertificateType {
  courseCompletion('Course Completion Certificate'),
  internshipExperience('Internship Experience Certificate');

  const CertificateType(this.displayName);
  final String displayName;
}

/// Verification status of an issued certificate.
enum CertificateStatus {
  active('Active / Verified'),
  revoked('Revoked');

  const CertificateStatus(this.displayName);
  final String displayName;
}

/// Model representing a verified digital certificate.
class CertificateModel {
  const CertificateModel({
    required this.id,
    required this.certificateCode,
    required this.recipientName,
    required this.recipientEmail,
    required this.certificateType,
    required this.programTitle,
    required this.tenure,
    required this.issuedDate,
    required this.mentorName,
    this.status = CertificateStatus.active,
    this.revocationReason,
    required this.verificationHash,
    required this.issuedBy,
  });

  final String id;
  final String certificateCode;
  final String recipientName;
  final String recipientEmail;
  final CertificateType certificateType;
  final String programTitle;
  final String tenure;
  final DateTime issuedDate;
  final String mentorName;
  final CertificateStatus status;
  final String? revocationReason;
  final String verificationHash;
  final String issuedBy;

  bool get isActive => status == CertificateStatus.active;
  bool get isRevoked => status == CertificateStatus.revoked;

  CertificateModel copyWith({
    String? id,
    String? certificateCode,
    String? recipientName,
    String? recipientEmail,
    CertificateType? certificateType,
    String? programTitle,
    String? tenure,
    DateTime? issuedDate,
    String? mentorName,
    CertificateStatus? status,
    String? revocationReason,
    String? verificationHash,
    String? issuedBy,
  }) {
    return CertificateModel(
      id: id ?? this.id,
      certificateCode: certificateCode ?? this.certificateCode,
      recipientName: recipientName ?? this.recipientName,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      certificateType: certificateType ?? this.certificateType,
      programTitle: programTitle ?? this.programTitle,
      tenure: tenure ?? this.tenure,
      issuedDate: issuedDate ?? this.issuedDate,
      mentorName: mentorName ?? this.mentorName,
      status: status ?? this.status,
      revocationReason: revocationReason ?? this.revocationReason,
      verificationHash: verificationHash ?? this.verificationHash,
      issuedBy: issuedBy ?? this.issuedBy,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'certificateCode': certificateCode,
        'recipientName': recipientName,
        'recipientEmail': recipientEmail,
        'certificateType': certificateType.name,
        'programTitle': programTitle,
        'tenure': tenure,
        'issuedDate': issuedDate.toIso8601String(),
        'mentorName': mentorName,
        'status': status.name,
        'revocationReason': revocationReason,
        'verificationHash': verificationHash,
        'issuedBy': issuedBy,
      };

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] as String,
      certificateCode: json['certificateCode'] as String,
      recipientName: json['recipientName'] as String,
      recipientEmail: json['recipientEmail'] as String,
      certificateType: CertificateType.values.firstWhere(
        (t) => t.name == json['certificateType'],
        orElse: () => CertificateType.courseCompletion,
      ),
      programTitle: json['programTitle'] as String,
      tenure: json['tenure'] as String,
      issuedDate: DateTime.parse(json['issuedDate'] as String),
      mentorName: json['mentorName'] as String,
      status: CertificateStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => CertificateStatus.active,
      ),
      revocationReason: json['revocationReason'] as String?,
      verificationHash: json['verificationHash'] as String,
      issuedBy: json['issuedBy'] as String,
    );
  }
}

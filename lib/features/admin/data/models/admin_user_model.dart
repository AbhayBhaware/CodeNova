/// Administrative roles for Role-Based Access Control (RBAC).
enum AdminRole {
  /// Unrestricted access to all modules, credentials, and audit logs.
  superAdmin('Super Administrator'),

  /// Manages course offerings, curriculum modules, and course certificates.
  courseCoordinator('Course Coordinator'),

  /// Manages internship postings, reviews student applications, and issues internship certificates.
  placementOfficer('Placement Officer'),

  /// Manages enterprise quote requests and business inquiries.
  businessManager('Business Solutions Manager');

  const AdminRole(this.displayName);
  final String displayName;
}

/// Represents an authenticated staff/administrator session.
class AdminUser {
  const AdminUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.token,
    required this.lastLoginAt,
  });

  final String id;
  final String fullName;
  final String email;
  final AdminRole role;
  final String token;
  final DateTime lastLoginAt;

  bool get canManageCourses =>
      role == AdminRole.superAdmin || role == AdminRole.courseCoordinator;

  bool get canManageInternships =>
      role == AdminRole.superAdmin || role == AdminRole.placementOfficer;

  bool get canViewApplications =>
      role == AdminRole.superAdmin || role == AdminRole.placementOfficer;

  bool get canManageQuotes =>
      role == AdminRole.superAdmin || role == AdminRole.businessManager;

  bool get canManageCertificates =>
      role == AdminRole.superAdmin ||
      role == AdminRole.courseCoordinator ||
      role == AdminRole.placementOfficer;

  bool get canViewAuditLogs => role == AdminRole.superAdmin;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'role': role.name,
        'token': token,
        'lastLoginAt': lastLoginAt.toIso8601String(),
      };

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: AdminRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => AdminRole.courseCoordinator,
      ),
      token: json['token'] as String,
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
    );
  }
}

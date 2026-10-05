import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../models/models.dart';
import '../../data/models/models.dart';
import '../../data/repositories/admin_data_repository.dart';
import '../../data/repositories/mock_admin_data_repository.dart';

/// Navigation tabs within the Admin Web Dashboard.
enum AdminTab {
  overview('Overview & Metrics'),
  courses('Courses Catalog'),
  internships('Internship Openings'),
  applications('Applications Pipeline'),
  quotes('Quotes & Inquiries'),
  certificates('Verified Certificates'),
  auditLogs('DPDP Audit Ledger');

  const AdminTab(this.title);
  final String title;
}

/// Controller managing data, CRUD operations, PII masking, and certificates.
class AdminDashboardController extends ChangeNotifier {
  AdminDashboardController({
    AdminDataRepository? repository,
  }) : _repository = repository ?? MockAdminDataRepository() {
    loadData();
  }

  final AdminDataRepository _repository;

  AdminTab _activeTab = AdminTab.overview;
  AdminTab get activeTab => _activeTab;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<CourseModel> _courses = [];
  List<CourseModel> get courses => _courses;

  List<InternshipModel> _internships = [];
  List<InternshipModel> get internships => _internships;

  List<InternshipApplicationModel> _applications = [];
  List<InternshipApplicationModel> get applications => _applications;

  List<QuoteRequestModel> _quotes = [];
  List<QuoteRequestModel> get quotes => _quotes;

  List<ContactEnquiryModel> _enquiries = [];
  List<ContactEnquiryModel> get enquiries => _enquiries;

  List<CertificateModel> _certificates = [];
  List<CertificateModel> get certificates => _certificates;

  List<AuditLogModel> _auditLogs = [];
  List<AuditLogModel> get auditLogs => _auditLogs;

  /// Set of application emails whose PII has been deliberately revealed with audit logging.
  final Set<String> _revealedPiiEmails = {};
  bool isPiiRevealed(String email) => _revealedPiiEmails.contains(email.toLowerCase());

  void setTab(AdminTab tab) {
    _activeTab = tab;
    notifyListeners();
  }

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getCourses(),
        _repository.getInternships(),
        _repository.getApplications(),
        _repository.getQuotes(),
        _repository.getEnquiries(),
        _repository.getCertificates(),
        _repository.getAuditLogs(),
      ]);

      _courses = results[0] as List<CourseModel>;
      _internships = results[1] as List<InternshipModel>;
      _applications = results[2] as List<InternshipApplicationModel>;
      _quotes = results[3] as List<QuoteRequestModel>;
      _enquiries = results[4] as List<ContactEnquiryModel>;
      _certificates = results[5] as List<CertificateModel>;
      _auditLogs = results[6] as List<AuditLogModel>;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load administrative dashboard data: $e';
      notifyListeners();
    }
  }

  // ── Course Actions ──────────────────────────────────────────
  Future<void> saveCourse(CourseModel course, String adminEmail) async {
    await _repository.saveCourse(course);
    await _logAudit(
      adminEmail: adminEmail,
      action: 'SAVE_COURSE',
      resourceType: 'course',
      resourceId: course.id,
      details: 'Created or updated course "${course.title}".',
    );
    await loadData();
  }

  Future<void> deleteCourse(String id, String title, String adminEmail) async {
    await _repository.deleteCourse(id);
    await _logAudit(
      adminEmail: adminEmail,
      action: 'DELETE_COURSE',
      resourceType: 'course',
      resourceId: id,
      details: 'Deleted course "$title".',
    );
    await loadData();
  }

  Future<void> toggleCourseAvailability(String id, String title, String adminEmail) async {
    await _repository.toggleCourseAvailability(id);
    await _logAudit(
      adminEmail: adminEmail,
      action: 'TOGGLE_COURSE_AVAILABILITY',
      resourceType: 'course',
      resourceId: id,
      details: 'Toggled availability status for "$title".',
    );
    await loadData();
  }

  // ── Internship Actions ──────────────────────────────────────
  Future<void> saveInternship(InternshipModel internship, String adminEmail) async {
    await _repository.saveInternship(internship);
    await _logAudit(
      adminEmail: adminEmail,
      action: 'SAVE_INTERNSHIP',
      resourceType: 'internship',
      resourceId: internship.id,
      details: 'Created or updated internship "${internship.title}".',
    );
    await loadData();
  }

  Future<void> deleteInternship(String id, String title, String adminEmail) async {
    await _repository.deleteInternship(id);
    await _logAudit(
      adminEmail: adminEmail,
      action: 'DELETE_INTERNSHIP',
      resourceType: 'internship',
      resourceId: id,
      details: 'Deleted internship posting "$title".',
    );
    await loadData();
  }

  Future<void> updateInternshipStatus(
    String id,
    String title,
    InternshipStatus newStatus,
    String adminEmail,
  ) async {
    await _repository.updateInternshipStatus(id, newStatus);
    await _logAudit(
      adminEmail: adminEmail,
      action: 'UPDATE_INTERNSHIP_STATUS',
      resourceType: 'internship',
      resourceId: id,
      details: 'Updated internship "$title" status to ${newStatus.label}.',
    );
    await loadData();
  }

  // ── Applications & PII Protection (DPDP Act) ─────────────────
  Future<void> revealApplicantPii(
    InternshipApplicationModel application,
    String adminEmail,
  ) async {
    _revealedPiiEmails.add(application.email.toLowerCase());
    await _logAudit(
      adminEmail: adminEmail,
      action: 'REVEAL_PII_ACCESS',
      resourceType: 'internship_application',
      resourceId: application.email,
      details:
          'Staff accessed unmasked candidate PII (Phone & Email) for candidate "${application.fullName}" (College: ${application.collegeName}).',
    );
    await loadData();
  }

  // ── Certificate Management ──────────────────────────────────
  Future<CertificateModel> issueCertificate({
    required String recipientName,
    required String recipientEmail,
    required CertificateType certificateType,
    required String programTitle,
    required String tenure,
    required String mentorName,
    required String issuedBy,
    required String adminEmail,
  }) async {
    final year = DateTime.now().year;
    final typePrefix = certificateType == CertificateType.courseCompletion ? 'CRS' : 'INT';
    final randomSuffix = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();
    final certificateCode = 'CN-CERT-$year-$typePrefix-$randomSuffix';

    // Verification fingerprint
    final rawPayload = '$certificateCode|$recipientName|$programTitle|${DateTime.now().toIso8601String()}';
    final hash = base64Url.encode(utf8.encode(rawPayload)).replaceAll('=', '');

    final cert = CertificateModel(
      id: 'cert-${DateTime.now().millisecondsSinceEpoch}',
      certificateCode: certificateCode,
      recipientName: recipientName.trim(),
      recipientEmail: recipientEmail.trim(),
      certificateType: certificateType,
      programTitle: programTitle.trim(),
      tenure: tenure.trim(),
      issuedDate: DateTime.now(),
      mentorName: mentorName.trim(),
      status: CertificateStatus.active,
      verificationHash: hash,
      issuedBy: issuedBy,
    );

    final issued = await _repository.issueCertificate(cert);
    await _logAudit(
      adminEmail: adminEmail,
      action: 'ISSUE_CERTIFICATE',
      resourceType: 'certificate',
      resourceId: certificateCode,
      details:
          'Issued ${certificateType.displayName} for "$recipientName" ($programTitle). Verification Code: $certificateCode.',
    );
    await loadData();
    return issued;
  }

  Future<void> revokeCertificate({
    required String certId,
    required String certificateCode,
    required String recipientName,
    required String reason,
    required String adminEmail,
  }) async {
    await _repository.revokeCertificate(certId, reason);
    await _logAudit(
      adminEmail: adminEmail,
      action: 'REVOKE_CERTIFICATE',
      resourceType: 'certificate',
      resourceId: certificateCode,
      details: 'Revoked certificate $certificateCode for "$recipientName". Reason: "$reason".',
    );
    await loadData();
  }

  Future<CertificateModel?> verifyCertificateCode(String code) async {
    return _repository.verifyCertificate(code);
  }

  Future<void> _logAudit({
    required String adminEmail,
    required String action,
    required String resourceType,
    required String resourceId,
    required String details,
  }) async {
    final log = AuditLogModel(
      id: 'log-${DateTime.now().millisecondsSinceEpoch}',
      adminEmail: adminEmail,
      action: action,
      resourceType: resourceType,
      resourceId: resourceId,
      timestamp: DateTime.now(),
      details: details,
    );
    await _repository.logAudit(log);
  }
}

import '../../../../models/models.dart';
import '../models/models.dart';

/// Contract for administrative management of catalog, submissions, and certificates.
abstract class AdminDataRepository {
  // ── Courses Management ─────────────────────────────────────
  Future<List<CourseModel>> getCourses();
  Future<void> saveCourse(CourseModel course);
  Future<void> deleteCourse(String id);
  Future<void> toggleCourseAvailability(String id);

  // ── Internships Management ─────────────────────────────────
  Future<List<InternshipModel>> getInternships();
  Future<void> saveInternship(InternshipModel internship);
  Future<void> deleteInternship(String id);
  Future<void> updateInternshipStatus(String id, InternshipStatus status);

  // ── Applications Pipeline ──────────────────────────────────
  Future<List<InternshipApplicationModel>> getApplications();
  Future<void> updateApplicationStatus(
    String referenceId,
    String status, {
    String? reviewerNotes,
  });

  // ── Quotes & Enquiries Triage ──────────────────────────────
  Future<List<QuoteRequestModel>> getQuotes();
  Future<void> updateQuoteStatus(
    String referenceId,
    String status, {
    String? internalNotes,
  });

  Future<List<ContactEnquiryModel>> getEnquiries();
  Future<void> updateEnquiryStatus(String referenceId, String status);

  // ── Certificates Ledger ────────────────────────────────────
  Future<List<CertificateModel>> getCertificates();
  Future<CertificateModel> issueCertificate(CertificateModel certificate);
  Future<void> revokeCertificate(String id, String reason);
  Future<CertificateModel?> verifyCertificate(String code);

  // ── DPDP Audit Logs ────────────────────────────────────────
  Future<List<AuditLogModel>> getAuditLogs();
  Future<void> logAudit(AuditLogModel log);
}

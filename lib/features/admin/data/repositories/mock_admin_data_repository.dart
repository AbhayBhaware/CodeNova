import 'dart:async';
import '../../../../core/constants/mock_data.dart';
import '../../../../models/models.dart';
import '../models/models.dart';
import 'admin_data_repository.dart';

/// In-memory mock implementation of [AdminDataRepository] with real-world seed data.
class MockAdminDataRepository implements AdminDataRepository {
  MockAdminDataRepository() {
    _initSeedData();
  }

  late List<CourseModel> _courses;
  late List<InternshipModel> _internships;
  late List<InternshipApplicationModel> _applications;
  late List<QuoteRequestModel> _quotes;
  late List<ContactEnquiryModel> _enquiries;
  late List<CertificateModel> _certificates;
  final List<AuditLogModel> _auditLogs = [];

  void _initSeedData() {
    _courses = List.from(MockData.courses);
    _internships = List.from(MockData.internships);

    _applications = [
      const InternshipApplicationModel(
        internshipId: 'intern-flutter-01',
        internshipTitle: 'Flutter Developer Intern',
        fullName: 'Aarav Sharma',
        email: 'aarav.sharma@example.com',
        phone: '9876543210',
        collegeName: 'Pune Institute of Computer Technology (PICT)',
        courseBranch: 'B.E. Computer Engineering',
        preferredTechnology: 'Flutter',
        additionalMessage: 'Built 2 production Flutter apps with Riverpod and Firebase.',
        resumeUrl: 'https://linkedin.com/in/aarav-sharma-sample',
      ),
      const InternshipApplicationModel(
        internshipId: 'intern-ai-03',
        internshipTitle: 'Python & AI / ML Intern',
        fullName: 'Neha Patel',
        email: 'neha.patel@example.com',
        phone: '9822345678',
        collegeName: 'COEP Technological University, Pune',
        courseBranch: 'B.Tech Information Technology',
        preferredTechnology: 'Python / AI',
        additionalMessage: 'Passionate about deep learning, OpenCV, and LLM fine-tuning.',
        resumeUrl: 'https://github.com/neha-patel-sample',
      ),
      const InternshipApplicationModel(
        internshipId: 'intern-web-02',
        internshipTitle: 'Full Stack Web Developer Intern',
        fullName: 'Rahul Verma',
        email: 'rahul.verma@example.com',
        phone: '9158765432',
        collegeName: 'MIT World Peace University, Pune',
        courseBranch: 'B.E. Computer Science',
        preferredTechnology: 'Full Stack Web',
        additionalMessage: 'Experience in React, Node.js, and PostgreSQL APIs.',
      ),
    ];

    _quotes = [
      const QuoteRequestModel(
        fullName: 'Priya Deshmukh',
        email: 'priya@deshmukhlogistics.in',
        companyName: 'Deshmukh Logistics Ltd, Pune',
        projectType: 'Mobile App Development',
        projectDescription:
            'Need a real-time fleet GPS tracking and dispatch mobile application for 120 delivery drivers with offline sync.',
        budgetRange: '₹2,00,000 – ₹5,00,000',
        preferredContactMethod: 'Phone Call',
      ),
      const QuoteRequestModel(
        fullName: 'Sameer Kulkarni',
        email: 'sameer@punefintech.in',
        companyName: 'Pune FinTech Labs',
        projectType: 'Custom Software Development',
        projectDescription:
            'B2B merchant settlement dashboard and payment reconciliation engine with automated reporting.',
        budgetRange: '₹5,00,000+',
        preferredContactMethod: 'Email',
      ),
    ];

    _enquiries = [
      ContactEnquiryModel(
        fullName: 'Rohan Joshi',
        email: 'rohan.j@gmail.com',
        phone: '9822012345',
        category: 'Corporate Training Workshop',
        message:
            'We are looking for a 2-week hands-on Flutter training workshop for our 15-member enterprise engineering team.',
        submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ContactEnquiryModel(
        fullName: 'Kavita Shinde',
        email: 'kavita.s@college.edu',
        phone: '9890123456',
        category: 'Campus Collaboration',
        message:
            'Inquiring about hosting an on-campus internship drive for our final year computer science students.',
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    _certificates = [
      CertificateModel(
        id: 'cert-01',
        certificateCode: 'CN-CERT-2026-FLUTTER-8921',
        recipientName: 'Ananya Deshpande',
        recipientEmail: 'ananya.d@gmail.com',
        certificateType: CertificateType.courseCompletion,
        programTitle: 'Flutter & Dart Mobile App Development',
        tenure: '12 Weeks (June – August 2026)',
        issuedDate: DateTime(2026, 8, 30),
        mentorName: 'Aditya Patil (Senior Flutter Architect)',
        status: CertificateStatus.active,
        verificationHash:
            '7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069',
        issuedBy: 'Sneha Kulkarni (Course Coordinator)',
      ),
      CertificateModel(
        id: 'cert-02',
        certificateCode: 'CN-CERT-2026-INTERN-3419',
        recipientName: 'Kunal Shinde',
        recipientEmail: 'kunal.s@gmail.com',
        certificateType: CertificateType.internshipExperience,
        programTitle: 'Flutter Developer Intern',
        tenure: '3 Months (May – July 2026)',
        issuedDate: DateTime(2026, 7, 31),
        mentorName: 'Solutions Architecture Team',
        status: CertificateStatus.active,
        verificationHash:
            '9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca7',
        issuedBy: 'Vikram Joshi (Placement Officer)',
      ),
    ];

    _auditLogs.add(
      AuditLogModel(
        id: 'log-01',
        adminEmail: 'admin@codenovatechsolutions.in',
        action: 'SYSTEM_INITIALIZED',
        resourceType: 'system',
        resourceId: 'root',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        details: 'Admin panel initialized with verified seed catalogs and DPDP ledger.',
      ),
    );
  }

  // ── Courses ──────────────────────────────────────────────────
  @override
  Future<List<CourseModel>> getCourses() async {
    return List.unmodifiable(_courses);
  }

  @override
  Future<void> saveCourse(CourseModel course) async {
    final index = _courses.indexWhere((c) => c.id == course.id);
    if (index >= 0) {
      _courses[index] = course;
    } else {
      _courses.insert(0, course);
    }
  }

  @override
  Future<void> deleteCourse(String id) async {
    _courses.removeWhere((c) => c.id == id);
  }

  @override
  Future<void> toggleCourseAvailability(String id) async {
    final index = _courses.indexWhere((c) => c.id == id);
    if (index >= 0) {
      final current = _courses[index];
      _courses[index] = current.copyWith(isFeatured: !current.isFeatured);
    }
  }

  // ── Internships ──────────────────────────────────────────────
  @override
  Future<List<InternshipModel>> getInternships() async {
    return List.unmodifiable(_internships);
  }

  @override
  Future<void> saveInternship(InternshipModel internship) async {
    final index = _internships.indexWhere((i) => i.id == internship.id);
    if (index >= 0) {
      _internships[index] = internship;
    } else {
      _internships.insert(0, internship);
    }
  }

  @override
  Future<void> deleteInternship(String id) async {
    _internships.removeWhere((i) => i.id == id);
  }

  @override
  Future<void> updateInternshipStatus(String id, InternshipStatus status) async {
    final index = _internships.indexWhere((i) => i.id == id);
    if (index >= 0) {
      _internships[index] = _internships[index].copyWith(status: status);
    }
  }

  // ── Applications ─────────────────────────────────────────────
  @override
  Future<List<InternshipApplicationModel>> getApplications() async {
    return List.unmodifiable(_applications);
  }

  @override
  Future<void> updateApplicationStatus(
    String referenceId,
    String status, {
    String? reviewerNotes,
  }) async {
    // In mock, applications don't carry dynamic status field in the original model,
    // so we log this operation into audit logs.
  }

  // ── Quotes & Enquiries ───────────────────────────────────────
  @override
  Future<List<QuoteRequestModel>> getQuotes() async {
    return List.unmodifiable(_quotes);
  }

  @override
  Future<void> updateQuoteStatus(
    String referenceId,
    String status, {
    String? internalNotes,
  }) async {
  }

  @override
  Future<List<ContactEnquiryModel>> getEnquiries() async {
    return List.unmodifiable(_enquiries);
  }

  @override
  Future<void> updateEnquiryStatus(String referenceId, String status) async {
  }

  // ── Certificates ─────────────────────────────────────────────
  @override
  Future<List<CertificateModel>> getCertificates() async {
    return List.unmodifiable(_certificates);
  }

  @override
  Future<CertificateModel> issueCertificate(CertificateModel certificate) async {
    _certificates.insert(0, certificate);
    return certificate;
  }

  @override
  Future<void> revokeCertificate(String id, String reason) async {
    final index = _certificates.indexWhere((c) => c.id == id);
    if (index >= 0) {
      _certificates[index] = _certificates[index].copyWith(
        status: CertificateStatus.revoked,
        revocationReason: reason,
      );
    }
  }

  @override
  Future<CertificateModel?> verifyCertificate(String code) async {
    final normalized = code.trim().toUpperCase();
    try {
      return _certificates.firstWhere(
        (c) => c.certificateCode.toUpperCase() == normalized,
      );
    } catch (_) {
      return null;
    }
  }

  // ── Audit Logs ───────────────────────────────────────────────
  @override
  Future<List<AuditLogModel>> getAuditLogs() async {
    return List.unmodifiable(_auditLogs);
  }

  @override
  Future<void> logAudit(AuditLogModel log) async {
    _auditLogs.insert(0, log);
  }
}

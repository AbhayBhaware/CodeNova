import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codenova_app/models/models.dart';
import 'package:codenova_app/features/admin/data/models/models.dart';
import 'package:codenova_app/features/admin/data/repositories/mock_admin_auth_repository.dart';
import 'package:codenova_app/features/admin/data/repositories/mock_admin_data_repository.dart';
import 'package:codenova_app/features/admin/presentation/controllers/admin_auth_controller.dart';
import 'package:codenova_app/features/admin/presentation/controllers/admin_dashboard_controller.dart';
import 'package:codenova_app/features/admin/presentation/pages/admin_login_page.dart';
import 'package:codenova_app/features/admin/presentation/pages/admin_dashboard_page.dart';

void main() {
  group('Admin RBAC & Auth Unit Tests', () {
    test('AdminRole permissions matrix validation', () {
      final superAdmin = AdminUser(
        id: '1',
        fullName: 'Admin',
        email: 'admin@codenovatechsolutions.in',
        role: AdminRole.superAdmin,
        token: 'tok-1',
        lastLoginAt: DateTime.now(),
      );

      final placementOfficer = AdminUser(
        id: '2',
        fullName: 'Placement',
        email: 'placement@codenovatechsolutions.in',
        role: AdminRole.placementOfficer,
        token: 'tok-2',
        lastLoginAt: DateTime.now(),
      );

      final courseCoordinator = AdminUser(
        id: '3',
        fullName: 'Courses',
        email: 'courses@codenovatechsolutions.in',
        role: AdminRole.courseCoordinator,
        token: 'tok-3',
        lastLoginAt: DateTime.now(),
      );

      final businessManager = AdminUser(
        id: '4',
        fullName: 'Sales',
        email: 'business@codenovatechsolutions.in',
        role: AdminRole.businessManager,
        token: 'tok-4',
        lastLoginAt: DateTime.now(),
      );

      // Super Admin has all permissions
      expect(superAdmin.canManageCourses, isTrue);
      expect(superAdmin.canManageInternships, isTrue);
      expect(superAdmin.canViewApplications, isTrue);
      expect(superAdmin.canManageQuotes, isTrue);
      expect(superAdmin.canManageCertificates, isTrue);
      expect(superAdmin.canViewAuditLogs, isTrue);

      // Placement Officer
      expect(placementOfficer.canManageCourses, isFalse);
      expect(placementOfficer.canManageInternships, isTrue);
      expect(placementOfficer.canViewApplications, isTrue);
      expect(placementOfficer.canManageQuotes, isFalse);
      expect(placementOfficer.canManageCertificates, isTrue);
      expect(placementOfficer.canViewAuditLogs, isFalse);

      // Course Coordinator
      expect(courseCoordinator.canManageCourses, isTrue);
      expect(courseCoordinator.canManageInternships, isFalse);
      expect(courseCoordinator.canViewApplications, isFalse);
      expect(courseCoordinator.canManageQuotes, isFalse);
      expect(courseCoordinator.canManageCertificates, isTrue);
      expect(courseCoordinator.canViewAuditLogs, isFalse);

      // Business Manager
      expect(businessManager.canManageCourses, isFalse);
      expect(businessManager.canManageInternships, isFalse);
      expect(businessManager.canViewApplications, isFalse);
      expect(businessManager.canManageQuotes, isTrue);
      expect(businessManager.canManageCertificates, isFalse);
      expect(businessManager.canViewAuditLogs, isFalse);
    });

    test('AdminAuthController login, validation, and logout lifecycle', () async {
      final authRepo = MockAdminAuthRepository();
      final controller = AdminAuthController(repository: authRepo);

      expect(controller.isAuthenticated, isFalse);

      // Test invalid email
      final failResult = await controller.login(
        email: 'unauthorized@gmail.com',
        password: 'Password123',
      );
      expect(failResult, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage, isNotNull);

      // Test valid demo login
      final successResult = await controller.login(
        email: 'admin@codenovatechsolutions.in',
        password: 'Admin@12345',
      );
      expect(successResult, isTrue);
      expect(controller.isAuthenticated, isTrue);
      expect(controller.currentAdmin?.role, equals(AdminRole.superAdmin));

      // Test logout
      await controller.logout();
      expect(controller.isAuthenticated, isFalse);
      expect(controller.currentAdmin, isNull);
    });
  });

  group('AdminDashboardController Module & DPDP Audit Tests', () {
    late AdminDashboardController controller;

    setUp(() {
      controller = AdminDashboardController(repository: MockAdminDataRepository());
    });

    test('Initial loading populates catalogs, submissions, and certificates', () async {
      await controller.loadData();

      expect(controller.courses, isNotEmpty);
      expect(controller.internships, isNotEmpty);
      expect(controller.applications, isNotEmpty);
      expect(controller.quotes, isNotEmpty);
      expect(controller.enquiries, isNotEmpty);
      expect(controller.certificates, isNotEmpty);
      expect(controller.auditLogs, isNotEmpty);
    });

    test('Course management operations add, toggle availability, and delete with audit trail', () async {
      await controller.loadData();
      final initialCount = controller.courses.length;

      const newCourse = CourseModel(
        id: 'test-course-01',
        title: 'Cloud DevOps Architecture',
        subtitle: 'Docker · Kubernetes · AWS · CI/CD',
        description: 'Comprehensive cloud architecture course.',
        duration: '1 Month',
        level: CourseLevel.advanced,
        tags: ['DevOps', 'Docker', 'Kubernetes'],
        icon: Icons.cloud_rounded,
        category: 'Cloud Computing',
        isFeatured: true,
      );

      await controller.saveCourse(newCourse, 'admin@codenovatechsolutions.in');
      expect(controller.courses.length, equals(initialCount + 1));
      expect(controller.courses.first.title, equals('Cloud DevOps Architecture'));

      // Check audit log recorded
      expect(controller.auditLogs.first.action, equals('SAVE_COURSE'));

      // Toggle availability
      await controller.toggleCourseAvailability(
        'test-course-01',
        'Cloud DevOps Architecture',
        'admin@codenovatechsolutions.in',
      );
      expect(controller.auditLogs.first.action, equals('TOGGLE_COURSE_AVAILABILITY'));

      // Delete course
      await controller.deleteCourse(
        'test-course-01',
        'Cloud DevOps Architecture',
        'admin@codenovatechsolutions.in',
      );
      expect(controller.courses.length, equals(initialCount));
      expect(controller.auditLogs.first.action, equals('DELETE_COURSE'));
    });

    test('DPDP Act PII reveal action unmasks candidate and records audit log', () async {
      await controller.loadData();
      final app = controller.applications.first;

      expect(controller.isPiiRevealed(app.email), isFalse);

      await controller.revealApplicantPii(app, 'officer@codenovatechsolutions.in');

      expect(controller.isPiiRevealed(app.email), isTrue);
      final latestLog = controller.auditLogs.first;
      expect(latestLog.action, equals('REVEAL_PII_ACCESS'));
      expect(latestLog.adminEmail, equals('officer@codenovatechsolutions.in'));
      expect(latestLog.details, contains(app.fullName));
    });

    test('Certificate issuance, verification, and revocation workflow', () async {
      await controller.loadData();
      final initialCount = controller.certificates.length;

      // Issue certificate
      final cert = await controller.issueCertificate(
        recipientName: 'Siddharth Deshmukh',
        recipientEmail: 'siddharth@example.com',
        certificateType: CertificateType.courseCompletion,
        programTitle: 'Flutter & Dart Mobile App Development',
        tenure: '12 Weeks (Summer 2026)',
        mentorName: 'Aditya Patil',
        issuedBy: 'Sneha Kulkarni',
        adminEmail: 'courses@codenovatechsolutions.in',
      );

      expect(controller.certificates.length, equals(initialCount + 1));
      expect(cert.certificateCode, startsWith('CN-CERT-'));
      expect(cert.status, equals(CertificateStatus.active));
      expect(controller.auditLogs.first.action, equals('ISSUE_CERTIFICATE'));

      // Verify certificate by code
      final verified = await controller.verifyCertificateCode(cert.certificateCode);
      expect(verified, isNotNull);
      expect(verified?.recipientName, equals('Siddharth Deshmukh'));
      expect(verified?.isActive, isTrue);

      // Revoke certificate
      await controller.revokeCertificate(
        certId: cert.id,
        certificateCode: cert.certificateCode,
        recipientName: cert.recipientName,
        reason: 'Misrepresented prior academic requirements',
        adminEmail: 'admin@codenovatechsolutions.in',
      );

      final revokedCert = await controller.verifyCertificateCode(cert.certificateCode);
      expect(revokedCert?.isRevoked, isTrue);
      expect(revokedCert?.revocationReason, contains('Misrepresented'));
      expect(controller.auditLogs.first.action, equals('REVOKE_CERTIFICATE'));
    });
  });

  group('Admin UI Widget Tests', () {
    testWidgets('AdminLoginPage renders form elements and demo accounts', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminLoginPage(),
        ),
      );

      expect(find.text('CodeNova Admin Portal'), findsOneWidget);
      expect(find.text('Official Staff Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In to Dashboard'), findsOneWidget);
      expect(find.text('Super Admin'), findsOneWidget);
      expect(find.text('Placement Officer'), findsOneWidget);
      expect(find.text('Course Coordinator'), findsOneWidget);
      expect(find.text('Business Solutions'), findsOneWidget);
    });

    testWidgets('AdminDashboardPage renders sidebar navigation and metric cards', (tester) async {
      final dashboardController = AdminDashboardController(
        repository: MockAdminDataRepository(),
      );
      await dashboardController.loadData();

      // Set authenticated admin session for widget rendering
      await AdminAuthController.instance.login(
        email: 'admin@codenovatechsolutions.in',
        password: 'Admin@12345',
      );

      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: AdminDashboardPage(controller: dashboardController),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Dashboard Overview'), findsWidgets);
      expect(find.text('Administrative Command Center'), findsOneWidget);
      expect(find.text('Active Courses'), findsOneWidget);
      expect(find.text('Open Internships'), findsOneWidget);
      expect(find.text('Student Applications'), findsOneWidget);
      expect(find.text('Verified Certificates'), findsWidgets);

      await AdminAuthController.instance.logout();
    });
  });
}

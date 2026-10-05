import 'dart:async';
import '../models/admin_user_model.dart';
import 'admin_auth_repository.dart';

/// Mock implementation of [AdminAuthRepository] for development and testing.
class MockAdminAuthRepository implements AdminAuthRepository {
  MockAdminAuthRepository();

  AdminUser? _currentSession;

  static final List<AdminUser> _demoAccounts = [
    AdminUser(
      id: 'admin-01',
      fullName: 'Super Administrator',
      email: 'admin@codenovatechsolutions.in',
      role: AdminRole.superAdmin,
      token: 'mock-jwt-super-admin-token',
      lastLoginAt: DateTime.now(),
    ),
    AdminUser(
      id: 'admin-02',
      fullName: 'Vikram Joshi (Placement Officer)',
      email: 'placement@codenovatechsolutions.in',
      role: AdminRole.placementOfficer,
      token: 'mock-jwt-placement-officer-token',
      lastLoginAt: DateTime.now(),
    ),
    AdminUser(
      id: 'admin-03',
      fullName: 'Sneha Kulkarni (Course Coordinator)',
      email: 'courses@codenovatechsolutions.in',
      role: AdminRole.courseCoordinator,
      token: 'mock-jwt-course-coordinator-token',
      lastLoginAt: DateTime.now(),
    ),
    AdminUser(
      id: 'admin-04',
      fullName: 'Amit Deshmukh (Solutions Manager)',
      email: 'business@codenovatechsolutions.in',
      role: AdminRole.businessManager,
      token: 'mock-jwt-business-manager-token',
      lastLoginAt: DateTime.now(),
    ),
  ];

  @override
  Future<AdminUser> login({
    required String email,
    required String password,
    String? totpCode,
  }) async {
    final normalized = email.trim().toLowerCase();
    final matched = _demoAccounts.firstWhere(
      (acc) => acc.email.toLowerCase() == normalized,
      orElse: () {
        // Allow any valid @codenovatechsolutions.in email or fallback for testing
        if (normalized.endsWith('@codenovatechsolutions.in') || normalized.contains('admin')) {
          return AdminUser(
            id: 'admin-dynamic',
            fullName: 'Staff Administrator',
            email: email,
            role: AdminRole.superAdmin,
            token: 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
            lastLoginAt: DateTime.now(),
          );
        }
        throw Exception('Invalid administrator credentials or unauthorized domain.');
      },
    );

    if (password.length < 6) {
      throw Exception('Password must contain at least 6 characters.');
    }

    _currentSession = matched;
    return matched;
  }

  @override
  Future<void> logout() async {
    _currentSession = null;
  }

  @override
  Future<AdminUser?> getCurrentSession() async {
    return _currentSession;
  }
}

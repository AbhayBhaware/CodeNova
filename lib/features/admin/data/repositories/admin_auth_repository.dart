import '../models/admin_user_model.dart';

/// Contract for administrative authentication and session management.
abstract class AdminAuthRepository {
  /// Authenticates an administrator with credentials and optional 2FA TOTP code.
  Future<AdminUser> login({
    required String email,
    required String password,
    String? totpCode,
  });

  /// Terminates the administrative session.
  Future<void> logout();

  /// Retrieves the cached administrator session if active.
  Future<AdminUser?> getCurrentSession();
}

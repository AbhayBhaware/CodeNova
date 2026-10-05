import 'package:flutter/foundation.dart';
import '../../data/models/admin_user_model.dart';
import '../../data/repositories/admin_auth_repository.dart';
import '../../data/repositories/mock_admin_auth_repository.dart';

/// State and authentication manager for CodeNova administrative sessions.
class AdminAuthController extends ChangeNotifier {
  AdminAuthController({
    AdminAuthRepository? repository,
  }) : _repository = repository ?? MockAdminAuthRepository();

  static final AdminAuthController instance = AdminAuthController();

  final AdminAuthRepository _repository;

  AdminUser? _currentAdmin;
  AdminUser? get currentAdmin => _currentAdmin;

  bool get isAuthenticated => _currentAdmin != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Authenticates an administrator.
  Future<bool> login({
    required String email,
    required String password,
    String? totpCode,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.login(
        email: email,
        password: password,
        totpCode: totpCode,
      );
      _currentAdmin = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Terminates the current admin session.
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.logout();
    } finally {
      _currentAdmin = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

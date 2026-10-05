import 'package:flutter/foundation.dart';
import '../../../../models/service_model.dart';
import '../../data/repositories/services_repository.dart';

/// State of the IT services loading lifecycle.
enum ServicesStatus { initial, loading, success, empty, error }

/// Controller managing the state, filtering, and search of IT services.
class ServicesController extends ChangeNotifier {
  ServicesController({
    ServicesRepository? repository,
  }) : _repository = repository ?? const MockServicesRepository();

  final ServicesRepository _repository;

  ServicesStatus _status = ServicesStatus.initial;
  List<ServiceModel> _all = [];
  List<ServiceModel> _filtered = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String? _errorMessage;

  // ── Public Getters ──────────────────────────────────────────────────────────

  ServicesStatus get status => _status;
  List<ServiceModel> get services => List.unmodifiable(_filtered);
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;

  int get totalCount => _all.length;
  int get filteredCount => _filtered.length;
  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty || _selectedCategory != 'All';

  // ── Data Fetching ───────────────────────────────────────────────────────────

  Future<void> loadServices({bool forceRefresh = false}) async {
    if (_status == ServicesStatus.loading) return;

    _status = ServicesStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.fetchServices();
      _all = List.from(data);
      _applyFilters();
    } catch (e) {
      _status = ServicesStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  // ── Filtering & Search ──────────────────────────────────────────────────────

  void search(String query) {
    _searchQuery = query.trim();
    _applyFilters();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _applyFilters();
  }

  void _applyFilters() {
    Iterable<ServiceModel> result = _all;

    // Filter by Category
    if (_selectedCategory != 'All') {
      result = result.where(
        (s) => s.category.toLowerCase() == _selectedCategory.toLowerCase(),
      );
    }

    // Filter by Search Query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((s) {
        final matchesTitle = s.title.toLowerCase().contains(q);
        final matchesDesc = s.description.toLowerCase().contains(q);
        final matchesTags = s.tags.any((t) => t.toLowerCase().contains(q));
        final matchesFeatures =
            s.features.any((f) => f.toLowerCase().contains(q));
        return matchesTitle || matchesDesc || matchesTags || matchesFeatures;
      });
    }

    _filtered = result.toList();
    _status = _filtered.isEmpty ? ServicesStatus.empty : ServicesStatus.success;
    notifyListeners();
  }
}

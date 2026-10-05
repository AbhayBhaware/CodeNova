import 'package:flutter/foundation.dart';
import '../../../../core/di/repository_registry.dart';
import '../../../../models/internship_model.dart';
import '../../data/repositories/internships_repository.dart';

/// Status of the internship listing load cycle.
enum InternshipsStatus { initial, loading, success, empty, error }

/// State controller for the Internships Listing screen.
///
/// Manages:
/// - Async data loading with loading / success / empty / error states
/// - Real-time text search across title, domain, description, and skills
/// - Tech category filtering
/// - Retry on error
/// - Pull-to-refresh
class InternshipsController extends ChangeNotifier {
  InternshipsController({
    InternshipsRepository? repository,
  }) : _repository = repository ?? RepositoryRegistry.instance.internshipsRepository;

  final InternshipsRepository _repository;

  // ── State ──────────────────────────────────────────────────────
  InternshipsStatus _status = InternshipsStatus.initial;
  List<InternshipModel> _all = [];
  List<InternshipModel> _filtered = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String? _errorMessage;

  // ── Public Getters ─────────────────────────────────────────────
  InternshipsStatus get status => _status;
  List<InternshipModel> get internships => List.unmodifiable(_filtered);
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;

  int get totalCount => _all.length;
  int get filteredCount => _filtered.length;
  int get openCount => _all.where((i) => i.isOpen).length;

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty || _selectedCategory != 'All';

  // ── Data Loading ───────────────────────────────────────────────
  Future<void> loadInternships({bool forceRefresh = false}) async {
    if (_status == InternshipsStatus.loading) return;

    _status = InternshipsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.fetchInternships();
      _all = List.from(data);
      _applyFilters();
    } catch (e) {
      _status = InternshipsStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> retry() => loadInternships(forceRefresh: true);

  // ── Search ─────────────────────────────────────────────────────
  void search(String query) {
    _searchQuery = query.trim();
    _applyFilters();
  }

  // ── Category Filter ────────────────────────────────────────────
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // ── Clear Filters ──────────────────────────────────────────────
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _applyFilters();
  }

  // ── Internal ───────────────────────────────────────────────────
  void _applyFilters() {
    var result = _all;

    // Category filter
    if (_selectedCategory != 'All') {
      result = result
          .where((i) => i.techCategory == _selectedCategory)
          .toList();
    }

    // Text search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((i) {
        return i.title.toLowerCase().contains(q) ||
            i.domain.toLowerCase().contains(q) ||
            i.description.toLowerCase().contains(q) ||
            i.techCategory.toLowerCase().contains(q) ||
            i.skills.any((s) => s.toLowerCase().contains(q));
      }).toList();
    }

    _filtered = result;
    _status = _filtered.isEmpty
        ? InternshipsStatus.empty
        : InternshipsStatus.success;
    notifyListeners();
  }
}

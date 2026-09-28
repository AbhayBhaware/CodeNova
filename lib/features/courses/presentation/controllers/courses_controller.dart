import 'package:flutter/foundation.dart';
import '../../../../models/course_model.dart';
import '../../data/repositories/courses_repository.dart';

/// Presentation state for the courses catalog.
enum CoursesStatus {
  initial,
  loading,
  success,
  empty,
  error,
}

/// Controller managing courses listing state, filtering, search, and async lifecycle.
///
/// Extends [ChangeNotifier] for reactive updates and easy testability.
class CoursesController extends ChangeNotifier {
  CoursesController({CoursesRepository? repository})
      : _repository = repository ?? const MockCoursesRepository();

  final CoursesRepository _repository;

  CoursesStatus _status = CoursesStatus.initial;
  List<CourseModel> _allCourses = const [];
  List<CourseModel> _filteredCourses = const [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  CourseLevel? _selectedLevel;
  String? _errorMessage;

  // ── Getters ────────────────────────────────────────────────────────
  CoursesStatus get status => _status;
  List<CourseModel> get courses => _filteredCourses;
  List<CourseModel> get allCourses => _allCourses;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  CourseLevel? get selectedLevel => _selectedLevel;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == CoursesStatus.loading;
  bool get isSuccess => _status == CoursesStatus.success;
  bool get isEmpty => _status == CoursesStatus.empty;
  bool get isError => _status == CoursesStatus.error;

  bool get hasActiveFilters =>
      _searchQuery.trim().isNotEmpty ||
      _selectedCategory != 'All' ||
      _selectedLevel != null;

  int get totalCount => _allCourses.length;
  int get filteredCount => _filteredCourses.length;

  /// Loads courses from the repository.
  Future<void> loadCourses({
    bool forceRefresh = false,
    bool simulateFailure = false,
  }) async {
    if (_status == CoursesStatus.loading && !forceRefresh) return;

    _status = CoursesStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final repo = simulateFailure
          ? const MockCoursesRepository(
              delay: Duration(milliseconds: 100),
              simulateFailure: true,
            )
          : _repository;

      _allCourses = await repo.getCourses();
      _applyFilters();
    } catch (e) {
      _status = CoursesStatus.error;
      _errorMessage = e is CoursesException
          ? e.message
          : 'Unable to load training programmes. Please try again.';
      notifyListeners();
    }
  }

  /// Updates the search query and reapplies filters.
  void search(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _applyFilters();
  }

  /// Sets the active category filter (e.g. 'All', 'Web Development').
  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _applyFilters();
  }

  /// Sets or toggles the active learner level filter.
  void setLevel(CourseLevel? level) {
    if (_selectedLevel == level) {
      _selectedLevel = null;
    } else {
      _selectedLevel = level;
    }
    _applyFilters();
  }

  /// Clears all active search and category filters.
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedLevel = null;
    _applyFilters();
  }

  /// Retries fetching after an error.
  Future<void> retry() => loadCourses(forceRefresh: true);

  /// Internal filtering algorithm combining category, level, and multi-field text search.
  void _applyFilters() {
    if (_allCourses.isEmpty) {
      _filteredCourses = const [];
      _status = CoursesStatus.empty;
      notifyListeners();
      return;
    }

    var result = _allCourses;

    // 1. Category filter
    if (_selectedCategory != 'All') {
      result = result
          .where((c) =>
              c.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }

    // 2. Level filter
    if (_selectedLevel != null) {
      result = result.where((c) => c.level == _selectedLevel).toList();
    }

    // 3. Search query across title, subtitle, description, tags, and category
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      result = result.where((c) {
        return c.title.toLowerCase().contains(q) ||
            c.subtitle.toLowerCase().contains(q) ||
            c.description.toLowerCase().contains(q) ||
            c.category.toLowerCase().contains(q) ||
            c.tags.any((t) => t.toLowerCase().contains(q));
      }).toList();
    }

    _filteredCourses = result;
    _status =
        _filteredCourses.isEmpty ? CoursesStatus.empty : CoursesStatus.success;
    notifyListeners();
  }
}

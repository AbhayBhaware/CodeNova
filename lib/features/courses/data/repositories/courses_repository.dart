import 'dart:async';
import '../../../../core/constants/mock_data.dart';
import '../../../../models/course_model.dart';

/// Abstract contract for course data operations.
///
/// Designed to decouple the UI from the concrete data source, allowing seamless
/// transition from local mock data to backend REST / GraphQL APIs.
abstract class CoursesRepository {
  /// Fetches all available courses.
  Future<List<CourseModel>> getCourses();

  /// Fetches a single course by its [id].
  Future<CourseModel?> getCourseById(String id);
}

/// In-memory mock implementation of [CoursesRepository] using verified company data.
///
/// Supports simulated latency and optional failure injection for testing
/// error states and offline resilience.
class MockCoursesRepository implements CoursesRepository {
  const MockCoursesRepository({
    this.delay = const Duration(milliseconds: 200),
    this.simulateFailure = false,
  });

  final Duration delay;
  final bool simulateFailure;

  @override
  Future<List<CourseModel>> getCourses() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    if (simulateFailure) {
      throw CoursesException(
        'Unable to load training programmes. Please check your connection and try again.',
      );
    }

    return List<CourseModel>.unmodifiable(MockData.courses);
  }

  @override
  Future<CourseModel?> getCourseById(String id) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    if (simulateFailure) {
      throw CoursesException('Course not found or network error.');
    }

    try {
      return MockData.courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Custom domain exception for courses data operations.
class CoursesException implements Exception {
  const CoursesException(this.message);

  final String message;

  @override
  String toString() => 'CoursesException: $message';
}

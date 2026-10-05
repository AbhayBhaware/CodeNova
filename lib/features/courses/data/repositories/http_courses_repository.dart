import '../../../../core/network/api_client.dart';
import '../../../../models/course_model.dart';
import 'courses_repository.dart';

/// Production HTTP implementation of [CoursesRepository].
/// Communicates with CodeNova's backend REST API to retrieve verified course data.
class HttpCoursesRepository implements CoursesRepository {
  const HttpCoursesRepository({
    required this.apiClient,
    this.fallbackMock,
  });

  final ApiClient apiClient;
  final CoursesRepository? fallbackMock;

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      final response = await apiClient.get('/courses');
      if (response is List) {
        return response
            .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response is Map<String, dynamic> && response['data'] is List) {
        final list = response['data'] as List;
        return list
            .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw CoursesException('Unexpected response format for courses catalog.');
    } catch (e) {
      if (fallbackMock != null) {
        return fallbackMock!.getCourses();
      }
      throw CoursesException(
        e.toString().replaceFirst('ApiException: ', '').replaceFirst('Exception: ', ''),
      );
    }
  }

  @override
  Future<CourseModel?> getCourseById(String id) async {
    try {
      final response = await apiClient.get('/courses/$id');
      if (response is Map<String, dynamic>) {
        final data = response.containsKey('data') && response['data'] is Map<String, dynamic>
            ? response['data'] as Map<String, dynamic>
            : response;
        return CourseModel.fromJson(data);
      }
      return null;
    } catch (e) {
      if (fallbackMock != null) {
        return fallbackMock!.getCourseById(id);
      }
      throw CoursesException(
        e.toString().replaceFirst('ApiException: ', '').replaceFirst('Exception: ', ''),
      );
    }
  }
}

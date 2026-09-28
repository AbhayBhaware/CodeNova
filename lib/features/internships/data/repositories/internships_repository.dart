import '../../../../models/internship_model.dart';
import '../../../../core/constants/mock_data.dart';

/// Abstract interface for the internship data source.
///
/// Enables clean separation between mock and real API implementations.
/// Swap [MockInternshipsRepository] for a live HTTP implementation
/// without touching any presentation layer code.
abstract interface class InternshipsRepository {
  Future<List<InternshipModel>> fetchInternships();
}

/// Mock implementation – returns verified local data with optional
/// simulated latency and failure injection for testing.
class MockInternshipsRepository implements InternshipsRepository {
  const MockInternshipsRepository({
    this.delay = const Duration(milliseconds: 600),
    this.simulateFailure = false,
  });

  final Duration delay;
  final bool simulateFailure;

  @override
  Future<List<InternshipModel>> fetchInternships() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (simulateFailure) {
      throw Exception('Unable to load internships. Please try again.');
    }
    return List.unmodifiable(MockData.internships);
  }
}

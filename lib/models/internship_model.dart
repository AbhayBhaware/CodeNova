/// Represents an internship programme offered by CodeNova Tech Solutions.
class InternshipModel {
  const InternshipModel({
    required this.id,
    required this.title,
    required this.domain,
    required this.duration,
    required this.description,
    required this.skills,
    this.isOpen = true,
  });

  final String id;
  final String title;
  final String domain;
  final String duration;
  final String description;
  final List<String> skills;
  final bool isOpen;

  @override
  String toString() => 'InternshipModel(id: $id, title: $title)';
}

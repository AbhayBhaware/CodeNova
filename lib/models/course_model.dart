import 'package:flutter/material.dart';

/// Represents a training course offered by CodeNova Tech Solutions.
class CourseModel {
  const CourseModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.duration,
    required this.level,
    required this.tags,
    required this.icon,
    this.isFeatured = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String duration;
  final CourseLevel level;
  final List<String> tags;

  /// Material icon representing this course category.
  final IconData icon;
  final bool isFeatured;

  @override
  String toString() => 'CourseModel(id: $id, title: $title)';
}

enum CourseLevel { beginner, intermediate, advanced }

extension CourseLevelLabel on CourseLevel {
  String get label {
    switch (this) {
      case CourseLevel.beginner:
        return 'Beginner';
      case CourseLevel.intermediate:
        return 'Intermediate';
      case CourseLevel.advanced:
        return 'Advanced';
    }
  }
}

import 'package:flutter/material.dart';

/// Level of expertise required or targeted by a course.
enum CourseLevel {
  beginner,
  intermediate,
  advanced;

  static CourseLevel fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'intermediate':
        return CourseLevel.intermediate;
      case 'advanced':
        return CourseLevel.advanced;
      case 'beginner':
      default:
        return CourseLevel.beginner;
    }
  }
}

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

/// Represents a technical training program offered by CodeNova Tech Solutions.
///
/// Fully serializable and architected for seamless REST / backend API integration.
@immutable
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
    this.category = 'General',
    this.isFeatured = false,
  });

  /// Unique identifier (e.g. 'full-stack-dev').
  final String id;

  /// Display title of the course.
  final String title;

  /// High-level subtitle or tech stack summary.
  final String subtitle;

  /// Concise description of the curriculum and training focus.
  final String description;

  /// Course duration (verified as '1 Month' for intensive training programs).
  final String duration;

  /// Recommended learner level.
  final CourseLevel level;

  /// Technology tags and keywords for search & badges.
  final List<String> tags;

  /// Material icon representing this program.
  final IconData icon;

  /// Functional category for grouping and filtering.
  final String category;

  /// Whether this course is highlighted in featured sections.
  final bool isFeatured;

  /// Creates a [CourseModel] from a JSON map (for future backend API integration).
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      duration: json['duration'] as String? ?? '1 Month',
      level: CourseLevel.fromString(json['level'] as String?),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [],
      icon: _iconFromCodePoint(
        json['iconCodePoint'] as int?,
        json['iconFontFamily'] as String?,
      ),
      category: json['category'] as String? ?? 'General',
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  /// Serializes this [CourseModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'duration': duration,
      'level': level.name,
      'tags': tags,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'category': category,
      'isFeatured': isFeatured,
    };
  }

  /// Creates a copy with optionally modified fields.
  CourseModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? duration,
    CourseLevel? level,
    List<String>? tags,
    IconData? icon,
    String? category,
    bool? isFeatured,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      level: level ?? this.level,
      tags: tags ?? this.tags,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  static IconData _iconFromCodePoint(int? codePoint, String? fontFamily) {
    if (codePoint == null) return Icons.school_rounded;
    switch (codePoint) {
      case 0xe197:
        return Icons.code_rounded;
      case 0xe4af:
        return Icons.phone_android_rounded;
      case 0xe64a:
        return Icons.terminal_rounded;
      case 0xe185:
        return Icons.computer_rounded;
      case 0xe0d6:
        return Icons.bar_chart_rounded;
      case 0xe4d3:
        return Icons.psychology_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          category == other.category &&
          duration == other.duration &&
          level == other.level;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      category.hashCode ^
      duration.hashCode ^
      level.hashCode;

  @override
  String toString() => 'CourseModel(id: $id, title: $title, category: $category)';
}

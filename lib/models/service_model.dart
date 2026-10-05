import 'package:flutter/material.dart';

/// Data model representing an IT service offered by CodeNova Tech Solutions.
///
/// Designed to be fully serializable for backend API integration and
/// local mock catalog rendering.
@immutable
class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tags,
    this.category = 'General',
    this.features = const [],
    this.deliverables = const [],
  });

  /// Unique identifier (e.g. 'web-development').
  final String id;

  /// Service headline name.
  final String title;

  /// High-level overview of the service offering.
  final String description;

  /// Visual icon associated with the technical domain.
  final IconData icon;

  /// Technologies, frameworks, and skill tags.
  final List<String> tags;

  /// Categorical classification (e.g. 'Web', 'Mobile', 'AI & Cloud', 'Enterprise').
  final String category;

  /// Key technical features and implementation capabilities.
  final List<String> features;

  /// Tangible business outcomes and project deliverables.
  final List<String> deliverables;

  ServiceModel copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    List<String>? tags,
    String? category,
    List<String>? features,
    List<String>? deliverables,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      features: features ?? this.features,
      deliverables: deliverables ?? this.deliverables,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'iconCodePoint': icon.codePoint,
        'tags': tags,
        'category': category,
        'features': features,
        'deliverables': deliverables,
      };

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: _iconFromCodePoint(json['iconCodePoint'] as int?),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      category: json['category'] as String? ?? 'General',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      deliverables: (json['deliverables'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  static IconData _iconFromCodePoint(int? codePoint) {
    if (codePoint == null) return Icons.business_center_rounded;
    switch (codePoint) {
      case 0xe6b0:
        return Icons.web_rounded;
      case 0xe4af:
        return Icons.phone_android_rounded;
      case 0xe4d3:
        return Icons.psychology_rounded;
      case 0xe17f:
        return Icons.cloud_done_rounded;
      case 0xe566:
        return Icons.security_rounded;
      case 0xe197:
        return Icons.code_rounded;
      default:
        // ignore: non_const_argument_for_const_parameter
        return IconData(codePoint, fontFamily: 'MaterialIcons');
    }
  }

  @override
  String toString() => 'ServiceModel(id: $id, title: $title, category: $category)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.icon == icon &&
        other.category == category;
  }

  @override
  int get hashCode => Object.hash(id, title, description, icon, category);
}

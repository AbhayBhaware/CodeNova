import 'package:flutter/material.dart';

/// Data model representing an IT service offered by CodeNova Tech Solutions.
class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tags,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<String> tags;

  @override
  String toString() => 'ServiceModel(id: $id, title: $title)';
}

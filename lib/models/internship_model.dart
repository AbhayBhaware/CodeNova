import 'package:flutter/material.dart';

/// Application status of an internship position.
enum InternshipStatus {
  open,
  closed,
  comingSoon;

  static InternshipStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'closed':
        return InternshipStatus.closed;
      case 'comingsoon':
      case 'coming_soon':
        return InternshipStatus.comingSoon;
      case 'open':
      default:
        return InternshipStatus.open;
    }
  }
}

extension InternshipStatusLabel on InternshipStatus {
  String get label {
    switch (this) {
      case InternshipStatus.open:
        return 'Now Hiring';
      case InternshipStatus.closed:
        return 'Closed';
      case InternshipStatus.comingSoon:
        return 'Coming Soon';
    }
  }

  Color get color {
    switch (this) {
      case InternshipStatus.open:
        return const Color(0xFF10B981); // success green
      case InternshipStatus.closed:
        return const Color(0xFF94A3B8); // neutral muted
      case InternshipStatus.comingSoon:
        return const Color(0xFFF59E0B); // warning amber
    }
  }

  IconData get icon {
    switch (this) {
      case InternshipStatus.open:
        return Icons.check_circle_rounded;
      case InternshipStatus.closed:
        return Icons.cancel_rounded;
      case InternshipStatus.comingSoon:
        return Icons.schedule_rounded;
    }
  }
}

/// Work mode for an internship (verified only – do not invent).
enum InternshipMode {
  offline,
  online,
  hybrid;

  static InternshipMode? fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'offline':
        return InternshipMode.offline;
      case 'online':
        return InternshipMode.online;
      case 'hybrid':
        return InternshipMode.hybrid;
      default:
        return null; // null = unspecified, not invented
    }
  }

  String get label {
    switch (this) {
      case InternshipMode.offline:
        return 'Offline';
      case InternshipMode.online:
        return 'Online';
      case InternshipMode.hybrid:
        return 'Hybrid';
    }
  }

  IconData get icon {
    switch (this) {
      case InternshipMode.offline:
        return Icons.location_on_rounded;
      case InternshipMode.online:
        return Icons.laptop_rounded;
      case InternshipMode.hybrid:
        return Icons.sync_alt_rounded;
    }
  }
}

/// Represents an internship programme offered by CodeNova Tech Solutions.
///
/// Fully serializable and architectured for REST / backend API integration.
/// Fields that cannot be verified from the official website are left nullable
/// to maintain the zero-hallucination policy.
@immutable
class InternshipModel {
  const InternshipModel({
    required this.id,
    required this.title,
    required this.domain,
    required this.duration,
    required this.description,
    this.skills = const [],
    this.status = InternshipStatus.open,
    this.mode,       // nullable – only set when officially verified
    this.icon = Icons.work_rounded,
    this.techCategory = 'General',
    this.responsibilities = const [],
    this.learningOutcomes = const [],
  });

  /// Unique identifier (e.g. 'web-dev-internship').
  final String id;

  /// Display title of the internship programme.
  final String title;

  /// Domain or functional area (e.g. 'Full Stack & Frontend Systems').
  final String domain;

  /// Verified duration string (e.g. '3 Months', '3 – 6 Months').
  final String duration;

  /// Programme description verified from the official website.
  final String description;

  /// Technology skills emphasized in the internship.
  final List<String> skills;

  /// Current application status of the position.
  final InternshipStatus status;

  /// Work mode (offline / online / hybrid) – nullable if not officially stated.
  final InternshipMode? mode;

  /// Material icon representing the internship domain.
  final IconData icon;

  /// Tech category for filtering (e.g. 'Web Development', 'Data & AI').
  final String techCategory;

  /// Key responsibilities for the intern (if provided).
  final List<String> responsibilities;

  /// Verified or approved learning outcomes from the internship programme.
  final List<String> learningOutcomes;

  /// Convenience getter for backwards compatibility.
  bool get isOpen => status == InternshipStatus.open;

  // ── Serialization ────────────────────────────────────────────────────────

  factory InternshipModel.fromJson(Map<String, dynamic> json) {
    return InternshipModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      description: json['description'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      status: InternshipStatus.fromString(json['status'] as String?),
      mode: InternshipMode.fromString(json['mode'] as String?),
      icon: _iconFromCodePoint(json['iconCodePoint'] as int?),
      techCategory: json['techCategory'] as String? ?? 'General',
      responsibilities: (json['responsibilities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      learningOutcomes: (json['learningOutcomes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'domain': domain,
        'duration': duration,
        'description': description,
        'skills': skills,
        'status': status.name,
        'mode': mode?.name,
        'iconCodePoint': icon.codePoint,
        'techCategory': techCategory,
        'responsibilities': responsibilities,
        'learningOutcomes': learningOutcomes,
      };

  InternshipModel copyWith({
    String? id,
    String? title,
    String? domain,
    String? duration,
    String? description,
    List<String>? skills,
    InternshipStatus? status,
    InternshipMode? mode,
    IconData? icon,
    String? techCategory,
    List<String>? responsibilities,
    List<String>? learningOutcomes,
  }) {
    return InternshipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      domain: domain ?? this.domain,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      skills: skills ?? this.skills,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      icon: icon ?? this.icon,
      techCategory: techCategory ?? this.techCategory,
      responsibilities: responsibilities ?? this.responsibilities,
      learningOutcomes: learningOutcomes ?? this.learningOutcomes,
    );
  }

  static IconData _iconFromCodePoint(int? codePoint) {
    if (codePoint == null) return Icons.work_rounded;
    switch (codePoint) {
      case 0xe59c:
        return Icons.web_rounded;
      case 0xe4af:
        return Icons.phone_android_rounded;
      case 0xe4d3:
        return Icons.psychology_rounded;
      case 0xe64a:
        return Icons.terminal_rounded;
      case 0xe197:
        return Icons.code_rounded;
      default:
        return Icons.work_rounded;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InternshipModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status &&
          techCategory == other.techCategory;

  @override
  int get hashCode => id.hashCode ^ status.hashCode ^ techCategory.hashCode;

  @override
  String toString() =>
      'InternshipModel(id: $id, title: $title, status: ${status.name})';
}

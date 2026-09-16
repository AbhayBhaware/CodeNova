import 'package:flutter/material.dart';
import '../../models/models.dart';

/// Static mock data for CodeNova Tech Solutions.
///
/// Replace each list with a repository/API call when the backend is ready.
/// All field values reflect actual company offerings from the website.
abstract final class MockData {
  MockData._();

  // ── Courses ──────────────────────────────────────────────────────────────
  static const List<CourseModel> courses = [
    CourseModel(
      id: 'full-stack-web',
      title: 'Full Stack Web Development',
      subtitle: 'HTML · CSS · JavaScript · React · Node.js',
      description:
          'A comprehensive end-to-end programme covering front-end and back-end '
          'development. Build real-world projects from scratch and get job-ready '
          'with portfolio-grade work.',
      duration: '4 Months',
      level: CourseLevel.beginner,
      tags: ['Web', 'React', 'Node.js', 'MongoDB'],
      icon: Icons.web_rounded,
      isFeatured: true,
    ),
    CourseModel(
      id: 'python-programming',
      title: 'Python Programming',
      subtitle: 'Core Python · OOP · File Handling · Libraries',
      description:
          'Master Python from basics to advanced. Ideal for beginners and '
          'professionals looking to upskill. Covers automation, scripting, and '
          'real-world problem solving.',
      duration: '2 Months',
      level: CourseLevel.beginner,
      tags: ['Python', 'Automation', 'Scripting'],
      icon: Icons.terminal_rounded,
      isFeatured: true,
    ),
    CourseModel(
      id: 'ai-ml',
      title: 'AI & Machine Learning',
      subtitle: 'Python · Scikit-Learn · TensorFlow · NLP',
      description:
          'Dive into the world of Artificial Intelligence and Machine Learning. '
          'Learn supervised, unsupervised learning, neural networks, and deploy '
          'your own ML models.',
      duration: '3 Months',
      level: CourseLevel.intermediate,
      tags: ['AI', 'ML', 'TensorFlow', 'Python'],
      icon: Icons.psychology_rounded,
      isFeatured: true,
    ),
    CourseModel(
      id: 'data-science',
      title: 'Data Science',
      subtitle: 'Python · Pandas · NumPy · Visualization · Statistics',
      description:
          'Learn to collect, clean, analyse, and visualise data. Develop skills '
          'in statistical thinking and data storytelling that modern companies '
          'need.',
      duration: '3 Months',
      level: CourseLevel.intermediate,
      tags: ['Data', 'Pandas', 'Visualization'],
      icon: Icons.bar_chart_rounded,
      isFeatured: false,
    ),
    CourseModel(
      id: 'java-core',
      title: 'Core Java',
      subtitle: 'Java SE · OOP · Collections · JDBC',
      description:
          'Build a solid foundation in Java – the language powering enterprise '
          'software worldwide. Covers OOP principles, collections, exception '
          'handling, and database connectivity.',
      duration: '2 Months',
      level: CourseLevel.beginner,
      tags: ['Java', 'OOP', 'JDBC'],
      icon: Icons.code_rounded,
      isFeatured: false,
    ),
    CourseModel(
      id: 'flutter-mobile',
      title: 'Flutter Mobile Development',
      subtitle: 'Dart · Flutter · Firebase · REST APIs',
      description:
          'Build beautiful cross-platform apps for Android and iOS using Flutter '
          'and Dart. Covers state management, Firebase integration, and '
          'publishing to app stores.',
      duration: '3 Months',
      level: CourseLevel.intermediate,
      tags: ['Flutter', 'Dart', 'Firebase'],
      icon: Icons.phone_android_rounded,
      isFeatured: true,
    ),
  ];

  // ── Internships ───────────────────────────────────────────────────────────
  static const List<InternshipModel> internships = [
    InternshipModel(
      id: 'web-dev-intern',
      title: 'Web Development Intern',
      domain: 'Full Stack Development',
      duration: '1 – 3 Months',
      description:
          'Work on live client projects under the guidance of senior developers. '
          'Gain hands-on experience with React, Node.js, and REST API integration.',
      skills: ['HTML/CSS', 'JavaScript', 'React', 'Node.js'],
      isOpen: true,
    ),
    InternshipModel(
      id: 'python-intern',
      title: 'Python Developer Intern',
      domain: 'Backend Development',
      duration: '1 – 2 Months',
      description:
          'Contribute to Python-based automation and backend projects. Ideal for '
          'students who have completed or are undergoing Python training.',
      skills: ['Python', 'Django/Flask', 'REST APIs', 'SQL'],
      isOpen: true,
    ),
    InternshipModel(
      id: 'data-analyst-intern',
      title: 'Data Analyst Intern',
      domain: 'Data Science & Analytics',
      duration: '2 – 3 Months',
      description:
          'Analyse real business data, create dashboards, and present insights. '
          'Work with Python, Excel, and visualization tools.',
      skills: ['Python', 'Pandas', 'Power BI / Tableau', 'Excel'],
      isOpen: true,
    ),
    InternshipModel(
      id: 'ai-research-intern',
      title: 'AI/ML Research Intern',
      domain: 'Artificial Intelligence',
      duration: '2 – 3 Months',
      description:
          'Explore ML models, contribute to research, and implement AI solutions '
          'for real-world problem statements under expert mentorship.',
      skills: ['Python', 'TensorFlow', 'Scikit-Learn', 'NLP'],
      isOpen: false,
    ),
  ];

  // ── Why Choose CodeNova ──────────────────────────────────────────────────
  static const List<FeatureItem> whyChooseUs = [
    FeatureItem(
      icon: Icons.workspace_premium_rounded,
      title: 'Industry-Focused Curriculum',
      description: 'Courses designed with real-world employer requirements in mind.',
    ),
    FeatureItem(
      icon: Icons.people_rounded,
      title: 'Expert Mentors',
      description: 'Learn from working professionals with years of industry experience.',
    ),
    FeatureItem(
      icon: Icons.laptop_mac_rounded,
      title: 'Hands-On Projects',
      description: 'Build a portfolio of real projects employers actually notice.',
    ),
    FeatureItem(
      icon: Icons.card_membership_rounded,
      title: 'Certification',
      description: 'Receive a recognised certificate upon successful programme completion.',
    ),
    FeatureItem(
      icon: Icons.manage_search_rounded,
      title: 'Placement Assistance',
      description: 'Dedicated support with resume building, mock interviews, and job referrals.',
    ),
    FeatureItem(
      icon: Icons.location_on_rounded,
      title: 'Located in Pune',
      description: 'Conveniently located in Maharashtra with both online & offline batches.',
    ),
  ];
}

/// Data model for "Why Choose Us" feature items.
class FeatureItem {
  const FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

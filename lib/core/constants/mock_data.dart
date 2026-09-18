import 'package:flutter/material.dart';
import '../../models/models.dart';

/// Central static mock data for CodeNova Tech Solutions.
///
/// All course names, descriptions, durations, service categories, and company
/// benefits strictly match the verified content from the official website
/// (https://www.codenovatechsolutions.in/).
abstract final class MockData {
  MockData._();

  // ── Verified Programs / Courses ──────────────────────────────
  static const List<CourseModel> courses = [
    CourseModel(
      id: 'full-stack-dev',
      title: 'Full Stack Development',
      subtitle: 'HTML · CSS · JavaScript · React · Modern Web',
      description:
          'Master HTML, CSS, JavaScript, React, and modern web technologies '
          'to build stunning responsive websites.',
      duration: '1 Month',
      level: CourseLevel.beginner,
      tags: ['HTML/CSS', 'JavaScript', 'React', 'Full Stack'],
      icon: Icons.code_rounded,
      isFeatured: true,
    ),
    CourseModel(
      id: 'android-dev',
      title: 'Android Development',
      subtitle: 'Java · Kotlin · Android Studio · Modern Architecture',
      description:
          'Learn Java and Kotlin to build powerful, user-friendly Android '
          'applications from scratch.',
      duration: '1 Month',
      level: CourseLevel.beginner,
      tags: ['Java', 'Kotlin', 'Android', 'Mobile'],
      icon: Icons.phone_android_rounded,
      isFeatured: true,
    ),
    CourseModel(
      id: 'python-programming',
      title: 'Python Programming',
      subtitle: 'Core Python · OOP · Scripting · Hands-on Projects',
      description:
          'Learn Python from scratch and build real-world applications with '
          'hands-on projects.',
      duration: '1 Month',
      level: CourseLevel.beginner,
      tags: ['Python', 'OOP', 'Automation', 'Projects'],
      icon: Icons.terminal_rounded,
      isFeatured: true,
    ),
    CourseModel(
      id: 'java-programming',
      title: 'Java Programming',
      subtitle: 'Core Java · OOP · Data Structures · Enterprise',
      description:
          'Learn Java from basics to advanced concepts with hands-on projects '
          'and real-world scenarios.',
      duration: '1 Month',
      level: CourseLevel.beginner,
      tags: ['Java', 'OOP', 'Enterprise', 'Backend'],
      icon: Icons.computer_rounded,
      isFeatured: false,
    ),
    CourseModel(
      id: 'data-science',
      title: 'Data Science',
      subtitle: 'Python · R · Machine Learning · Data Analysis',
      description:
          'Learn Python, R, and machine learning to analyze and interpret '
          'data for actionable insights.',
      duration: '1 Month',
      level: CourseLevel.intermediate,
      tags: ['Python', 'R', 'Machine Learning', 'Data Analysis'],
      icon: Icons.bar_chart_rounded,
      isFeatured: true,
    ),
    CourseModel(
      id: 'artificial-intelligence',
      title: 'Artificial Intelligence',
      subtitle: 'AI Fundamentals · Neural Networks · Intelligent Systems',
      description:
          'Learn AI fundamentals, neural networks, and build intelligent '
          'applications with modern tools.',
      duration: '1 Month',
      level: CourseLevel.intermediate,
      tags: ['AI', 'Neural Networks', 'Intelligent Systems'],
      icon: Icons.psychology_rounded,
      isFeatured: true,
    ),
  ];

  // ── Verified Internship Programmes ───────────────────────────
  static const List<InternshipModel> internships = [
    InternshipModel(
      id: 'software-internship-program',
      title: 'Internship Program',
      domain: 'Live Client Projects & Software Engineering',
      duration: '3 – 6 Months',
      description:
          'Get real-world experience working on live projects with guidance '
          'from industry mentors. Build portfolio-grade applications and earn '
          'a verified industry-recognized certification.',
      skills: ['Live Projects', 'Mentorship', 'Agile/Git', 'Full Stack'],
      isOpen: true,
    ),
    InternshipModel(
      id: 'web-dev-internship',
      title: 'Web Development Internship',
      domain: 'Full Stack & Frontend Systems',
      duration: '3 Months',
      description:
          'Contribute to production-grade responsive web applications and '
          'APIs using modern frameworks under direct senior developer guidance.',
      skills: ['React', 'JavaScript', 'REST APIs', 'Responsive Design'],
      isOpen: true,
    ),
    InternshipModel(
      id: 'python-ai-internship',
      title: 'Python & AI Internship',
      domain: 'Data Analytics & Intelligent Applications',
      duration: '3 Months',
      description:
          'Apply machine learning and Python programming on real-world datasets '
          'and software automation pipelines.',
      skills: ['Python', 'Data Science', 'Machine Learning', 'APIs'],
      isOpen: true,
    ),
  ];

  // ── Verified IT Services (From CodeNova Website) ─────────────
  static const List<ServiceModel> services = [
    ServiceModel(
      id: 'web-development',
      title: 'Web Application Development',
      description:
          'Modern, scalable web applications and digital platforms tailored '
          'to business needs with responsive architecture.',
      icon: Icons.web_rounded,
      tags: ['React', 'Full Stack', 'Web Portals'],
    ),
    ServiceModel(
      id: 'mobile-development',
      title: 'Mobile App Development',
      description:
          'Native Android and cross-platform mobile applications engineered '
          'for performance and seamless user engagement.',
      icon: Icons.phone_android_rounded,
      tags: ['Android', 'Flutter', 'Cross-Platform'],
    ),
    ServiceModel(
      id: 'ai-solutions',
      title: 'AI & Machine Learning',
      description:
          'Intelligent software solutions, neural network integrations, and '
          'data-driven automation to transform workflows.',
      icon: Icons.psychology_rounded,
      tags: ['AI Models', 'Automation', 'ML Insights'],
    ),
    ServiceModel(
      id: 'cloud-technologies',
      title: 'Cloud Technologies',
      description:
          'Reliable cloud architecture, deployment management, and infrastructure '
          'solutions built for scale.',
      icon: Icons.cloud_done_rounded,
      tags: ['Cloud Deploy', 'Scalability', 'DevOps'],
    ),
    ServiceModel(
      id: 'cybersecurity',
      title: 'Cybersecurity Solutions',
      description:
          'Robust security practices, vulnerability mitigation, and secure '
          'digital system implementations.',
      icon: Icons.security_rounded,
      tags: ['Security', 'Secure Code', 'Protection'],
    ),
    ServiceModel(
      id: 'custom-software',
      title: 'Custom Software Development',
      description:
          'Bespoke digital software engineered to address unique business '
          'processes and digital transformation goals.',
      icon: Icons.code_rounded,
      tags: ['Custom Systems', 'Enterprise', 'Scalable'],
    ),
  ];

  // ── Verified Company Claims ("Why Choose CodeNova") ──────────
  // Exactly matching array $f from the official website
  static const List<FeatureItem> whyChooseUs = [
    FeatureItem(
      icon: Icons.school_rounded,
      title: 'Expert Mentors',
      description:
          'Learn from industry professionals with years of real-world '
          'experience in top tech companies.',
    ),
    FeatureItem(
      icon: Icons.terminal_rounded,
      title: 'Hands-on Projects',
      description:
          'Build real-world applications and gain practical experience that '
          'employers value.',
    ),
    FeatureItem(
      icon: Icons.verified_rounded,
      title: 'Verified Certificates',
      description:
          'Earn industry-recognized certifications that boost your credibility '
          'and career prospects.',
    ),
  ];
}

/// Data model for "Why Choose Us" verified benefit items.
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

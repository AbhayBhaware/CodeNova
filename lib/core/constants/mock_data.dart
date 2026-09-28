import 'package:flutter/material.dart';
import '../../models/models.dart';

/// Central static mock data for CodeNova Tech Solutions.
///
/// All course names, descriptions, durations, service categories, and company
/// benefits strictly match the verified content from the official website
/// (https://www.codenovatechsolutions.in/).
abstract final class MockData {
  MockData._();

  // ── Verified Course Categories ──────────────────────────────
  static const List<String> courseCategories = [
    'All',
    'Web Development',
    'Mobile Development',
    'Programming',
    'Data & AI',
  ];

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
      category: 'Web Development',
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
      category: 'Mobile Development',
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
      category: 'Programming',
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
      category: 'Programming',
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
      category: 'Data & AI',
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
      category: 'Data & AI',
      tags: ['AI', 'Neural Networks', 'Intelligent Systems'],
      icon: Icons.psychology_rounded,
      isFeatured: true,
    ),
  ];

  // ── Internship Tech Filter Categories ────────────────────────
  static const List<String> internshipCategories = [
    'All',
    'Full Stack',
    'Mobile',
    'Data & AI',
  ];

  // ── Verified Internship Programmes ───────────────────────────
  // All data verified from https://www.codenovatechsolutions.in/
  static const List<InternshipModel> internships = [
    InternshipModel(
      id: 'software-internship-program',
      title: 'Software Engineering Internship',
      domain: 'Live Client Projects & Software Engineering',
      duration: '3 – 6 Months',
      description:
          'Get real-world experience working on live projects with guidance '
          'from industry mentors. Build portfolio-grade applications and earn '
          'a verified industry-recognized certificate.',
      skills: ['Live Projects', 'Mentorship', 'Agile/Git', 'Full Stack'],
      status: InternshipStatus.open,
      mode: InternshipMode.hybrid,
      icon: Icons.code_rounded,
      techCategory: 'Full Stack',
      responsibilities: [
        'Collaborate on live client deliverables following Agile and Scrum workflows',
        'Write clean, testable, and maintainable software code using version control (Git)',
        'Participate in sprint reviews, mentor feedback sessions, and architecture discussions',
        'Troubleshoot, debug, and document technical solutions across the stack',
      ],
      learningOutcomes: [
        'End-to-end SDLC and production deployment experience on real client deliverables',
        'Proficiency in professional Git workflows, pull requests, and peer code reviews',
        'Portfolio-grade software system demonstrating full-stack problem solving',
        'Industry-recognized, verifiable CodeNova Tech Solutions Internship Certificate',
      ],
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
      status: InternshipStatus.open,
      mode: InternshipMode.online,
      icon: Icons.web_rounded,
      techCategory: 'Full Stack',
      responsibilities: [
        'Develop responsive, mobile-first web pages using React and modern CSS',
        'Consume and test REST APIs, ensuring robust error handling and loading states',
        'Optimize web page load speeds, accessibility, and cross-browser consistency',
        'Work closely with design leads to implement pixel-perfect user interfaces',
      ],
      learningOutcomes: [
        'Modern frontend engineering with component-driven architecture',
        'Real-world REST API consumption, asynchronous state handling, and data binding',
        'Hands-on understanding of web deployment and production build optimization',
        'Verifiable CodeNova Web Development Internship Certificate',
      ],
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
      status: InternshipStatus.open,
      mode: InternshipMode.hybrid,
      icon: Icons.psychology_rounded,
      techCategory: 'Data & AI',
      responsibilities: [
        'Clean, preprocess, and visualize structured datasets for machine learning',
        'Implement and evaluate machine learning models for classification and regression',
        'Build Python scripts to automate repetitive workflows and data extraction',
        'Document model accuracy metrics, performance benchmarks, and insights',
      ],
      learningOutcomes: [
        'Applied machine learning pipeline development with Python',
        'Practical automation script engineering and dataset processing techniques',
        'Actionable business intelligence reporting and model performance evaluation',
        'Verifiable CodeNova Python & AI Internship Certificate',
      ],
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

  // ── Verified Core Company Values (From website about section) ─
  static const List<CompanyValueItem> companyValues = [
    CompanyValueItem(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Innovation',
      description:
          'Developing cutting-edge software solutions and empowering learners with modern technologies.',
    ),
    CompanyValueItem(
      icon: Icons.verified_user_outlined,
      title: 'Integrity',
      description:
          'Maintaining absolute transparency in training outcomes, certifications, and enterprise deliverables.',
    ),
    CompanyValueItem(
      icon: Icons.auto_stories_outlined,
      title: 'Continuous Learning',
      description:
          'Adapting our courses and architectures to the rapid evolutions of the global technology landscape.',
    ),
    CompanyValueItem(
      icon: Icons.sentiment_very_satisfied_outlined,
      title: 'Customer Satisfaction',
      description:
          'Creating long-term collaborative value for our students, clients, and industry partners.',
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

/// Data model for verified company core values.
class CompanyValueItem {
  const CompanyValueItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}


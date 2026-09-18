/// App-wide string constants for CodeNova Tech Solutions.
/// Single source of truth – update here to propagate everywhere.
/// All company descriptions, headlines, and statistics are verified from
/// the official CodeNova Tech Solutions website (codenovatechsolutions.in).
abstract final class AppStrings {
  AppStrings._();

  // ── Company Information ──────────────────────────────────────
  static const String appName = 'CodeNova Tech Solutions';
  static const String appTagline = 'Innovating Today, Empowering Tomorrow.';
  static const String appDescription =
      'Industry-focused IT training, internships, and verified certifications designed to make you job-ready.';

  // ── Contact Details ──────────────────────────────────────────
  static const String phone = '+91 8087480411';
  static const String phoneDialable = '+918087480411';
  static const String email = 'contact@codenovatechsolutions.in';
  static const String website = 'https://www.codenovatechsolutions.in';
  static const String address = 'Pune, Maharashtra, India';

  // ── Mission & Vision ─────────────────────────────────────────
  static const String mission =
      'To deliver high-quality software solutions, provide practical learning opportunities, '
      'and foster innovation that creates lasting value for our clients, learners, and communities.';
  static const String vision =
      'To build a trusted technology company that empowers businesses with innovative digital '
      'solutions and helps shape the next generation of skilled IT professionals.';

  // ── Navigation Labels ────────────────────────────────────────
  static const String navHome = 'Home';
  static const String navAbout = 'About';
  static const String navExplore = 'Explore'; // courses browse hub
  static const String navCourses = 'Courses'; // deep-link
  static const String navInternships = 'Internships';
  static const String navServices = 'Services';
  static const String navProfile = 'Profile';
  static const String navContact = 'Contact';

  // ── Routes ───────────────────────────────────────────────────
  static const String routeHome = '/';
  static const String routeAbout = '/about';
  static const String routeExplore = '/explore';
  static const String routeCourses = '/courses';
  static const String routeCourseDetail = '/courses/:id';
  static const String routeInternships = '/internships';
  static const String routeServices = '/services';
  static const String routeProfile = '/profile';
  static const String routeContact = '/contact';

  // ── Hero Section (Verified from website) ─────────────────────
  static const String heroEyebrow = '🚀 IT Training & Internship Platform';
  static const String heroTitle = 'Where Code Meets Innovation';
  static const String heroSubtitle =
      'Industry-focused IT training, internships, and verified certifications designed to make you job-ready.';
  static const String heroCtaPrimary = 'Explore Programs';
  static const String heroCtaSecondary = 'Explore Internships';

  // ── Verified Stats (From website bundle) ──────────────────────
  static const String statsStudentsValue = '5,000+';
  static const String statsStudentsLabel = 'Students Trained';
  static const String statsPartnersValue = '50+';
  static const String statsPartnersLabel = 'Industry Partners';

  // ── Section Titles ───────────────────────────────────────────
  static const String featuredCoursesTitle = 'Our Programs';
  static const String featuredCoursesSubtitle =
      'Comprehensive training paths designed for your success in tech.';

  static const String internshipSectionTitle = 'Internship Program';
  static const String internshipSectionSubtitle =
      'Get real-world experience working on live projects with guidance from industry mentors.';

  static const String servicesSectionTitle = 'IT Services & Solutions';
  static const String servicesSectionSubtitle =
      'Scalable, modern digital solutions engineered for businesses and startups.';

  static const String whyChooseTitle = 'Why Choose CodeNova';
  static const String whyChooseSubtitle =
      'Everything you need to build practical, in-demand technical capabilities.';

  static const String testimonialsTitle = 'Student Experiences';
  static const String testimonialsSubtitle =
      'Genuine student feedback and verification records.';

  static const String ctaBannerTitle = 'Ready to launch your tech career?';
  static const String ctaBannerSubtitle =
      'Connect with CodeNova Tech Solutions in Pune for industry training, internships, and digital enterprise services.';
  static const String ctaBannerButton = 'Get in Touch';
}

/// App-wide string constants for CodeNova Tech Solutions.
/// Single source of truth – update here to propagate everywhere.
abstract final class AppStrings {
  // ── Company ─────────────────────────────────────────────────
  static const String appName = 'CodeNova Tech Solutions';
  static const String appTagline = 'Learn. Build. Succeed.';
  static const String appDescription =
      'Industry-focused IT training and internships to make you job-ready.';

  // ── Contact ─────────────────────────────────────────────────
  static const String phone = '+91 8087480411';
  static const String phoneDialable = '+918087480411';
  static const String email = 'info@codenovatechsolutions.in';
  static const String website = 'https://www.codenovatechsolutions.in';
  static const String address = 'Pune, Maharashtra, India';

  // ── Navigation Labels ────────────────────────────────────────
  static const String navHome = 'Home';
  static const String navAbout = 'About';
  static const String navExplore = 'Explore';      // courses browse hub
  static const String navCourses = 'Courses';      // kept for deep-links
  static const String navInternships = 'Internships';
  static const String navServices = 'Services';
  static const String navProfile = 'Profile';      // user / contact hub
  static const String navContact = 'Contact';      // kept for deep-links

  // ── Routes ──────────────────────────────────────────────────
  static const String routeHome = '/';
  static const String routeAbout = '/about';
  static const String routeExplore = '/explore';         // nav tab
  static const String routeCourses = '/courses';         // deep-link
  static const String routeCourseDetail = '/courses/:id';
  static const String routeInternships = '/internships';
  static const String routeServices = '/services';
  static const String routeProfile = '/profile';         // nav tab
  static const String routeContact = '/contact';         // deep-link

  // ── Section Titles ──────────────────────────────────────────
  static const String heroTitle = 'Shape Your Tech Career';
  static const String heroSubtitle =
      'Industry-focused IT training, internships & certifications in Pune.';
  static const String heroCtaPrimary = 'Explore Courses';
  static const String heroCtaSecondary = 'Apply for Internship';

  static const String featuredCoursesTitle = 'Featured Courses';
  static const String featuredCoursesSubtitle =
      'Hands-on programs designed for real-world industry demand.';

  static const String whyChooseTitle = 'Why CodeNova?';

  static const String testimonialsTitle = 'Student Success Stories';

  static const String ctaBannerTitle = 'Ready to Start Your Journey?';
  static const String ctaBannerSubtitle =
      'Join hundreds of students who launched their careers with CodeNova.';
  static const String ctaBannerButton = 'Get in Touch';
}

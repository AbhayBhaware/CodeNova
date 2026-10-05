import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/course_model.dart';
import '../controllers/admin_auth_controller.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Administrative view for managing course offerings, curriculum, and publication state.
class AdminCoursesView extends StatelessWidget {
  const AdminCoursesView({
    super.key,
    required this.controller,
  });

  final AdminDashboardController controller;

  void _showCourseDialog(BuildContext context, [CourseModel? existingCourse]) {
    final titleController = TextEditingController(text: existingCourse?.title ?? '');
    final subtitleController = TextEditingController(
      text: existingCourse?.subtitle ?? 'HTML · CSS · JavaScript · Modern Architecture',
    );
    final descriptionController = TextEditingController(
      text: existingCourse?.description ?? 'Intensive mentored training program with practical projects.',
    );
    final durationController = TextEditingController(text: existingCourse?.duration ?? '1 Month');
    final categoryController = TextEditingController(text: existingCourse?.category ?? 'Software Engineering');
    final tagsController = TextEditingController(
      text: existingCourse?.tags.join(', ') ?? 'Full Stack, Mentorship, Live Code',
    );
    CourseLevel level = existingCourse?.level ?? CourseLevel.beginner;
    bool isFeatured = existingCourse?.isFeatured ?? true;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(existingCourse == null ? 'Add New Course' : 'Edit Course'),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Course Title *',
                          hintText: 'e.g. Flutter & Dart Mobile App Development',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: subtitleController,
                        decoration: const InputDecoration(
                          labelText: 'Subtitle / Key Stack *',
                          hintText: 'e.g. Dart · Flutter · Riverpod · REST API',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: durationController,
                              decoration: const InputDecoration(labelText: 'Duration *'),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceMD),
                          Expanded(
                            child: DropdownButtonFormField<CourseLevel>(
                              initialValue: level,
                              decoration: const InputDecoration(labelText: 'Level *'),
                              items: CourseLevel.values
                                  .map((l) => DropdownMenuItem(value: l, child: Text(l.label)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setDialogState(() => level = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Category *',
                          hintText: 'e.g. Mobile Development',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: tagsController,
                        decoration: const InputDecoration(
                          labelText: 'Tags (comma separated)',
                          hintText: 'Dart, Flutter, Mobile, REST',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Course Curriculum Description *',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      SwitchListTile(
                        title: const Text('Featured / Active for Enrolment'),
                        subtitle: const Text('Highlight on mobile app home screen'),
                        value: isFeatured,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) => setDialogState(() => isFeatured = val),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;

                    final adminEmail =
                        AdminAuthController.instance.currentAdmin?.email ?? 'admin@codenovatechsolutions.in';
                    final courseId = existingCourse?.id ??
                        'course-${DateTime.now().millisecondsSinceEpoch}';

                    final course = CourseModel(
                      id: courseId,
                      title: titleController.text.trim(),
                      subtitle: subtitleController.text.trim(),
                      description: descriptionController.text.trim(),
                      duration: durationController.text.trim(),
                      level: level,
                      tags: tagsController.text
                          .split(',')
                          .map((s) => s.trim())
                          .where((s) => s.isNotEmpty)
                          .toList(),
                      icon: existingCourse?.icon ?? Icons.school_rounded,
                      category: categoryController.text.trim(),
                      isFeatured: isFeatured,
                    );

                    Navigator.of(ctx).pop();
                    await controller.saveCourse(course, adminEmail);
                  },
                  child: Text(existingCourse == null ? 'Create Course' : 'Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final adminEmail = AdminAuthController.instance.currentAdmin?.email ?? 'admin@codenovatechsolutions.in';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Catalog Management',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage curriculum, syllabus tags, and enrolment promotion live on the mobile app.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showCourseDialog(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Course'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          if (controller.courses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spaceXXL),
                child: Text('No courses found in catalog.'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.courses.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spaceMD),
              itemBuilder: (context, index) {
                final course = controller.courses[index];
                return AppCard(
                  padding: const EdgeInsets.all(AppDimensions.spaceMD),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceMD),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                        ),
                        child: Icon(course.icon, color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: AppDimensions.spaceMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    course.title,
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (course.isFeatured ? AppColors.success : AppColors.neutral400)
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                                  ),
                                  child: Text(
                                    course.isFeatured ? 'Featured / Active' : 'Standard Offering',
                                    style: TextStyle(
                                      color: course.isFeatured ? AppColors.success : AppColors.neutral400,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              course.subtitle,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              children: [
                                Chip(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  label: Text(course.duration, style: const TextStyle(fontSize: 11)),
                                  avatar: const Icon(Icons.schedule_rounded, size: 12),
                                ),
                                Chip(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  label: Text(course.level.label, style: const TextStyle(fontSize: 11)),
                                  avatar: const Icon(Icons.trending_up_rounded, size: 12),
                                ),
                                Chip(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  label: Text(course.category, style: const TextStyle(fontSize: 11)),
                                  avatar: const Icon(Icons.category_rounded, size: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              course.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceMD),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            tooltip: 'Edit Course',
                            onPressed: () => _showCourseDialog(context, course),
                          ),
                          Switch(
                            value: course.isFeatured,
                            activeThumbColor: AppColors.success,
                            onChanged: (val) => controller.toggleCourseAvailability(
                              course.id,
                              course.title,
                              adminEmail,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                            tooltip: 'Delete Course',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Course'),
                                  content: Text('Are you sure you want to delete "${course.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await controller.deleteCourse(course.id, course.title, adminEmail);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

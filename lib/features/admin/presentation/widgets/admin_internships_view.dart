import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../models/internship_model.dart';
import '../controllers/admin_auth_controller.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Administrative view for managing internship postings, requirements, and hiring status.
class AdminInternshipsView extends StatelessWidget {
  const AdminInternshipsView({
    super.key,
    required this.controller,
  });

  final AdminDashboardController controller;

  void _showInternshipDialog(BuildContext context, [InternshipModel? existing]) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final domainController = TextEditingController(
      text: existing?.domain ?? 'Live Client Projects & Software Engineering',
    );
    final durationController = TextEditingController(text: existing?.duration ?? '3 – 6 Months');
    final descriptionController = TextEditingController(
      text: existing?.description ??
          'Get real-world experience working on live projects with guidance from industry mentors.',
    );
    final skillsController = TextEditingController(
      text: existing?.skills.join(', ') ?? 'Live Projects, Mentorship, Agile/Git, Full Stack',
    );
    final responsibilitiesController = TextEditingController(
      text: existing?.responsibilities.join('\n') ??
          'Collaborate on live client deliverables following Agile and Scrum workflows\nWrite clean, testable, and maintainable software code\nParticipate in sprint reviews and mentor feedback sessions',
    );
    final outcomesController = TextEditingController(
      text: existing?.learningOutcomes.join('\n') ??
          'End-to-end SDLC and production deployment experience\nProficiency in professional Git workflows\nVerifiable CodeNova Internship Certificate',
    );
    InternshipStatus status = existing?.status ?? InternshipStatus.open;
    InternshipMode? mode = existing?.mode ?? InternshipMode.hybrid;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(existing == null ? 'Post New Internship' : 'Edit Internship'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Internship Title *',
                          hintText: 'e.g. Software Engineering Internship',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: domainController,
                        decoration: const InputDecoration(
                          labelText: 'Domain Focus *',
                          hintText: 'e.g. Full Stack & Frontend Systems',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<InternshipStatus>(
                              initialValue: status,
                              decoration: const InputDecoration(labelText: 'Hiring Status *'),
                              items: InternshipStatus.values
                                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setDialogState(() => status = val);
                              },
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceMD),
                          Expanded(
                            child: DropdownButtonFormField<InternshipMode?>(
                              initialValue: mode,
                              decoration: const InputDecoration(labelText: 'Delivery Mode'),
                              items: [
                                const DropdownMenuItem(value: null, child: Text('Unspecified')),
                                ...InternshipMode.values.map(
                                  (m) => DropdownMenuItem(value: m, child: Text(m.label)),
                                ),
                              ],
                              onChanged: (val) => setDialogState(() => mode = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: durationController,
                              decoration: const InputDecoration(labelText: 'Tenure / Duration *'),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceMD),
                          Expanded(
                            child: TextField(
                              controller: skillsController,
                              decoration: const InputDecoration(
                                labelText: 'Key Skills (comma separated)',
                                hintText: 'React, Node, Git, SQL',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: descriptionController,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Program Description *'),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: responsibilitiesController,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Key Responsibilities (1 per line)'),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: outcomesController,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Learning Outcomes (1 per line)'),
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
                    final internId = existing?.id ?? 'intern-${DateTime.now().millisecondsSinceEpoch}';

                    final internship = InternshipModel(
                      id: internId,
                      title: titleController.text.trim(),
                      domain: domainController.text.trim(),
                      duration: durationController.text.trim(),
                      description: descriptionController.text.trim(),
                      skills: skillsController.text
                          .split(',')
                          .map((s) => s.trim())
                          .where((s) => s.isNotEmpty)
                          .toList(),
                      status: status,
                      mode: mode,
                      responsibilities: responsibilitiesController.text
                          .split('\n')
                          .map((s) => s.trim())
                          .where((s) => s.isNotEmpty)
                          .toList(),
                      learningOutcomes: outcomesController.text
                          .split('\n')
                          .map((s) => s.trim())
                          .where((s) => s.isNotEmpty)
                          .toList(),
                    );

                    Navigator.of(ctx).pop();
                    await controller.saveInternship(internship, adminEmail);
                  },
                  child: Text(existing == null ? 'Publish Posting' : 'Save Changes'),
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
                    'Internship Openings Management',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage seasonal internship drives, hiring statuses, and candidate qualifications.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showInternshipDialog(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Post Internship'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          if (controller.internships.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spaceXXL),
                child: Text('No internships currently posted.'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.internships.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spaceMD),
              itemBuilder: (context, index) {
                final item = controller.internships[index];

                return AppCard(
                  padding: const EdgeInsets.all(AppDimensions.spaceMD),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceMD),
                        decoration: BoxDecoration(
                          color: item.status.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                        ),
                        child: Icon(item.icon, color: item.status.color, size: 28),
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
                                    item.title,
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: item.status.color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                                  ),
                                  child: Text(
                                    item.status.label,
                                    style: TextStyle(
                                      color: item.status.color,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.domain,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              children: [
                                Chip(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  label: Text(item.duration, style: const TextStyle(fontSize: 11)),
                                  avatar: const Icon(Icons.schedule_rounded, size: 12),
                                ),
                                if (item.mode != null)
                                  Chip(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    label: Text(item.mode!.label, style: const TextStyle(fontSize: 11)),
                                    avatar: Icon(item.mode!.icon, size: 12),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.description,
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
                            tooltip: 'Edit Posting',
                            onPressed: () => _showInternshipDialog(context, item),
                          ),
                          PopupMenuButton<InternshipStatus>(
                            icon: const Icon(Icons.more_vert_rounded, size: 20),
                            tooltip: 'Update Status',
                            onSelected: (newStatus) {
                              controller.updateInternshipStatus(
                                item.id,
                                item.title,
                                newStatus,
                                adminEmail,
                              );
                            },
                            itemBuilder: (ctx) => InternshipStatus.values
                                .map(
                                  (s) => PopupMenuItem(
                                    value: s,
                                    child: Text('Mark as ${s.label}'),
                                  ),
                                )
                                .toList(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                            tooltip: 'Delete Posting',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Internship'),
                                  content: Text('Are you sure you want to delete "${item.title}"?'),
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
                                await controller.deleteInternship(item.id, item.title, adminEmail);
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

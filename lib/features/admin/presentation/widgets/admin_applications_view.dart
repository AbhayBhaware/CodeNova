import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../models/internship_application_model.dart';
import '../controllers/admin_auth_controller.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Administrative view for reviewing student internship applications with DPDP PII protection.
class AdminApplicationsView extends StatefulWidget {
  const AdminApplicationsView({
    super.key,
    required this.controller,
  });

  final AdminDashboardController controller;

  @override
  State<AdminApplicationsView> createState() => _AdminApplicationsViewState();
}

class _AdminApplicationsViewState extends State<AdminApplicationsView> {
  String _selectedTechFilter = 'All';

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return '*****';
    final user = parts[0];
    final domain = parts[1];
    if (user.length <= 2) return '**@$domain';
    return '${user[0]}***${user[user.length - 1]}@$domain';
  }

  String _maskPhone(String phone) {
    final clean = phone.replaceAll(RegExp(r'\D'), '');
    if (clean.length < 6) return '******';
    return '+91 ${clean.substring(0, 2)}****${clean.substring(clean.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final adminEmail = AdminAuthController.instance.currentAdmin?.email ?? 'admin@codenovatechsolutions.in';

    final applications = widget.controller.applications.where((app) {
      if (_selectedTechFilter == 'All') return true;
      return app.preferredTechnology.toLowerCase().contains(_selectedTechFilter.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & DPDP Notice
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student Applications Pipeline',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Review applicants, verify qualifications, and manage admission offers.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.privacy_tip_outlined, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 6),
                    Text(
                      'PII Masked by Default',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Filters
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All Tech'),
                selected: _selectedTechFilter == 'All',
                onSelected: (val) => setState(() => _selectedTechFilter = 'All'),
              ),
              FilterChip(
                label: const Text('Flutter'),
                selected: _selectedTechFilter == 'Flutter',
                onSelected: (val) => setState(() => _selectedTechFilter = 'Flutter'),
              ),
              FilterChip(
                label: const Text('Python / AI'),
                selected: _selectedTechFilter == 'Python',
                onSelected: (val) => setState(() => _selectedTechFilter = 'Python'),
              ),
              FilterChip(
                label: const Text('Full Stack Web'),
                selected: _selectedTechFilter == 'Web',
                onSelected: (val) => setState(() => _selectedTechFilter = 'Web'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Candidate List
          if (applications.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spaceXXL),
                child: Text('No applications match the selected criteria.'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: applications.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spaceMD),
              itemBuilder: (context, index) {
                final InternshipApplicationModel app = applications[index];
                final isRevealed = widget.controller.isPiiRevealed(app.email);

                return AppCard(
                  padding: const EdgeInsets.all(AppDimensions.spaceMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                            child: Text(
                              app.fullName.characters.first.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
                            ),
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
                                        app.fullName,
                                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                                      ),
                                      child: Text(
                                        app.internshipTitle ?? 'General Internship',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${app.collegeName} · ${app.courseBranch}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // Candidate Statement / Message
                      if (app.additionalMessage != null && app.additionalMessage!.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppDimensions.spaceMD),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.backgroundCard : AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                          ),
                          child: Text(
                            '"${app.additionalMessage}"',
                            style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMD),
                      ],

                      // PII Section with Reveal Action
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceMD),
                        decoration: BoxDecoration(
                          color: (isRevealed ? AppColors.warning : AppColors.primary).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                          border: Border.all(
                            color: (isRevealed ? AppColors.warning : AppColors.primary).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.email_outlined, size: 14, color: AppColors.textMuted),
                                      const SizedBox(width: 6),
                                      Text(
                                        isRevealed ? app.email : _maskEmail(app.email),
                                        style: TextStyle(
                                          fontFamily: isRevealed ? null : 'Courier',
                                          fontWeight: isRevealed ? FontWeight.bold : FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone_outlined, size: 14, color: AppColors.textMuted),
                                      const SizedBox(width: 6),
                                      Text(
                                        isRevealed ? app.phone : _maskPhone(app.phone),
                                        style: TextStyle(
                                          fontFamily: isRevealed ? null : 'Courier',
                                          fontWeight: isRevealed ? FontWeight.bold : FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (!isRevealed)
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  side: const BorderSide(color: AppColors.primary),
                                ),
                                icon: const Icon(Icons.visibility_outlined, size: 14),
                                label: const Text('Reveal PII (Logged)', style: TextStyle(fontSize: 11)),
                                onPressed: () async {
                                  await widget.controller.revealApplicantPii(app, adminEmail);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('DPDP Audit Logged: Staff access to candidate PII recorded.'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock_open_rounded, size: 12, color: AppColors.warning),
                                    SizedBox(width: 4),
                                    Text(
                                      'Access Logged',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.warning,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceSM),

                      // Resume Link
                      if (app.resumeUrl != null && app.resumeUrl!.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.open_in_new_rounded, size: 14),
                            label: const Text('Open Resume / Portfolio Link', style: TextStyle(fontSize: 12)),
                            onPressed: () => AppUtils.launchWebUrl(app.resumeUrl!),
                          ),
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

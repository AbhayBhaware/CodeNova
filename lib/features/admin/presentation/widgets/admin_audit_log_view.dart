import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Administrative view for inspecting immutable DPDP Act audit logs.
class AdminAuditLogView extends StatelessWidget {
  const AdminAuditLogView({
    super.key,
    required this.controller,
  });

  final AdminDashboardController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                    'DPDP Act Audit Trail Ledger',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Immutable compliance log tracking all staff PII access, credential issuance, and catalog modifications.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user_rounded, size: 14, color: AppColors.success),
                    SizedBox(width: 6),
                    Text(
                      'DPDP 2023 Compliant',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          if (controller.auditLogs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spaceXXL),
                child: Text('No audit events recorded.'),
              ),
            )
          else
            AppCard(
              padding: EdgeInsets.zero,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.auditLogs.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final log = controller.auditLogs[index];
                  final isPii = log.action.contains('PII');

                  return ListTile(
                    dense: true,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isPii ? AppColors.warning : AppColors.primary).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                      ),
                      child: Icon(
                        isPii ? Icons.privacy_tip_rounded : Icons.history_rounded,
                        color: isPii ? AppColors.warning : AppColors.primary,
                        size: 18,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          log.action,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isPii ? AppColors.warning : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '· ${log.resourceType}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(log.details, style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          'Staff: ${log.adminEmail}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '${log.timestamp.year}-${log.timestamp.month.toString().padLeft(2, '0')}-${log.timestamp.day.toString().padLeft(2, '0')} ${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

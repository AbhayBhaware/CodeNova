import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/certificate_model.dart';
import '../controllers/admin_auth_controller.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Administrative view for issuing, inspecting, verifying, and revoking digital certificates.
class AdminCertificatesView extends StatefulWidget {
  const AdminCertificatesView({
    super.key,
    required this.controller,
  });

  final AdminDashboardController controller;

  @override
  State<AdminCertificatesView> createState() => _AdminCertificatesViewState();
}

class _AdminCertificatesViewState extends State<AdminCertificatesView> {
  final _verifySearchController = TextEditingController();
  CertificateModel? _verifiedResult;
  bool _hasSearched = false;

  @override
  void dispose() {
    _verifySearchController.dispose();
    super.dispose();
  }

  void _showIssueDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final programController = TextEditingController(text: 'Flutter & Dart Mobile App Development');
    final tenureController = TextEditingController(text: '12 Weeks (Summer 2026)');
    final mentorController = TextEditingController(text: 'Senior Solutions Architect');
    CertificateType type = CertificateType.courseCompletion;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Issue New Verified Certificate'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<CertificateType>(
                        initialValue: type,
                        decoration: const InputDecoration(labelText: 'Certificate Type *'),
                        items: CertificateType.values
                            .map((t) => DropdownMenuItem(value: t, child: Text(t.displayName)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              type = val;
                              if (val == CertificateType.internshipExperience) {
                                programController.text = 'Flutter Developer Intern';
                                tenureController.text = '3 Months (June – August 2026)';
                              } else {
                                programController.text = 'Flutter & Dart Mobile App Development';
                                tenureController.text = '12 Weeks (Summer 2026)';
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Recipient Full Name *',
                          hintText: 'e.g. Aditya Sharma',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Recipient Email *',
                          hintText: 'student@example.com',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      TextField(
                        controller: programController,
                        decoration: const InputDecoration(
                          labelText: 'Program / Role Title *',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: tenureController,
                              decoration: const InputDecoration(labelText: 'Tenure / Duration *'),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceMD),
                          Expanded(
                            child: TextField(
                              controller: mentorController,
                              decoration: const InputDecoration(labelText: 'Assigned Mentor / Lead *'),
                            ),
                          ),
                        ],
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
                    if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty) return;

                    final auth = AdminAuthController.instance.currentAdmin;
                    final adminEmail = auth?.email ?? 'admin@codenovatechsolutions.in';
                    final adminName = auth?.fullName ?? 'Staff Administrator';

                    Navigator.of(ctx).pop();

                    final cert = await widget.controller.issueCertificate(
                      recipientName: nameController.text.trim(),
                      recipientEmail: emailController.text.trim(),
                      certificateType: type,
                      programTitle: programController.text.trim(),
                      tenure: tenureController.text.trim(),
                      mentorName: mentorController.text.trim(),
                      issuedBy: adminName,
                      adminEmail: adminEmail,
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Issued certificate ${cert.certificateCode} successfully.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: const Text('Generate & Issue'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRevokeDialog(BuildContext context, CertificateModel cert) {
    final reasonController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke Certificate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to revoke credential ${cert.certificateCode} for ${cert.recipientName}?'),
            const SizedBox(height: AppDimensions.spaceMD),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Revocation Reason *',
                hintText: 'e.g. Incomplete coursework / Administrative policy',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) return;
              final adminEmail =
                  AdminAuthController.instance.currentAdmin?.email ?? 'admin@codenovatechsolutions.in';

              Navigator.of(ctx).pop();
              await widget.controller.revokeCertificate(
                certId: cert.id,
                certificateCode: cert.certificateCode,
                recipientName: cert.recipientName,
                reason: reasonController.text.trim(),
                adminEmail: adminEmail,
              );
            },
            child: const Text('Revoke Credential'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verified Certificates Ledger',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Issue verifiable certificates with cryptographic hashes and online verification codes.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showIssueDialog(context),
                icon: const Icon(Icons.verified_rounded, size: 18),
                label: const Text('Issue Certificate'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Certificate Verification Tool (Search box)
          AppCard(
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.search_rounded, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Live Credential Verification Lookup',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _verifySearchController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Certificate ID (e.g. CN-CERT-2026-FLUTTER-8921)',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onSubmitted: (val) async {
                          final res = await widget.controller.verifyCertificateCode(val);
                          setState(() {
                            _verifiedResult = res;
                            _hasSearched = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMD),
                    ElevatedButton(
                      onPressed: () async {
                        final res = await widget.controller.verifyCertificateCode(
                          _verifySearchController.text,
                        );
                        setState(() {
                          _verifiedResult = res;
                          _hasSearched = true;
                        });
                      },
                      child: const Text('Verify Code'),
                    ),
                  ],
                ),
                if (_hasSearched) ...[
                  const SizedBox(height: AppDimensions.spaceMD),
                  if (_verifiedResult != null)
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceMD),
                      decoration: BoxDecoration(
                        color: (_verifiedResult!.isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                        border: Border.all(
                          color: (_verifiedResult!.isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _verifiedResult!.isActive ? Icons.verified_rounded : Icons.cancel_rounded,
                            color: _verifiedResult!.isActive ? AppColors.success : AppColors.error,
                            size: 28,
                          ),
                          const SizedBox(width: AppDimensions.spaceMD),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _verifiedResult!.isActive
                                      ? 'VALID & AUTHENTIC CREDENTIAL'
                                      : 'REVOKED CREDENTIAL: ${_verifiedResult!.revocationReason ?? "Administrative"}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _verifiedResult!.isActive ? AppColors.success : AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_verifiedResult!.recipientName} · ${_verifiedResult!.programTitle}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Tenure: ${_verifiedResult!.tenure} · Issued: ${_verifiedResult!.issuedDate.year}-${_verifiedResult!.issuedDate.month.toString().padLeft(2, '0')}-${_verifiedResult!.issuedDate.day.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceMD),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                          SizedBox(width: 8),
                          Text('No credential matching this verification code was found in the official registry.'),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // Ledger Table / List
          Text(
            'All Issued Certificates (${widget.controller.certificates.length})',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.controller.certificates.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spaceMD),
            itemBuilder: (context, index) {
              final cert = widget.controller.certificates[index];

              return AppCard(
                padding: const EdgeInsets.all(AppDimensions.spaceMD),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceMD),
                      decoration: BoxDecoration(
                        color: (cert.isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                      ),
                      child: Icon(
                        cert.isActive ? Icons.verified_rounded : Icons.block_rounded,
                        color: cert.isActive ? AppColors.success : AppColors.error,
                        size: 28,
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
                                  cert.certificateCode,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Courier',
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (cert.isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                                ),
                                child: Text(
                                  cert.status.displayName,
                                  style: TextStyle(
                                    color: cert.isActive ? AppColors.success : AppColors.error,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Recipient: ${cert.recipientName} (${cert.recipientEmail})',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${cert.programTitle} · ${cert.tenure}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'SHA-256 Fingerprint: ${cert.verificationHash.substring(0, 24)}...',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Courier',
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                            ),
                          ),
                          if (cert.isRevoked && cert.revocationReason != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Revocation Reason: ${cert.revocationReason}',
                                style: const TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (cert.isActive)
                      IconButton(
                        icon: const Icon(Icons.block_rounded, size: 20, color: AppColors.error),
                        tooltip: 'Revoke Certificate',
                        onPressed: () => _showRevokeDialog(context, cert),
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

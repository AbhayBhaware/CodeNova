/// Immutable record of an administrative action for DPDP Act auditing.
class AuditLogModel {
  const AuditLogModel({
    required this.id,
    required this.adminEmail,
    required this.action,
    required this.resourceType,
    required this.resourceId,
    required this.timestamp,
    required this.details,
  });

  final String id;
  final String adminEmail;
  final String action;
  final String resourceType;
  final String resourceId;
  final DateTime timestamp;
  final String details;

  Map<String, dynamic> toJson() => {
        'id': id,
        'adminEmail': adminEmail,
        'action': action,
        'resourceType': resourceType,
        'resourceId': resourceId,
        'timestamp': timestamp.toIso8601String(),
        'details': details,
      };

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'] as String,
      adminEmail: json['adminEmail'] as String,
      action: json['action'] as String,
      resourceType: json['resourceType'] as String,
      resourceId: json['resourceId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      details: json['details'] as String,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility helpers used across the application.
abstract final class AppUtils {
  AppUtils._();

  /// Launches the device dialler with [phone].
  static Future<void> launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Opens the default email client with [email] pre-filled.
  static Future<void> launchEmail(String email, {String subject = ''}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: subject.isNotEmpty ? {'subject': subject} : null,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Opens [url] in an in-app browser or external browser.
  static Future<void> launchWebUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Shows a generic [SnackBar] with [message].
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
  }
}

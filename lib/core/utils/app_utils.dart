import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility helpers used across the application.
abstract final class AppUtils {
  AppUtils._();

  /// Launches the device dialler with [phone].
  /// If launch fails or is unsupported (e.g. tablet/desktop), copies [phone] to clipboard
  /// and displays a feedback SnackBar if [context] is provided.
  static Future<bool> launchPhone(String phone, {BuildContext? context}) async {
    try {
      final uri = Uri(scheme: 'tel', path: phone);
      if (await canLaunchUrl(uri)) {
        final success = await launchUrl(uri);
        if (success) return true;
      }
    } catch (_) {
      // Fall through to fallback
    }

    if (context != null && context.mounted) {
      await copyToClipboard(
        context,
        phone,
        successMessage: 'Phone number copied to clipboard: $phone',
      );
    }
    return false;
  }

  /// Opens the default email client with [email] pre-filled.
  /// If launch fails, copies [email] to clipboard and displays a feedback SnackBar.
  static Future<bool> launchEmail(
    String email, {
    String subject = '',
    BuildContext? context,
  }) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: subject.isNotEmpty ? {'subject': subject} : null,
      );
      if (await canLaunchUrl(uri)) {
        final success = await launchUrl(uri);
        if (success) return true;
      }
    } catch (_) {
      // Fall through to fallback
    }

    if (context != null && context.mounted) {
      await copyToClipboard(
        context,
        email,
        successMessage: 'Email address copied to clipboard: $email',
      );
    }
    return false;
  }

  /// Opens [url] in an in-app browser or external browser.
  static Future<bool> launchWebUrl(String url, {BuildContext? context}) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (success) return true;
      }
    } catch (_) {
      // Fall through to fallback
    }

    if (context != null && context.mounted) {
      showSnackBar(context, 'Unable to open link: $url', isError: true);
    }
    return false;
  }

  /// Opens Google Maps with a search query or verified address.
  /// If launch fails, copies [address] to clipboard and displays a feedback SnackBar.
  static Future<bool> launchMaps(String address, {BuildContext? context}) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);
      final webUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');
      if (await canLaunchUrl(webUri)) {
        final success = await launchUrl(webUri, mode: LaunchMode.externalApplication);
        if (success) return true;
      }
    } catch (_) {
      // Fall through to fallback
    }

    if (context != null && context.mounted) {
      await copyToClipboard(
        context,
        address,
        successMessage: 'Office location copied to clipboard: $address',
      );
    }
    return false;
  }

  /// Copies [text] to the device clipboard and shows a confirmation SnackBar.
  static Future<void> copyToClipboard(
    BuildContext context,
    String text, {
    String? successMessage,
  }) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        showSnackBar(
          context,
          successMessage ?? 'Copied to clipboard',
          isError: false,
        );
      }
    } catch (_) {
      if (context.mounted) {
        showSnackBar(context, 'Failed to copy to clipboard', isError: true);
      }
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

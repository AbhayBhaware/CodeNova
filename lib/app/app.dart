import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import '../core/constants/constants.dart';

/// Root application widget.
///
/// Wires together [GoRouter] navigation and the centralized [AppTheme].
/// Defaults to the clean, restrained Light Theme with Dark Theme support.
class CodeNovaApp extends StatelessWidget {
  const CodeNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // ── Identity ─────────────────────────────────────────────
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // ── Theme Configuration ──────────────────────────────────
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,

      // ── Routing ──────────────────────────────────────────────
      routerConfig: appRouter,
    );
  }
}

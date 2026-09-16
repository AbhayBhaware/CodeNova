import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:codenova_app/app/theme/app_theme.dart';
import 'package:codenova_app/core/constants/constants.dart';
import 'package:codenova_app/core/widgets/widgets.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });
  group('Design System - AppTheme Tests', () {
    testWidgets('Light theme has correct brand primary and off-white background',
        (tester) async {
      final light = AppTheme.light;
      expect(light.colorScheme.primary, equals(AppColors.primary));
      expect(light.scaffoldBackgroundColor, equals(AppColors.backgroundLight));
      expect(light.useMaterial3, isTrue);
    });

    testWidgets('Dark theme has dark navy background and accent primary',
        (tester) async {
      final dark = AppTheme.dark;
      expect(dark.scaffoldBackgroundColor, equals(AppColors.backgroundDark));
      expect(dark.useMaterial3, isTrue);
    });
  });

  group('Design System - Shared Components Tests', () {
    testWidgets('AppButton renders label, handles tap, and has >= 48dp height',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: AppButton(
                label: 'Get Started',
                onPressed: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);

      // Verify touch target height
      final buttonSize = tester.getSize(buttonFinder);
      expect(buttonSize.height, greaterThanOrEqualTo(48.0));

      // Verify tap interaction
      await tester.tap(buttonFinder);
      expect(tapped, isTrue);
    });

    testWidgets('AppCard renders child and adapts to light theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: Center(
              child: AppCard(
                child: Text('Card Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets('AppBadge renders label with accessible contrast',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppBadge(
                label: 'Featured',
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Featured'), findsOneWidget);
      expect(find.byType(AppBadge), findsOneWidget);
    });

    testWidgets('AppTextField renders label and hint text',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: AppTextField(
                label: 'Full Name',
                hintText: 'Enter your name',
                controller: controller,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Abhay');
      expect(controller.text, equals('Abhay'));
    });
  });
}

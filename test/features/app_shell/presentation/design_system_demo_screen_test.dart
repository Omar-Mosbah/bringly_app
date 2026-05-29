import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../app_shell/presentation/app_shell_test_helpers.dart';

void main() {
  Future<void> pumpDemoScreen(WidgetTester tester) async {
    final router = buildFakeAppRouter();
    router.go('/design-system');
    await tester.pumpWidget(
      CupertinoApp.router(
        theme: BringlyTheme.lightTheme(),
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Design System Demo screen', () {
    testWidgets('screen renders without exception', (tester) async {
      await pumpDemoScreen(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders Buttons section', (tester) async {
      await pumpDemoScreen(tester);
      await tester.scrollUntilVisible(find.text('Buttons'), 200);
      expect(find.text('Buttons'), findsOneWidget);
    });

    testWidgets('renders Cards section', (tester) async {
      await pumpDemoScreen(tester);
      await tester.scrollUntilVisible(find.text('Cards'), 200);
      expect(find.text('Cards'), findsOneWidget);
    });

    testWidgets('renders Status section', (tester) async {
      await pumpDemoScreen(tester);
      // Status section is above the fold — no scroll needed in test viewport.
      // If not visible, drag the first vertical Scrollable downward.
      if (find.text('Status').evaluate().isEmpty) {
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -400));
        await tester.pumpAndSettle();
      }
      expect(find.text('Status'), findsOneWidget);
    });

    testWidgets('demo data does not contain real sensitive information', (
      tester,
    ) async {
      await pumpDemoScreen(tester);
      // Scroll through the whole screen to render all content
      await tester.scrollUntilVisible(
        find.text('Design System'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      const forbidden = [
        'supabase',
        'stripe',
        'passport',
        'ssn',
        'credit card',
        'secret',
        'private key',
        'token',
        'verified',
        'completed identity',
        'receipt',
        'delivery confirmation',
      ];
      for (final word in forbidden) {
        expect(
          find.textContaining(word, findRichText: true),
          findsNothing,
          reason: 'Demo screen must not expose "$word"',
        );
      }
    });
  });
}

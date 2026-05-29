import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/features/app_shell/presentation/design_system_demo_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_shell_test_helpers.dart';

/// Privacy and trade-dress regression test:
/// Scans all visible demo content for forbidden sensitive or
/// third-party brand wording.
void main() {
  Future<void> pumpDemo(WidgetTester tester) async {
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

  group('Demo content safety', () {
    const sensitiveWords = [
      'supabase',
      'stripe',
      'passport',
      'ssn',
      'social security',
      'credit card',
      'bank account',
      'private key',
      'api key',
      'secret',
      'token',
      'password',
      'visa',
      'mastercard',
      'paypal',
      'verified',
      'completed identity',
      'receipt',
      'delivery confirmation',
      'passport',
      'nyc',
      'lax',
      'lhr',
      'cdg',
    ];

    testWidgets(
      'no sensitive or third-party brand words in first-screen content',
      (tester) async {
        await pumpDemo(tester);
        for (final word in sensitiveWords) {
          expect(
            find.textContaining(word, findRichText: true),
            findsNothing,
            reason: 'Demo screen must not expose "$word"',
          );
        }
      },
    );

    test('demo data avoids real-looking personal and travel data', () {
      final demoText = <String>[
        for (final traveler in DemoData.travelerCards) ...[
          traveler.displayName,
          traveler.route,
          traveler.travelDate,
        ],
        for (final request in DemoData.requestCards) ...[
          request.itemDescription,
          request.destination,
          request.reward,
        ],
        for (final line in DemoData.priceBreakdown.lineItems) ...[
          line.label,
          line.amount,
        ],
        DemoData.priceBreakdown.total,
      ].join(' ').toLowerCase();

      for (final word in sensitiveWords) {
        expect(
          demoText,
          isNot(contains(word)),
          reason: 'Demo data must not include "$word"',
        );
      }
    });

    testWidgets('demo renders without backend error or exception', (
      tester,
    ) async {
      await pumpDemo(tester);
      expect(tester.takeException(), isNull);
    });
  });
}

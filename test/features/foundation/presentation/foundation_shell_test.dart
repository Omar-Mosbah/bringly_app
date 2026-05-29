import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../app_shell/presentation/app_shell_test_helpers.dart';

void main() {
  testWidgets(
    'all foundation destinations are reachable via developer routes',
    (tester) async {
      // Build a router with initial location at the foundation startup route.
      final router = buildFakeAppRouter();
      router.go('/');

      await tester.pumpWidget(
        CupertinoApp.router(
          theme: BringlyTheme.lightTheme(),
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Startup'), findsWidgets);
      await tester.tap(find.text('Configuration').last);
      await tester.pumpAndSettle();
      expect(find.text('Configuration is valid'), findsOneWidget);

      await tester.tap(find.text('Connectivity').last);
      await tester.pumpAndSettle();
      expect(find.text('Connectivity check ready'), findsOneWidget);

      await tester.tap(find.text('UI States').last);
      await tester.pumpAndSettle();
      expect(find.text('Loading state'), findsOneWidget);
    },
  );
}

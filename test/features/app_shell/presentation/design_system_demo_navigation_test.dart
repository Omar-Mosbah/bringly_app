import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../app_shell/presentation/app_shell_test_helpers.dart';

void main() {
  group('Design System Demo navigation', () {
    testWidgets('demo route is reachable from /design-system', (tester) async {
      final router = buildFakeAppRouter();
      await tester.pumpWidget(
        CupertinoApp.router(
          theme: BringlyTheme.lightTheme(),
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      router.go('/design-system');
      await tester.pumpAndSettle();

      expect(find.text('Design System'), findsOneWidget);
    });

    testWidgets('design system route is not a primary tab', (tester) async {
      final router = buildFakeAppRouter();
      await tester.pumpWidget(
        CupertinoApp.router(
          theme: BringlyTheme.lightTheme(),
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      // The tab bar at /shopper should not contain a 'Design System' tab item
      final tabBar = tester.widget<CupertinoTabBar>(
        find.byKey(const Key('marketplace_tab_bar')),
      );
      final tabLabels = tabBar.items
          .map((item) => (item.label ?? '').toLowerCase())
          .toList();
      expect(tabLabels.contains('design system'), isFalse);
    });

    testWidgets('Profile screen has demo entry button', (tester) async {
      final router = buildFakeAppRouter();
      router.go('/profile');
      await tester.pumpWidget(
        CupertinoApp.router(
          theme: BringlyTheme.lightTheme(),
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('design_system_demo_button')),
        findsOneWidget,
      );
    });

    testWidgets('demo close button returns to Profile shell tab', (
      tester,
    ) async {
      final router = buildFakeAppRouter();
      router.go('/design-system');
      await tester.pumpWidget(
        CupertinoApp.router(
          theme: BringlyTheme.lightTheme(),
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('design_system_close_button')));
      await tester.pumpAndSettle();

      expect(find.text('Your profile'), findsOneWidget);
      expect(find.byKey(const Key('marketplace_tab_bar')), findsOneWidget);
    });
  });
}

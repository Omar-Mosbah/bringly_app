import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_shell_test_helpers.dart';

void main() {
  group('MarketplaceShell accessibility', () {
    testWidgets('renders without overflow at 1x text scale', (tester) async {
      await pumpShellAtRoute(tester, '/shopper');
      expect(tester.takeException(), isNull);
    });

    testWidgets('tab labels remain readable at 1.3x text scale', (
      tester,
    ) async {
      final router = buildFakeAppRouter();
      router.go('/shopper');
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
          child: CupertinoApp.router(
            theme: BringlyTheme.lightTheme(),
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on compact 320x568 viewport without error', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpShellAtRoute(tester, '/shopper');
      expect(tester.takeException(), isNull);
    });
  });
}

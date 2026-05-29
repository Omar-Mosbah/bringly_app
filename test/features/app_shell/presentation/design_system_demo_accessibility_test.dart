import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_shell_test_helpers.dart';

void main() {
  Future<void> pumpDemo(
    WidgetTester tester, {
    double textScaleFactor = 1.0,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = buildFakeAppRouter();
    router.go('/design-system');
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScaleFactor)),
        child: CupertinoApp.router(
          theme: BringlyTheme.lightTheme(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Design System Demo accessibility', () {
    testWidgets('renders without exception at 1x scale', (tester) async {
      await pumpDemo(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without exception at 1.3x text scale', (tester) async {
      await pumpDemo(tester, textScaleFactor: 1.3);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without exception on compact 320x568 viewport', (
      tester,
    ) async {
      await pumpDemo(tester, size: const Size(320, 568));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Buttons section is visible', (tester) async {
      await pumpDemo(tester);
      expect(find.text('Buttons'), findsOneWidget);
    });
  });
}

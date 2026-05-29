import 'package:bringly_app/design_system/layouts/marketplace_shell_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_bringly_widget.dart';

void main() {
  group('MarketplaceShellScaffold', () {
    testWidgets('renders provided title in navigation bar', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShellScaffold(
          title: 'Browse',
          body: SizedBox.shrink(),
        ),
      );
      expect(find.text('Browse'), findsOneWidget);
    });

    testWidgets('renders body content', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShellScaffold(
          title: 'Test',
          body: Text('Body content'),
        ),
      );
      expect(find.text('Body content'), findsOneWidget);
    });

    testWidgets('applies safe area — navigation bar key is present', (
      tester,
    ) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShellScaffold(
          title: 'Safe Area Test',
          body: SizedBox.shrink(),
        ),
      );
      expect(
        find.byKey(const ValueKey<String>('marketplace_nav_bar')),
        findsOneWidget,
      );
    });

    testWidgets('renders trailing widget when provided', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShellScaffold(
          title: 'With Trailing',
          trailing: Icon(CupertinoIcons.ellipsis, key: ValueKey('trailing')),
          body: SizedBox.shrink(),
        ),
      );
      expect(find.byKey(const ValueKey<String>('trailing')), findsOneWidget);
    });

    testWidgets('omits trailing slot when not provided', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShellScaffold(
          title: 'No Trailing',
          body: SizedBox.shrink(),
        ),
      );
      // No extra icon rendered in the bar
      expect(find.byIcon(CupertinoIcons.ellipsis), findsNothing);
    });

    testWidgets('uses Bringly surface colour for scaffold background', (
      tester,
    ) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShellScaffold(
          title: 'Color Test',
          body: SizedBox.shrink(),
        ),
      );
      final scaffold = tester.widget<CupertinoPageScaffold>(
        find.byType(CupertinoPageScaffold),
      );
      expect(scaffold.backgroundColor, equals(BringlyColors.surface));
    });

    testWidgets('compact 320×568 viewport renders without overflow', (
      tester,
    ) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShellScaffold(
          title: 'Compact',
          body: Text('Compact body'),
        ),
        surfaceSize: const Size(320, 568),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Compact body'), findsOneWidget);
    });

    testWidgets('body scrolls when content overflows viewport', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShellScaffold(
          title: 'Scrollable',
          body: SizedBox(height: 2000, child: Text('Tall content')),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });
}

import 'package:bringly_app/features/app_shell/domain/entities/marketplace_destination.dart';
import 'package:bringly_app/features/app_shell/presentation/marketplace_shell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_bringly_widget.dart';

void main() {
  group('MarketplaceShell — primary tabs', () {
    testWidgets('renders exactly four tab bar items', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShell(
          activeDestinationId: MarketplaceDestinationId.shopper,
        ),
      );
      await tester.pumpAndSettle();
      final tabBar = tester.widget<CupertinoTabBar>(
        find.byKey(const ValueKey<String>('marketplace_tab_bar')),
      );
      expect(tabBar.items.length, equals(4));
    });

    testWidgets('renders tab bar with Shop label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShell(
          activeDestinationId: MarketplaceDestinationId.shopper,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Shop'), findsWidgets);
    });

    testWidgets('renders tab bar with Travel label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShell(
          activeDestinationId: MarketplaceDestinationId.shopper,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Travel'), findsWidgets);
    });

    testWidgets('renders tab bar with Activity label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShell(
          activeDestinationId: MarketplaceDestinationId.shopper,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Activity'), findsWidgets);
    });

    testWidgets('renders tab bar with Profile label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShell(
          activeDestinationId: MarketplaceDestinationId.shopper,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsWidgets);
    });

    testWidgets('tab scaffold key is present', (tester) async {
      await pumpBringlyWidget(
        tester,
        const MarketplaceShell(
          activeDestinationId: MarketplaceDestinationId.shopper,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey<String>('marketplace_tab_scaffold')),
        findsOneWidget,
      );
    });
  });
}

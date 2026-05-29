import 'package:bringly_app/features/app_shell/domain/entities/marketplace_destination.dart';
import 'package:bringly_app/features/app_shell/presentation/marketplace_shell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_bringly_widget.dart';

void main() {
  group('MarketplaceShell — placeholder switching', () {
    Future<void> pumpShell(
      WidgetTester tester,
      MarketplaceDestinationId id,
    ) async {
      await pumpBringlyWidget(
        tester,
        MarketplaceShell(activeDestinationId: id),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Shopper tab shows shopper placeholder title', (tester) async {
      await pumpShell(tester, MarketplaceDestinationId.shopper);
      expect(
        find.text(
          MarketplaceDestination.byId(
            MarketplaceDestinationId.shopper,
          ).placeholder.title,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Traveler tab shows traveler placeholder title', (
      tester,
    ) async {
      await pumpShell(tester, MarketplaceDestinationId.traveler);
      expect(
        find.text(
          MarketplaceDestination.byId(
            MarketplaceDestinationId.traveler,
          ).placeholder.title,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Activity tab shows activity placeholder title', (
      tester,
    ) async {
      await pumpShell(tester, MarketplaceDestinationId.activity);
      expect(
        find.text(
          MarketplaceDestination.byId(
            MarketplaceDestinationId.activity,
          ).placeholder.title,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Profile tab shows profile placeholder title', (tester) async {
      await pumpShell(tester, MarketplaceDestinationId.profile);
      expect(
        find.text(
          MarketplaceDestination.byId(
            MarketplaceDestinationId.profile,
          ).placeholder.title,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'each destination shows the correct placeholder_title key widget',
      (tester) async {
        for (final dest in MarketplaceDestination.all) {
          await pumpShell(tester, dest.id);
          expect(
            find.byKey(const ValueKey<String>('placeholder_title')),
            findsOneWidget,
            reason: '${dest.id} should show a placeholder_title widget',
          );
        }
      },
    );
  });
}

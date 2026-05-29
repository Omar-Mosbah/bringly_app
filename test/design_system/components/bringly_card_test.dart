import 'package:bringly_app/design_system/components/bringly_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_bringly_widget.dart';

void main() {
  group('BringlyCard', () {
    testWidgets('renders child content', (tester) async {
      await pumpBringlyWidget(
        tester,
        const BringlyCard(child: Text('Card content')),
      );
      expect(find.text('Card content'), findsOneWidget);
    });

    testWidgets('invokes onTap when tappable', (tester) async {
      var tapped = false;
      await pumpBringlyWidget(
        tester,
        BringlyCard(onTap: () => tapped = true, child: const Text('Tap me')),
      );
      await tester.tap(find.byType(BringlyCard));
      expect(tapped, isTrue);
    });

    testWidgets('does not invoke onTap when disabled', (tester) async {
      var tapped = false;
      await pumpBringlyWidget(
        tester,
        BringlyCard(
          onTap: () => tapped = true,
          isDisabled: true,
          child: const Text('Disabled'),
        ),
      );
      await tester.tap(find.byType(BringlyCard), warnIfMissed: false);
      expect(tapped, isFalse);
    });

    testWidgets('handles long text without overflow', (tester) async {
      const longText =
          'This is a very long marketplace item title that should not overflow the card layout under any circumstances';
      await pumpBringlyWidget(tester, const BringlyCard(child: Text(longText)));
      expect(tester.takeException(), isNull);
      expect(find.text(longText), findsOneWidget);
    });

    testWidgets('renders status slot widget when provided', (tester) async {
      await pumpBringlyWidget(
        tester,
        const BringlyCard(statusSlot: Text('Pending'), child: Text('Item')),
      );
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Item'), findsOneWidget);
    });

    testWidgets('has stable test key', (tester) async {
      await pumpBringlyWidget(
        tester,
        const BringlyCard(key: Key('card_item'), child: Text('Item')),
      );
      expect(find.byKey(const Key('card_item')), findsOneWidget);
    });
  });
}

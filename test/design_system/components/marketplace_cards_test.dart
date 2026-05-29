import 'package:bringly_app/design_system/components/price_breakdown_card.dart';
import 'package:bringly_app/design_system/components/request_card.dart';
import 'package:bringly_app/design_system/components/traveler_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_bringly_widget.dart';

void main() {
  group('PriceBreakdownCard', () {
    testWidgets('renders line items and total', (tester) async {
      await pumpBringlyWidget(
        tester,
        const PriceBreakdownCard(
          lineItems: [
            PriceLineItem(label: 'Item fee', amount: '\$12.00'),
            PriceLineItem(label: 'Service fee', amount: '\$2.00'),
          ],
          total: '\$14.00',
        ),
      );
      expect(find.text('Item fee'), findsOneWidget);
      expect(find.text('\$12.00'), findsOneWidget);
      expect(find.text('\$14.00'), findsOneWidget);
    });

    testWidgets('does not imply real payment authorization', (tester) async {
      await pumpBringlyWidget(
        tester,
        const PriceBreakdownCard(
          lineItems: [PriceLineItem(label: 'Item', amount: '\$0.00')],
          total: '\$0.00',
        ),
      );
      const forbidden = [
        'charge',
        'authorize',
        'escrow',
        'payout',
        'refund',
        'stripe',
        'card',
      ];
      for (final word in forbidden) {
        expect(
          find.textContaining(word, findRichText: true),
          findsNothing,
          reason: 'PriceBreakdownCard must not expose "$word"',
        );
      }
    });
  });

  group('TravelerCard', () {
    testWidgets('renders display name and route', (tester) async {
      await pumpBringlyWidget(
        tester,
        const TravelerCard(
          displayName: 'Alex T.',
          route: 'Demo route A',
          travelDate: 'Jun 15',
        ),
      );
      expect(find.text('Alex T.'), findsOneWidget);
      expect(find.text('Demo route A'), findsOneWidget);
      expect(find.text('Jun 15'), findsOneWidget);
    });

    testWidgets('does not reveal real identity or contact', (tester) async {
      await pumpBringlyWidget(
        tester,
        const TravelerCard(
          displayName: 'Demo User',
          route: 'A → B',
          travelDate: 'TBD',
        ),
      );
      const forbidden = ['@', 'phone', 'passport', 'approved', 'matched'];
      for (final word in forbidden) {
        expect(
          find.textContaining(word, findRichText: true),
          findsNothing,
          reason: 'TravelerCard must not expose "$word"',
        );
      }
    });
  });

  group('RequestCard', () {
    testWidgets('renders item description and destination', (tester) async {
      await pumpBringlyWidget(
        tester,
        const RequestCard(
          itemDescription: 'Running shoes',
          destination: 'San Francisco',
          reward: '\$5.00',
        ),
      );
      expect(find.text('Running shoes'), findsOneWidget);
      expect(find.text('San Francisco'), findsOneWidget);
      expect(find.text('\$5.00'), findsOneWidget);
    });

    testWidgets('does not imply match eligibility or offer acceptance', (
      tester,
    ) async {
      await pumpBringlyWidget(
        tester,
        const RequestCard(
          itemDescription: 'Demo item',
          destination: 'Demo City',
          reward: '\$0',
        ),
      );
      const forbidden = ['matched', 'approved', 'accepted offer', 'confirmed'];
      for (final word in forbidden) {
        expect(
          find.textContaining(word, findRichText: true),
          findsNothing,
          reason: 'RequestCard must not expose "$word"',
        );
      }
    });
  });
}

import 'package:bringly_app/design_system/components/price_breakdown_card.dart';
import 'package:bringly_app/design_system/components/request_card.dart';
import 'package:bringly_app/design_system/components/traveler_card.dart';

/// Deterministic fake demo data for the Design System Demo screen.
///
/// All values are fake and non-sensitive. Must not resemble real PII, payment
/// details, documents, receipts, travel proof, tokens, or internal risk scores.
class DemoData {
  DemoData._();

  static const List<TravelerCard> travelerCards = [
    TravelerCard(
      displayName: 'Sample participant A',
      route: 'Demo route A',
      travelDate: 'Demo window',
    ),
    TravelerCard(
      displayName: 'Sample participant B',
      route: 'Demo route B',
      travelDate: 'Demo window',
    ),
  ];

  static const List<RequestCard> requestCards = [
    RequestCard(
      itemDescription: 'Sample item category A',
      destination: 'Demo destination A',
      reward: '\$8.00',
    ),
    RequestCard(
      itemDescription: 'Sample item category B',
      destination: 'Demo destination B',
      reward: '\$5.00',
    ),
  ];

  static const PriceBreakdownCard priceBreakdown = PriceBreakdownCard(
    lineItems: [
      PriceLineItem(label: 'Item fee', amount: '\$25.00'),
      PriceLineItem(label: 'Service fee', amount: '\$3.75'),
      PriceLineItem(label: 'Traveler reward', amount: '\$8.00'),
    ],
    total: '\$36.75',
  );
}

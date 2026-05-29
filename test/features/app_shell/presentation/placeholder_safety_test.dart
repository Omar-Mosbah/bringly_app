import 'package:bringly_app/features/app_shell/domain/entities/marketplace_destination.dart';
import 'package:bringly_app/features/app_shell/presentation/marketplace_shell.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_bringly_widget.dart';

void main() {
  // Labels that would indicate a future marketplace action is available.
  const forbiddenLabels = <String>[
    'Submit',
    'Request item',
    'Add trip',
    'Upload',
    'Pay',
    'Payment',
    'Pay now',
    'Checkout',
    'Confirm offer',
    'Accept offer',
    'Send offer',
    'Dispute',
    'File dispute',
    'Rate',
    'Leave review',
    'Payout',
    'Request payout',
    'Log in',
    'Login',
    'Sign in',
    'Sign up',
    'Register',
    'Verify',
    'Start verification',
    'Deliver',
    'Mark delivered',
    'Match',
    'View match',
  ];

  group('Placeholder safety — no future marketplace action labels', () {
    for (final dest in MarketplaceDestination.all) {
      testWidgets('${dest.id} placeholder exposes no forbidden action label', (
        tester,
      ) async {
        await pumpBringlyWidget(
          tester,
          MarketplaceShell(activeDestinationId: dest.id),
        );
        await tester.pumpAndSettle();

        for (final label in forbiddenLabels) {
          expect(
            find.text(label),
            findsNothing,
            reason:
                '${dest.id} placeholder must not show "$label" — '
                'marketplace actions are not available in Phase 1',
          );
        }
      });
    }
  });
}

import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_bringly_widget.dart';

void main() {
  group('BringlyButton', () {
    testWidgets('renders label in normal state', (tester) async {
      await pumpBringlyWidget(
        tester,
        BringlyButton(label: 'Confirm', onPressed: () {}),
      );
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('invokes onPressed when tapped', (tester) async {
      var tapped = false;
      await pumpBringlyWidget(
        tester,
        BringlyButton(label: 'Go', onPressed: () => tapped = true),
      );
      await tester.tap(find.byType(BringlyButton));
      expect(tapped, isTrue);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      tester,
    ) async {
      await pumpBringlyWidget(
        tester,
        const BringlyButton(label: 'Wait', onPressed: null, isLoading: true),
      );
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('hides label text when loading', (tester) async {
      await pumpBringlyWidget(
        tester,
        const BringlyButton(label: 'Wait', onPressed: null, isLoading: true),
      );
      expect(find.text('Wait'), findsNothing);
    });

    testWidgets('disabled button does not invoke callback', (tester) async {
      var tapped = false;
      await pumpBringlyWidget(
        tester,
        BringlyButton(
          label: 'Disabled',
          onPressed: null,
          onPressedFallback: () => tapped = true,
        ),
      );
      await tester.tap(find.byType(BringlyButton), warnIfMissed: false);
      expect(tapped, isFalse);
    });

    testWidgets('error state renders label', (tester) async {
      await pumpBringlyWidget(
        tester,
        BringlyButton(label: 'Retry', onPressed: () {}, isError: true),
      );
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('has stable test key', (tester) async {
      await pumpBringlyWidget(
        tester,
        BringlyButton(
          key: const Key('btn_confirm'),
          label: 'Confirm',
          onPressed: () {},
        ),
      );
      expect(find.byKey(const Key('btn_confirm')), findsOneWidget);
    });
  });
}

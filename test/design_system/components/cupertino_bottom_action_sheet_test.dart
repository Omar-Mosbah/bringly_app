import 'package:bringly_app/design_system/components/cupertino_bottom_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_bringly_widget.dart';

void main() {
  group('BringlyCupertinoActionSheet', () {
    Future<void> pumpSheet(
      WidgetTester tester, {
      String? title,
      String? message,
      List<BringlyActionSheetAction> actions = const [],
      VoidCallback? onCancel,
    }) async {
      await pumpBringlyWidget(
        tester,
        CupertinoActionSheet(
          title: title != null ? Text(title) : null,
          message: message != null ? Text(message) : null,
          actions: actions
              .map(
                (a) => CupertinoActionSheetAction(
                  onPressed: a.onPressed,
                  isDestructiveAction: a.isDestructive,
                  child: Text(a.label),
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: onCancel ?? () {},
            child: const Text('Cancel'),
          ),
        ),
      );
    }

    testWidgets('renders title', (tester) async {
      await pumpSheet(tester, title: 'Choose an option');
      expect(find.text('Choose an option'), findsOneWidget);
    });

    testWidgets('renders message', (tester) async {
      await pumpSheet(tester, message: 'Select one of the following actions');
      expect(find.text('Select one of the following actions'), findsOneWidget);
    });

    testWidgets('renders cancel button', (tester) async {
      await pumpSheet(tester);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('renders primary action', (tester) async {
      await pumpSheet(
        tester,
        actions: [BringlyActionSheetAction(label: 'Save', onPressed: () {})],
      );
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('renders destructive action', (tester) async {
      await pumpSheet(
        tester,
        actions: [
          BringlyActionSheetAction(
            label: 'Remove',
            onPressed: () {},
            isDestructive: true,
          ),
        ],
      );
      expect(find.text('Remove'), findsOneWidget);
    });

    testWidgets('invoking primary action calls callback', (tester) async {
      var called = false;
      await pumpSheet(
        tester,
        actions: [
          BringlyActionSheetAction(
            label: 'Confirm',
            onPressed: () => called = true,
          ),
        ],
      );
      await tester.tap(find.text('Confirm'));
      expect(called, isTrue);
    });

    testWidgets('cancel invokes cancel callback', (tester) async {
      var cancelled = false;
      await pumpSheet(tester, onCancel: () => cancelled = true);
      await tester.tap(find.text('Cancel'));
      expect(cancelled, isTrue);
    });
  });
}

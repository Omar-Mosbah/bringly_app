import 'package:bringly_app/features/foundation/presentation/ui_state_demo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders stable text for all baseline UI states', (tester) async {
    await tester.pumpWidget(const CupertinoApp(home: UiStateDemoScreen()));

    for (final title in const <String>[
      'Loading state',
      'Empty state',
      'Error state',
      'Blocked state',
      'Offline state',
      'Success state',
    ]) {
      expect(find.text(title), findsOneWidget);
    }
  });
}

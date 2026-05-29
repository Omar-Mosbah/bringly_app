import 'package:bringly_app/design_system/components/bringly_state_view.dart';
import 'package:bringly_app/design_system/components/component_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildStateView({
    required ComponentState state,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        child: BringlyStateView(
          componentState: state,
          title: state.displayLabel,
          message: 'Test message for ${state.displayLabel}',
          actionLabel: actionLabel,
          onAction: onAction,
        ),
      ),
    );
  }

  group('BringlyStateView', () {
    testWidgets('loading state shows activity indicator', (tester) async {
      await tester.pumpWidget(buildStateView(state: ComponentState.loading));
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('empty state shows title and message', (tester) async {
      await tester.pumpWidget(buildStateView(state: ComponentState.empty));
      expect(find.text('Empty'), findsOneWidget);
      expect(find.text('Test message for Empty'), findsOneWidget);
    });

    testWidgets('blocked state shows title and message', (tester) async {
      await tester.pumpWidget(buildStateView(state: ComponentState.blocked));
      expect(find.text('Unavailable'), findsOneWidget);
    });

    testWidgets('error state shows title, message, and action button', (
      tester,
    ) async {
      bool actionCalled = false;
      await tester.pumpWidget(
        buildStateView(
          state: ComponentState.error,
          actionLabel: 'Retry',
          onAction: () => actionCalled = true,
        ),
      );
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(actionCalled, isTrue);
    });

    testWidgets('does not show action button when actionLabel is null', (
      tester,
    ) async {
      await tester.pumpWidget(buildStateView(state: ComponentState.empty));
      expect(find.byType(CupertinoButton), findsNothing);
    });

    testWidgets('loading state wording is safe', (tester) async {
      await tester.pumpWidget(buildStateView(state: ComponentState.loading));
      expect(find.text('Loading'), findsOneWidget);
      // Should not contain alarming or technical jargon
      expect(find.textContaining('exception'), findsNothing);
      expect(find.textContaining('null'), findsNothing);
    });
  });
}

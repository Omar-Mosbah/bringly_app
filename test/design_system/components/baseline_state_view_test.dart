import 'package:bringly_app/design_system/components/baseline_state_view.dart';
import 'package:bringly_app/features/foundation/domain/entities/baseline_ui_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpState(WidgetTester tester, BaselineUiState state) {
    return tester.pumpWidget(
      CupertinoApp(home: BaselineStateView(state: state)),
    );
  }

  testWidgets(
    'renders loading empty error blocked offline and success states',
    (tester) async {
      for (final state in const <BaselineUiState>[
        BaselineUiState(
          kind: BaselineUiStateKind.loading,
          title: 'Loading',
          message: 'Please wait.',
        ),
        BaselineUiState(
          kind: BaselineUiStateKind.empty,
          title: 'Empty',
          message: 'Nothing to show.',
        ),
        BaselineUiState(
          kind: BaselineUiStateKind.error,
          title: 'Error',
          message: 'Safe error.',
        ),
        BaselineUiState(
          kind: BaselineUiStateKind.blocked,
          title: 'Blocked',
          message: 'Cannot continue.',
        ),
        BaselineUiState(
          kind: BaselineUiStateKind.offline,
          title: 'Offline',
          message: 'No network.',
        ),
        BaselineUiState(
          kind: BaselineUiStateKind.success,
          title: 'Success',
          message: 'Completed.',
        ),
      ]) {
        await pumpState(tester, state);
        expect(find.text(state.title), findsOneWidget);
        expect(find.text(state.message), findsOneWidget);
      }
    },
  );
}

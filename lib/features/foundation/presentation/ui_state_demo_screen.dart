import 'package:bringly_app/design_system/components/baseline_state_view.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/foundation/domain/entities/baseline_ui_state.dart';
import 'package:flutter/widgets.dart';

class UiStateDemoScreen extends StatelessWidget {
  const UiStateDemoScreen({super.key});

  static const List<BaselineUiState> demoStates = <BaselineUiState>[
    BaselineUiState(
      kind: BaselineUiStateKind.loading,
      title: 'Loading state',
      message: 'Fake loading feedback for Phase 0 widgets.',
    ),
    BaselineUiState(
      kind: BaselineUiStateKind.empty,
      title: 'Empty state',
      message: 'No business data is shown in Phase 0.',
      primaryAction: 'Review setup',
    ),
    BaselineUiState(
      kind: BaselineUiStateKind.error,
      title: 'Error state',
      message: 'Unexpected provider details stay redacted.',
      primaryAction: 'Try again',
      retryAllowed: true,
    ),
    BaselineUiState(
      kind: BaselineUiStateKind.blocked,
      title: 'Blocked state',
      message: 'Future marketplace flows stay out of scope in Phase 0.',
    ),
    BaselineUiState(
      kind: BaselineUiStateKind.offline,
      title: 'Offline state',
      message: 'The device can show a safe offline experience.',
      primaryAction: 'Retry',
      retryAllowed: true,
    ),
    BaselineUiState(
      kind: BaselineUiStateKind.success,
      title: 'Success state',
      message: 'The reusable state view can also show positive outcomes.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FoundationScaffold(
      title: 'UI States',
      child: Column(
        children: demoStates
            .map(
              (state) => Padding(
                padding: const EdgeInsets.only(bottom: BringlySpacing.md),
                child: BaselineStateView(state: state),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

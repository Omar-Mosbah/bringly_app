import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/design_system/components/baseline_state_view.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/features/foundation/domain/entities/baseline_ui_state.dart';
import 'package:flutter/widgets.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({required this.appConfig, super.key});

  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {
    final state = appConfig.isValid
        ? const BaselineUiState(
            kind: BaselineUiStateKind.success,
            title: 'Foundation ready',
            message: 'The app shell is configured for Phase 0 validation.',
          )
        : const BaselineUiState(
            kind: BaselineUiStateKind.blocked,
            title: 'Configuration required',
            message: 'Fix the public runtime configuration before continuing.',
          );

    return FoundationScaffold(
      title: 'Startup',
      child: BaselineStateView(state: state),
    );
  }
}

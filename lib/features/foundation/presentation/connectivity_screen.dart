import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/design_system/components/baseline_state_view.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/domain/entities/baseline_ui_state.dart';
import 'package:bringly_app/features/foundation/domain/entities/connectivity_check_result.dart';
import 'package:flutter/cupertino.dart';

class ConnectivityScreen extends StatefulWidget {
  const ConnectivityScreen({
    required this.appConfig,
    required this.runConnectivityCheck,
    super.key,
  });

  final AppConfig appConfig;
  final RunConnectivityCheck runConnectivityCheck;

  @override
  State<ConnectivityScreen> createState() => _ConnectivityScreenState();
}

class _ConnectivityScreenState extends State<ConnectivityScreen> {
  ConnectivityCheckResult _result = ConnectivityCheckResult.idle();

  Future<void> _runCheck() async {
    setState(() {
      _result = ConnectivityCheckResult.loading();
    });

    final result = await widget.runConnectivityCheck(
      widget.appConfig.environmentProfile,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = _baselineStateForResult(_result);
    return FoundationScaffold(
      title: 'Connectivity',
      child: BaselineStateView(state: state, onPrimaryAction: _runCheck),
    );
  }

  BaselineUiState _baselineStateForResult(ConnectivityCheckResult result) {
    return switch (result.status) {
      ConnectivityCheckStatus.idle => const BaselineUiState(
        kind: BaselineUiStateKind.empty,
        title: 'Connectivity check ready',
        message: 'Run a non-sensitive reachability check when you are ready.',
        primaryAction: 'Run connectivity check',
      ),
      ConnectivityCheckStatus.loading => const BaselineUiState(
        kind: BaselineUiStateKind.loading,
        title: 'Checking connectivity',
        message: 'Waiting for a safe backend reachability response.',
      ),
      ConnectivityCheckStatus.success => BaselineUiState(
        kind: BaselineUiStateKind.success,
        title: 'Connectivity confirmed',
        message: result.safeMessage,
        primaryAction: 'Run connectivity check',
      ),
      ConnectivityCheckStatus.unavailable => BaselineUiState(
        kind: BaselineUiStateKind.error,
        title: 'Backend unavailable',
        message: result.safeMessage,
        primaryAction: 'Retry connectivity',
        retryAllowed: true,
      ),
      ConnectivityCheckStatus.timeout => BaselineUiState(
        kind: BaselineUiStateKind.error,
        title: 'Connectivity timed out',
        message: result.safeMessage,
        primaryAction: 'Retry connectivity',
        retryAllowed: true,
      ),
      ConnectivityCheckStatus.invalidConfiguration => BaselineUiState(
        kind: BaselineUiStateKind.blocked,
        title: 'Connectivity blocked',
        message: result.safeMessage,
        primaryAction: 'Retry connectivity',
      ),
      ConnectivityCheckStatus.offline => BaselineUiState(
        kind: BaselineUiStateKind.offline,
        title: 'Offline',
        message: result.safeMessage,
        primaryAction: 'Retry connectivity',
        retryAllowed: true,
      ),
      ConnectivityCheckStatus.failed => BaselineUiState(
        kind: BaselineUiStateKind.error,
        title: 'Safe error state',
        message: result.safeMessage,
        primaryAction: 'Retry connectivity',
        retryAllowed: true,
      ),
    };
  }
}

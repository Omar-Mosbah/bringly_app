import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/design_system/components/baseline_state_view.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/domain/entities/baseline_ui_state.dart';
import 'package:bringly_app/features/foundation/domain/entities/protected_storage_smoke_test_result.dart';
import 'package:flutter/cupertino.dart';

class ConfigurationStatusScreen extends StatefulWidget {
  const ConfigurationStatusScreen({
    required this.appConfig,
    required this.runProtectedStorageSmokeTest,
    super.key,
  });

  final AppConfig appConfig;
  final RunProtectedStorageSmokeTest runProtectedStorageSmokeTest;

  @override
  State<ConfigurationStatusScreen> createState() =>
      _ConfigurationStatusScreenState();
}

class _ConfigurationStatusScreenState extends State<ConfigurationStatusScreen> {
  ProtectedStorageSmokeTestResult _result =
      const ProtectedStorageSmokeTestResult(
        status: ProtectedStorageSmokeTestStatus.notRun,
        safeMessage: 'Protected storage check has not run yet.',
      );

  Future<void> _runSmokeTest() async {
    setState(() {
      _result = const ProtectedStorageSmokeTestResult(
        status: ProtectedStorageSmokeTestStatus.running,
        safeMessage: 'Running protected storage check...',
      );
    });

    final result = await widget.runProtectedStorageSmokeTest(
      enabled: widget.appConfig.isValid,
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
    final environmentProfile = widget.appConfig.environmentProfile;
    final state = widget.appConfig.isValid
        ? const BaselineUiState(
            kind: BaselineUiStateKind.success,
            title: 'Configuration is valid',
            message: 'Public runtime values are present and safe to inspect.',
          )
        : const BaselineUiState(
            kind: BaselineUiStateKind.blocked,
            title: 'Configuration blocked',
            message: 'Missing or invalid public values are preventing checks.',
          );

    return FoundationScaffold(
      title: 'Configuration',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          BaselineStateView(state: state),
          const SizedBox(height: BringlySpacing.md),
          Text('Environment: ${widget.appConfig.environmentName}'),
          const SizedBox(height: BringlySpacing.xs),
          Text('Supabase host: ${environmentProfile.safeUrlHost}'),
          const SizedBox(height: BringlySpacing.xs),
          Text('Anon key: ${widget.appConfig.safeAnonKeyStatus}'),
          const SizedBox(height: BringlySpacing.xs),
          Text(
            'Validation issues: ${environmentProfile.validationIssues.length}',
          ),
          const SizedBox(height: BringlySpacing.lg),
          CupertinoButton.filled(
            onPressed: _runSmokeTest,
            child: const Text('Run storage check'),
          ),
          const SizedBox(height: BringlySpacing.md),
          Text(_result.safeMessage),
        ],
      ),
    );
  }
}

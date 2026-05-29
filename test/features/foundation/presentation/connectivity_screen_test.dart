import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/data/fake_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';
import 'package:bringly_app/features/foundation/presentation/connectivity_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

class _DelayedConnectivityClient extends BackendConnectivityClient {
  const _DelayedConnectivityClient(this.status);

  final BackendConnectivityStatus status;

  @override
  Future<BackendConnectivityStatus> checkConnectivity(profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return status;
  }
}

void main() {
  AppConfig buildConfig({required bool valid}) {
    return AppConfig(
      environmentName: 'development',
      supabaseUrl: valid ? 'https://example.supabase.co' : '',
      supabaseAnonKey: valid ? 'anon-public-key' : '',
      environmentProfile: EnvironmentProfile(
        name: 'development',
        supabaseUrl: valid ? 'https://example.supabase.co' : '',
        supabaseAnonKeyPresent: valid,
        validationIssues: valid
            ? const <EnvironmentValidationIssue>[]
            : const <EnvironmentValidationIssue>[
                EnvironmentValidationIssue.missingSupabaseUrl,
              ],
      ),
    );
  }

  Future<void> pumpScreen(
    WidgetTester tester, {
    required AppConfig config,
    required BackendConnectivityStatus status,
  }) {
    return tester.pumpWidget(
      CupertinoApp(
        home: ConnectivityScreen(
          key: ValueKey<String>('standard-${config.isValid}-$status'),
          appConfig: config,
          runConnectivityCheck: RunConnectivityCheck(
            FakeConnectivityClient(nextStatus: status),
          ),
        ),
      ),
    );
  }

  Future<void> pumpScreenWithDelayedClient(
    WidgetTester tester, {
    required AppConfig config,
    required BackendConnectivityStatus status,
  }) {
    return tester.pumpWidget(
      CupertinoApp(
        home: ConnectivityScreen(
          key: ValueKey<String>('delayed-${config.isValid}-$status'),
          appConfig: config,
          runConnectivityCheck: RunConnectivityCheck(
            _DelayedConnectivityClient(status),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'covers loading success unavailable timeout offline invalid config safe error and retry states',
    (tester) async {
      await pumpScreenWithDelayedClient(
        tester,
        config: buildConfig(valid: true),
        status: BackendConnectivityStatus.success,
      );

      expect(find.text('Connectivity check ready'), findsOneWidget);
      await tester.tap(find.text('Run connectivity check'));
      await tester.pump();
      expect(find.text('Checking connectivity'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Connectivity confirmed'), findsOneWidget);

      for (final testCase in <(BackendConnectivityStatus, String)>[
        (BackendConnectivityStatus.unavailable, 'Backend unavailable'),
        (BackendConnectivityStatus.timeout, 'Connectivity timed out'),
        (BackendConnectivityStatus.offline, 'Offline'),
        (BackendConnectivityStatus.failed, 'Safe error state'),
      ]) {
        await pumpScreen(
          tester,
          config: buildConfig(valid: true),
          status: testCase.$1,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Run connectivity check'));
        await tester.pumpAndSettle();
        expect(find.text(testCase.$2), findsOneWidget);
      }

      await pumpScreen(
        tester,
        config: buildConfig(valid: false),
        status: BackendConnectivityStatus.success,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Run connectivity check'));
      await tester.pumpAndSettle();
      expect(find.text('Connectivity blocked'), findsOneWidget);
      expect(find.text('Retry connectivity'), findsOneWidget);
    },
  );
}

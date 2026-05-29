import 'package:bringly_app/app/app.dart';
import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/core/analytics/noop_analytics_reporter.dart';
import 'package:bringly_app/core/logging/in_memory_safe_logger.dart';
import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/core/storage/memory_protected_storage.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/data/fake_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';
import 'package:flutter_test/flutter_test.dart';

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
                EnvironmentValidationIssue.missingSupabaseAnonKey,
              ],
      ),
    );
  }

  Future<void> pumpApp(WidgetTester tester, {required bool valid}) {
    return tester.pumpWidget(
      BringlyApp(
        appConfig: buildConfig(valid: valid),
        logger: InMemorySafeLogger(),
        analyticsReporter: const NoopAnalyticsReporter(),
        runProtectedStorageSmokeTest: RunProtectedStorageSmokeTest(
          MemoryProtectedStorage(),
        ),
        runConnectivityCheck: const RunConnectivityCheck(
          FakeConnectivityClient(nextStatus: BackendConnectivityStatus.success),
        ),
      ),
    );
  }

  testWidgets('launches with valid config into auth onboarding', (
    tester,
  ) async {
    await pumpApp(tester, valid: true);
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
  });

  testWidgets('launches into blocked foundation startup with invalid config', (
    tester,
  ) async {
    await pumpApp(tester, valid: false);
    await tester.pumpAndSettle();

    expect(find.text('Configuration required'), findsOneWidget);
    expect(find.text('Browse the marketplace'), findsNothing);
  });
}

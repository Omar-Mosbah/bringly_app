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
  Future<void> pumpApp(WidgetTester tester) {
    return tester.pumpWidget(
      BringlyApp(
        appConfig: AppConfig(
          environmentName: 'development',
          supabaseUrl: 'https://example.supabase.co',
          supabaseAnonKey: 'anon-public-key',
          environmentProfile: const EnvironmentProfile(
            name: 'development',
            supabaseUrl: 'https://example.supabase.co',
            supabaseAnonKeyPresent: true,
            validationIssues: <EnvironmentValidationIssue>[],
          ),
        ),
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

  testWidgets('all foundation destinations are reachable', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.text('Startup'), findsWidgets);
    await tester.tap(find.text('Configuration').last);
    await tester.pumpAndSettle();
    expect(find.text('Configuration is valid'), findsOneWidget);

    await tester.tap(find.text('Connectivity').last);
    await tester.pumpAndSettle();
    expect(find.text('Connectivity check ready'), findsOneWidget);

    await tester.tap(find.text('UI States').last);
    await tester.pumpAndSettle();
    expect(find.text('Loading state'), findsOneWidget);
  });
}

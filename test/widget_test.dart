import 'package:flutter_test/flutter_test.dart';

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

void main() {
  testWidgets('Phase 1 shell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
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
    await tester.pumpAndSettle();

    // Phase 1: app launches into the marketplace shell — shopper tab visible.
    expect(find.text('Browse the marketplace'), findsOneWidget);
  });
}

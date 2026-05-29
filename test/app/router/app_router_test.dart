import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/app/router/app_router.dart';
import 'package:bringly_app/core/analytics/noop_analytics_reporter.dart';
import 'package:bringly_app/core/logging/in_memory_safe_logger.dart';
import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/core/storage/memory_protected_storage.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/data/fake_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final config = AppConfig(
    environmentName: 'development',
    supabaseUrl: 'https://example.supabase.co',
    supabaseAnonKey: 'anon-public-key',
    environmentProfile: const EnvironmentProfile(
      name: 'development',
      supabaseUrl: 'https://example.supabase.co',
      supabaseAnonKeyPresent: true,
      validationIssues: <EnvironmentValidationIssue>[],
    ),
  );

  final router = createAppRouter(
    appConfig: config,
    logger: InMemorySafeLogger(),
    analyticsReporter: const NoopAnalyticsReporter(),
    runProtectedStorageSmokeTest: RunProtectedStorageSmokeTest(
      MemoryProtectedStorage(),
    ),
    runConnectivityCheck: const RunConnectivityCheck(
      FakeConnectivityClient(nextStatus: BackendConnectivityStatus.success),
    ),
  );

  test(
    'router supports only startup configuration connectivity and ui-state routes',
    () {
      expect(router.routeInformationParser, isNotNull);
      final paths = router.configuration.routes
          .whereType<GoRoute>()
          .map((route) => route.path)
          .toList(growable: false);

      expect(
        paths,
        equals(const <String>['/', '/config', '/connectivity', '/ui-states']),
      );
    },
  );
}

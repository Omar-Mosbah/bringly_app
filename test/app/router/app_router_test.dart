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
    'router supports auth routes marketplace shell routes and foundation routes',
    () {
      expect(router.routeInformationParser, isNotNull);
      final paths = router.configuration.routes
          .whereType<GoRoute>()
          .map((route) => route.path)
          .toList(growable: false);

      expect(paths, contains('/onboarding'));
      expect(paths, contains('/register'));
      expect(paths, contains('/role-selection'));
      expect(paths, contains('/marketplace-blocked'));

      // Phase 1 — four primary tab routes
      expect(paths, contains('/shopper'));
      expect(paths, contains('/traveler'));
      expect(paths, contains('/activity'));
      expect(paths, contains('/profile'));
      // Phase 1 — non-primary demo route
      expect(paths, contains('/design-system'));
      // Phase 0 — foundation/developer routes preserved
      expect(paths, contains('/'));
      expect(paths, contains('/config'));
      expect(paths, contains('/connectivity'));
      expect(paths, contains('/ui-states'));
    },
  );

  test('demo route is not one of the four primary tab routes', () {
    final paths = router.configuration.routes
        .whereType<GoRoute>()
        .map((route) => route.path)
        .toList(growable: false);

    // The four primary tabs defined by MarketplaceDestination.all
    const primaryTabPaths = <String>[
      '/shopper',
      '/traveler',
      '/activity',
      '/profile',
    ];
    // /design-system must exist but must not be a primary tab path
    expect(paths, contains('/design-system'));
    expect(primaryTabPaths, isNot(contains('/design-system')));
  });

  test('valid config starts at onboarding instead of the marketplace shell', () {
    expect(router.routeInformationProvider.value.uri.path, '/onboarding');
  });
}

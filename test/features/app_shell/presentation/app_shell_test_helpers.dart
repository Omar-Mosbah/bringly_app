import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/app/router/app_router.dart';
import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/core/analytics/noop_analytics_reporter.dart';
import 'package:bringly_app/core/logging/in_memory_safe_logger.dart';
import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/core/storage/memory_protected_storage.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/data/fake_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Builds a minimal but valid [AppConfig] for use in shell widget tests.
/// Uses the same fake config pattern as Phase 0 tests.
AppConfig buildFakeAppConfig() {
  return AppConfig(
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
}

/// Creates a [GoRouter] wired with fake Phase 0 dependencies.
GoRouter buildFakeAppRouter() {
  return createAppRouter(
    appConfig: buildFakeAppConfig(),
    logger: InMemorySafeLogger(),
    analyticsReporter: const NoopAnalyticsReporter(),
    runProtectedStorageSmokeTest: RunProtectedStorageSmokeTest(
      MemoryProtectedStorage(),
    ),
    runConnectivityCheck: const RunConnectivityCheck(
      FakeConnectivityClient(nextStatus: BackendConnectivityStatus.success),
    ),
  );
}

/// Pumps the full routed app at [initialRoute] inside a [CupertinoApp.router].
///
/// Use this helper in shell navigation tests that need live go_router
/// navigation rather than standalone widget pumping.
Future<void> pumpShellAtRoute(
  WidgetTester tester,
  String initialRoute, {
  GoRouter? router,
}) async {
  final resolvedRouter = router ?? buildFakeAppRouter();
  resolvedRouter.go(initialRoute);
  await tester.pumpWidget(
    CupertinoApp.router(
      theme: BringlyTheme.lightTheme(),
      routerConfig: resolvedRouter,
    ),
  );
  await tester.pumpAndSettle();
}

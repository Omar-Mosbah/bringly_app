import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/core/analytics/analytics_reporter.dart';
import 'package:bringly_app/core/logging/safe_logger.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/domain/entities/foundation_destination.dart';
import 'package:bringly_app/features/foundation/presentation/foundation_shell.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({
  required AppConfig appConfig,
  required SafeLogger logger,
  required AnalyticsReporter analyticsReporter,
  required RunProtectedStorageSmokeTest runProtectedStorageSmokeTest,
  required RunConnectivityCheck runConnectivityCheck,
}) {
  FoundationShell buildShell(FoundationDestinationId destination) {
    return FoundationShell(
      destination: destination,
      appConfig: appConfig,
      logger: logger,
      analyticsReporter: analyticsReporter,
      runProtectedStorageSmokeTest: runProtectedStorageSmokeTest,
      runConnectivityCheck: runConnectivityCheck,
    );
  }

  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) =>
            buildShell(FoundationDestinationId.startup),
      ),
      GoRoute(
        path: '/config',
        builder: (context, state) =>
            buildShell(FoundationDestinationId.configurationStatus),
      ),
      GoRoute(
        path: '/connectivity',
        builder: (context, state) =>
            buildShell(FoundationDestinationId.connectivity),
      ),
      GoRoute(
        path: '/ui-states',
        builder: (context, state) =>
            buildShell(FoundationDestinationId.uiStateDemo),
      ),
    ],
  );
}

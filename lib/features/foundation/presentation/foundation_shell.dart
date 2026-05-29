import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/core/analytics/analytics_reporter.dart';
import 'package:bringly_app/core/logging/safe_logger.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/domain/entities/foundation_destination.dart';
import 'package:bringly_app/features/foundation/presentation/configuration_status_screen.dart';
import 'package:bringly_app/features/foundation/presentation/connectivity_screen.dart';
import 'package:bringly_app/features/foundation/presentation/startup_screen.dart';
import 'package:bringly_app/features/foundation/presentation/ui_state_demo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class FoundationShell extends StatelessWidget {
  const FoundationShell({
    required this.destination,
    required this.appConfig,
    required this.logger,
    required this.analyticsReporter,
    required this.runProtectedStorageSmokeTest,
    required this.runConnectivityCheck,
    super.key,
  });

  final FoundationDestinationId destination;
  final AppConfig appConfig;
  final SafeLogger logger;
  final AnalyticsReporter analyticsReporter;
  final RunProtectedStorageSmokeTest runProtectedStorageSmokeTest;
  final RunConnectivityCheck runConnectivityCheck;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: FoundationDestination.all
            .map(
              (destination) => BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.circle_fill),
                label: destination.title,
              ),
            )
            .toList(growable: false),
        currentIndex: FoundationDestination.all.indexWhere(
          (item) => item.id == destination,
        ),
        onTap: (index) =>
            context.go(FoundationDestination.all[index].routePath),
      ),
      tabBuilder: (context, index) => _buildDestination(),
    );
  }

  Widget _buildDestination() {
    return switch (destination) {
      FoundationDestinationId.startup => StartupScreen(appConfig: appConfig),
      FoundationDestinationId.configurationStatus => ConfigurationStatusScreen(
        appConfig: appConfig,
        runProtectedStorageSmokeTest: runProtectedStorageSmokeTest,
      ),
      FoundationDestinationId.connectivity => ConnectivityScreen(
        appConfig: appConfig,
        runConnectivityCheck: runConnectivityCheck,
      ),
      FoundationDestinationId.uiStateDemo => const UiStateDemoScreen(),
    };
  }
}

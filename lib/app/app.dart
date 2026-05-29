import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/app/router/app_router.dart';
import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/core/analytics/analytics_reporter.dart';
import 'package:bringly_app/core/logging/safe_logger.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class BringlyApp extends StatefulWidget {
  const BringlyApp({
    required this.appConfig,
    required this.logger,
    required this.analyticsReporter,
    required this.runProtectedStorageSmokeTest,
    required this.runConnectivityCheck,
    super.key,
  });

  final AppConfig appConfig;
  final SafeLogger logger;
  final AnalyticsReporter analyticsReporter;
  final RunProtectedStorageSmokeTest runProtectedStorageSmokeTest;
  final RunConnectivityCheck runConnectivityCheck;

  @override
  State<BringlyApp> createState() => _BringlyAppState();
}

class _BringlyAppState extends State<BringlyApp> {
  late final GoRouter _router = createAppRouter(
    appConfig: widget.appConfig,
    logger: widget.logger,
    analyticsReporter: widget.analyticsReporter,
    runProtectedStorageSmokeTest: widget.runProtectedStorageSmokeTest,
    runConnectivityCheck: widget.runConnectivityCheck,
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      title: 'Bringly',
      theme: BringlyTheme.lightTheme(),
      routerConfig: _router,
    );
  }
}

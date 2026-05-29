import 'package:bringly_app/app/app.dart';
import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/core/analytics/noop_analytics_reporter.dart';
import 'package:bringly_app/core/logging/in_memory_safe_logger.dart';
import 'package:bringly_app/core/storage/flutter_secure_protected_storage.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/application/validate_environment_profile.dart';
import 'package:bringly_app/features/foundation/data/supabase_connectivity_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appConfig = AppConfig.fromEnvironment(
    validator: const ValidateEnvironmentProfile(),
  );

  runApp(
    ProviderScope(
      child: BringlyApp(
        appConfig: appConfig,
        logger: InMemorySafeLogger(),
        analyticsReporter: const NoopAnalyticsReporter(),
        runProtectedStorageSmokeTest: RunProtectedStorageSmokeTest(
          const FlutterSecureProtectedStorage(),
        ),
        runConnectivityCheck: RunConnectivityCheck(
          const SupabaseConnectivityClient(),
        ),
      ),
    ),
  );
}

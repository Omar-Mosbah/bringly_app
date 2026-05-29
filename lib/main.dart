import 'package:bringly_app/app/app.dart';
import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/core/analytics/noop_analytics_reporter.dart';
import 'package:bringly_app/core/logging/in_memory_safe_logger.dart';
import 'package:bringly_app/core/security/local_auth_app_unlock.dart';
import 'package:bringly_app/core/storage/protected_storage_local_storage.dart';
import 'package:bringly_app/core/storage/flutter_secure_protected_storage.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/application/request_password_reset.dart';
import 'package:bringly_app/features/auth/application/require_local_unlock.dart';
import 'package:bringly_app/features/auth/application/restore_session.dart';
import 'package:bringly_app/features/auth/application/sign_in_with_email.dart';
import 'package:bringly_app/features/auth/application/sign_out.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/data/in_memory_auth_repository.dart';
import 'package:bringly_app/features/auth/data/local_unlock_repository.dart';
import 'package:bringly_app/features/auth/data/protected_auth_storage.dart';
import 'package:bringly_app/features/auth/data/supabase_auth_repository.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/application/validate_environment_profile.dart';
import 'package:bringly_app/features/foundation/data/supabase_connectivity_client.dart';
import 'package:bringly_app/features/profile/application/load_profile_summary.dart';
import 'package:bringly_app/features/profile/application/profile_controller.dart';
import 'package:bringly_app/features/profile/application/update_basic_profile.dart';
import 'package:bringly_app/features/profile/application/update_marketplace_role.dart';
import 'package:bringly_app/features/profile/data/in_memory_profile_repository.dart';
import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/data/supabase_profile_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appConfig = AppConfig.fromEnvironment(
    validator: const ValidateEnvironmentProfile(),
  );
  final protectedStorage = const FlutterSecureProtectedStorage();

  final authRepository = await _createAuthRepository(
    appConfig: appConfig,
    protectedStorage: protectedStorage,
  );
  final profileRepository = await _createProfileRepository(appConfig: appConfig);
  final localUnlockRepository = LocalUnlockRepository(LocalAuthAppUnlock());

  final authController = AuthController(
    signUpWithEmail: SignUpWithEmail(authRepository),
    signInWithEmail: SignInWithEmail(authRepository),
    restoreSession: RestoreSession(authRepository),
    requireLocalUnlock: RequireLocalUnlock(localUnlockRepository),
    signOut: SignOut(authRepository),
    requestPasswordReset: RequestPasswordReset(authRepository),
  );
  final profileController = ProfileController(
    loadProfileSummary: LoadProfileSummary(profileRepository),
    updateBasicProfile: UpdateBasicProfile(profileRepository),
    updateMarketplaceRole: UpdateMarketplaceRole(profileRepository),
  );

  runApp(
    ProviderScope(
      child: BringlyApp(
        appConfig: appConfig,
        logger: InMemorySafeLogger(),
        analyticsReporter: const NoopAnalyticsReporter(),
        runProtectedStorageSmokeTest: RunProtectedStorageSmokeTest(
          protectedStorage,
        ),
        runConnectivityCheck: RunConnectivityCheck(
          SupabaseConnectivityClient(
            publishableAnonKey: appConfig.supabaseAnonKey,
          ),
        ),
        authController: authController,
        profileController: profileController,
      ),
    ),
  );
}

Future<AuthRepository> _createAuthRepository({
  required AppConfig appConfig,
  required FlutterSecureProtectedStorage protectedStorage,
}) async {
  if (!appConfig.isValid) {
    return InMemoryAuthRepository();
  }

  await Supabase.initialize(
    url: appConfig.supabaseUrl,
    anonKey: appConfig.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(
      detectSessionInUri: false,
      localStorage: ProtectedStorageLocalStorage(
        protectedStorage: protectedStorage,
      ),
      pkceAsyncStorage: ProtectedStorageAsyncStorage(
        protectedStorage: protectedStorage,
      ),
    ),
  );

  return SupabaseAuthRepository(
    authClient: Supabase.instance.client.auth,
    protectedAuthStorage: ProtectedAuthStorage(protectedStorage),
  );
}

Future<ProfileRepository> _createProfileRepository({
  required AppConfig appConfig,
}) async {
  if (!appConfig.isValid || !Supabase.instance.isInitialized) {
    return InMemoryProfileRepository();
  }

  return SupabaseProfileRepository(authClient: Supabase.instance.client.auth);
}

import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/app/router/app_router.dart';
import 'package:bringly_app/core/analytics/noop_analytics_reporter.dart';
import 'package:bringly_app/core/logging/in_memory_safe_logger.dart';
import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/core/storage/memory_protected_storage.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/auth/application/sign_in_with_email.dart';
import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/data/fake_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/fake_auth_repository.dart';

void main() {
  AppConfig buildConfig({required bool valid}) {
    return AppConfig(
      environmentName: 'development',
      supabaseUrl: valid ? 'https://example.supabase.co' : '',
      supabaseAnonKey: valid ? 'anon-public-key' : '',
      environmentProfile: EnvironmentProfile(
        name: 'development',
        supabaseUrl: valid ? 'https://example.supabase.co' : '',
        supabaseAnonKeyPresent: valid,
        validationIssues: valid
            ? const <EnvironmentValidationIssue>[]
            : const <EnvironmentValidationIssue>[
                EnvironmentValidationIssue.missingSupabaseUrl,
                EnvironmentValidationIssue.missingSupabaseAnonKey,
              ],
      ),
    );
  }

  AuthAccountSnapshot buildSnapshot(AuthSessionState state) {
    return AuthAccountSnapshot(
      safeAccountId: 'acct-123',
      session: AuthSession(
        state: state,
        requiresLocalUnlock: state != AuthSessionState.signedInUnlocked,
      ),
      emailConfirmationStatus: EmailConfirmationStatus.confirmed,
      accountRestriction: AccountRestriction.active,
      marketplaceRole: MarketplaceRole.shopper,
      verificationStatus: VerificationStatus.verified,
    );
  }

  GoRouter buildRouter({required AppConfig config, required AuthController controller}) {
    return createAppRouter(
      appConfig: config,
      logger: InMemorySafeLogger(),
      analyticsReporter: const NoopAnalyticsReporter(),
      runProtectedStorageSmokeTest: RunProtectedStorageSmokeTest(
        MemoryProtectedStorage(),
      ),
      runConnectivityCheck: const RunConnectivityCheck(
        FakeConnectivityClient(nextStatus: BackendConnectivityStatus.success),
      ),
      authController: controller,
    );
  }

  test('routes signed-out users to onboarding', () {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
      signInWithEmail: SignInWithEmail(FakeAuthRepository()),
      initialState: const AuthControllerState.signedOut(),
    );

    final router = buildRouter(config: buildConfig(valid: true), controller: controller);

    expect(router.routeInformationProvider.value.uri.path, '/onboarding');
  });

  test('routes signed-in locked users to local unlock', () {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
      signInWithEmail: SignInWithEmail(FakeAuthRepository()),
      initialState: AuthControllerState.signedInLocked(buildSnapshot(AuthSessionState.signedInRequiresUnlock)),
    );

    final router = buildRouter(config: buildConfig(valid: true), controller: controller);

    expect(router.routeInformationProvider.value.uri.path, '/local-unlock');
  });

  test('routes signed-in unlocked users to marketplace shell', () {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
      signInWithEmail: SignInWithEmail(FakeAuthRepository()),
      initialState: AuthControllerState.signedInUnlocked(buildSnapshot(AuthSessionState.signedInUnlocked)),
    );

    final router = buildRouter(config: buildConfig(valid: true), controller: controller);
    router.go('/shopper');

    expect(router.routeInformationProvider.value.uri.path, '/shopper');
  });

  test('invalid config keeps startup blocked route', () {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
      signInWithEmail: SignInWithEmail(FakeAuthRepository()),
    );

    final router = buildRouter(config: buildConfig(valid: false), controller: controller);

    expect(router.routeInformationProvider.value.uri.path, '/');
  });

  test('expired sessions route back to login', () {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
      signInWithEmail: SignInWithEmail(FakeAuthRepository()),
      initialState: AuthControllerState.expired(),
    );

    final router = buildRouter(config: buildConfig(valid: true), controller: controller);

    expect(router.routeInformationProvider.value.uri.path, '/login');
  });
}
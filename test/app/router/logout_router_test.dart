import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/app/router/app_router.dart';
import 'package:bringly_app/core/analytics/noop_analytics_reporter.dart';
import 'package:bringly_app/core/logging/in_memory_safe_logger.dart';
import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/core/storage/memory_protected_storage.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/application/sign_in_with_email.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/fake_auth_repository.dart';

void main() {
  AppConfig buildConfig() {
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

  AuthAccountSnapshot buildSnapshot() {
    return AuthAccountSnapshot(
      safeAccountId: 'acct-router-123',
      session: const AuthSession(
        state: AuthSessionState.signedInUnlocked,
        requiresLocalUnlock: false,
      ),
      emailConfirmationStatus: EmailConfirmationStatus.confirmed,
      accountRestriction: AccountRestriction.active,
      marketplaceRole: MarketplaceRole.shopper,
      verificationStatus: VerificationStatus.verified,
    );
  }

  GoRouter buildRouter(AuthController controller) {
    return createAppRouter(
      appConfig: buildConfig(),
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

  testWidgets('protected routes redirect away after logout and restart', (tester) async {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
      signInWithEmail: SignInWithEmail(FakeAuthRepository()),
      initialState: AuthControllerState.signedInUnlocked(buildSnapshot()),
    );
    final router = buildRouter(controller);

    await tester.pumpWidget(CupertinoApp.router(routerConfig: router));
    router.go('/profile');
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/profile');

    controller.setSignedOut(safeMessage: 'Signed out.');
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/onboarding');

    final restartedRouter = buildRouter(
      AuthController(
        signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
        signInWithEmail: SignInWithEmail(FakeAuthRepository()),
        initialState: const AuthControllerState.signedOut(),
      ),
    );

    await tester.pumpWidget(CupertinoApp.router(routerConfig: restartedRouter));
    await tester.pumpAndSettle();

    expect(restartedRouter.routeInformationProvider.value.uri.path, '/onboarding');
  });
}
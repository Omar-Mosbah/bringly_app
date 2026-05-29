import 'dart:async';

import 'package:bringly_app/app/config/app_config.dart';
import 'package:bringly_app/core/analytics/analytics_reporter.dart';
import 'package:bringly_app/core/logging/safe_logger.dart';
import 'package:bringly_app/core/security/local_auth_app_unlock.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/application/require_local_unlock.dart';
import 'package:bringly_app/features/auth/application/protected_marketplace_gate.dart';
import 'package:bringly_app/features/auth/application/request_password_reset.dart';
import 'package:bringly_app/features/auth/application/restore_session.dart';
import 'package:bringly_app/features/auth/application/sign_in_with_email.dart';
import 'package:bringly_app/features/auth/application/sign_out.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/auth/data/in_memory_auth_repository.dart';
import 'package:bringly_app/features/auth/data/local_unlock_repository.dart';
import 'package:bringly_app/features/auth/presentation/auth_blocked_state_view.dart';
import 'package:bringly_app/features/auth/presentation/local_unlock_screen.dart';
import 'package:bringly_app/features/auth/presentation/login_screen.dart';
import 'package:bringly_app/features/auth/presentation/onboarding_screen.dart';
import 'package:bringly_app/features/auth/presentation/password_reset_screen.dart';
import 'package:bringly_app/features/auth/presentation/register_screen.dart';
import 'package:bringly_app/features/app_shell/domain/entities/marketplace_destination.dart';
import 'package:bringly_app/features/app_shell/presentation/marketplace_shell.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/presentation/foundation_shell.dart';
import 'package:bringly_app/features/foundation/domain/entities/foundation_destination.dart';
import 'package:bringly_app/features/app_shell/presentation/design_system_demo_screen.dart';
import 'package:bringly_app/features/profile/application/profile_controller.dart';
import 'package:bringly_app/features/profile/application/load_profile_summary.dart';
import 'package:bringly_app/features/profile/application/update_basic_profile.dart';
import 'package:bringly_app/features/profile/application/update_marketplace_role.dart';
import 'package:bringly_app/features/profile/data/in_memory_profile_repository.dart';
import 'package:bringly_app/features/profile/presentation/profile_edit_screen.dart';
import 'package:bringly_app/features/profile/presentation/role_selection_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({
  required AppConfig appConfig,
  required SafeLogger logger,
  required AnalyticsReporter analyticsReporter,
  required RunProtectedStorageSmokeTest runProtectedStorageSmokeTest,
  required RunConnectivityCheck runConnectivityCheck,
  AuthController? authController,
  ProfileController? profileController,
}) {
  final authRepository = InMemoryAuthRepository();
  final profileRepository = InMemoryProfileRepository();
  final resolvedAuthController =
      authController ??
      AuthController(
        signUpWithEmail: SignUpWithEmail(authRepository),
        signInWithEmail: SignInWithEmail(authRepository),
        restoreSession: RestoreSession(authRepository),
        requireLocalUnlock: RequireLocalUnlock(
          LocalUnlockRepository(LocalAuthAppUnlock()),
        ),
        signOut: SignOut(authRepository),
        requestPasswordReset: RequestPasswordReset(authRepository),
      );
  final resolvedProfileController =
      profileController ??
      ProfileController(
        loadProfileSummary: LoadProfileSummary(profileRepository),
        updateBasicProfile: UpdateBasicProfile(profileRepository),
        updateMarketplaceRole: UpdateMarketplaceRole(profileRepository),
      );

  if (authController == null) {
    unawaited(resolvedAuthController.restore());
  }

  FoundationShell buildFoundationShell(FoundationDestinationId destination) {
    return FoundationShell(
      destination: destination,
      appConfig: appConfig,
      logger: logger,
      analyticsReporter: analyticsReporter,
      runProtectedStorageSmokeTest: runProtectedStorageSmokeTest,
      runConnectivityCheck: runConnectivityCheck,
    );
  }

  String initialLocationForAuthState() {
    if (!appConfig.isValid) {
      return '/';
    }

    return switch (resolvedAuthController.state.status) {
      AuthControllerStatus.signedInLocked => '/local-unlock',
      AuthControllerStatus.signedInUnlocked => '/shopper',
      AuthControllerStatus.expired || AuthControllerStatus.unauthorized => '/login',
      AuthControllerStatus.registered => '/marketplace-blocked?reason=emailConfirmationRequired',
      _ => '/onboarding',
    };
  }

  return GoRouter(
    // Phase 1: launch into the marketplace shell only when public runtime
    // configuration is valid. Invalid configuration keeps the Phase 0 blocked
    // startup path as the first screen.
    initialLocation: initialLocationForAuthState(),
    refreshListenable: resolvedAuthController,
    redirect: (context, state) {
      final path = state.uri.path;
      final isFoundationRoute =
          path == '/' ||
          path == '/config' ||
          path == '/connectivity' ||
          path == '/ui-states';

      if (!appConfig.isValid) {
        return isFoundationRoute ? null : '/';
      }

      const authPaths = <String>{
        '/onboarding',
        '/register',
        '/login',
        '/password-reset',
        '/local-unlock',
      };

      return switch (resolvedAuthController.state.status) {
        AuthControllerStatus.signedInLocked =>
          path == '/local-unlock' ? null : '/local-unlock',
        AuthControllerStatus.signedInUnlocked =>
          authPaths.contains(path) ? '/shopper' : null,
        AuthControllerStatus.expired || AuthControllerStatus.unauthorized =>
          path == '/login' ? null : '/login',
        AuthControllerStatus.registered => path == '/marketplace-blocked'
            ? null
            : '/marketplace-blocked?reason=emailConfirmationRequired',
        AuthControllerStatus.signedOut ||
        AuthControllerStatus.empty ||
        AuthControllerStatus.error ||
        AuthControllerStatus.loading =>
          isFoundationRoute || authPaths.contains(path) ? null : '/onboarding',
        _ => null,
      };
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(
          controller: resolvedAuthController,
          onRegister: () => context.go('/register'),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(
          controller: resolvedAuthController,
          onRegistered: () => context.go(
            '/marketplace-blocked?reason=emailConfirmationRequired',
          ),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(
          controller: resolvedAuthController,
          onLoggedIn: () => context.go('/local-unlock'),
          onForgotPassword: () => context.go('/password-reset'),
        ),
      ),
      GoRoute(
        path: '/password-reset',
        builder: (context, state) => PasswordResetScreen(
          controller: resolvedAuthController,
        ),
      ),
      GoRoute(
        path: '/local-unlock',
        builder: (context, state) => LocalUnlockScreen(
          controller: resolvedAuthController,
          onUnlocked: () => context.go('/shopper'),
          onSignedOut: () => context.go('/login'),
        ),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => RoleSelectionScreen(
          controller: resolvedProfileController,
          onSaved: () => context.go(
            '/marketplace-blocked?reason=emailConfirmationRequired',
          ),
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => ProfileEditScreen(
          controller: resolvedProfileController,
          onSaved: () => context.go('/profile'),
        ),
      ),
      GoRoute(
        path: '/marketplace-blocked',
        builder: (context, state) {
          final reason = switch (state.uri.queryParameters['reason']) {
            'verificationRequired' =>
              ProtectedMarketplaceGateReason.verificationRequired,
            _ => ProtectedMarketplaceGateReason.emailConfirmationRequired,
          };

          return CupertinoPageScaffold(
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: AuthBlockedStateView(
                    reason: reason,
                    actionLabel: 'Review role',
                    onAction: () => context.go('/role-selection'),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      // -----------------------------------------------------------------------
      // Phase 1: Marketplace shell — four primary tab destinations.
      // Each destination renders a safe placeholder; no business logic.
      // -----------------------------------------------------------------------
      GoRoute(
        path: '/shopper',
        builder: (context, state) => const MarketplaceShell(
          activeDestinationId: MarketplaceDestinationId.shopper,
        ),
      ),
      GoRoute(
        path: '/traveler',
        builder: (context, state) => const MarketplaceShell(
          activeDestinationId: MarketplaceDestinationId.traveler,
        ),
      ),
      GoRoute(
        path: '/activity',
        builder: (context, state) => const MarketplaceShell(
          activeDestinationId: MarketplaceDestinationId.activity,
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => MarketplaceShell(
          activeDestinationId: MarketplaceDestinationId.profile,
          profileController: resolvedProfileController,
          authController: resolvedAuthController,
          onEditProfile: () => context.go('/profile/edit'),
          onChangeRole: () => context.go('/role-selection'),
          onSignOut: () => context.go('/onboarding'),
          onDesignSystemDemo: () => context.go('/design-system'),
        ),
      ),
      // -----------------------------------------------------------------------
      // Phase 1: Design System Demo — non-primary, reachable from Profile.
      // -----------------------------------------------------------------------
      GoRoute(
        path: '/design-system',
        builder: (context, state) => const DesignSystemDemoScreen(),
      ),
      // -----------------------------------------------------------------------
      // Phase 0: Foundation routes — preserved for developer tooling.
      // -----------------------------------------------------------------------
      GoRoute(
        path: '/',
        builder: (context, state) =>
            buildFoundationShell(FoundationDestinationId.startup),
      ),
      GoRoute(
        path: '/config',
        builder: (context, state) =>
            buildFoundationShell(FoundationDestinationId.configurationStatus),
      ),
      GoRoute(
        path: '/connectivity',
        builder: (context, state) =>
            buildFoundationShell(FoundationDestinationId.connectivity),
      ),
      GoRoute(
        path: '/ui-states',
        builder: (context, state) =>
            buildFoundationShell(FoundationDestinationId.uiStateDemo),
      ),
    ],
  );
}

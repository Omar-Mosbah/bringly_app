import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/application/sign_in_with_email.dart';
import 'package:bringly_app/features/auth/application/sign_out.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:bringly_app/features/profile/presentation/logout_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../auth/data/fake_auth_repository.dart';

void main() {
  AuthAccountSnapshot buildSnapshot() {
    return AuthAccountSnapshot(
      safeAccountId: 'acct-profile-123',
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

  AuthController buildController({
    AuthFailure? signOutFailure,
    AuthControllerState? initialState,
  }) {
    final repository = FakeAuthRepository(seededSnapshot: buildSnapshot())
      ..nextSignOutFailure = signOutFailure;

    return AuthController(
      signUpWithEmail: SignUpWithEmail(repository),
      signInWithEmail: SignInWithEmail(repository),
      signOut: SignOut(repository),
      initialState: initialState ?? AuthControllerState.signedInUnlocked(buildSnapshot()),
    );
  }

  Future<void> pumpAction(
    WidgetTester tester, {
    required AuthController controller,
    VoidCallback? onSignedOut,
  }) {
    return tester.pumpWidget(
      CupertinoApp(
        home: CupertinoPageScaffold(
          child: Center(
            child: LogoutAction(
              controller: controller,
              onSignedOut: onSignedOut,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('logout action asks for confirmation before signing out', (tester) async {
    final controller = buildController();

    await pumpAction(tester, controller: controller);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Sign out of this device?'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('logout action shows loading state', (tester) async {
    final controller = buildController(
      initialState: const AuthControllerState.loading(),
    );

    await pumpAction(tester, controller: controller);

    expect(find.byType(CupertinoActivityIndicator), findsWidgets);
  });

  testWidgets('logout action signs out locally on success and server unavailable states', (tester) async {
    Future<void> expectSignOut({AuthFailure? failure, String? message}) async {
      final controller = buildController(signOutFailure: failure);
      var signedOut = 0;

      await pumpAction(tester, controller: controller, onSignedOut: () => signedOut += 1);
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(signedOut, 1);
      if (message != null) {
        expect(find.text(message), findsOneWidget);
      }
    }

    await expectSignOut(message: 'You have been signed out securely.');
    await expectSignOut(
      failure: const AuthFailure.serviceUnavailable(),
      message: 'You have been signed out on this device. Server confirmation will retry later.',
    );
  });
}
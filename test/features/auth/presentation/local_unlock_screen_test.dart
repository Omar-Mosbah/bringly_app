import 'package:bringly_app/core/security/local_app_unlock.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/application/require_local_unlock.dart';
import 'package:bringly_app/features/auth/application/sign_in_with_email.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/data/local_unlock_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/auth/domain/entities/local_unlock_state.dart';
import 'package:bringly_app/features/auth/presentation/local_unlock_screen.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../core/security/fake_local_app_unlock.dart';
import '../data/fake_auth_repository.dart';

void main() {
  AuthAccountSnapshot buildSnapshot() {
    return const AuthAccountSnapshot(
      safeAccountId: 'acct-1',
      session: AuthSession(
        state: AuthSessionState.signedInRequiresUnlock,
        requiresLocalUnlock: true,
      ),
      emailConfirmationStatus: EmailConfirmationStatus.confirmed,
      accountRestriction: AccountRestriction.active,
      marketplaceRole: MarketplaceRole.shopper,
      verificationStatus: VerificationStatus.verified,
    );
  }

  AuthController buildController({
    required LocalUnlockState unlockState,
    LocalAppUnlockResult nextResult = LocalAppUnlockResult.unlocked,
    AuthControllerState? initialState,
  }) {
    return AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
      signInWithEmail: SignInWithEmail(FakeAuthRepository()),
      requireLocalUnlock: RequireLocalUnlock(
        LocalUnlockRepository(
          FakeLocalAppUnlock(
            availability: LocalAppUnlockStatus(
              availability: unlockState.availability,
              method: unlockState.method,
            ),
            nextResult: nextResult,
          ),
        ),
      ),
      initialState:
          initialState ?? AuthControllerState.signedInLocked(buildSnapshot(), unlockState: unlockState),
    );
  }

  Future<void> pumpScreen(
    WidgetTester tester, {
    required AuthController controller,
    VoidCallback? onUnlocked,
    VoidCallback? onSignedOut,
  }) {
    return tester.pumpWidget(
      CupertinoApp(
        home: LocalUnlockScreen(
          controller: controller,
          onUnlocked: onUnlocked,
          onSignedOut: onSignedOut,
        ),
      ),
    );
  }

  Finder unlockButton() => find.descendant(
        of: find.byKey(const ValueKey<String>('local_unlock_button')),
        matching: find.byType(CupertinoButton),
      );

  testWidgets('shows required and in-progress unlock states', (tester) async {
    final requiredController = buildController(
      unlockState: const LocalUnlockState(
        availability: LocalAppUnlockAvailability.availableBiometric,
        method: LocalAppUnlockMethod.biometric,
        phase: LocalUnlockPhase.required,
      ),
    );
    final loadingController = buildController(
      unlockState: const LocalUnlockState(
        availability: LocalAppUnlockAvailability.availableBiometric,
        method: LocalAppUnlockMethod.biometric,
        phase: LocalUnlockPhase.inProgress,
      ),
      initialState: AuthControllerState.loading(),
    );

    await pumpScreen(tester, controller: requiredController);
    expect(find.text('Unlock required'), findsOneWidget);

    await pumpScreen(tester, controller: loadingController);
    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
  });

  testWidgets('unlocks successfully and calls the unlocked callback', (tester) async {
    final controller = buildController(
      unlockState: const LocalUnlockState(
        availability: LocalAppUnlockAvailability.availableBiometric,
        method: LocalAppUnlockMethod.biometric,
        phase: LocalUnlockPhase.required,
      ),
    );
    var unlocked = 0;

    await pumpScreen(tester, controller: controller, onUnlocked: () => unlocked += 1);
    await tester.tap(unlockButton());
    await tester.pumpAndSettle();

    expect(unlocked, 1);
  });

  testWidgets('shows failed cancelled locked-out unavailable and signed-out states', (tester) async {
    Future<void> expectState({
      required AuthController controller,
      required String message,
      VoidCallback? onSignedOut,
    }) async {
      await pumpScreen(tester, controller: controller, onSignedOut: onSignedOut);
      expect(find.text(message), findsOneWidget);
    }

    await expectState(
      controller: buildController(
        unlockState: const LocalUnlockState(
          availability: LocalAppUnlockAvailability.availableBiometric,
          method: LocalAppUnlockMethod.biometric,
          phase: LocalUnlockPhase.failed,
        ),
        initialState: AuthControllerState.signedInLocked(
          buildSnapshot(),
          unlockState: const LocalUnlockState(
            availability: LocalAppUnlockAvailability.availableBiometric,
            method: LocalAppUnlockMethod.biometric,
            phase: LocalUnlockPhase.failed,
          ),
        ),
      ),
      message: 'Local unlock could not be completed.',
    );
    await expectState(
      controller: buildController(
        unlockState: const LocalUnlockState(
          availability: LocalAppUnlockAvailability.availableBiometric,
          method: LocalAppUnlockMethod.biometric,
          phase: LocalUnlockPhase.cancelled,
        ),
        initialState: AuthControllerState.signedInLocked(
          buildSnapshot(),
          unlockState: const LocalUnlockState(
            availability: LocalAppUnlockAvailability.availableBiometric,
            method: LocalAppUnlockMethod.biometric,
            phase: LocalUnlockPhase.cancelled,
          ),
        ),
      ),
      message: 'Local unlock was cancelled.',
    );
    await expectState(
      controller: buildController(
        unlockState: const LocalUnlockState(
          availability: LocalAppUnlockAvailability.lockedOut,
          method: LocalAppUnlockMethod.biometric,
          phase: LocalUnlockPhase.lockedOut,
        ),
        initialState: AuthControllerState.signedInLocked(
          buildSnapshot(),
          unlockState: const LocalUnlockState(
            availability: LocalAppUnlockAvailability.lockedOut,
            method: LocalAppUnlockMethod.biometric,
            phase: LocalUnlockPhase.lockedOut,
          ),
        ),
      ),
      message: 'Local unlock is temporarily locked.',
    );
    await expectState(
      controller: buildController(
        unlockState: const LocalUnlockState(
          availability: LocalAppUnlockAvailability.unavailable,
          method: LocalAppUnlockMethod.unavailable,
          phase: LocalUnlockPhase.required,
        ),
        initialState: AuthControllerState.signedInLocked(
          buildSnapshot(),
          unlockState: const LocalUnlockState(
            availability: LocalAppUnlockAvailability.unavailable,
            method: LocalAppUnlockMethod.unavailable,
            phase: LocalUnlockPhase.required,
          ),
        ),
      ),
      message: 'Local unlock is not available on this device.',
    );

    var signedOut = 0;
    await expectState(
      controller: AuthController(
        signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
        signInWithEmail: SignInWithEmail(FakeAuthRepository()),
        initialState: const AuthControllerState.signedOut(),
      ),
      message: 'You have been signed out.',
      onSignedOut: () => signedOut += 1,
    );
    await tester.tap(find.text('Back to sign in'));
    await tester.pump();
    expect(signedOut, 1);
  });
}
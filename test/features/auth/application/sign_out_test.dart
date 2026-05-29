import 'package:bringly_app/features/auth/application/sign_out.dart';
import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_auth_repository.dart';

void main() {
  AuthAccountSnapshot buildSnapshot() {
    return AuthAccountSnapshot(
      safeAccountId: 'acct-logout-123',
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

  test('sign out succeeds for a normal authenticated session', () async {
    final repository = FakeAuthRepository(seededSnapshot: buildSnapshot());
    final useCase = SignOut(repository);

    final result = await useCase();

    expect(result.status, SignOutStatus.signedOut);
    expect(repository.currentSnapshot, isNull);
  });

  test('sign out clears local access even when server confirmation is unavailable', () async {
    final repository = FakeAuthRepository(seededSnapshot: buildSnapshot())
      ..nextSignOutFailure = const AuthFailure.offline();
    final useCase = SignOut(repository);

    final result = await useCase();

    expect(result.status, SignOutStatus.signedOutLocally);
    expect(result.failure?.code, AuthFailureCode.offline);
    expect(repository.currentSnapshot, isNull);
  });

  test('sign out handles missing session and safe unknown failure', () async {
    final missingSessionResult = await SignOut(FakeAuthRepository())();
    final unknownRepository = FakeAuthRepository(seededSnapshot: buildSnapshot())
      ..nextSignOutFailure = const AuthFailure.unknownSafeFailure();
    final unknownResult = await SignOut(unknownRepository)();

    expect(missingSessionResult.status, SignOutStatus.signedOut);
    expect(unknownResult.status, SignOutStatus.signedOutLocally);
    expect(unknownResult.failure?.code, AuthFailureCode.unknownSafeFailure);
    expect(unknownRepository.currentSnapshot, isNull);
  });
}
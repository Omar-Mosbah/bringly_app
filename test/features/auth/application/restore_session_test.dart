import 'package:bringly_app/features/auth/application/restore_session.dart';
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

  test('restore session succeeds with a valid stored session', () async {
    final repository = FakeAuthRepository(
      seededSnapshot: buildSnapshot(AuthSessionState.signedInRequiresUnlock),
    );
    final useCase = RestoreSession(repository);

    final result = await useCase();

    expect(result.status, RestoreSessionStatus.restored);
    expect(result.snapshot?.session.blocksProtectedContent, isTrue);
  });

  test('restore session returns missing when there is no stored session', () async {
    final useCase = RestoreSession(FakeAuthRepository());

    final result = await useCase();

    expect(result.status, RestoreSessionStatus.missingSession);
    expect(result.snapshot, isNull);
  });

  test('restore session distinguishes expired unauthorized forced logout and unavailable states', () async {
    final expiredUseCase = RestoreSession(
      FakeAuthRepository(
        seededSnapshot: buildSnapshot(AuthSessionState.expired),
      ),
    );
    final unauthorizedUseCase = RestoreSession(
      FakeAuthRepository()..nextRestoreFailure = const AuthFailure.unauthorized(),
    );
    final forcedLogoutUseCase = RestoreSession(
      FakeAuthRepository()..nextRestoreFailure = const AuthFailure.forcedLogout(),
    );
    final unavailableUseCase = RestoreSession(
      FakeAuthRepository()..nextRestoreFailure = const AuthFailure.serviceUnavailable(),
    );
    final offlineUseCase = RestoreSession(
      FakeAuthRepository()..nextRestoreFailure = const AuthFailure.offline(),
    );

    expect((await expiredUseCase()).status, RestoreSessionStatus.expired);
    expect((await unauthorizedUseCase()).status, RestoreSessionStatus.unauthorized);
    expect((await forcedLogoutUseCase()).status, RestoreSessionStatus.forcedLogout);
    expect((await unavailableUseCase()).status, RestoreSessionStatus.unavailable);
    expect((await offlineUseCase()).status, RestoreSessionStatus.unavailable);
  });
}
import 'package:bringly_app/features/auth/application/protected_marketplace_gate.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final gate = ProtectedMarketplaceGate();

  test('allows protected access when session is unlocked and requirements are met', () {
    final result = gate(
      session: const AuthSession(state: AuthSessionState.signedInUnlocked),
      emailConfirmationStatus: EmailConfirmationStatus.confirmed,
      verificationStatus: VerificationStatus.verified,
      accountRestriction: AccountRestriction.active,
    );

    expect(result.isAllowed, isTrue);
    expect(result.reason, ProtectedMarketplaceGateReason.allowed);
  });

  test('blocks protected access for unconfirmed email', () {
    final result = gate(
      session: const AuthSession(
        state: AuthSessionState.signedInUnlocked,
        requiresLocalUnlock: false,
      ),
      emailConfirmationStatus: EmailConfirmationStatus.pending,
      verificationStatus: VerificationStatus.verified,
      accountRestriction: AccountRestriction.active,
    );

    expect(result.isAllowed, isFalse);
    expect(result.reason, ProtectedMarketplaceGateReason.emailConfirmationRequired);
  });

  test('blocks protected access for incomplete verification', () {
    final result = gate(
      session: const AuthSession(
        state: AuthSessionState.signedInUnlocked,
        requiresLocalUnlock: false,
      ),
      emailConfirmationStatus: EmailConfirmationStatus.confirmed,
      verificationStatus: VerificationStatus.incomplete,
      accountRestriction: AccountRestriction.active,
    );

    expect(result.isAllowed, isFalse);
    expect(result.reason, ProtectedMarketplaceGateReason.verificationRequired);
  });
}
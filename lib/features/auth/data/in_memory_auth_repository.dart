import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';

class InMemoryAuthRepository extends AuthRepository {
  final Map<String, String> _registeredPasswordsByEmail = <String, String>{};
  AuthAccountSnapshot? _currentSnapshot;

  final Set<String> unavailableEmails = <String>{};

  @override
  Future<AuthRepositoryResult<AuthAccountSnapshot>> registerWithEmail({
    required EmailAddress email,
    required PasswordInput password,
    required MarketplaceRole initialMarketplaceRole,
  }) async {
    if (!email.isValid || !password.isValid) {
      return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
        AuthFailure.invalidInput(),
      );
    }

    if (unavailableEmails.contains(email.value)) {
      return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
        AuthFailure.invalidInput(
          message: 'That email cannot be used for registration right now.',
        ),
      );
    }

    final snapshot = AuthAccountSnapshot(
      safeAccountId: 'acct-${email.value.hashCode.abs()}',
      session: const AuthSession(
        state: AuthSessionState.signedInRequiresUnlock,
        requiresLocalUnlock: true,
      ),
      emailConfirmationStatus: EmailConfirmationStatus.pending,
      accountRestriction: AccountRestriction.active,
      marketplaceRole: initialMarketplaceRole,
      verificationStatus: VerificationStatus.incomplete,
    );

    _registeredPasswordsByEmail[email.value] = password.value;
    _currentSnapshot = snapshot;

    return AuthRepositoryResult<AuthAccountSnapshot>.success(snapshot);
  }

  @override
  Future<AuthRepositoryResult<AuthAccountSnapshot>> signInWithEmail({
    required EmailAddress email,
    required PasswordInput password,
  }) async {
    final registeredPassword = _registeredPasswordsByEmail[email.value];
    if (registeredPassword == null || registeredPassword != password.value) {
      return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
        AuthFailure.invalidCredentials(),
      );
    }

    final snapshot = AuthAccountSnapshot(
      safeAccountId: 'acct-${email.value.hashCode.abs()}',
      session: const AuthSession(
        state: AuthSessionState.signedInRequiresUnlock,
        requiresLocalUnlock: true,
      ),
      emailConfirmationStatus:
          _currentSnapshot?.emailConfirmationStatus ?? EmailConfirmationStatus.confirmed,
      accountRestriction:
          _currentSnapshot?.accountRestriction ?? AccountRestriction.active,
      marketplaceRole: _currentSnapshot?.marketplaceRole ?? MarketplaceRole.shopper,
      verificationStatus:
          _currentSnapshot?.verificationStatus ?? VerificationStatus.incomplete,
    );

    _currentSnapshot = snapshot;
    return AuthRepositoryResult<AuthAccountSnapshot>.success(snapshot);
  }

  @override
  Future<AuthRepositoryResult<AuthAccountSnapshot?>> restoreSession() async {
    return AuthRepositoryResult<AuthAccountSnapshot?>.success(_currentSnapshot);
  }

  @override
  Future<AuthRepositoryResult<void>> requestPasswordReset({
    required EmailAddress email,
  }) async {
    if (!email.isValid) {
      return const AuthRepositoryResult<void>.failure(AuthFailure.invalidInput());
    }

    return const AuthRepositoryResult<void>.success(null);
  }

  @override
  Future<AuthRepositoryResult<void>> signOut() async {
    _currentSnapshot = null;
    return const AuthRepositoryResult<void>.success(null);
  }
}
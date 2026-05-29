import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';

class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository({AuthAccountSnapshot? seededSnapshot})
    : _currentSnapshot = seededSnapshot;

  final Map<String, String> _registeredPasswordsByEmail = <String, String>{};
  AuthAccountSnapshot? _currentSnapshot;

  AuthFailure? nextRegisterFailure;
  AuthFailure? nextSignInFailure;
  AuthFailure? nextRestoreFailure;
  AuthFailure? nextPasswordResetFailure;
  AuthFailure? nextSignOutFailure;
  final Set<String> unavailableEmails = <String>{};

  AuthAccountSnapshot? get currentSnapshot => _currentSnapshot;

  @override
  Future<AuthRepositoryResult<AuthAccountSnapshot>> registerWithEmail({
    required EmailAddress email,
    required PasswordInput password,
    required MarketplaceRole initialMarketplaceRole,
  }) async {
    final failure = _consumeFailure(() => nextRegisterFailure = null, nextRegisterFailure);
    if (failure != null) {
      return AuthRepositoryResult<AuthAccountSnapshot>.failure(failure);
    }

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
      safeAccountId: _buildSafeAccountId(email.value),
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
    final failure = _consumeFailure(() => nextSignInFailure = null, nextSignInFailure);
    if (failure != null) {
      return AuthRepositoryResult<AuthAccountSnapshot>.failure(failure);
    }

    final registeredPassword = _registeredPasswordsByEmail[email.value];
    if (registeredPassword == null || registeredPassword != password.value) {
      return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
        AuthFailure.invalidCredentials(),
      );
    }

    final snapshot = AuthAccountSnapshot(
      safeAccountId: _buildSafeAccountId(email.value),
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
    final failure = _consumeFailure(() => nextRestoreFailure = null, nextRestoreFailure);
    if (failure != null) {
      return AuthRepositoryResult<AuthAccountSnapshot?>.failure(failure);
    }

    return AuthRepositoryResult<AuthAccountSnapshot?>.success(_currentSnapshot);
  }

  @override
  Future<AuthRepositoryResult<void>> requestPasswordReset({
    required EmailAddress email,
  }) async {
    final failure = _consumeFailure(
      () => nextPasswordResetFailure = null,
      nextPasswordResetFailure,
    );
    if (failure != null) {
      return AuthRepositoryResult<void>.failure(failure);
    }

    if (!email.isValid) {
      return const AuthRepositoryResult<void>.failure(AuthFailure.invalidInput());
    }

    return const AuthRepositoryResult<void>.success(null);
  }

  @override
  Future<AuthRepositoryResult<void>> signOut() async {
    final failure = _consumeFailure(() => nextSignOutFailure = null, nextSignOutFailure);
    if (failure != null) {
      _currentSnapshot = null;
      return AuthRepositoryResult<void>.failure(failure);
    }

    _currentSnapshot = null;
    return const AuthRepositoryResult<void>.success(null);
  }

  AuthFailure? _consumeFailure(void Function() clear, AuthFailure? failure) {
    if (failure == null) {
      return null;
    }

    clear();
    return failure;
  }

  String _buildSafeAccountId(String normalizedEmail) {
    return 'acct-${normalizedEmail.hashCode.abs()}';
  }
}
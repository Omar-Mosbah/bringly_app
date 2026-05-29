import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';

class AuthRepositoryResult<T> {
  const AuthRepositoryResult.success(this.value)
    : failure = null,
      isSuccess = true;

  const AuthRepositoryResult.failure(this.failure)
    : value = null,
      isSuccess = false;

  final T? value;
  final AuthFailure? failure;
  final bool isSuccess;
}

class AuthAccountSnapshot {
  const AuthAccountSnapshot({
    required this.safeAccountId,
    required this.session,
    required this.emailConfirmationStatus,
    required this.accountRestriction,
    this.marketplaceRole = MarketplaceRole.unavailable,
    this.verificationStatus = VerificationStatus.incomplete,
  });

  final String safeAccountId;
  final AuthSession session;
  final EmailConfirmationStatus emailConfirmationStatus;
  final AccountRestriction accountRestriction;
  final MarketplaceRole marketplaceRole;
  final VerificationStatus verificationStatus;

  AuthAccountSnapshot copyWith({
    String? safeAccountId,
    AuthSession? session,
    EmailConfirmationStatus? emailConfirmationStatus,
    AccountRestriction? accountRestriction,
    MarketplaceRole? marketplaceRole,
    VerificationStatus? verificationStatus,
  }) {
    return AuthAccountSnapshot(
      safeAccountId: safeAccountId ?? this.safeAccountId,
      session: session ?? this.session,
      emailConfirmationStatus:
          emailConfirmationStatus ?? this.emailConfirmationStatus,
      accountRestriction: accountRestriction ?? this.accountRestriction,
      marketplaceRole: marketplaceRole ?? this.marketplaceRole,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }
}

abstract class AuthRepository {
  const AuthRepository();

  Future<AuthRepositoryResult<AuthAccountSnapshot>> registerWithEmail({
    required EmailAddress email,
    required PasswordInput password,
    required MarketplaceRole initialMarketplaceRole,
  });

  Future<AuthRepositoryResult<AuthAccountSnapshot>> signInWithEmail({
    required EmailAddress email,
    required PasswordInput password,
  });

  Future<AuthRepositoryResult<AuthAccountSnapshot?>> restoreSession();

  Future<AuthRepositoryResult<void>> requestPasswordReset({
    required EmailAddress email,
  });

  Future<AuthRepositoryResult<void>> signOut();
}
import 'dart:convert';

import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/data/protected_auth_storage.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository extends AuthRepository {
  SupabaseAuthRepository({
    required GoTrueClient authClient,
    required ProtectedAuthStorage protectedAuthStorage,
  }) : _authClient = authClient,
       _protectedAuthStorage = protectedAuthStorage;

  final GoTrueClient _authClient;
  final ProtectedAuthStorage _protectedAuthStorage;

  @override
  Future<AuthRepositoryResult<AuthAccountSnapshot>> registerWithEmail({
    required EmailAddress email,
    required PasswordInput password,
    required MarketplaceRole initialMarketplaceRole,
  }) async {
    try {
      final response = await _authClient.signUp(
        email: email.value,
        password: password.value,
        data: <String, dynamic>{
          'marketplace_role': initialMarketplaceRole.name,
        },
      );

      final user = response.user ?? response.session?.user;
      if (user == null) {
        return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
          AuthFailure.unknownSafeFailure(),
        );
      }

      if (response.session != null) {
        await _persistSession(response.session!);
      }

      return AuthRepositoryResult<AuthAccountSnapshot>.success(
        _snapshotFromUser(
          user,
          session: response.session,
          initialRole: initialMarketplaceRole,
        ),
      );
    } on AuthException catch (error) {
      return AuthRepositoryResult<AuthAccountSnapshot>.failure(
        _mapAuthFailure(error, fallback: const AuthFailure.unknownSafeFailure()),
      );
    } catch (_) {
      return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
        AuthFailure.unknownSafeFailure(),
      );
    }
  }

  @override
  Future<AuthRepositoryResult<AuthAccountSnapshot>> signInWithEmail({
    required EmailAddress email,
    required PasswordInput password,
  }) async {
    try {
      final response = await _authClient.signInWithPassword(
        email: email.value,
        password: password.value,
      );
      final session = response.session;
      final user = response.user ?? session?.user;
      if (session == null || user == null) {
        return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
          AuthFailure.invalidCredentials(),
        );
      }

      await _persistSession(session);
      final snapshot = _snapshotFromUser(user, session: session);
      final restriction = snapshot.accountRestriction;
      if (restriction == AccountRestriction.blocked) {
        return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
          AuthFailure.blocked(),
        );
      }
      if (restriction == AccountRestriction.suspended) {
        return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
          AuthFailure.suspended(),
        );
      }

      return AuthRepositoryResult<AuthAccountSnapshot>.success(snapshot);
    } on AuthException catch (error) {
      return AuthRepositoryResult<AuthAccountSnapshot>.failure(
        _mapAuthFailure(error, fallback: const AuthFailure.invalidCredentials()),
      );
    } catch (_) {
      return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
        AuthFailure.unknownSafeFailure(),
      );
    }
  }

  @override
  Future<AuthRepositoryResult<AuthAccountSnapshot?>> restoreSession() async {
    final storedSession = await _protectedAuthStorage.readSession();
    if (storedSession == null) {
      return const AuthRepositoryResult<AuthAccountSnapshot?>.success(null);
    }

    try {
      final response = await _authClient.setSession(
        storedSession.refreshToken,
        accessToken: storedSession.accessToken,
      );
      final session = response.session ?? _authClient.currentSession;
      final user = session?.user ?? response.user;
      if (session == null || user == null) {
        await _protectedAuthStorage.clearSession();
        return const AuthRepositoryResult<AuthAccountSnapshot?>.success(null);
      }

      await _persistSession(session);
      final snapshot = _snapshotFromUser(user, session: session);
      if (snapshot.accountRestriction == AccountRestriction.forcedLogoutRequired) {
        await _protectedAuthStorage.clearSession();
        await _authClient.signOut();
        return const AuthRepositoryResult<AuthAccountSnapshot?>.failure(
          AuthFailure.forcedLogout(),
        );
      }

      return AuthRepositoryResult<AuthAccountSnapshot?>.success(snapshot);
    } on AuthException catch (error) {
      await _protectedAuthStorage.clearSession();
      return AuthRepositoryResult<AuthAccountSnapshot?>.failure(
        _mapAuthFailure(error, fallback: const AuthFailure.unauthorized()),
      );
    } catch (_) {
      await _protectedAuthStorage.clearSession();
      return const AuthRepositoryResult<AuthAccountSnapshot?>.failure(
        AuthFailure.serviceUnavailable(),
      );
    }
  }

  @override
  Future<AuthRepositoryResult<void>> requestPasswordReset({
    required EmailAddress email,
  }) async {
    try {
      await _authClient.resetPasswordForEmail(email.value);
      return const AuthRepositoryResult<void>.success(null);
    } on AuthException catch (error) {
      return AuthRepositoryResult<void>.failure(
        _mapAuthFailure(error, fallback: const AuthFailure.unknownSafeFailure()),
      );
    } catch (_) {
      return const AuthRepositoryResult<void>.failure(
        AuthFailure.serviceUnavailable(),
      );
    }
  }

  @override
  Future<AuthRepositoryResult<void>> signOut() async {
    await _protectedAuthStorage.clearSession();

    try {
      await _authClient.signOut();
      return const AuthRepositoryResult<void>.success(null);
    } on AuthException catch (error) {
      return AuthRepositoryResult<void>.failure(
        _mapAuthFailure(error, fallback: const AuthFailure.serviceUnavailable()),
      );
    } catch (_) {
      return const AuthRepositoryResult<void>.failure(
        AuthFailure.serviceUnavailable(),
      );
    }
  }

  Future<void> _persistSession(Session session) {
    return _protectedAuthStorage.writeSession(
      ProtectedAuthSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken ?? '',
        serializedSession: jsonEncode(session.toJson()),
      ),
    );
  }

  AuthAccountSnapshot _snapshotFromUser(
    User user, {
    Session? session,
    MarketplaceRole? initialRole,
  }) {
    final userMetadata = user.userMetadata ?? const <String, dynamic>{};
    final appMetadata = user.appMetadata;
    final restriction = _accountRestrictionFrom(
      appMetadata['account_restriction']?.toString() ??
          userMetadata['account_restriction']?.toString(),
    );

    return AuthAccountSnapshot(
      safeAccountId: 'acct-${user.id.hashCode.abs()}',
      session: AuthSession(
        state: session == null
            ? AuthSessionState.signedOut
            : AuthSessionState.signedInRequiresUnlock,
        requiresLocalUnlock: session != null,
      ),
      emailConfirmationStatus: user.emailConfirmedAt == null
          ? EmailConfirmationStatus.pending
          : EmailConfirmationStatus.confirmed,
      accountRestriction: restriction,
      marketplaceRole: _marketplaceRoleFrom(
        userMetadata['marketplace_role']?.toString() ?? initialRole?.name,
      ),
      verificationStatus: _verificationStatusFrom(
        appMetadata['verification_status']?.toString() ??
            userMetadata['verification_status']?.toString(),
      ),
    );
  }

  AuthFailure _mapAuthFailure(AuthException error, {required AuthFailure fallback}) {
    if (error is AuthWeakPasswordException) {
      return const AuthFailure.weakPassword();
    }

    return switch (error.statusCode) {
      '400' when error.code == 'email_exists' => const AuthFailure.invalidInput(
          message: 'That email cannot be used for registration right now.',
        ),
      '400' when error.code == 'invalid_credentials' =>
        const AuthFailure.invalidCredentials(),
      '400' when error.code == 'email_address_invalid' => const AuthFailure.invalidInput(),
      '401' => const AuthFailure.unauthorized(),
      '429' => const AuthFailure.rateLimited(),
      '500' || '502' || '503' || '504' => const AuthFailure.serviceUnavailable(),
      _ when error is AuthRetryableFetchException => const AuthFailure.offline(),
      _ => fallback,
    };
  }

  MarketplaceRole _marketplaceRoleFrom(String? value) {
    return switch (value) {
      'shopper' => MarketplaceRole.shopper,
      'traveler' => MarketplaceRole.traveler,
      'both' => MarketplaceRole.both,
      _ => MarketplaceRole.unavailable,
    };
  }

  VerificationStatus _verificationStatusFrom(String? value) {
    return switch (value) {
      'verified' => VerificationStatus.verified,
      'underReview' || 'under_review' => VerificationStatus.underReview,
      'rejected' => VerificationStatus.rejected,
      'blocked' => VerificationStatus.blocked,
      'unavailable' => VerificationStatus.unavailable,
      _ => VerificationStatus.incomplete,
    };
  }

  AccountRestriction _accountRestrictionFrom(String? value) {
    return switch (value) {
      'suspended' => AccountRestriction.suspended,
      'blocked' => AccountRestriction.blocked,
      'forcedLogoutRequired' || 'forced_logout_required' =>
        AccountRestriction.forcedLogoutRequired,
      _ => AccountRestriction.active,
    };
  }
}
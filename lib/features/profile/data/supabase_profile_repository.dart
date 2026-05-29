import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProfileRepository extends ProfileRepository {
  SupabaseProfileRepository({required GoTrueClient authClient})
    : _authClient = authClient;

  final GoTrueClient _authClient;

  @override
  Future<ProfileRepositoryResult<UserProfile?>> loadProfileSummary() async {
    try {
      final user = _authClient.currentUser ?? (await _authClient.getUser()).user;
      if (user == null) {
        return const ProfileRepositoryResult<UserProfile?>.failure(
          ProfileRepositoryFailure(
            code: ProfileRepositoryFailureCode.unauthorized,
            message: 'Sign in again to continue.',
            retryAllowed: true,
          ),
        );
      }

      return ProfileRepositoryResult<UserProfile?>.success(_profileFromUser(user));
    } on AuthException catch (error) {
      return ProfileRepositoryResult<UserProfile?>.failure(_mapFailure(error));
    } catch (_) {
      return const ProfileRepositoryResult<UserProfile?>.failure(
        ProfileRepositoryFailure(
          code: ProfileRepositoryFailureCode.serviceUnavailable,
          message: 'The service is unavailable right now.',
          retryAllowed: true,
        ),
      );
    }
  }

  @override
  Future<ProfileRepositoryResult<UserProfile>> updateBasicProfile({
    required DisplayName displayName,
    String? avatarReference,
    required CountryCity countryCity,
    required PreferredLanguage preferredLanguage,
  }) async {
    try {
      final currentUser = _authClient.currentUser;
      if (currentUser == null) {
        return const ProfileRepositoryResult<UserProfile>.failure(
          ProfileRepositoryFailure(
            code: ProfileRepositoryFailureCode.unauthorized,
            message: 'Sign in again to continue.',
            retryAllowed: true,
          ),
        );
      }

      final userMetadata = <String, dynamic>{
        ...(currentUser.userMetadata ?? const <String, dynamic>{}),
        'display_name': displayName.value,
        'avatar_reference': avatarReference,
        'country': countryCity.country,
        'city': countryCity.city,
        'preferred_language': preferredLanguage.value,
      };

      final updatedUser =
          (await _authClient.updateUser(UserAttributes(data: userMetadata))).user;
      if (updatedUser == null) {
        return const ProfileRepositoryResult<UserProfile>.failure(
          ProfileRepositoryFailure(
            code: ProfileRepositoryFailureCode.unknownSafeFailure,
            message: 'Something went wrong. Please try again.',
            retryAllowed: true,
          ),
        );
      }

      return ProfileRepositoryResult<UserProfile>.success(
        _profileFromUser(updatedUser),
      );
    } on AuthException catch (error) {
      return ProfileRepositoryResult<UserProfile>.failure(_mapFailure(error));
    } catch (_) {
      return const ProfileRepositoryResult<UserProfile>.failure(
        ProfileRepositoryFailure(
          code: ProfileRepositoryFailureCode.serviceUnavailable,
          message: 'The service is unavailable right now.',
          retryAllowed: true,
        ),
      );
    }
  }

  @override
  Future<ProfileRepositoryResult<UserProfile>> updateMarketplaceRole({
    required MarketplaceRole marketplaceRole,
  }) async {
    try {
      final currentUser = _authClient.currentUser;
      if (currentUser == null) {
        return const ProfileRepositoryResult<UserProfile>.failure(
          ProfileRepositoryFailure(
            code: ProfileRepositoryFailureCode.unauthorized,
            message: 'Sign in again to continue.',
            retryAllowed: true,
          ),
        );
      }

      final userMetadata = <String, dynamic>{
        ...(currentUser.userMetadata ?? const <String, dynamic>{}),
        'marketplace_role': marketplaceRole.name,
      };

      final updatedUser =
          (await _authClient.updateUser(UserAttributes(data: userMetadata))).user;
      if (updatedUser == null) {
        return const ProfileRepositoryResult<UserProfile>.failure(
          ProfileRepositoryFailure(
            code: ProfileRepositoryFailureCode.unknownSafeFailure,
            message: 'Something went wrong. Please try again.',
            retryAllowed: true,
          ),
        );
      }

      return ProfileRepositoryResult<UserProfile>.success(
        _profileFromUser(updatedUser),
      );
    } on AuthException catch (error) {
      return ProfileRepositoryResult<UserProfile>.failure(_mapFailure(error));
    } catch (_) {
      return const ProfileRepositoryResult<UserProfile>.failure(
        ProfileRepositoryFailure(
          code: ProfileRepositoryFailureCode.serviceUnavailable,
          message: 'The service is unavailable right now.',
          retryAllowed: true,
        ),
      );
    }
  }

  UserProfile _profileFromUser(User user) {
    final userMetadata = user.userMetadata ?? const <String, dynamic>{};
    final appMetadata = user.appMetadata;

    return UserProfile(
      displayName: DisplayName(
        userMetadata['display_name']?.toString() ?? 'Bringly User',
      ),
      avatarReference: userMetadata['avatar_reference']?.toString(),
      countryCity: CountryCity(
        country: userMetadata['country']?.toString() ?? 'Portugal',
        city: userMetadata['city']?.toString() ?? 'Lisbon',
      ),
      preferredLanguage: PreferredLanguage(
        userMetadata['preferred_language']?.toString() ?? 'en',
      ),
      marketplaceRole: _marketplaceRoleFrom(
        userMetadata['marketplace_role']?.toString(),
      ),
      emailConfirmationStatus: user.emailConfirmedAt == null
          ? EmailConfirmationStatus.pending
          : EmailConfirmationStatus.confirmed,
      verificationStatus: _verificationStatusFrom(
        appMetadata['verification_status']?.toString() ??
            userMetadata['verification_status']?.toString(),
      ),
      accountRestriction: _accountRestrictionFrom(
        appMetadata['account_restriction']?.toString() ??
            userMetadata['account_restriction']?.toString(),
      ),
      profileCompletenessLabel:
          userMetadata['profile_completeness']?.toString() ?? 'basic-ready',
    );
  }

  ProfileRepositoryFailure _mapFailure(AuthException error) {
    return switch (error.statusCode) {
      '401' => const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.unauthorized,
        message: 'Sign in again to continue.',
        retryAllowed: true,
      ),
      '429' => const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.serviceUnavailable,
        message: 'The service is unavailable right now.',
        retryAllowed: true,
      ),
      '500' || '502' || '503' || '504' => const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.serviceUnavailable,
        message: 'The service is unavailable right now.',
        retryAllowed: true,
      ),
      _ when error is AuthRetryableFetchException => const ProfileRepositoryFailure(
          code: ProfileRepositoryFailureCode.offline,
          message: 'No network connection is available right now.',
          retryAllowed: true,
        ),
      _ => const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.unknownSafeFailure,
        message: 'Something went wrong. Please try again.',
        retryAllowed: true,
      ),
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
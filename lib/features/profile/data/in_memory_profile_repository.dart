import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';

class InMemoryProfileRepository extends ProfileRepository {
  UserProfile? _currentProfile;

  final Set<MarketplaceRole> unavailableRoles = <MarketplaceRole>{};
  final Set<MarketplaceRole> backendRejectedRoles = <MarketplaceRole>{};

  @override
  Future<ProfileRepositoryResult<UserProfile?>> loadProfileSummary() async {
    return ProfileRepositoryResult<UserProfile?>.success(_currentProfile);
  }

  @override
  Future<ProfileRepositoryResult<UserProfile>> updateBasicProfile({
    required DisplayName displayName,
    String? avatarReference,
    required CountryCity countryCity,
    required PreferredLanguage preferredLanguage,
  }) async {
    if (!displayName.isValid) {
      return const ProfileRepositoryResult<UserProfile>.failure(
        ProfileRepositoryFailure(
          code: ProfileRepositoryFailureCode.invalidDisplayName,
          message: 'Display name is invalid.',
        ),
      );
    }

    if (!countryCity.isValid) {
      return const ProfileRepositoryResult<UserProfile>.failure(
        ProfileRepositoryFailure(
          code: ProfileRepositoryFailureCode.invalidCountryCity,
          message: 'Country and city are invalid.',
        ),
      );
    }

    if (!preferredLanguage.isValid) {
      return const ProfileRepositoryResult<UserProfile>.failure(
        ProfileRepositoryFailure(
          code: ProfileRepositoryFailureCode.unsupportedLanguage,
          message: 'Preferred language is not supported.',
        ),
      );
    }

    final profile = UserProfile(
      displayName: displayName,
      avatarReference: avatarReference,
      countryCity: countryCity,
      preferredLanguage: preferredLanguage,
      marketplaceRole: _currentProfile?.marketplaceRole ?? MarketplaceRole.shopper,
      emailConfirmationStatus:
          _currentProfile?.emailConfirmationStatus ?? EmailConfirmationStatus.pending,
      verificationStatus:
          _currentProfile?.verificationStatus ?? VerificationStatus.incomplete,
      accountRestriction: _currentProfile?.accountRestriction ?? AccountRestriction.active,
      profileCompletenessLabel: 'basic-ready',
    );

    _currentProfile = profile;
    return ProfileRepositoryResult<UserProfile>.success(profile);
  }

  @override
  Future<ProfileRepositoryResult<UserProfile>> updateMarketplaceRole({
    required MarketplaceRole marketplaceRole,
  }) async {
    if (unavailableRoles.contains(marketplaceRole)) {
      return const ProfileRepositoryResult<UserProfile>.failure(
        ProfileRepositoryFailure(
          code: ProfileRepositoryFailureCode.roleUnavailable,
          message: 'This role is not available right now.',
        ),
      );
    }

    if (backendRejectedRoles.contains(marketplaceRole)) {
      return const ProfileRepositoryResult<UserProfile>.failure(
        ProfileRepositoryFailure(
          code: ProfileRepositoryFailureCode.backendRejectedEligibility,
          message: 'The backend rejected this role selection.',
        ),
      );
    }

    final profile = UserProfile(
      displayName: _currentProfile?.displayName ?? DisplayName('Bringly User'),
      avatarReference: _currentProfile?.avatarReference,
      countryCity:
          _currentProfile?.countryCity ?? CountryCity(country: 'Portugal', city: 'Lisbon'),
      preferredLanguage: _currentProfile?.preferredLanguage ?? PreferredLanguage('en'),
      marketplaceRole: marketplaceRole,
      emailConfirmationStatus:
          _currentProfile?.emailConfirmationStatus ?? EmailConfirmationStatus.pending,
      verificationStatus:
          _currentProfile?.verificationStatus ?? VerificationStatus.incomplete,
      accountRestriction: _currentProfile?.accountRestriction ?? AccountRestriction.active,
      profileCompletenessLabel:
          _currentProfile?.profileCompletenessLabel ?? 'basic-ready',
    );

    _currentProfile = profile;
    return ProfileRepositoryResult<UserProfile>.success(profile);
  }
}
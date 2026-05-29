import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';

class FakeProfileRepository extends ProfileRepository {
  FakeProfileRepository({UserProfile? seededProfile}) : _currentProfile = seededProfile;

  UserProfile? _currentProfile;

  ProfileRepositoryFailure? nextLoadFailure;
  ProfileRepositoryFailure? nextUpdateFailure;
  ProfileRepositoryFailure? nextRoleFailure;
  final Set<MarketplaceRole> unavailableRoles = <MarketplaceRole>{};
  final Set<MarketplaceRole> backendRejectedRoles = <MarketplaceRole>{};

  UserProfile? get currentProfile => _currentProfile;

  @override
  Future<ProfileRepositoryResult<UserProfile?>> loadProfileSummary() async {
    final failure = _consumeFailure(() => nextLoadFailure = null, nextLoadFailure);
    if (failure != null) {
      return ProfileRepositoryResult<UserProfile?>.failure(failure);
    }

    return ProfileRepositoryResult<UserProfile?>.success(_currentProfile);
  }

  @override
  Future<ProfileRepositoryResult<UserProfile>> updateBasicProfile({
    required DisplayName displayName,
    String? avatarReference,
    required CountryCity countryCity,
    required PreferredLanguage preferredLanguage,
  }) async {
    final failure = _consumeFailure(() => nextUpdateFailure = null, nextUpdateFailure);
    if (failure != null) {
      return ProfileRepositoryResult<UserProfile>.failure(failure);
    }

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

    if (avatarReference != null && avatarReference.trim().isEmpty) {
      return const ProfileRepositoryResult<UserProfile>.failure(
        ProfileRepositoryFailure(
          code: ProfileRepositoryFailureCode.invalidAvatarReference,
          message: 'Avatar reference is invalid.',
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
    final failure = _consumeFailure(() => nextRoleFailure = null, nextRoleFailure);
    if (failure != null) {
      return ProfileRepositoryResult<UserProfile>.failure(failure);
    }

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

  ProfileRepositoryFailure? _consumeFailure(
    void Function() clear,
    ProfileRepositoryFailure? failure,
  ) {
    if (failure == null) {
      return null;
    }

    clear();
    return failure;
  }
}
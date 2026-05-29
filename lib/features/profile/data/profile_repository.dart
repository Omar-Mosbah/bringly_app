import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';

enum ProfileRepositoryFailureCode {
  invalidDisplayName,
  invalidAvatarReference,
  invalidCountryCity,
  unsupportedLanguage,
  roleUnavailable,
  backendRejectedEligibility,
  unauthorized,
  suspended,
  blocked,
  offline,
  serviceUnavailable,
  unknownSafeFailure,
}

class ProfileRepositoryFailure {
  const ProfileRepositoryFailure({
    required this.code,
    required this.message,
    this.retryAllowed = false,
  });

  final ProfileRepositoryFailureCode code;
  final String message;
  final bool retryAllowed;
}

class ProfileRepositoryResult<T> {
  const ProfileRepositoryResult.success(this.value)
    : failure = null,
      isSuccess = true;

  const ProfileRepositoryResult.failure(this.failure)
    : value = null,
      isSuccess = false;

  final T? value;
  final ProfileRepositoryFailure? failure;
  final bool isSuccess;
}

abstract class ProfileRepository {
  const ProfileRepository();

  Future<ProfileRepositoryResult<UserProfile?>> loadProfileSummary();

  Future<ProfileRepositoryResult<UserProfile>> updateBasicProfile({
    required DisplayName displayName,
    String? avatarReference,
    required CountryCity countryCity,
    required PreferredLanguage preferredLanguage,
  });

  Future<ProfileRepositoryResult<UserProfile>> updateMarketplaceRole({
    required MarketplaceRole marketplaceRole,
  });
}
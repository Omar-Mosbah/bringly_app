import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';

class UpdateBasicProfile {
  const UpdateBasicProfile(this._profileRepository);

  final ProfileRepository _profileRepository;

  Future<ProfileRepositoryResult<UserProfile>> call({
    required String displayName,
    String? avatarReference,
    required String country,
    required String city,
    required String preferredLanguageCode,
  }) {
    final displayNameValue = DisplayName(displayName);
    if (!displayNameValue.isValid) {
      return Future.value(
        const ProfileRepositoryResult<UserProfile>.failure(
          ProfileRepositoryFailure(
            code: ProfileRepositoryFailureCode.invalidDisplayName,
            message: 'Display name is invalid.',
          ),
        ),
      );
    }

    final countryCity = CountryCity(country: country, city: city);
    if (!countryCity.isValid) {
      return Future.value(
        const ProfileRepositoryResult<UserProfile>.failure(
          ProfileRepositoryFailure(
            code: ProfileRepositoryFailureCode.invalidCountryCity,
            message: 'Country and city are invalid.',
          ),
        ),
      );
    }

    final preferredLanguage = PreferredLanguage(preferredLanguageCode);
    if (!preferredLanguage.isValid) {
      return Future.value(
        const ProfileRepositoryResult<UserProfile>.failure(
          ProfileRepositoryFailure(
            code: ProfileRepositoryFailureCode.unsupportedLanguage,
            message: 'Preferred language is not supported.',
          ),
        ),
      );
    }

    if (avatarReference != null && avatarReference.trim().isEmpty) {
      return Future.value(
        const ProfileRepositoryResult<UserProfile>.failure(
          ProfileRepositoryFailure(
            code: ProfileRepositoryFailureCode.invalidAvatarReference,
            message: 'Avatar reference is invalid.',
          ),
        ),
      );
    }

    return _profileRepository.updateBasicProfile(
      displayName: displayNameValue,
      avatarReference: avatarReference,
      countryCity: countryCity,
      preferredLanguage: preferredLanguage,
    );
  }
}
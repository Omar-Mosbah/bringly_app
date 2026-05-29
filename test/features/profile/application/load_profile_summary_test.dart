import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/application/load_profile_summary.dart';
import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_profile_repository.dart';

void main() {
  UserProfile buildProfile({
    VerificationStatus verificationStatus = VerificationStatus.verified,
    EmailConfirmationStatus emailStatus = EmailConfirmationStatus.confirmed,
    AccountRestriction restriction = AccountRestriction.active,
  }) {
    return UserProfile(
      displayName: DisplayName('Bringly Tester'),
      avatarReference: 'avatar://tester',
      countryCity: CountryCity(country: 'Portugal', city: 'Lisbon'),
      preferredLanguage: PreferredLanguage('en'),
      marketplaceRole: MarketplaceRole.both,
      emailConfirmationStatus: emailStatus,
      verificationStatus: verificationStatus,
      accountRestriction: restriction,
      profileCompletenessLabel: 'basic-ready',
    );
  }

  test('load profile summary returns empty and success states safely', () async {
    final emptyResult = await LoadProfileSummary(FakeProfileRepository())();
    final loadedResult = await LoadProfileSummary(
      FakeProfileRepository(seededProfile: buildProfile()),
    )();

    expect(emptyResult.isSuccess, isTrue);
    expect(emptyResult.value, isNull);
    expect(loadedResult.isSuccess, isTrue);
    expect(loadedResult.value?.displayName.value, 'Bringly Tester');
  });

  test('load profile summary surfaces unauthorized blocked offline and safe failures', () async {
    Future<void> expectFailure(ProfileRepositoryFailure failure) async {
      final repository = FakeProfileRepository()..nextLoadFailure = failure;
      final result = await LoadProfileSummary(repository)();

      expect(result.isSuccess, isFalse);
      expect(result.failure?.code, failure.code);
    }

    await expectFailure(
      const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.unauthorized,
        message: 'Unauthorized.',
      ),
    );
    await expectFailure(
      const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.blocked,
        message: 'Blocked.',
      ),
    );
    await expectFailure(
      const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.offline,
        message: 'Offline.',
      ),
    );
    await expectFailure(
      const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.unknownSafeFailure,
        message: 'Something went wrong.',
      ),
    );
  });
}
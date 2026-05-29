import 'package:bringly_app/features/profile/application/update_basic_profile.dart';
import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_profile_repository.dart';

void main() {
  test('updates basic profile fields successfully', () async {
    final result = await UpdateBasicProfile(FakeProfileRepository())(
      displayName: 'Bringly Tester',
      avatarReference: 'avatar://tester',
      country: 'Portugal',
      city: 'Lisbon',
      preferredLanguageCode: 'en',
    );

    expect(result.isSuccess, isTrue);
    expect(result.value?.displayName.value, 'Bringly Tester');
    expect(result.value?.countryCity.displayValue, 'Lisbon, Portugal');
  });

  test('rejects invalid display name country city and language inputs', () async {
    final useCase = UpdateBasicProfile(FakeProfileRepository());

    expect(
      (await useCase(
        displayName: 'A',
        avatarReference: 'avatar://tester',
        country: 'Portugal',
        city: 'Lisbon',
        preferredLanguageCode: 'en',
      )).failure?.code,
      ProfileRepositoryFailureCode.invalidDisplayName,
    );
    expect(
      (await useCase(
        displayName: 'Bringly Tester',
        avatarReference: 'avatar://tester',
        country: '',
        city: '',
        preferredLanguageCode: 'en',
      )).failure?.code,
      ProfileRepositoryFailureCode.invalidCountryCity,
    );
    expect(
      (await useCase(
        displayName: 'Bringly Tester',
        avatarReference: 'avatar://tester',
        country: 'Portugal',
        city: 'Lisbon',
        preferredLanguageCode: 'de',
      )).failure?.code,
      ProfileRepositoryFailureCode.unsupportedLanguage,
    );
  });

  test('propagates unauthorized blocked and offline failures', () async {
    Future<void> expectFailure(ProfileRepositoryFailure failure) async {
      final repository = FakeProfileRepository()..nextUpdateFailure = failure;
      final result = await UpdateBasicProfile(repository)(
        displayName: 'Bringly Tester',
        avatarReference: 'avatar://tester',
        country: 'Portugal',
        city: 'Lisbon',
        preferredLanguageCode: 'en',
      );

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
  });
}
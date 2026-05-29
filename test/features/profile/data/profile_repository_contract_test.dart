import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_profile_repository.dart';

void main() {
  test('fake profile repository loads empty and then stores updated basics', () async {
    final repository = FakeProfileRepository();

    final initialResult = await repository.loadProfileSummary();
    final updateResult = await repository.updateBasicProfile(
      displayName: DisplayName('Bringly User'),
      avatarReference: 'avatars/bringly-user.png',
      countryCity: CountryCity(country: 'Portugal', city: 'Lisbon'),
      preferredLanguage: PreferredLanguage('en'),
    );

    expect(initialResult.isSuccess, isTrue);
    expect(initialResult.value, isNull);
    expect(updateResult.isSuccess, isTrue);
    expect(updateResult.value?.displayName.value, 'Bringly User');
  });

  test('fake profile repository returns safe role availability failures', () async {
    final repository = FakeProfileRepository()
      ..unavailableRoles.add(MarketplaceRole.traveler);

    final result = await repository.updateMarketplaceRole(
      marketplaceRole: MarketplaceRole.traveler,
    );

    expect(result.isSuccess, isFalse);
    expect(result.failure?.code, ProfileRepositoryFailureCode.roleUnavailable);
  });
}
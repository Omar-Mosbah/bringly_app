import 'package:bringly_app/features/profile/application/update_marketplace_role.dart';
import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_profile_repository.dart';

void main() {
  test('updates shopper traveler and both roles successfully', () async {
    final repository = FakeProfileRepository();
    final useCase = UpdateMarketplaceRole(repository);

    final shopperResult = await useCase(marketplaceRole: MarketplaceRole.shopper);
    final travelerResult = await useCase(marketplaceRole: MarketplaceRole.traveler);
    final bothResult = await useCase(marketplaceRole: MarketplaceRole.both);

    expect(shopperResult.isSuccess, isTrue);
    expect(travelerResult.isSuccess, isTrue);
    expect(bothResult.isSuccess, isTrue);
    expect(bothResult.value?.marketplaceRole, MarketplaceRole.both);
  });

  test('rejects unavailable role selections safely', () async {
    final repository = FakeProfileRepository()
      ..unavailableRoles.add(MarketplaceRole.unavailable);
    final useCase = UpdateMarketplaceRole(repository);

    final result = await useCase(marketplaceRole: MarketplaceRole.unavailable);

    expect(result.isSuccess, isFalse);
    expect(result.failure?.code, ProfileRepositoryFailureCode.roleUnavailable);
  });

  test('propagates unauthorized and backend rejected role failures', () async {
    final unauthorizedRepository = FakeProfileRepository()
      ..nextRoleFailure = const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.unauthorized,
        message: 'Unauthorized.',
      );
    final rejectedRepository = FakeProfileRepository()
      ..backendRejectedRoles.add(MarketplaceRole.traveler);

    final unauthorizedResult = await UpdateMarketplaceRole(unauthorizedRepository)(
      marketplaceRole: MarketplaceRole.shopper,
    );
    final rejectedResult = await UpdateMarketplaceRole(rejectedRepository)(
      marketplaceRole: MarketplaceRole.traveler,
    );

    expect(unauthorizedResult.failure?.code, ProfileRepositoryFailureCode.unauthorized);
    expect(
      rejectedResult.failure?.code,
      ProfileRepositoryFailureCode.backendRejectedEligibility,
    );
  });
}
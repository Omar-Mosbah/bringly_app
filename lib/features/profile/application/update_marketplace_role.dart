import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';

class UpdateMarketplaceRole {
  const UpdateMarketplaceRole(this._profileRepository);

  final ProfileRepository _profileRepository;

  Future<ProfileRepositoryResult<UserProfile>> call({
    required MarketplaceRole marketplaceRole,
  }) {
    return _profileRepository.updateMarketplaceRole(
      marketplaceRole: marketplaceRole,
    );
  }
}
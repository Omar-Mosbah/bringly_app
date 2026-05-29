import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';

class LoadProfileSummary {
  const LoadProfileSummary(this._profileRepository);

  final ProfileRepository _profileRepository;

  Future<ProfileRepositoryResult<UserProfile?>> call() {
    return _profileRepository.loadProfileSummary();
  }
}
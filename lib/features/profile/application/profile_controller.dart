import 'package:bringly_app/features/profile/application/load_profile_summary.dart';
import 'package:bringly_app/features/profile/application/update_basic_profile.dart';
import 'package:bringly_app/features/profile/application/update_marketplace_role.dart';
import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:flutter/foundation.dart';

enum ProfileControllerStatus { idle, loading, empty, loaded, updated, error }

class ProfileControllerState {
  const ProfileControllerState._({
    required this.status,
    this.profile,
    this.failure,
  });

  const ProfileControllerState.idle()
    : this._(status: ProfileControllerStatus.idle);

  const ProfileControllerState.loading()
    : this._(status: ProfileControllerStatus.loading);

  const ProfileControllerState.empty()
    : this._(status: ProfileControllerStatus.empty);

  const ProfileControllerState.loaded(UserProfile profile)
    : this._(status: ProfileControllerStatus.loaded, profile: profile);

  const ProfileControllerState.updated(UserProfile profile)
    : this._(status: ProfileControllerStatus.updated, profile: profile);

  const ProfileControllerState.error(ProfileRepositoryFailure failure)
    : this._(status: ProfileControllerStatus.error, failure: failure);

  final ProfileControllerStatus status;
  final UserProfile? profile;
  final ProfileRepositoryFailure? failure;

  bool get isLoading => status == ProfileControllerStatus.loading;
}

class ProfileController extends ChangeNotifier {
  ProfileController({
    required UpdateMarketplaceRole updateMarketplaceRole,
    LoadProfileSummary? loadProfileSummary,
    UpdateBasicProfile? updateBasicProfile,
    ProfileControllerState initialState = const ProfileControllerState.idle(),
  }) : _updateMarketplaceRole = updateMarketplaceRole,
       _loadProfileSummary = loadProfileSummary,
       _updateBasicProfile = updateBasicProfile,
       _state = initialState;

  final UpdateMarketplaceRole _updateMarketplaceRole;
  final LoadProfileSummary? _loadProfileSummary;
  final UpdateBasicProfile? _updateBasicProfile;

  ProfileControllerState _state;

  ProfileControllerState get state => _state;

  Future<void> loadSummary() async {
    final useCase = _loadProfileSummary;
    if (useCase == null) {
      return;
    }

    _state = const ProfileControllerState.loading();
    notifyListeners();

    final result = await useCase();
    if (result.isSuccess) {
      final profile = result.value;
      _state = profile == null
          ? const ProfileControllerState.empty()
          : ProfileControllerState.loaded(profile);
    } else {
      _state = ProfileControllerState.error(
        result.failure ??
            const ProfileRepositoryFailure(
              code: ProfileRepositoryFailureCode.unknownSafeFailure,
              message: 'Something went wrong. Please try again.',
              retryAllowed: true,
            ),
      );
    }

    notifyListeners();
  }

  Future<void> updateProfile({
    required String displayName,
    String? avatarReference,
    required String country,
    required String city,
    required String preferredLanguageCode,
  }) async {
    final useCase = _updateBasicProfile;
    if (useCase == null) {
      return;
    }

    _state = const ProfileControllerState.loading();
    notifyListeners();

    final result = await useCase(
      displayName: displayName,
      avatarReference: avatarReference,
      country: country,
      city: city,
      preferredLanguageCode: preferredLanguageCode,
    );

    if (result.isSuccess && result.value != null) {
      _state = ProfileControllerState.updated(result.value!);
    } else {
      _state = ProfileControllerState.error(
        result.failure ??
            const ProfileRepositoryFailure(
              code: ProfileRepositoryFailureCode.unknownSafeFailure,
              message: 'Something went wrong. Please try again.',
              retryAllowed: true,
            ),
      );
    }

    notifyListeners();
  }

  Future<void> updateRole({required MarketplaceRole marketplaceRole}) async {
    _state = const ProfileControllerState.loading();
    notifyListeners();

    final result = await _updateMarketplaceRole(marketplaceRole: marketplaceRole);
    if (result.isSuccess && result.value != null) {
      _state = ProfileControllerState.updated(result.value!);
    } else {
      _state = ProfileControllerState.error(
        result.failure ??
            const ProfileRepositoryFailure(
              code: ProfileRepositoryFailureCode.unknownSafeFailure,
              message: 'Something went wrong. Please try again.',
              retryAllowed: true,
            ),
      );
    }

    notifyListeners();
  }
}
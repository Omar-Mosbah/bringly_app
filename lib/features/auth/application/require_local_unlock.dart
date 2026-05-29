import 'package:bringly_app/core/security/local_app_unlock.dart';
import 'package:bringly_app/features/auth/data/local_unlock_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/local_unlock_state.dart';

enum RequireLocalUnlockStatus {
  unlocked,
  unavailable,
  disabled,
  cancelled,
  failed,
  lockedOut,
}

class RequireLocalUnlockResult {
  const RequireLocalUnlockResult({
    required this.status,
    this.state,
    this.failure,
  });

  final RequireLocalUnlockStatus status;
  final LocalUnlockState? state;
  final AuthFailure? failure;
}

class RequireLocalUnlock {
  const RequireLocalUnlock(this._localUnlockRepository);

  final LocalUnlockRepository _localUnlockRepository;

  Future<void> reset() {
    return _localUnlockRepository.reset();
  }

  Future<RequireLocalUnlockResult> call({required String reason}) async {
    final availability = await _localUnlockRepository.checkAvailability();

    switch (availability.availability) {
      case LocalAppUnlockAvailability.unavailable:
        return RequireLocalUnlockResult(
          status: RequireLocalUnlockStatus.unavailable,
          state: availability,
        );
      case LocalAppUnlockAvailability.disabled:
        return RequireLocalUnlockResult(
          status: RequireLocalUnlockStatus.disabled,
          state: availability,
        );
      case LocalAppUnlockAvailability.lockedOut:
        return RequireLocalUnlockResult(
          status: RequireLocalUnlockStatus.lockedOut,
          state: availability,
        );
      case LocalAppUnlockAvailability.availableBiometric:
      case LocalAppUnlockAvailability.availableDevicePin:
      case LocalAppUnlockAvailability.unknown:
        break;
    }

    final result = await _localUnlockRepository.requestUnlock(reason: reason);
    if (result.isSuccess) {
      return RequireLocalUnlockResult(
        status: RequireLocalUnlockStatus.unlocked,
        state: result.state,
      );
    }

    return switch (result.state?.phase) {
      LocalUnlockPhase.cancelled => RequireLocalUnlockResult(
        status: RequireLocalUnlockStatus.cancelled,
        state: result.state,
        failure: result.failure,
      ),
      LocalUnlockPhase.lockedOut => RequireLocalUnlockResult(
        status: RequireLocalUnlockStatus.lockedOut,
        state: result.state,
        failure: result.failure,
      ),
      _ => RequireLocalUnlockResult(
        status: RequireLocalUnlockStatus.failed,
        state: result.state,
        failure: result.failure,
      ),
    };
  }
}
import 'package:bringly_app/core/security/local_app_unlock.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/local_unlock_state.dart';

class LocalUnlockRepositoryResult {
  const LocalUnlockRepositoryResult.success(this.state) : failure = null;

  const LocalUnlockRepositoryResult.failure(this.failure, {this.state});

  final LocalUnlockState? state;
  final AuthFailure? failure;

  bool get isSuccess => failure == null;
}

class LocalUnlockRepository {
  const LocalUnlockRepository(this._localAppUnlock);

  final LocalAppUnlock _localAppUnlock;

  Future<LocalUnlockState> checkAvailability() async {
    try {
      final status = await _localAppUnlock.checkAvailability();

      return LocalUnlockState(
        availability: status.availability,
        method: status.method,
        phase: LocalUnlockPhase.required,
      );
    } catch (_) {
      return const LocalUnlockState(
        availability: LocalAppUnlockAvailability.unknown,
        method: LocalAppUnlockMethod.unavailable,
        phase: LocalUnlockPhase.required,
        lastAttemptResult: LocalAppUnlockResult.error,
      );
    }
  }

  Future<LocalUnlockRepositoryResult> requestUnlock({
    required String reason,
  }) async {
    final availability = await checkAvailability();

    if (!availability.canPromptUnlock) {
      return LocalUnlockRepositoryResult.failure(
        const AuthFailure.localUnlockFailed(
          message: 'Local unlock is not available on this device.',
        ),
        state: LocalUnlockState(
          availability: availability.availability,
          method: availability.method,
          phase: LocalUnlockPhase.failed,
          lastAttemptResult: LocalAppUnlockResult.notAvailable,
        ),
      );
    }

    try {
      final result = await _localAppUnlock.requestUnlock(reason: reason);

      return switch (result) {
        LocalAppUnlockResult.unlocked => LocalUnlockRepositoryResult.success(
          LocalUnlockState(
            availability: availability.availability,
            method: availability.method,
            phase: LocalUnlockPhase.unlocked,
            lastAttemptResult: result,
          ),
        ),
        LocalAppUnlockResult.cancelled => LocalUnlockRepositoryResult.failure(
          const AuthFailure.localUnlockFailed(
            message: 'Local unlock was cancelled.',
          ),
          state: LocalUnlockState(
            availability: availability.availability,
            method: availability.method,
            phase: LocalUnlockPhase.cancelled,
            lastAttemptResult: result,
          ),
        ),
        LocalAppUnlockResult.lockedOut => LocalUnlockRepositoryResult.failure(
          const AuthFailure.localUnlockFailed(
            message: 'Local unlock is temporarily locked.',
          ),
          state: LocalUnlockState(
            availability: availability.availability,
            method: availability.method,
            phase: LocalUnlockPhase.lockedOut,
            lastAttemptResult: result,
          ),
        ),
        LocalAppUnlockResult.notAvailable => LocalUnlockRepositoryResult.failure(
          const AuthFailure.localUnlockFailed(
            message: 'Local unlock is not available on this device.',
          ),
          state: LocalUnlockState(
            availability: availability.availability,
            method: availability.method,
            phase: LocalUnlockPhase.failed,
            lastAttemptResult: result,
          ),
        ),
        LocalAppUnlockResult.failed || LocalAppUnlockResult.error =>
          LocalUnlockRepositoryResult.failure(
            const AuthFailure.localUnlockFailed(),
            state: LocalUnlockState(
              availability: availability.availability,
              method: availability.method,
              phase: LocalUnlockPhase.failed,
              lastAttemptResult: result,
            ),
          ),
      };
    } catch (_) {
      return LocalUnlockRepositoryResult.failure(
        const AuthFailure.localUnlockFailed(),
        state: LocalUnlockState(
          availability: availability.availability,
          method: availability.method,
          phase: LocalUnlockPhase.failed,
          lastAttemptResult: LocalAppUnlockResult.error,
        ),
      );
    }
  }

  Future<void> reset() {
    return _localAppUnlock.reset();
  }
}
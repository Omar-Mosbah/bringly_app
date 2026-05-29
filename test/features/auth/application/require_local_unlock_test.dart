import 'package:bringly_app/core/security/local_app_unlock.dart';
import 'package:bringly_app/features/auth/application/require_local_unlock.dart';
import 'package:bringly_app/features/auth/data/local_unlock_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../core/security/fake_local_app_unlock.dart';

void main() {
  RequireLocalUnlock buildUseCase({
    required LocalAppUnlockStatus availability,
    LocalAppUnlockResult result = LocalAppUnlockResult.unlocked,
  }) {
    return RequireLocalUnlock(
      LocalUnlockRepository(
        FakeLocalAppUnlock(
          availability: availability,
          nextResult: result,
        ),
      ),
    );
  }

  test('local unlock succeeds when biometric unlock is available', () async {
    final useCase = buildUseCase(
      availability: const LocalAppUnlockStatus(
        availability: LocalAppUnlockAvailability.availableBiometric,
        method: LocalAppUnlockMethod.biometric,
      ),
    );

    final result = await useCase(reason: 'Unlock Bringly');

    expect(result.status, RequireLocalUnlockStatus.unlocked);
    expect(result.state?.method, LocalAppUnlockMethod.biometric);
  });

  test('local unlock preserves device pin fallback availability', () async {
    final useCase = buildUseCase(
      availability: const LocalAppUnlockStatus(
        availability: LocalAppUnlockAvailability.availableDevicePin,
        method: LocalAppUnlockMethod.devicePin,
      ),
    );

    final result = await useCase(reason: 'Unlock Bringly');

    expect(result.status, RequireLocalUnlockStatus.unlocked);
    expect(result.state?.method, LocalAppUnlockMethod.devicePin);
  });

  test('local unlock maps unavailable disabled cancelled failed and locked out states', () async {
    expect(
      (await buildUseCase(
        availability: const LocalAppUnlockStatus(
          availability: LocalAppUnlockAvailability.unavailable,
          method: LocalAppUnlockMethod.unavailable,
        ),
      )(reason: 'Unlock Bringly')).status,
      RequireLocalUnlockStatus.unavailable,
    );
    expect(
      (await buildUseCase(
        availability: const LocalAppUnlockStatus(
          availability: LocalAppUnlockAvailability.disabled,
          method: LocalAppUnlockMethod.unavailable,
        ),
      )(reason: 'Unlock Bringly')).status,
      RequireLocalUnlockStatus.disabled,
    );
    expect(
      (await buildUseCase(
        availability: const LocalAppUnlockStatus(
          availability: LocalAppUnlockAvailability.availableBiometric,
          method: LocalAppUnlockMethod.biometric,
        ),
        result: LocalAppUnlockResult.cancelled,
      )(reason: 'Unlock Bringly')).status,
      RequireLocalUnlockStatus.cancelled,
    );
    expect(
      (await buildUseCase(
        availability: const LocalAppUnlockStatus(
          availability: LocalAppUnlockAvailability.availableBiometric,
          method: LocalAppUnlockMethod.biometric,
        ),
        result: LocalAppUnlockResult.failed,
      )(reason: 'Unlock Bringly')).status,
      RequireLocalUnlockStatus.failed,
    );
    expect(
      (await buildUseCase(
        availability: const LocalAppUnlockStatus(
          availability: LocalAppUnlockAvailability.availableBiometric,
          method: LocalAppUnlockMethod.biometric,
        ),
        result: LocalAppUnlockResult.lockedOut,
      )(reason: 'Unlock Bringly')).status,
      RequireLocalUnlockStatus.lockedOut,
    );
  });
}
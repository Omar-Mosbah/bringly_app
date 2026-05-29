import 'package:bringly_app/core/security/local_app_unlock.dart';
import 'package:bringly_app/features/auth/data/local_unlock_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/local_unlock_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../core/security/fake_local_app_unlock.dart';

void main() {
  test('local unlock repository maps availability to a local unlock state', () async {
    final repository = LocalUnlockRepository(
      FakeLocalAppUnlock(
        availability: const LocalAppUnlockStatus(
          availability: LocalAppUnlockAvailability.availableBiometric,
          method: LocalAppUnlockMethod.biometric,
        ),
      ),
    );

    final state = await repository.checkAvailability();

    expect(state.canPromptUnlock, isTrue);
    expect(state.phase, LocalUnlockPhase.required);
  });

  test('local unlock repository maps cancelled unlock to a safe failure', () async {
    final repository = LocalUnlockRepository(
      FakeLocalAppUnlock(nextResult: LocalAppUnlockResult.cancelled),
    );

    final result = await repository.requestUnlock(reason: 'Unlock Bringly');

    expect(result.isSuccess, isFalse);
    expect(result.failure?.code, AuthFailureCode.localUnlockFailed);
    expect(result.state?.phase, LocalUnlockPhase.cancelled);
  });

  test('local unlock repository maps thrown platform errors to safe failures', () async {
    final repository = LocalUnlockRepository(
      FakeLocalAppUnlock(throwOnRequest: StateError('platform failure')),
    );

    final result = await repository.requestUnlock(reason: 'Unlock Bringly');

    expect(result.isSuccess, isFalse);
    expect(result.failure?.code, AuthFailureCode.localUnlockFailed);
    expect(result.state?.phase, LocalUnlockPhase.failed);
  });
}
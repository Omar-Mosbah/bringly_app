import 'package:bringly_app/core/security/local_app_unlock.dart';

class FakeLocalAppUnlock extends LocalAppUnlock {
  FakeLocalAppUnlock({
    LocalAppUnlockStatus? availability,
    this.nextResult = LocalAppUnlockResult.unlocked,
    this.throwOnCheck,
    this.throwOnRequest,
  }) : nextAvailability =
           availability ??
           const LocalAppUnlockStatus(
             availability: LocalAppUnlockAvailability.availableBiometric,
             method: LocalAppUnlockMethod.biometric,
           );

  LocalAppUnlockStatus nextAvailability;
  LocalAppUnlockResult nextResult;
  Object? throwOnCheck;
  Object? throwOnRequest;
  int resetCallCount = 0;
  int requestCallCount = 0;

  @override
  Future<LocalAppUnlockStatus> checkAvailability() async {
    if (throwOnCheck != null) {
      throw throwOnCheck!;
    }

    return nextAvailability;
  }

  @override
  Future<LocalAppUnlockResult> requestUnlock({required String reason}) async {
    requestCallCount += 1;

    if (throwOnRequest != null) {
      throw throwOnRequest!;
    }

    return nextResult;
  }

  @override
  Future<void> reset() async {
    resetCallCount += 1;
  }
}
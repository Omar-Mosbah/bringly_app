import 'package:bringly_app/core/security/local_app_unlock.dart';

enum LocalUnlockPhase {
  required,
  inProgress,
  unlocked,
  failed,
  cancelled,
  lockedOut,
  signedOut,
}

class LocalUnlockState {
  const LocalUnlockState({
    required this.availability,
    required this.method,
    required this.phase,
    this.lastAttemptResult,
  });

  final LocalAppUnlockAvailability availability;
  final LocalAppUnlockMethod method;
  final LocalUnlockPhase phase;
  final LocalAppUnlockResult? lastAttemptResult;

  bool get canPromptUnlock {
    return availability == LocalAppUnlockAvailability.availableBiometric ||
        availability == LocalAppUnlockAvailability.availableDevicePin;
  }

  bool get isUnlocked => phase == LocalUnlockPhase.unlocked;

  bool get blocksContent => !isUnlocked && phase != LocalUnlockPhase.signedOut;
}
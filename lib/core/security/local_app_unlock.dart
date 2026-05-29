enum LocalAppUnlockAvailability {
  availableBiometric,
  availableDevicePin,
  unavailable,
  disabled,
  lockedOut,
  unknown,
}

enum LocalAppUnlockMethod {
  biometric,
  devicePin,
  platformFallback,
  unavailable,
}

enum LocalAppUnlockResult {
  unlocked,
  failed,
  cancelled,
  lockedOut,
  notAvailable,
  error,
}

class LocalAppUnlockStatus {
  const LocalAppUnlockStatus({
    required this.availability,
    required this.method,
    this.safeReason,
  });

  final LocalAppUnlockAvailability availability;
  final LocalAppUnlockMethod method;
  final String? safeReason;

  bool get isAvailable {
    return availability == LocalAppUnlockAvailability.availableBiometric ||
        availability == LocalAppUnlockAvailability.availableDevicePin;
  }
}

abstract class LocalAppUnlock {
  const LocalAppUnlock();

  Future<LocalAppUnlockStatus> checkAvailability();

  Future<LocalAppUnlockResult> requestUnlock({required String reason});

  Future<void> reset();
}
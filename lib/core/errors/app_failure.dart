enum AppFailureCode {
  invalidConfiguration,
  unavailable,
  timeout,
  offline,
  storageFailure,
  blockedScope,
  unexpected,
}

class AppFailure {
  const AppFailure({
    required this.code,
    required this.message,
    this.retryAllowed = false,
  });

  final AppFailureCode code;
  final String message;
  final bool retryAllowed;
}

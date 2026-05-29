enum ConnectivityCheckStatus {
  idle,
  loading,
  success,
  unavailable,
  timeout,
  invalidConfiguration,
  offline,
  failed,
}

class ConnectivityCheckResult {
  const ConnectivityCheckResult({
    required this.status,
    required this.safeMessage,
    this.checkedAt,
  });

  final ConnectivityCheckStatus status;
  final DateTime? checkedAt;
  final String safeMessage;

  bool get retryAllowed => switch (status) {
    ConnectivityCheckStatus.unavailable ||
    ConnectivityCheckStatus.timeout ||
    ConnectivityCheckStatus.offline ||
    ConnectivityCheckStatus.failed => true,
    _ => false,
  };

  static ConnectivityCheckResult idle() => const ConnectivityCheckResult(
    status: ConnectivityCheckStatus.idle,
    safeMessage: 'Ready to check backend reachability.',
  );

  static ConnectivityCheckResult loading() => const ConnectivityCheckResult(
    status: ConnectivityCheckStatus.loading,
    safeMessage: 'Checking backend reachability...',
  );
}

enum ProtectedStorageSmokeTestStatus {
  notRun,
  running,
  passed,
  writeFailed,
  readFailed,
  deleteFailed,
  skipped,
}

class ProtectedStorageSmokeTestResult {
  const ProtectedStorageSmokeTestResult({
    required this.status,
    required this.safeMessage,
    this.ranAt,
  });

  final ProtectedStorageSmokeTestStatus status;
  final String safeMessage;
  final DateTime? ranAt;
}

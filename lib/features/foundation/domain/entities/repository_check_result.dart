enum RepositoryCheckStatus { pending, running, passed, failed, cancelled }

enum RepositoryCheckStepStatus { passed, failed, notRun }

class RepositoryCheckResult {
  const RepositoryCheckResult({
    required this.status,
    required this.analysisStatus,
    required this.testStatus,
    required this.safeSummary,
  });

  final RepositoryCheckStatus status;
  final RepositoryCheckStepStatus analysisStatus;
  final RepositoryCheckStepStatus testStatus;
  final String safeSummary;
}

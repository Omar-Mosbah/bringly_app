import 'package:bringly_app/features/foundation/domain/entities/repository_check_result.dart';

class BuildRepositoryCheckResult {
  const BuildRepositoryCheckResult();

  RepositoryCheckResult call({
    required RepositoryCheckStatus status,
    required RepositoryCheckStepStatus analysisStatus,
    required RepositoryCheckStepStatus testStatus,
  }) {
    final summary = switch (status) {
      RepositoryCheckStatus.pending =>
        'Repository checks have not started yet.',
      RepositoryCheckStatus.running => 'Repository checks are in progress.',
      RepositoryCheckStatus.passed => 'Repository checks passed.',
      RepositoryCheckStatus.failed => 'Repository checks failed.',
      RepositoryCheckStatus.cancelled => 'Repository checks were cancelled.',
    };

    return RepositoryCheckResult(
      status: status,
      analysisStatus: analysisStatus,
      testStatus: testStatus,
      safeSummary: summary,
    );
  }
}

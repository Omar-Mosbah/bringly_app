import 'package:bringly_app/features/foundation/domain/entities/validation_checklist.dart';

class BuildValidationChecklist {
  const BuildValidationChecklist();

  ValidationChecklist call({
    required bool analysisPassed,
    required bool testsPassed,
    required bool securityBaselinePassed,
    required bool ciPassed,
    List<String> remainingIssues = const <String>[],
  }) {
    return ValidationChecklist(
      analysisPassed: analysisPassed,
      testsPassed: testsPassed,
      securityBaselinePassed: securityBaselinePassed,
      ciPassed: ciPassed,
      remainingIssues: remainingIssues,
    );
  }
}

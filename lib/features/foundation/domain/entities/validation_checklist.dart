class ValidationChecklist {
  const ValidationChecklist({
    required this.analysisPassed,
    required this.testsPassed,
    required this.securityBaselinePassed,
    required this.ciPassed,
    this.remainingIssues = const <String>[],
  });

  final bool analysisPassed;
  final bool testsPassed;
  final bool securityBaselinePassed;
  final bool ciPassed;
  final List<String> remainingIssues;
}

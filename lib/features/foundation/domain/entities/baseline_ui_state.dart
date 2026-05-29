enum BaselineUiStateKind { loading, empty, error, blocked, offline, success }

class BaselineUiState {
  const BaselineUiState({
    required this.kind,
    required this.title,
    required this.message,
    this.primaryAction,
    this.retryAllowed = false,
  });

  final BaselineUiStateKind kind;
  final String title;
  final String message;
  final String? primaryAction;
  final bool retryAllowed;
}

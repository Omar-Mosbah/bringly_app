import 'package:bringly_app/core/logging/redactor.dart';

enum SafeLogLevel { info, warning, error }

class SafeLogEntry {
  const SafeLogEntry({
    required this.level,
    required this.message,
    required this.metadata,
  });

  final SafeLogLevel level;
  final String message;
  final Map<String, Object?> metadata;
}

abstract class SafeLogger {
  void info(String message, {Map<String, Object?> metadata = const {}});

  void warning(String message, {Map<String, Object?> metadata = const {}});

  void error(String message, {Map<String, Object?> metadata = const {}});
}

mixin SafeLoggerSanitizer {
  Redactor get redactor;

  SafeLogEntry sanitize(
    SafeLogLevel level,
    String message,
    Map<String, Object?> metadata,
  ) {
    return SafeLogEntry(
      level: level,
      message: redactor.redactText(message),
      metadata: redactor.redactMetadata(metadata),
    );
  }
}

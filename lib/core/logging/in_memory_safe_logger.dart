import 'package:bringly_app/core/logging/redactor.dart';
import 'package:bringly_app/core/logging/safe_logger.dart';

class InMemorySafeLogger with SafeLoggerSanitizer implements SafeLogger {
  InMemorySafeLogger({Redactor? redactor})
    : _redactor = redactor ?? const Redactor();

  final Redactor _redactor;
  final List<SafeLogEntry> entries = <SafeLogEntry>[];

  @override
  Redactor get redactor => _redactor;

  @override
  void error(String message, {Map<String, Object?> metadata = const {}}) {
    entries.add(sanitize(SafeLogLevel.error, message, metadata));
  }

  @override
  void info(String message, {Map<String, Object?> metadata = const {}}) {
    entries.add(sanitize(SafeLogLevel.info, message, metadata));
  }

  @override
  void warning(String message, {Map<String, Object?> metadata = const {}}) {
    entries.add(sanitize(SafeLogLevel.warning, message, metadata));
  }
}

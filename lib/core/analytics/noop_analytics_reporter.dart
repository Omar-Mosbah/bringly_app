import 'package:bringly_app/core/analytics/analytics_event.dart';
import 'package:bringly_app/core/analytics/analytics_reporter.dart';
import 'package:bringly_app/core/logging/redactor.dart';

class NoopAnalyticsReporter extends AnalyticsReporter {
  const NoopAnalyticsReporter({Redactor? redactor})
    : _redactor = redactor ?? const Redactor();

  final Redactor _redactor;

  static const Set<String> _unsafeKeyFragments = <String>{
    'token',
    'email',
    'phone',
    'payment',
    'card',
    'document',
    'receipt',
    'travel',
    'risk',
    'secret',
    'error',
  };

  Map<String, Object?> sanitizeMetadata(Map<String, Object?> metadata) {
    final sanitized = <String, Object?>{};
    for (final entry in metadata.entries) {
      final lowerKey = entry.key.toLowerCase();
      final isUnsafeKey = _unsafeKeyFragments.any(
        (fragment) => lowerKey.contains(fragment),
      );
      if (isUnsafeKey) {
        continue;
      }

      final value = entry.value;
      if (value is bool || value is num) {
        sanitized[entry.key] = value;
        continue;
      }
      if (value is String) {
        final redacted = _redactor.redactText(value);
        if (redacted == value) {
          sanitized[entry.key] = value;
        }
      }
    }
    return sanitized;
  }

  @override
  void report(AnalyticsEvent event) {
    sanitizeMetadata(event.metadata);
  }
}

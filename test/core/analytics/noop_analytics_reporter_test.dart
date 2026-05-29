import 'package:bringly_app/core/analytics/analytics_event.dart';
import 'package:bringly_app/core/analytics/noop_analytics_reporter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'noop analytics reporter accepts safe event names and drops unsafe metadata',
    () {
      const reporter = NoopAnalyticsReporter();

      reporter.report(
        const AnalyticsEvent(
          name: AnalyticsEventName.connectivityChecked,
          metadata: <String, Object?>{
            'screen': 'connectivity',
            'token': 'eyJfakeValue123',
          },
        ),
      );

      final sanitized = reporter.sanitizeMetadata(const <String, Object?>{
        'screen': 'connectivity',
        'token': 'eyJfakeValue123',
      });

      expect(
        sanitized,
        equals(const <String, Object?>{'screen': 'connectivity'}),
      );
    },
  );
}

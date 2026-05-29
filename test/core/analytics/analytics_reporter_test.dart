import 'package:bringly_app/core/analytics/noop_analytics_reporter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'unsafe analytics metadata is excluded or redacted before reporting',
    () {
      const reporter = NoopAnalyticsReporter();

      final sanitized = reporter.sanitizeMetadata(const <String, Object?>{
        'screen': 'foundation',
        'attempt': 1,
        'token': 'eyJfakeValue123',
        'email': 'fake.user@example.com',
        'status': true,
      });

      expect(sanitized['screen'], 'foundation');
      expect(sanitized['attempt'], 1);
      expect(sanitized['status'], isTrue);
      expect(sanitized.containsKey('token'), isFalse);
      expect(sanitized.containsKey('email'), isFalse);
    },
  );
}

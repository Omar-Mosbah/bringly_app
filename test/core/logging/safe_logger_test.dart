import 'package:bringly_app/core/logging/in_memory_safe_logger.dart';
import 'package:bringly_app/core/logging/redactor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('safe logger strips fake sensitive data from messages and metadata', () {
    final logger = InMemorySafeLogger();

    logger.error(
      'provider postgres error for fake.user@example.com with token eyJfakeValue123',
      metadata: const <String, Object?>{
        'email': 'fake.user@example.com',
        'token': 'eyJfakeValue123',
      },
    );

    final entry = logger.entries.single;
    expect(entry.message, contains(Redactor.redactedEmail));
    expect(entry.message, contains(Redactor.redactedToken));
    expect(entry.metadata['email'], Redactor.redactedEmail);
    expect(entry.metadata['token'], Redactor.redactedToken);
  });
}

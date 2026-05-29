import 'package:bringly_app/core/logging/redactor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Redactor', () {
    const redactor = Redactor();

    test('redacts fake sensitive strings', () {
      final input = '''
token eyJfakeValue123
supabase sb_publishable_fakePublicValue123
SUPABASE_ANON_KEY=sb_publishable_fakePublicValue123
email fake.user@example.com
phone +1 555 123 4567
payment 4242 4242 4242 4242
document passport copy
receipt receipt image
travel boarding pass
risk internal risk score
provider postgres stack trace
''';

      final output = redactor.redactText(input);

      expect(output, contains(Redactor.redactedToken));
      expect(output, isNot(contains('sb_publishable_fakePublicValue123')));
      expect(output, contains('SUPABASE_ANON_KEY=${Redactor.redactedToken}'));
      expect(output, contains(Redactor.redactedEmail));
      expect(output, contains(Redactor.redactedPhone));
      expect(output, contains(Redactor.redactedPayment));
      expect(output, contains(Redactor.redactedDocument));
      expect(output, contains(Redactor.redactedReceipt));
      expect(output, contains(Redactor.redactedTravelProof));
      expect(output, contains(Redactor.redactedRisk));
      expect(output, contains(Redactor.redactedProviderError));
    });

    test('redacts metadata values based on key and content', () {
      final output = redactor.redactMetadata(const <String, Object?>{
        'email': 'fake.user@example.com',
        'phone': '+1 555 123 4567',
        'paymentRef': '4242 4242 4242 4242',
        'safe': 'foundation-only',
      });

      expect(output['email'], Redactor.redactedEmail);
      expect(output['phone'], Redactor.redactedPhone);
      expect(output['paymentRef'], Redactor.redactedPayment);
      expect(output['safe'], 'foundation-only');
    });
  });
}

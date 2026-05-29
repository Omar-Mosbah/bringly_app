import 'package:bringly_app/features/auth/application/request_password_reset.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_auth_repository.dart';

void main() {
  test('known and unknown emails use the same safe password reset response pattern', () async {
    final repository = FakeAuthRepository();
    final useCase = RequestPasswordReset(repository);

    final known = await useCase(email: 'known@example.com');
    final unknown = await useCase(email: 'unknown@example.com');

    expect(known.isSuccess, isTrue);
    expect(unknown.isSuccess, isTrue);
    expect(known.safeMessage, 'If the email can receive reset instructions, a secure link will arrive shortly.');
    expect(unknown.safeMessage, known.safeMessage);
  });
}
import 'package:bringly_app/features/auth/application/request_password_reset.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_auth_repository.dart';

void main() {
  test('password reset succeeds for valid and unknown emails with the same safe response', () async {
    final useCase = RequestPasswordReset(FakeAuthRepository());

    final known = await useCase(email: 'known@example.com');
    final unknown = await useCase(email: 'unknown@example.com');

    expect(known.isSuccess, isTrue);
    expect(unknown.isSuccess, isTrue);
    expect(known.safeMessage, unknown.safeMessage);
  });

  test('password reset rejects malformed emails', () async {
    final result = await RequestPasswordReset(FakeAuthRepository())(
      email: 'invalid-email',
    );

    expect(result.isSuccess, isFalse);
    expect(result.failure?.code, AuthFailureCode.invalidInput);
  });

  test('password reset surfaces rate limited offline and safe unknown failures', () async {
    Future<void> expectFailure(AuthFailure failure) async {
      final repository = FakeAuthRepository()..nextPasswordResetFailure = failure;
      final result = await RequestPasswordReset(repository)(
        email: 'known@example.com',
      );

      expect(result.isSuccess, isFalse);
      expect(result.failure?.code, failure.code);
    }

    await expectFailure(const AuthFailure.rateLimited());
    await expectFailure(const AuthFailure.offline());
    await expectFailure(const AuthFailure.unknownSafeFailure(
      message: 'The reset link is no longer valid. Request a new email.',
    ));
    await expectFailure(const AuthFailure.unknownSafeFailure(
      message: 'This reset link has already been used. Request a new email.',
    ));
  });
}
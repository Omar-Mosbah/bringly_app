import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_auth_repository.dart';

void main() {
  test('fake auth repository registers and restores a local-unlock session', () async {
    final repository = FakeAuthRepository();

    final registerResult = await repository.registerWithEmail(
      email: EmailAddress('shopper@example.com'),
      password: PasswordInput('Bringly123'),
      initialMarketplaceRole: MarketplaceRole.shopper,
    );
    final restoreResult = await repository.restoreSession();

    expect(registerResult.isSuccess, isTrue);
    expect(registerResult.value?.session.blocksProtectedContent, isTrue);
    expect(restoreResult.isSuccess, isTrue);
    expect(restoreResult.value?.safeAccountId, registerResult.value?.safeAccountId);
  });

  test('fake auth repository returns configured sign-in failures', () async {
    final repository = FakeAuthRepository()
      ..nextSignInFailure = const AuthFailure.rateLimited();

    final signInResult = await repository.signInWithEmail(
      email: EmailAddress('shopper@example.com'),
      password: PasswordInput('Bringly123'),
    );

    expect(signInResult.isSuccess, isFalse);
    expect(signInResult.failure?.code, AuthFailureCode.rateLimited);
  });
}
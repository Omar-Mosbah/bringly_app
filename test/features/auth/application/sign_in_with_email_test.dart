import 'package:bringly_app/features/auth/application/sign_in_with_email.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_auth_repository.dart';

void main() {
  Future<FakeAuthRepository> buildRegisteredRepository() async {
    final repository = FakeAuthRepository();
    await repository.registerWithEmail(
      email: EmailAddress('returning@example.com'),
      password: PasswordInput('Bringly123'),
      initialMarketplaceRole: MarketplaceRole.shopper,
    );
    return repository;
  }

  test('sign in succeeds with valid credentials', () async {
    final repository = await buildRegisteredRepository();
    final useCase = SignInWithEmail(repository);

    final result = await useCase(
      email: 'returning@example.com',
      password: 'Bringly123',
    );

    expect(result.isSuccess, isTrue);
    expect(result.value?.session.blocksProtectedContent, isTrue);
  });

  test('sign in rejects invalid credentials safely', () async {
    final repository = await buildRegisteredRepository();
    final useCase = SignInWithEmail(repository);

    final result = await useCase(
      email: 'returning@example.com',
      password: 'wrong-password',
    );

    expect(result.isSuccess, isFalse);
    expect(result.failure?.code, AuthFailureCode.invalidCredentials);
  });

  test('sign in propagates rate-limited offline blocked suspended and unknown failures', () async {
    final rateLimitedRepository = await buildRegisteredRepository()
      ..nextSignInFailure = const AuthFailure.rateLimited();
    final offlineRepository = await buildRegisteredRepository()
      ..nextSignInFailure = const AuthFailure.offline();
    final blockedRepository = await buildRegisteredRepository()
      ..nextSignInFailure = const AuthFailure.blocked();
    final suspendedRepository = await buildRegisteredRepository()
      ..nextSignInFailure = const AuthFailure.suspended();
    final unknownRepository = await buildRegisteredRepository()
      ..nextSignInFailure = const AuthFailure.unknownSafeFailure();

    expect(
      (await SignInWithEmail(rateLimitedRepository)(
        email: 'returning@example.com',
        password: 'Bringly123',
      )).failure?.code,
      AuthFailureCode.rateLimited,
    );
    expect(
      (await SignInWithEmail(offlineRepository)(
        email: 'returning@example.com',
        password: 'Bringly123',
      )).failure?.code,
      AuthFailureCode.offline,
    );
    expect(
      (await SignInWithEmail(blockedRepository)(
        email: 'returning@example.com',
        password: 'Bringly123',
      )).failure?.code,
      AuthFailureCode.blocked,
    );
    expect(
      (await SignInWithEmail(suspendedRepository)(
        email: 'returning@example.com',
        password: 'Bringly123',
      )).failure?.code,
      AuthFailureCode.suspended,
    );
    expect(
      (await SignInWithEmail(unknownRepository)(
        email: 'returning@example.com',
        password: 'Bringly123',
      )).failure?.code,
      AuthFailureCode.unknownSafeFailure,
    );
  });
}
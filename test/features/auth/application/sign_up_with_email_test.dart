import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_auth_repository.dart';

void main() {
  test('sign up succeeds with a valid email password and marketplace role', () async {
    final useCase = SignUpWithEmail(FakeAuthRepository());

    final result = await useCase(
      email: 'new-user@example.com',
      password: 'Bringly123',
      initialMarketplaceRole: MarketplaceRole.shopper,
    );

    expect(result.isSuccess, isTrue);
    expect(result.value?.session.blocksProtectedContent, isTrue);
    expect(result.value?.emailConfirmationStatus, EmailConfirmationStatus.pending);
  });

  test('sign up rejects invalid email input before repository execution', () async {
    final useCase = SignUpWithEmail(FakeAuthRepository());

    final result = await useCase(
      email: 'not-an-email',
      password: 'Bringly123',
      initialMarketplaceRole: MarketplaceRole.shopper,
    );

    expect(result.isSuccess, isFalse);
    expect(result.failure?.code, AuthFailureCode.invalidInput);
  });

  test('sign up rejects weak passwords before repository execution', () async {
    final useCase = SignUpWithEmail(FakeAuthRepository());

    final result = await useCase(
      email: 'new-user@example.com',
      password: 'short',
      initialMarketplaceRole: MarketplaceRole.shopper,
    );

    expect(result.isSuccess, isFalse);
    expect(result.failure?.code, AuthFailureCode.weakPassword);
  });

  test('sign up propagates unavailable email failures safely', () async {
    final repository = FakeAuthRepository()..unavailableEmails.add('taken@example.com');
    final useCase = SignUpWithEmail(repository);

    final result = await useCase(
      email: 'taken@example.com',
      password: 'Bringly123',
      initialMarketplaceRole: MarketplaceRole.traveler,
    );

    expect(result.isSuccess, isFalse);
    expect(result.failure?.code, AuthFailureCode.invalidInput);
  });

  test('sign up propagates rate-limited offline and safe unknown failures', () async {
    final rateLimitedRepository = FakeAuthRepository()
      ..nextRegisterFailure = const AuthFailure.rateLimited();
    final offlineRepository = FakeAuthRepository()
      ..nextRegisterFailure = const AuthFailure.offline();
    final unknownRepository = FakeAuthRepository()
      ..nextRegisterFailure = const AuthFailure.unknownSafeFailure();

    final rateLimitedResult = await SignUpWithEmail(rateLimitedRepository)(
      email: 'new-user@example.com',
      password: 'Bringly123',
      initialMarketplaceRole: MarketplaceRole.both,
    );
    final offlineResult = await SignUpWithEmail(offlineRepository)(
      email: 'new-user@example.com',
      password: 'Bringly123',
      initialMarketplaceRole: MarketplaceRole.both,
    );
    final unknownResult = await SignUpWithEmail(unknownRepository)(
      email: 'new-user@example.com',
      password: 'Bringly123',
      initialMarketplaceRole: MarketplaceRole.both,
    );

    expect(rateLimitedResult.failure?.code, AuthFailureCode.rateLimited);
    expect(offlineResult.failure?.code, AuthFailureCode.offline);
    expect(unknownResult.failure?.code, AuthFailureCode.unknownSafeFailure);
  });
}
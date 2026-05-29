import 'package:bringly_app/core/security/local_app_unlock.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/auth/domain/entities/local_unlock_state.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmailAddress', () {
    test('normalizes a valid email address', () {
      final email = EmailAddress('  PERSON@Example.com ');

      expect(email.isValid, isTrue);
      expect(email.value, 'person@example.com');
      expect(email.validationMessage, isNull);
    });

    test('rejects malformed email input', () {
      final email = EmailAddress('invalid-email');

      expect(email.isValid, isFalse);
      expect(email.validationMessage, isNotNull);
    });
  });

  group('PasswordInput', () {
    test('accepts minimum-strength passwords', () {
      final password = PasswordInput('Bringly123');

      expect(password.isValid, isTrue);
      expect(password.validationMessage, isNull);
    });

    test('rejects empty or weak passwords', () {
      expect(PasswordInput('').isValid, isFalse);
      expect(PasswordInput('short').isValid, isFalse);
      expect(PasswordInput('allletters').isValid, isFalse);
    });
  });

  test('auth failure exposes safe local unlock failure state', () {
    const failure = AuthFailure.localUnlockFailed();

    expect(failure.code, AuthFailureCode.localUnlockFailed);
    expect(failure.retryAllowed, isFalse);
  });

  test('auth session blocks content until local unlock succeeds', () {
    final session = AuthSession(
      state: AuthSessionState.signedInRequiresUnlock,
      requiresLocalUnlock: true,
    );

    expect(session.isSignedIn, isTrue);
    expect(session.blocksProtectedContent, isTrue);
  });

  test('email confirmation only allows protected access when confirmed', () {
    expect(EmailConfirmationStatus.pending.allowsProtectedAccess, isFalse);
    expect(EmailConfirmationStatus.confirmed.allowsProtectedAccess, isTrue);
  });

  test('local unlock state surfaces prompt availability and block state', () {
    const state = LocalUnlockState(
      availability: LocalAppUnlockAvailability.availableBiometric,
      method: LocalAppUnlockMethod.biometric,
      phase: LocalUnlockPhase.required,
    );

    expect(state.canPromptUnlock, isTrue);
    expect(state.blocksContent, isTrue);
    expect(state.isUnlocked, isFalse);
  });
}
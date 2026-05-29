import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';

class SignInWithEmail {
  const SignInWithEmail(this._authRepository);

  final AuthRepository _authRepository;

  Future<AuthRepositoryResult<AuthAccountSnapshot>> call({
    required String email,
    required String password,
  }) async {
    final emailAddress = EmailAddress(email);
    if (!emailAddress.isValid) {
      return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
        AuthFailure.invalidCredentials(),
      );
    }

    final passwordInput = PasswordInput(password);
    if (!passwordInput.isValid) {
      return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
        AuthFailure.invalidCredentials(),
      );
    }

    return _authRepository.signInWithEmail(
      email: emailAddress,
      password: passwordInput,
    );
  }
}